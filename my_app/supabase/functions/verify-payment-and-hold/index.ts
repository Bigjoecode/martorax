// Supabase Edge Function: verify-payment-and-hold
//
// Server-authoritative checkout. The client cannot tamper with amount or
// seller_id — both are derived from the products table here.
//
// Two modes:
//
//   POST { mode: 'init', items: [{product_id, quantity}], landmark }
//     -> { authorization_url, reference, expected_total_naira, seller_id }
//
//   POST { mode: 'verify', reference, items: [{product_id, quantity}], landmark }
//     -> { success: true, order_id, hold_code, total_naira }
//
// Required env vars (set via `supabase secrets set ...`):
//   PAYSTACK_SECRET_KEY     - sk_test_... or sk_live_...
//   SUPABASE_URL            - auto-provided
//   SUPABASE_SERVICE_ROLE_KEY - auto-provided
// Optional env vars (override defaults):
//   DELIVERY_FEE_NAIRA      - default 800
//   SERVICE_FEE_NAIRA       - default 150

import { serve } from 'https://deno.land/std@0.203.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.45.4';

const PAYSTACK_BASE = 'https://api.paystack.co';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type',
};

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  });
}

function genReference(): string {
  return `MTX-${Date.now()}-${Math.floor(Math.random() * 900_000) + 100_000}`;
}

