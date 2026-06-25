import { redirect } from "next/navigation";
import { createSupabaseServerClient } from "./supabase/server";

export function adminEmails(): string[] {
  return (process.env.ADMIN_EMAILS || "")
    .split(",")
    .map((e) => e.trim().toLowerCase())
    .filter(Boolean);
}

export function isAdminEmail(email: string | undefined | null): boolean {
  if (!email) return false;
  const allow = adminEmails();
  // If no allowlist configured, deny by default (safer).
  if (allow.length === 0) return false;
  return allow.includes(email.toLowerCase());
}

/**
 * Returns the signed-in admin user or redirects to /login.
 * Use at the top of every protected page/layout.
 */
export async function requireAdmin() {
  const supabase = await createSupabaseServerClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user || !isAdminEmail(user.email)) {
    redirect("/login");
  }
  return user;
}
