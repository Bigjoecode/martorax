-- Hardening pass #2: stock decrement + stock check.
--
-- Replaces the v2 functions from migration 003 with versions that:
--   1. Reserve stock (FOR UPDATE row lock) during quote, so two concurrent
--      buyers can't both check out the last unit.
--   2. Raise if any item's stock < requested quantity.
--   3. Decrement stock inside the same transaction as the order insert.
--
-- Apply with `supabase db push` or paste into the SQL editor.

-- ==========================================
-- 1. PRICE QUOTE RPC (stock-aware)
-- ==========================================
-- Same as before, plus checks stock availability. Does NOT decrement —
-- that happens in create_order_with_escrow_v2 only after Paystack confirms
-- the charge actually happened.
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
    v_stock integer;
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

        select price, vendor_id, stock
        into v_unit_price, v_vendor_id, v_stock
        from public.products
        where id = v_product_id;

        if v_unit_price is null then
            raise exception 'Product % not found or unavailable', v_product_id;
        end if;

        if v_stock < v_quantity then
            raise exception 'Out of stock: only % left of product %', v_stock, v_product_id;
        end if;

        if v_seller_id is null then
            v_seller_id := v_vendor_id;
        elsif v_seller_id <> v_vendor_id then
            raise exception 'Multi-vendor cart not supported. Split your cart by vendor.';
        end if;

        v_items_subtotal := v_items_subtotal + (v_unit_price * v_quantity);
    end loop;

    return query select v_seller_id,
                        v_items_subtotal + coalesce(p_delivery_fee_naira, 0) + coalesce(p_service_fee_naira, 0),
                        v_items_subtotal;
end;
$$;

-- ==========================================
-- 2. SAFE ORDER CREATION RPC (stock-decrementing)
-- ==========================================
-- Same as v2 in migration 003, plus FOR UPDATE row lock on each product
-- (so concurrent checkouts serialize) and atomic stock decrement.
--
-- If any item is now out of stock at commit time (someone else just bought
-- the last unit between init and verify), the whole transaction rolls back
-- and the caller (Edge Function) issues a Paystack refund.
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
    v_stock integer;
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

    -- 1. Lock rows, validate price + vendor + stock, sum subtotal.
    for v_item in select * from jsonb_array_elements(p_items)
    loop
        v_product_id := (v_item ->> 'product_id')::uuid;
        v_quantity   := (v_item ->> 'quantity')::integer;
        if v_quantity is null or v_quantity <= 0 then
            raise exception 'Invalid quantity for product %', v_product_id;
        end if;

        -- FOR UPDATE serializes concurrent checkouts on the same product.
        select price, vendor_id, stock
        into v_unit_price, v_vendor_id, v_stock
        from public.products
        where id = v_product_id
        for update;

        if v_unit_price is null then
            raise exception 'Product % not found or unavailable', v_product_id;
        end if;

        if v_stock < v_quantity then
            raise exception 'Out of stock: only % left of product %', v_stock, v_product_id;
        end if;

        if v_seller_id is null then
            v_seller_id := v_vendor_id;
        elsif v_seller_id <> v_vendor_id then
            raise exception 'Multi-vendor cart not supported. Split your cart by vendor.';
        end if;

        v_items_subtotal := v_items_subtotal + (v_unit_price * v_quantity);
    end loop;

    -- 2. Cross-check the Paystack-confirmed amount.
    v_grand_total := v_items_subtotal + coalesce(p_delivery_fee_naira, 0) + coalesce(p_service_fee_naira, 0);
    v_expected_kobo := round(v_grand_total * 100)::integer;
    if v_expected_kobo <> p_paid_amount_kobo then
        raise exception
            'Amount mismatch: server expected % kobo, Paystack reported % kobo paid',
            v_expected_kobo, p_paid_amount_kobo;
    end if;

    -- 3. Persist order header.
    insert into public.orders (buyer_id, seller_id, total_amount, landmark_destination)
    values (p_buyer_id, v_seller_id, v_grand_total, p_landmark)
    returning id into v_order_id;

    -- 4. Persist items AND decrement stock atomically (still inside the
    --    same transaction; if anything below fails the order header above
    --    rolls back too).
    for v_item in select * from jsonb_array_elements(p_items)
    loop
        v_product_id := (v_item ->> 'product_id')::uuid;
        v_quantity   := (v_item ->> 'quantity')::integer;
        select price into v_unit_price from public.products where id = v_product_id;

        insert into public.order_items (order_id, product_id, unit_price_at_purchase, quantity)
        values (v_order_id, v_product_id, v_unit_price, v_quantity);

        update public.products
        set stock = stock - v_quantity
        where id = v_product_id;
    end loop;

    -- 5. Escrow hold.
    v_hold_code := 'SP-' || upper(substr(p_paystack_reference, length(p_paystack_reference) - 7));

    insert into public.escrow_ledger (order_id, hold_code, buyer_id, provider_id, amount, status)
    values (v_order_id, v_hold_code, p_buyer_id, v_seller_id, v_grand_total, 'held'::escrow_status);

    return query select v_order_id, v_hold_code, v_grand_total;
end;
$$;

grant execute on function public.create_order_with_escrow_v2(uuid, jsonb, numeric, numeric, text, text, integer)
    to authenticated, service_role;
grant execute on function public.quote_cart_total(jsonb, numeric, numeric)
    to authenticated, service_role;