/// Issue a full refund for a Paystack transaction by reference.
/// Used when the buyer's payment captured but we couldn't persist the order
/// (out of stock, product deleted mid-flow, RPC error, etc.).
async function refundTransaction(
  secret: string,
  reference: string,
): Promise<{ refunded: boolean; refundId?: string; error?: string }> {
  try {
    const resp = await fetch(`${PAYSTACK_BASE}/refund`, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${secret}`,
        'Content-Type': 'application/json',
      },
      // Body is just { transaction: reference } — Paystack refunds the full
      // amount of the matched transaction by default.
      body: JSON.stringify({ transaction: reference }),
    });
    const body = await resp.json();
    if (body.status === true) {
      return { refunded: true, refundId: body.data?.id?.toString() };
    }
    return { refunded: false, error: body.message ?? 'Paystack refund failed' };
  } catch (e) {
    return { refunded: false, error: String(e) };
  }
}

serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders });

  try {
    const secret = Deno.env.get('PAYSTACK_SECRET_KEY');
    if (!secret) return json({ success: false, message: 'Server not configured' }, 500);

    const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
    const serviceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;

    const deliveryFee = Number(Deno.env.get('DELIVERY_FEE_NAIRA') ?? '800');
    const serviceFee = Number(Deno.env.get('SERVICE_FEE_NAIRA') ?? '150');

    // 1. Authenticate caller — we need their user id for buyer_id and email.
    const authHeader = req.headers.get('Authorization') ?? '';
    const userClient = createClient(supabaseUrl, serviceKey, {
      global: { headers: { Authorization: authHeader } },
    });
    const { data: userData, error: userErr } = await userClient.auth.getUser();
    if (userErr || !userData?.user) {
      return json({ success: false, message: 'Not authenticated' }, 401);
    }
    const buyerId = userData.user.id;
    const buyerEmail = userData.user.email;
    if (!buyerEmail) {
      return json({ success: false, message: 'Buyer has no email' }, 400);
    }

    const body = await req.json();
    const mode = body.mode as string;
    const items = body.items;
    const landmark = (body.landmark as string) ?? '';

    if (!Array.isArray(items) || items.length === 0) {
      return json({ success: false, message: 'Cart is empty' }, 400);
    }

    // Service-role client used for the RPC calls (bypasses RLS, runs the
    // SECURITY DEFINER functions on the buyer's behalf with verified buyerId).
    const adminClient = createClient(supabaseUrl, serviceKey);

    if (mode === 'init') {
      // 2a. Ask the DB for the authoritative total based on current prices.
      const { data: quoteData, error: quoteErr } = await adminClient.rpc(
        'quote_cart_total',
        {
          p_items: items,
          p_delivery_fee_naira: deliveryFee,
          p_service_fee_naira: serviceFee,
        },
      );
      if (quoteErr) {
        return json({ success: false, message: `Quote failed: ${quoteErr.message}` }, 400);
      }
      const quote = Array.isArray(quoteData) ? quoteData[0] : quoteData;
      if (!quote?.grand_total_naira || !quote?.seller_id) {
        return json({ success: false, message: 'Could not quote cart' }, 400);
      }
      const totalNaira = Number(quote.grand_total_naira);
      const totalKobo = Math.round(totalNaira * 100);
      const reference = genReference();

      // 3a. Initialize Paystack with the server-computed amount.
      const initResp = await fetch(`${PAYSTACK_BASE}/transaction/initialize`, {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${secret}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          email: buyerEmail,
          amount: totalKobo,
          reference,
          metadata: {
            buyer_id: buyerId,
            seller_id: quote.seller_id,
            // Items echoed for audit/troubleshooting only; we recompute on verify.
            items,
          },
        }),
      });
      const initBody = await initResp.json();
      if (!initBody.status) {
        return json({ success: false, message: initBody.message ?? 'Init failed' }, 400);
      }
      return json({
        success: true,
        authorization_url: initBody.data.authorization_url,
        reference: initBody.data.reference,
        expected_total_naira: totalNaira,
        seller_id: quote.seller_id,
      });
    }

    if (mode === 'verify') {
      const reference = body.reference as string;
      if (!reference) {
        return json({ success: false, message: 'Missing reference' }, 400);
      }

      // 2b. Confirm the transaction with Paystack server-to-server.
      const verifyResp = await fetch(
        `${PAYSTACK_BASE}/transaction/verify/${reference}`,
        { headers: { Authorization: `Bearer ${secret}` } },
      );
      const verifyBody = await verifyResp.json();
      if (!verifyBody.status || verifyBody.data?.status !== 'success') {
        return json(
          { success: false, message: verifyBody.message ?? 'Payment not successful' },
          402,
        );
      }
      const paidKobo = verifyBody.data.amount as number;

      // 3b. Hand off to the DB. It will: re-quote from products, sanity-check
      //     the paid amount, and persist order + items + escrow atomically.
      //     If the totals don't match, the RPC raises and nothing is written.
      const { data: rpcData, error: rpcErr } = await adminClient.rpc(
        'create_order_with_escrow_v2',
        {
          p_buyer_id: buyerId,
          p_items: items,
          p_delivery_fee_naira: deliveryFee,
          p_service_fee_naira: serviceFee,
          p_landmark: landmark,
          p_paystack_reference: reference,
          p_paid_amount_kobo: paidKobo,
        },
      );
      if (rpcErr) {
        // Payment was captured but the DB couldn't persist (out of stock,
        // product deleted mid-flow, etc.). Refund automatically so the
        // buyer's money doesn't sit in limbo.
        const refundResult = await refundTransaction(secret, reference);
        return json(
          {
            success: false,
            message: `Order creation failed: ${rpcErr.message}. ${
              refundResult.refunded
                ? `Refund issued (id ${refundResult.refundId}).`
                : `Refund FAILED: ${refundResult.error}. Manual refund needed for reference ${reference}.`
            }`,
            refund_attempted: true,
            refund_succeeded: refundResult.refunded,
          },
          refundResult.refunded ? 409 : 500,
        );
      }
      const row = Array.isArray(rpcData) ? rpcData[0] : rpcData;
      return json({
        success: true,
        order_id: row?.order_id,
        hold_code: row?.hold_code,
        total_naira: Number(row?.computed_total_naira ?? 0),
      });
    }

    return json({ success: false, message: `Unknown mode: ${mode}` }, 400);
  } catch (e) {
    return json({ success: false, message: `Edge function error: ${String(e)}` }, 500);
  }
});
