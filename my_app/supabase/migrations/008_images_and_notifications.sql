-- Product image storage + in-app notifications.
--
-- Apply with `supabase db push` or paste into the SQL editor.

-- ==========================================
-- 1. Public bucket for product images
-- ==========================================
insert into storage.buckets (id, name, public)
values ('product-images', 'product-images', true)
on conflict (id) do nothing;

-- Vendors upload/replace only inside their own {uid}/ folder; everyone can read.
drop policy if exists "product images upload own" on storage.objects;
create policy "product images upload own"
    on storage.objects for insert to authenticated
    with check (
        bucket_id = 'product-images'
        and (storage.foldername(name))[1] = auth.uid()::text
    );

drop policy if exists "product images update own" on storage.objects;
create policy "product images update own"
    on storage.objects for update to authenticated
    using (
        bucket_id = 'product-images'
        and (storage.foldername(name))[1] = auth.uid()::text
    );

drop policy if exists "product images public read" on storage.objects;
create policy "product images public read"
    on storage.objects for select to public
    using (bucket_id = 'product-images');

-- ==========================================
-- 2. In-app notifications
-- ==========================================
create table if not exists public.notifications (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references public.profiles(id) on delete cascade not null,
    title text not null,
    body text,
    type text default 'general',
    is_read boolean default false not null,
    created_at timestamptz default timezone('utc'::text, now()) not null
);

alter table public.notifications enable row level security;

drop policy if exists "Users read own notifications" on public.notifications;
create policy "Users read own notifications"
    on public.notifications for select using (auth.uid() = user_id);

drop policy if exists "Users update own notifications" on public.notifications;
create policy "Users update own notifications"
    on public.notifications for update using (auth.uid() = user_id);

create index if not exists notifications_user_idx
    on public.notifications (user_id, created_at desc);

-- Auto-create notifications for both parties when an order is created.
create or replace function public.notify_on_order()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
    insert into public.notifications (user_id, title, body, type)
    values
        (new.buyer_id, 'Order placed',
         'Your order of ₦' || new.total_amount || ' is being processed.', 'order'),
        (new.seller_id, 'New order received',
         'You received a new order worth ₦' || new.total_amount || '.', 'order');
    return new;
end;
$$;

drop trigger if exists trg_notify_on_order on public.orders;
create trigger trg_notify_on_order
    after insert on public.orders
    for each row execute function public.notify_on_order();
