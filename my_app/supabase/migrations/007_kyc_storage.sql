-- Private storage bucket for KYC documents + per-user access policies.
--
-- Documents are stored at  kyc-docs/{user_id}/id.jpg  and  .../selfie.jpg
-- Each user may only read/write their own folder. The admin dashboard reads
-- with the service-role key, which bypasses these policies.

-- 1. Create the private bucket (idempotent).
insert into storage.buckets (id, name, public)
values ('kyc-docs', 'kyc-docs', false)
on conflict (id) do nothing;

-- 2. Per-user RLS on storage.objects for this bucket.
drop policy if exists "kyc upload own folder" on storage.objects;
create policy "kyc upload own folder"
    on storage.objects for insert to authenticated
    with check (
        bucket_id = 'kyc-docs'
        and (storage.foldername(name))[1] = auth.uid()::text
    );

drop policy if exists "kyc update own folder" on storage.objects;
create policy "kyc update own folder"
    on storage.objects for update to authenticated
    using (
        bucket_id = 'kyc-docs'
        and (storage.foldername(name))[1] = auth.uid()::text
    );

drop policy if exists "kyc read own folder" on storage.objects;
create policy "kyc read own folder"
    on storage.objects for select to authenticated
    using (
        bucket_id = 'kyc-docs'
        and (storage.foldername(name))[1] = auth.uid()::text
    );
