# Supabase deploy steps

Server-side bits the Flutter app calls into for SafePay / Paystack. Three
things to deploy in order: the v1 SQL helper, the v2 (hardened) SQL helper,
and the Edge Function.

## Prerequisites

```bash
npm install -g supabase
supabase login
supabase link --project-ref kabkurhvsthlxokmnbrb
```

## 1. Apply the SQL migrations (in order)

These migrations harden the order/escrow creation so the client cannot
tamper with the amount or which vendor gets paid. Apply both:

```bash
# From the my_app/ folder, either:
supabase db push
```

Or paste each file into the Supabase dashboard SQL editor and Run, in order:

- `sql/002_create_order_with_escrow.sql` — original (kept for reference; 003 drops it)
- `sql/003_harden_order_creation.sql` — adds `order_items`, `quote_cart_total`,
  `create_order_with_escrow_v2`. Drops the unsafe v1.
- `sql/004_stock_decrement_and_quote.sql` — replaces both functions with
  stock-aware versions: refuses checkout if `stock < quantity`, decrements
  stock atomically with the order insert (`FOR UPDATE` row lock).

After applying all three, only the hardened RPCs exist. Server-side guarantees:

- Total is computed from `products.price`, not client input
- `seller_id` is derived from `products.vendor_id`, not client input
- All items must share a single vendor (multi-vendor cart raises)
- Stock is checked + decremented atomically — no overselling
- Paystack-reported paid amount must match server-computed total exactly (kobo precision)
- Order, items, stock decrement, and escrow row written in one transaction — any failure rolls all back
- On any RPC failure after Paystack captured the payment, the Edge Function
  automatically calls `POST /refund` with the secret key (see threat model below)

## 2. Set the Paystack secret key

The secret key MUST NOT live in the app bundle. It lives only as a secret on
the Edge Function runtime:

```bash
supabase secrets set PAYSTACK_SECRET_KEY=sk_test_xxxxxxxxxxxxxxxx
```

Swap `sk_test_...` for your live key (`sk_live_...`) before launch.

`SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY` are auto-injected by the
runtime — you don't set them.

### Optional: fee overrides

The Edge Function uses these defaults for fees added on top of the cart:

- `DELIVERY_FEE_NAIRA` = 800
- `SERVICE_FEE_NAIRA` = 150

To change either, set them as secrets:

```bash
supabase secrets set DELIVERY_FEE_NAIRA=1200
supabase secrets set SERVICE_FEE_NAIRA=200
```

The client UI still hardcodes these values in `cart_screen.dart` — keep the
two in sync (or move them into a `settings` table read by both).

## 3. Deploy the Edge Function

```bash
supabase functions deploy verify-payment-and-hold
```

The function URL will be:

```
https://kabkurhvsthlxokmnbrb.functions.supabase.co/verify-payment-and-hold
```

The Flutter app calls it via `supabase.functions.invoke(...)`.

## 4. Update the Paystack public key in the app

Open [my_app/lib/core/supabase/paystack_payment_service.dart](../lib/core/supabase/paystack_payment_service.dart)
and replace `paystackPublicKey` with your real `pk_test_...` or `pk_live_...`
key. The public key is safe to embed in the client bundle.

## 5. Seed at least one real product

Because the server now looks prices up from `products`, the test cart must
contain real `product_id` UUIDs from that table. Either:

- Add products through the vendor flow (`/vendor/inventory`), or
- Insert directly:

```sql
insert into public.products (vendor_id, title, price, stock)
values ('<some-vendor-profile-uuid>', 'Test Tote', 45000, 10)
returning id;
```

Then update the test cart in `product_detail_screen.dart` to use that
returned UUID (the current `_productId = 'leather-tote-001'` won't resolve).

## 6. Test the flow

1. `flutter run -d chrome` (or device)
2. Sign in, add a real product, checkout
3. Tap "Pay ₦… securely" on the Payment Method screen
4. Paystack hosted checkout loads in the WebView
5. Use Paystack's test card: `4084 0840 8408 4081`, any future expiry, CVV `408`
6. After success the WebView closes, the Edge Function:
   - Re-fetches the transaction from Paystack
   - Re-quotes the cart from `products`
   - Verifies `paid kobo == server-computed kobo`
   - Inserts order + order_items + escrow_ledger atomically
7. Confirm in the dashboard: matching rows in `orders`, `order_items`,
   `escrow_ledger` (status `held`, hold_code `SP-...`)

## Threat model — what's defended, what's not

**Defended:**
- Client tampering with amount → server recomputes from products, refuses on mismatch
- Client tampering with seller_id → derived from `products.vendor_id`, ignored from client
- Forged Paystack callbacks → server re-fetches from Paystack with secret key, ignores client claim
- Race conditions on product price changes → row-level `FOR UPDATE` locks during quote
- Partial writes → all DB writes in one transaction, rolled back on any failure

**Closed in this hardening pass:**
- Multi-vendor cart UX: the cart screen now shows a per-vendor "Checkout from
  [Vendor]" button when more than one vendor's items are in the cart. The
  in-flight vendor is held in `checkoutVendorProvider`; on Paystack success
  only that vendor's items get cleared from the cart.
- Auto-refund on RPC failure: the Edge Function calls `POST /refund` with the
  secret key whenever the post-payment DB write fails (out of stock, product
  deleted, anything). The error response indicates whether the refund
  succeeded; manual operator action is only needed if the refund itself fails
  (network blip on Paystack's end).
- Stock decrement: the `create_order_with_escrow_v2` RPC now does
  `select stock for update`, raises "out of stock" if insufficient, and
  decrements stock in the same transaction as the order insert.

**Still flagged:**
- Delivery / service fee defaults live in the Edge Function env. Move to a
  `settings` table if you need per-region or A/B variation.
- Stock decrement does not currently restock on refund. If you want the
  stock to come back when a payment is auto-refunded, the RPC error path
  needs a compensating update. Not strictly necessary if the soft-launch
  refund volume is low and operators can adjust manually.
