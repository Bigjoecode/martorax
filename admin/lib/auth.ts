import { redirect } from "next/navigation";
import { createSupabaseServerClient } from "./supabase/server";

function emailList(envVar: string | undefined): string[] {
  return (envVar || "")
    .split(",")
    .map((e) => e.trim().toLowerCase())
    .filter(Boolean);
}

export function adminEmails(): string[] {
  return emailList(process.env.ADMIN_EMAILS);
}

export function superAdminEmails(): string[] {
  return emailList(process.env.SUPER_ADMIN_EMAILS);
}

export function isAdminEmail(email: string | undefined | null): boolean {
  if (!email) return false;
  const allow = adminEmails();
  if (allow.length === 0) return false;
  return allow.includes(email.toLowerCase());
}

export type AdminRole = "super" | "support";

/**
 * Role for an admin email. If SUPER_ADMIN_EMAILS is unset, every admin is a
 * super-admin (backwards compatible). Otherwise only listed emails are super.
 */
export function adminRole(email: string | undefined | null): AdminRole {
  if (!email) return "support";
  const supers = superAdminEmails();
  if (supers.length === 0) return "super";
  return supers.includes(email.toLowerCase()) ? "super" : "support";
}

/** Returns the signed-in admin user (+ role) or redirects to /login. */
export async function requireAdmin() {
  const supabase = await createSupabaseServerClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user || !isAdminEmail(user.email)) {
    redirect("/login");
  }
  return { user, role: adminRole(user.email) };
}

/** Like requireAdmin but only allows super-admins (for destructive actions). */
export async function requireSuperAdmin() {
  const { user, role } = await requireAdmin();
  if (role !== "super") {
    throw new Error("This action requires a super-admin account.");
  }
  return { user, role };
}
