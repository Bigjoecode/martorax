"use server";

import { revalidatePath } from "next/cache";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireSuperAdmin } from "@/lib/auth";
import { logAction } from "@/lib/audit";

export async function releaseEscrow(formData: FormData) {
  const { user } = await requireSuperAdmin();
  const id = String(formData.get("id"));
  const db = createAdminClient();
  await db
    .from("escrow_ledger")
    .update({ status: "released", released_at: new Date().toISOString() })
    .eq("id", id);
  await logAction(user.email, "release_escrow", "escrow", id);
  revalidatePath("/escrow");
}

export async function refundEscrow(formData: FormData) {
  const { user } = await requireSuperAdmin();
  const id = String(formData.get("id"));
  const db = createAdminClient();
  await db.from("escrow_ledger").update({ status: "resolved" }).eq("id", id);
  await logAction(user.email, "refund_escrow", "escrow", id);
  revalidatePath("/escrow");
}
