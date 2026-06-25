"use server";

import { revalidatePath } from "next/cache";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/auth";

export async function releaseEscrow(formData: FormData) {
  await requireAdmin();
  const id = String(formData.get("id"));
  const db = createAdminClient();
  await db
    .from("escrow_ledger")
    .update({ status: "released", released_at: new Date().toISOString() })
    .eq("id", id);
  revalidatePath("/escrow");
}

export async function refundEscrow(formData: FormData) {
  await requireAdmin();
  const id = String(formData.get("id"));
  const db = createAdminClient();
  // Mark resolved (funds returned to buyer out-of-band / via Paystack refund).
  await db.from("escrow_ledger").update({ status: "resolved" }).eq("id", id);
  revalidatePath("/escrow");
}
