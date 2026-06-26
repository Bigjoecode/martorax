"use server";

import { revalidatePath } from "next/cache";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireSuperAdmin } from "@/lib/auth";
import { logAction } from "@/lib/audit";

async function setStatus(formData: FormData, status: string) {
  const { user } = await requireSuperAdmin();
  const id = String(formData.get("id"));
  const db = createAdminClient();
  await db
    .from("payout_requests")
    .update({ status, processed_at: new Date().toISOString() })
    .eq("id", id);
  await logAction(user.email, `payout_${status}`, "payout", id);
  revalidatePath("/payouts");
}

export async function approvePayout(formData: FormData) {
  await setStatus(formData, "approved");
}
export async function markPaid(formData: FormData) {
  await setStatus(formData, "paid");
}
export async function rejectPayout(formData: FormData) {
  await setStatus(formData, "rejected");
}
