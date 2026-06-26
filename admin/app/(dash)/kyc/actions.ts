"use server";

import { revalidatePath } from "next/cache";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/auth";
import { logAction } from "@/lib/audit";

export async function approveKyc(formData: FormData) {
  const { user } = await requireAdmin();
  const id = String(formData.get("id"));
  const db = createAdminClient();
  await db
    .from("profiles")
    .update({
      kyc_status: "verified",
      kyc_reviewed_at: new Date().toISOString(),
      kyc_reject_reason: null,
    })
    .eq("id", id);
  await logAction(user.email, "kyc_approve", "profile", id);
  revalidatePath("/kyc");
  revalidatePath(`/users/${id}`);
}

export async function rejectKyc(formData: FormData) {
  const { user } = await requireAdmin();
  const id = String(formData.get("id"));
  const reason = String(formData.get("reason") || "Documents unclear or invalid");
  const db = createAdminClient();
  await db
    .from("profiles")
    .update({
      kyc_status: "rejected",
      kyc_reviewed_at: new Date().toISOString(),
      kyc_reject_reason: reason,
    })
    .eq("id", id);
  await logAction(user.email, "kyc_reject", "profile", id, reason);
  revalidatePath("/kyc");
  revalidatePath(`/users/${id}`);
}
