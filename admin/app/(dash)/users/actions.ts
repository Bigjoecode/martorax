"use server";

import { revalidatePath } from "next/cache";
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

export async function deleteUser(formData: FormData) {
  await requireAdmin();
  const id = String(formData.get("id"));
  const db = createAdminClient();
  // Removing the auth user cascades to the profile row.
  await db.auth.admin.deleteUser(id).catch(async () => {
    await db.from("profiles").delete().eq("id", id);
  });
  revalidatePath("/users");
}
