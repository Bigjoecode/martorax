"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin, requireSuperAdmin } from "@/lib/auth";
import { logAction } from "@/lib/audit";

function num(v: FormDataEntryValue | null): number | null {
  if (v == null || v === "") return null;
  const n = Number(v);
  return Number.isFinite(n) ? n : null;
}

function fields(formData: FormData) {
  return {
    title: String(formData.get("title") || "").trim(),
    description: String(formData.get("description") || "").trim() || null,
    price: num(formData.get("price")) ?? 0,
    wholesale_price: num(formData.get("wholesale_price")),
    stock: num(formData.get("stock")) ?? 0,
    location: String(formData.get("location") || "Asaba").trim(),
    category: String(formData.get("category") || "").trim() || null,
    image_url: String(formData.get("image_url") || "").trim() || null,
  };
}

export async function createProduct(formData: FormData) {
  const { user } = await requireAdmin();
  const db = createAdminClient();
  const vendorId = String(formData.get("vendor_id") || "").trim();
  if (!vendorId) throw new Error("vendor_id is required");
  const { data } = await db
    .from("products")
    .insert({ vendor_id: vendorId, ...fields(formData) })
    .select("id")
    .single();
  await logAction(user.email, "create_product", "product", data?.id);
  revalidatePath("/products");
  redirect("/products");
}

export async function updateProduct(formData: FormData) {
  const { user } = await requireAdmin();
  const db = createAdminClient();
  const id = String(formData.get("id"));
  await db.from("products").update(fields(formData)).eq("id", id);
  await logAction(user.email, "update_product", "product", id);
  revalidatePath("/products");
  redirect("/products");
}

export async function deleteProduct(formData: FormData) {
  const { user } = await requireSuperAdmin();
  const id = String(formData.get("id"));
  const db = createAdminClient();
  await db.from("products").delete().eq("id", id);
  await logAction(user.email, "delete_product", "product", id);
  revalidatePath("/products");
}

export async function updateStock(formData: FormData) {
  const { user } = await requireAdmin();
  const id = String(formData.get("id"));
  const stock = Number(formData.get("stock"));
  const db = createAdminClient();
  await db.from("products").update({ stock }).eq("id", id);
  await logAction(user.email, "update_stock", "product", id, `stock=${stock}`);
  revalidatePath("/products");
}
