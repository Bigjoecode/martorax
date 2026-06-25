-- Withdrawal / payout requests (vendor, provider, rider "Withdraw" button).
-- Admin processes them from the dashboard.

create table if not exists public.payout_requests (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references public.profiles(id) on delete cascade not null,
    amount numeric(12,2) not null,
    -- requested -> approved -> paid | rejected
    status text not null default 'requested',
    bank_name text,
    account_number text,
    account_name text,
    note text,
    created_at timestamptz default timezone('utc'::text, now()) not null,
    processed_at timestamptz
);

alter table public.payout_requests enable row level security;

drop policy if exists "Users read own payouts" on public.payout_requests;
create policy "Users read own payouts"
    on public.payout_requests for select using (auth.uid() = user_id);

drop policy if exists "Users request payouts" on public.payout_requests;
create policy "Users request payouts"
    on public.payout_requests for insert with check (auth.uid() = user_id);

create index if not exists payout_requests_user_idx
    on public.payout_requests (user_id, created_at desc);
create index if not exists payout_requests_status_idx
    on public.payout_requests (status);
