-- KYC verification state + service bookings + rider assignment.
--
-- Apply with `supabase db push` or paste into the SQL editor.

-- ==========================================
-- 1. KYC verification fields on profiles
-- ==========================================
-- kyc_status: unverified -> pending (docs submitted) -> verified | rejected
alter table public.profiles
    add column if not exists kyc_status text not null default 'unverified',
    add column if not exists kyc_id_type text,
    add column if not exists kyc_id_url text,
    add column if not exists kyc_selfie_url text,
    add column if not exists kyc_submitted_at timestamptz,
    add column if not exists kyc_reviewed_at timestamptz,
    add column if not exists kyc_reject_reason text;

-- ==========================================
-- 2. Service bookings (a shopper books a service provider)
-- ==========================================
create table if not exists public.service_bookings (
    id uuid primary key default gen_random_uuid(),
    shopper_id uuid references public.profiles(id) on delete cascade not null,
    provider_id uuid references public.profiles(id) on delete cascade not null,
    service_category text,
    description text,
    amount numeric(12,2) default 0,
    -- requested -> accepted -> completed | cancelled
    status text not null default 'requested',
    scheduled_for timestamptz,
    created_at timestamptz default timezone('utc'::text, now()) not null
);

alter table public.service_bookings enable row level security;

create policy "Booking parties can read"
    on public.service_bookings for select
    using (auth.uid() = shopper_id or auth.uid() = provider_id);

create policy "Shoppers can create bookings"
    on public.service_bookings for insert
    with check (auth.uid() = shopper_id);

create policy "Booking parties can update"
    on public.service_bookings for update
    using (auth.uid() = shopper_id or auth.uid() = provider_id);

create index if not exists service_bookings_provider_idx
    on public.service_bookings (provider_id);
create index if not exists service_bookings_shopper_idx
    on public.service_bookings (shopper_id);

-- ==========================================
-- 3. Rider assignment on orders (for the rider deliveries dashboard)
-- ==========================================
alter table public.orders
    add column if not exists rider_id uuid references public.profiles(id);

create index if not exists orders_rider_idx on public.orders (rider_id);

-- Let an assigned rider read the order they're delivering.
drop policy if exists "Riders can view assigned orders" on public.orders;
create policy "Riders can view assigned orders"
    on public.orders for select using (auth.uid() = rider_id);
