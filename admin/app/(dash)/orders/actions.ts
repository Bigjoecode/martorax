"use server";

import { revalidatePath } from "next/cache";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin, requireSuperAdmin } from "@/lib/auth";
import { logAction } from "@/lib/audit";

export async function updateOrderStatus(formData: FormData) {
  const { user } = await requireAdmin();
  const id = String(formData.get("id"));
  const status = String(formData.get("status"));
  const db = createAdminClient();
  await db.from("orders").update({ delivery_status: status }).eq("id", id);
  await logAction(user.email, "update_order_status", "order", id, `status=${status}`);
  revalidatePath("/orders");
  revalidatePath(`/orders/${id}`);
}

export async function assignRider(formData: FormData) {
  const { user } = await requireAdmin();
  const id = String(formData.get("id"));
  const riderId = String(formData.get("rider_id") || "").trim();
  const db = createAdminClient();
  await db.from("orders").update({ rider_id: riderId || null }).eq("id", id);
  await logAction(user.email, "assign_rider", "order", id, `rider=${riderId || "none"}`);
  revalidatePath(`/orders/${id}`);
}

export async function deleteOrder(formData: FormData) {
  const { user } = await requireSuperAdmin();
  const id = String(formData.get("id"));
  const db = createAdminClient();
  await db.from("orders").delete().eq("id", id);
  await logAction(user.email, "delete_order", "order", id);
  revalidatePath("/orders");
}
