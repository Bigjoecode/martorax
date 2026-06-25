"use server";

import { revalidatePath } from "next/cache";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/auth";

export async function updateOrderStatus(formData: FormData) {
  await requireAdmin();
  const id = String(formData.get("id"));
  const status = String(formData.get("status"));
  const db = createAdminClient();
  await db.from("orders").update({ delivery_status: status }).eq("id", id);
  revalidatePath("/orders");
  revalidatePath(`/orders/${id}`);
}

export async function assignRider(formData: FormData) {
  await requireAdmin();
  const id = String(formData.get("id"));
  const riderId = String(formData.get("rider_id") || "").trim();
  const db = createAdminClient();
  await db.from("orders").update({ rider_id: riderId || null }).eq("id", id);
  revalidatePath(`/orders/${id}`);
}

export async function deleteOrder(formData: FormData) {
  await requireAdmin();
  const id = String(formData.get("id"));
  const db = createAdminClient();
  await db.from("orders").delete().eq("id", id);
  revalidatePath("/orders");
}
