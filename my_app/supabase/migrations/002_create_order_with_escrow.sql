-- Atomic order + escrow creation.
-- Called from the verify-payment-and-hold Edge Function AFTER Paystack has
-- confirmed the transaction. Runs as SECURITY DEFINER so the function can
-- bypass RLS on the buyer's behalf with the verified buyer_id.
--
-- Apply with:
--   supabase db push
-- or paste this into the SQL editor in the Supabase dashboard.

create or replace function public.create_order_with_escrow(
  p_buyer_id uuid,
  p_seller_id uuid,
  p_amount numeric,
  p_landmark text,
  p_paystack_reference text
)
returns table (order_id uuid, hold_code text)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_order_id uuid;
  v_hold_code text;
begin
  -- 1. Create the order
  insert into public.orders (buyer_id, seller_id, total_amount, landmark_destination)
  values (p_buyer_id, p_seller_id, p_amount, p_landmark)
  returning id into v_order_id;

  -- 2. Derive a stable, short hold_code from the Paystack reference
  v_hold_code := 'SP-' || upper(substr(p_paystack_reference, length(p_paystack_reference) - 7));

  -- 3. Create the escrow_ledger row in `held` status
  insert into public.escrow_ledger (
    order_id, hold_code, buyer_id, provider_id, amount, status
  ) values (
    v_order_id, v_hold_code, p_buyer_id, p_seller_id, p_amount, 'held'::escrow_status
  );

  return query select v_order_id, v_hold_code;
end;
$$;

-- Allow authenticated users to call this (the function itself validates inputs).
grant execute on function public.create_order_with_escrow(uuid, uuid, numeric, text, text)
  to authenticated, service_role;
