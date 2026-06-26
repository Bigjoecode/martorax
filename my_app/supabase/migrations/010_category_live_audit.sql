-- Product category, vendor live-stream status, and admin audit log.

-- 1. Product category (for revenue-by-category analytics).
alter table public.products
    add column if not exists category text;

-- 2. Vendor "go live" status.
alter table public.profiles
    add column if not exists is_live boolean not null default false,
    add column if not exists live_started_at timestamptz;

-- 3. Admin audit log. RLS on with NO policies => only the service role
--    (the admin dashboard) can read/write it; never exposed to app users.
create table if not exists public.admin_audit_log (
    id uuid primary key default gen_random_uuid(),
    actor_email text not null,
    action text not null,
    entity text,
    entity_id text,
    detail text,
    created_at timestamptz default timezone('utc'::text, now()) not null
);

alter table public.admin_audit_log enable row level security;

create index if not exists admin_audit_log_created_idx
    on public.admin_audit_log (created_at desc);
