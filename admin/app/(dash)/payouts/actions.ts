"use server";

import { revalidatePath } from "next/cache";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/auth";

async function setStatus(id: string, status: string) {
  const db = createAdminClient();
  await db
    .from("payout_requests")
    .update({ status, processed_at: new Date().toISOString() })
    .eq("id", id);
  revalidatePath("/payouts");
}

export async function approvePayout(formData: FormData) {
  await requireAdmin();
  await setStatus(String(formData.get("id")), "approved");
}

export async function markPaid(formData: FormData) {
  await requireAdmin();
  await setStatus(String(formData.get("id")), "paid");
}

export async function rejectPayout(formData: FormData) {
  await requireAdmin();
  await setStatus(String(formData.get("id")), "rejected");
}
