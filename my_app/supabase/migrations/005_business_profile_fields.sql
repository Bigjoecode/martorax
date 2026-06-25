-- Vendor + Service Provider business detail columns on profiles.
--
-- These were missing, so the in-app onboarding screens (vendor_register,
-- provider_register) collected info that had nowhere to go. After this
-- migration the screens upsert directly into profiles for the signed-in
-- user.
--
-- Apply with `supabase db push` or paste into the SQL editor.

alter table public.profiles
    add column if not exists business_name text,
    add column if not exists business_market text,
    add column if not exists business_stall text,
    add column if not exists business_type text,
    add column if not exists service_category text,
    add column if not exists service_experience_years integer,
    add column if not exists onboarding_completed boolean default false not null;

-- Helpful index for vendor lookups (rare, but the admin dashboard will use it)
create index if not exists profiles_business_market_idx
    on public.profiles (business_market)
    where business_market is not null;

create index if not exists profiles_service_category_idx
    on public.profiles (service_category)
    where service_category is not null;
