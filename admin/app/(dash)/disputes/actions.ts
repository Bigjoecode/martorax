"use server";

import { revalidatePath } from "next/cache";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/auth";
import { logAction } from "@/lib/audit";

export async function resolveDispute(formData: FormData) {
  const { user } = await requireAdmin();
  const id = String(formData.get("id"));
  const escrowId = String(formData.get("escrow_id"));
  const notes = String(formData.get("notes") || "");
  const outcome = String(formData.get("outcome")); // "release" | "refund"
  const db = createAdminClient();

  await db
    .from("escrow_disputes")
    .update({ is_resolved: true, mediator_notes: notes })
    .eq("id", id);

  if (escrowId) {
    if (outcome === "release") {
      await db
        .from("escrow_ledger")
        .update({ status: "released", released_at: new Date().toISOString() })
        .eq("id", escrowId);
    } else {
      await db.from("escrow_ledger").update({ status: "resolved" }).eq("id", escrowId);
    }
  }
  await logAction(user.email, "resolve_dispute", "dispute", id, `outcome=${outcome}`);
  revalidatePath("/disputes");
}
