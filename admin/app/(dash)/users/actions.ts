"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/auth";

export async function updateRole(formData: FormData) {
  await requireAdmin();
  const id = String(formData.get("id"));
  const role = String(formData.get("role"));
  const db = createAdminClient();
  await db.from("profiles").update({ active_role: role }).eq("id", id);
  revalidatePath("/users");
}

export async function updateProfile(formData: FormData) {
  await requireAdmin();
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
  revalidatePath("/users");
  redirect("/users");
}

export async function deleteUser(formData: FormData) {
  await requireAdmin();
  const id = String(formData.get("id"));
  const db = createAdminClient();
  await db.auth.admin.deleteUser(id).catch(async () => {
    await db.from("profiles").delete().eq("id", id);
  });
  revalidatePath("/users");
}
