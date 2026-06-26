"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin, requireSuperAdmin } from "@/lib/auth";
import { logAction } from "@/lib/audit";

export async function updateRole(formData: FormData) {
  const { user } = await requireAdmin();
  const id = String(formData.get("id"));
  const role = String(formData.get("role"));
  const db = createAdminClient();
  await db.from("profiles").update({ active_role: role }).eq("id", id);
  await logAction(user.email, "update_role", "profile", id, `role=${role}`);
  revalidatePath("/users");
}

export async function updateProfile(formData: FormData) {
  const { user } = await requireAdmin();
  const id = String(formData.get("id"));
  const db = createAdminClient();
  const rating = formData.get("rating");
  await db
    .from("profiles")
    .update({
      full_name: String(formData.get("full_name") || "").trim(),
      phone_number: String(formData.get("phone_number") || "").trim() || null,
      active_role: String(formData.get("active_role") || "shopper"),
      kyc_status: String(formData.get("kyc_status") || "unverified"),
      rating: rating ? Number(rating) : null,
      business_name: String(formData.get("business_name") || "").trim() || null,
      service_category: String(formData.get("service_category") || "").trim() || null,
      landmark_address: String(formData.get("landmark_address") || "").trim() || null,
    })
    .eq("id", id);
  await logAction(user.email, "update_profile", "profile", id);
  revalidatePath("/users");
  redirect("/users");
}

export async function endVendorLive(formData: FormData) {
  const { user } = await requireAdmin();
  const id = String(formData.get("id"));
  const db = createAdminClient();
  await db.from("profiles").update({ is_live: false }).eq("id", id);
  await logAction(user.email, "end_vendor_live", "profile", id);
  revalidatePath("/users");
  revalidatePath(`/users/${id}`);
}

export async function deleteUser(formData: FormData) {
  const { user } = await requireSuperAdmin();
  const id = String(formData.get("id"));
  const db = createAdminClient();
  await db.auth.admin.deleteUser(id).catch(async () => {
    await db.from("profiles").delete().eq("id", id);
  });
  await logAction(user.email, "delete_user", "profile", id);
  revalidatePath("/users");
}
