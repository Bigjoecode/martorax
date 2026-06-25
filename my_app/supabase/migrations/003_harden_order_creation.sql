-- Hardening pass: server-derived totals + seller_id, no client-trusted amounts.
--
-- Apply with `supabase db push` or paste into the SQL editor.
--
-- This file:
--   1. Adds an `order_items` table so each order has an audit trail of what
--      was bought at what price.
--   2. Replaces the old `create_order_with_escrow` (client-supplied amount +
--      seller_id) with `create_order_with_escrow_v2` that takes only the cart
--      items array and looks up everything server-side.
--   3. Drops the old function so callers must use the safe one.

-- ==========================================
-- 1. ORDER ITEMS TABLE
-- ==========================================
create table if not exists public.order_items (
    -- gen_random_uuid() is a Postgres built-in (in pg_catalog) and resolves
    -- regardless of the migration runner's restricted search_path.
    id uuid primary key default gen_random_uuid(),
    order_id uuid references public.orders(id) on delete cascade not null,
    product_id uuid references public.products(id) not null,
    -- Snapshot of the price at purchase time. Products may change price later;
    -- the order ledger must remember what was actually charged.
    unit_price_at_purchase numeric(12,2) not null,
    quantity integer not null check (quantity > 0),
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table public.order_items enable row level security;

create policy "Buyers and sellers can view their order items"
    on public.order_items for select using (
        exists (
            select 1 from public.orders o
            where o.id = order_id and (o.buyer_id = auth.uid() or o.seller_id = auth.uid())
        )
    );

-- ==========================================
-- 2. SAFE ORDER CREATION RPC
-- ==========================================
-- Inputs:
--   p_buyer_id   - The auth'd user creating the order (Edge Function passes auth.uid())
--   p_items      - JSONB array: [{"product_id": "...", "quantity": 2}, ...]
--   p_delivery_fee_naira - Server-known delivery fee (set by Edge Function, not client)
--   p_service_fee_naira  - Server-known SafePay fee (set by Edge Function, not client)
--   p_landmark   - Delivery destination
--   p_paystack_reference - Paystack reference, used for hold_code derivation
--   p_paid_amount_kobo   - What Paystack confirmed the buyer paid (in kobo)
--
-- Validates:
--   * Every product_id exists and has the same vendor_id (single-vendor cart only)
--   * Sum(price * qty) + fees == paid amount (kobo-precision)
--
-- Returns: order_id, hold_code, computed_total_naira
--
-- On any validation failure, raises and rolls back. The Edge Function should
-- then trigger a Paystack refund for the orphaned charge.
create or replace function public.create_order_with_escrow_v2(
    p_buyer_id uuid,
    p_items jsonb,
    p_delivery_fee_naira numeric,
    p_service_fee_naira numeric,
    p_landmark text,
    p_paystack_reference text,
    p_paid_amount_kobo integer
)
returns table (order_id uuid, hold_code text, computed_total_naira numeric)
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
    v_item jsonb;
    v_product_id uuid;
    v_quantity integer;
    v_unit_price numeric(12,2);
    v_vendor_id uuid;
    v_seller_id uuid;
    v_items_subtotal numeric(12,2) := 0;
    v_grand_total numeric(12,2);
    v_expected_kobo integer;
    v_order_id uuid;
    v_hold_code text;
begin
    if jsonb_typeof(p_items) <> 'array' or jsonb_array_length(p_items) = 0 then
        raise exception 'Cart is empty';
    end if;

    -- 1. Walk items, look up authoritative price + vendor for each.
    for v_item in select * from jsonb_array_elements(p_items)
    loop
        v_product_id := (v_item ->> 'product_id')::uuid;
        v_quantity   := (v_item ->> 'quantity')::integer;

        if v_quantity is null or v_quantity <= 0 then
            raise exception 'Invalid quantity for product %', v_product_id;
        end if;

        -- Lock the product row so price can't change underneath us mid-transaction.
        select price, vendor_id
        into v_unit_price, v_vendor_id
        from public.products
        where id = v_product_id
        for update;

        if v_unit_price is null then
            raise exception 'Product % not found or unavailable', v_product_id;
        end if;

        -- 2. Enforce single-vendor cart. This is intentional for the soft
        --    launch — multi-vendor would require splitting into N orders.
        if v_seller_id is null then
            v_seller_id := v_vendor_id;
        elsif v_seller_id <> v_vendor_id then
            raise exception 'Multi-vendor cart not supported. Split your cart by vendor.';
        end if;

        v_items_subtotal := v_items_subtotal + (v_unit_price * v_quantity);
    end loop;

    -- 3. Compute the authoritative total and check it matches Paystack.
    v_grand_total := v_items_subtotal + coalesce(p_delivery_fee_naira, 0) + coalesce(p_service_fee_naira, 0);
    v_expected_kobo := round(v_grand_total * 100)::integer;

    if v_expected_kobo <> p_paid_amount_kobo then
        raise exception
            'Amount mismatch: server expected % kobo, Paystack reported % kobo paid',
            v_expected_kobo, p_paid_amount_kobo;
    end if;

    -- 4. Persist order, items, escrow ledger atomically.
    insert into public.orders (buyer_id, seller_id, total_amount, landmark_destination)
    values (p_buyer_id, v_seller_id, v_grand_total, p_landmark)
    returning id into v_order_id;

    for v_item in select * from jsonb_array_elements(p_items)
    loop
        v_product_id := (v_item ->> 'product_id')::uuid;
        v_quantity   := (v_item ->> 'quantity')::integer;
        select price into v_unit_price from public.products where id = v_product_id;
        insert into public.order_items (order_id, product_id, unit_price_at_purchase, quantity)
        values (v_order_id, v_product_id, v_unit_price, v_quantity);
    end loop;

    v_hold_code := 'SP-' || upper(substr(p_paystack_reference, length(p_paystack_reference) - 7));

    insert into public.escrow_ledger (order_id, hold_code, buyer_id, provider_id, amount, status)
    values (v_order_id, v_hold_code, p_buyer_id, v_seller_id, v_grand_total, 'held'::escrow_status);

    return query select v_order_id, v_hold_code, v_grand_total;
end;
$$;

grant execute on function public.create_order_with_escrow_v2(uuid, jsonb, numeric, numeric, text, text, integer)
    to authenticated, service_role;

-- ==========================================
-- 3. PRICE QUOTE RPC (used at init, before Paystack)
-- ==========================================
-- Same lookup logic as v2 but read-only — used at the `init` phase so the
-- Edge Function can send the correct authoritative total to Paystack.
create or replace function public.quote_cart_total(
    p_items jsonb,
    p_delivery_fee_naira numeric,
    p_service_fee_naira numeric
)
returns table (seller_id uuid, grand_total_naira numeric, items_subtotal_naira numeric)
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
    v_item jsonb;
    v_product_id uuid;
    v_quantity integer;
    v_unit_price numeric(12,2);
    v_vendor_id uuid;
    v_seller_id uuid;
    v_items_subtotal numeric(12,2) := 0;
begin
    if jsonb_typeof(p_items) <> 'array' or jsonb_array_length(p_items) = 0 then
        raise exception 'Cart is empty';
    end if;

    for v_item in select * from jsonb_array_elements(p_items)
    loop
        v_product_id := (v_item ->> 'product_id')::uuid;
        v_quantity   := (v_item ->> 'quantity')::integer;
        if v_quantity is null or v_quantity <= 0 then
            raise exception 'Invalid quantity for product %', v_product_id;
        end if;
        select price, vendor_id into v_unit_price, v_vendor_id
        from public.products where id = v_product_id;
        if v_unit_price is null then
            raise exception 'Product % not found or unavailable', v_product_id;
        end if;
        if v_seller_id is null then
            v_seller_id := v_vendor_id;
        elsif v_seller_id <> v_vendor_id then
            raise exception 'Multi-vendor cart not supported. Split your cart by vendor.';
        end if;
        v_items_subtotal := v_items_subtotal + (v_unit_price * v_quantity);
    end loop;

    return query select v_seller_id, v_items_subtotal + coalesce(p_delivery_fee_naira, 0) + coalesce(p_service_fee_naira, 0), v_items_subtotal;
end;
$$;

grant execute on function public.quote_cart_total(jsonb, numeric, numeric)
    to authenticated, service_role;

-- ==========================================
-- 4. Drop the old, unsafe function
-- ==========================================
-- Old signature trusted client-supplied seller_id + amount. Remove it so no
-- caller can accidentally use it.
drop function if exists public.create_order_with_escrow(uuid, uuid, numeric, text, text);
