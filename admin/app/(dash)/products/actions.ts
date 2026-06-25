"use server";

import { revalidatePath } from "next/cache";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/auth";

export async function deleteProduct(formData: FormData) {
  await requireAdmin();
  const id = String(formData.get("id"));
  const db = createAdminClient();
  await db.from("products").delete().eq("id", id);
  revalidatePath("/products");
}

export async function updateStock(formData: FormData) {
  await requireAdmin();
  const id = String(formData.get("id"));
  const stock = Number(formData.get("stock"));
  const db = createAdminClient();
  await db.from("products").update({ stock }).eq("id", id);
  revalidatePath("/products");
}
