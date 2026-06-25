import { createClient } from "@supabase/supabase-js";

/**
 * Server-only Supabase client using the service_role key.
 * Bypasses RLS so the admin can read/write across every user's data.
 * NEVER import this into a Client Component — it would leak the secret.
 */
export function createAdminClient() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const serviceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
  if (!url || !serviceKey) {
    throw new Error(
      "Missing NEXT_PUBLIC_SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY env vars."
    );
  }
  return createClient(url, serviceKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  });
}
