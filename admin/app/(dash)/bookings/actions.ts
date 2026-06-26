"use server";

import { revalidatePath } from "next/cache";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin, requireSuperAdmin } from "@/lib/auth";
import { logAction } from "@/lib/audit";

export async function updateBookingStatus(formData: FormData) {
  const { user } = await requireAdmin();
  const id = String(formData.get("id"));
  const status = String(formData.get("status"));
  const db = createAdminClient();
  await db.from("service_bookings").update({ status }).eq("id", id);
  await logAction(user.email, "update_booking_status", "booking", id, `status=${status}`);
  revalidatePath("/bookings");
}

export async function deleteBooking(formData: FormData) {
  const { user } = await requireSuperAdmin();
  const id = String(formData.get("id"));
  const db = createAdminClient();
  await db.from("service_bookings").delete().eq("id", id);
  await logAction(user.email, "delete_booking", "booking", id);
  revalidatePath("/bookings");
}
