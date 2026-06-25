"use server";

import { revalidatePath } from "next/cache";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/auth";

export async function approveKyc(formData: FormData) {
  await requireAdmin();
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
  revalidatePath("/kyc");
}

export async function rejectKyc(formData: FormData) {
  await requireAdmin();
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
  revalidatePath("/kyc");
}
