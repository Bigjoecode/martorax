"use server";

import { revalidatePath } from "next/cache";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/auth";

export async function updateBookingStatus(formData: FormData) {
  await requireAdmin();
  const id = String(formData.get("id"));
  const status = String(formData.get("status"));
  const db = createAdminClient();
  await db.from("service_bookings").update({ status }).eq("id", id);
  revalidatePath("/bookings");
}

export async function deleteBooking(formData: FormData) {
  await requireAdmin();
  const id = String(formData.get("id"));
  const db = createAdminClient();
  await db.from("service_bookings").delete().eq("id", id);
  revalidatePath("/bookings");
}
