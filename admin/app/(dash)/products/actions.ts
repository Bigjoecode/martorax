"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/auth";

function num(v: FormDataEntryValue | null): number | null {
  if (v == null || v === "") return null;
  const n = Number(v);
  return Number.isFinite(n) ? n : null;
}

export async function createProduct(formData: FormData) {
  await requireAdmin();
  const db = createAdminClient();
  const vendorId = String(formData.get("vendor_id") || "").trim();
  if (!vendorId) throw new Error("vendor_id is required");
  await db.from("products").insert({
    vendor_id: vendorId,
    title: String(formData.get("title") || "").trim(),
    description: String(formData.get("description") || "").trim() || null,
    price: num(formData.get("price")) ?? 0,
    wholesale_price: num(formData.get("wholesale_price")),
    stock: num(formData.get("stock")) ?? 0,
    location: String(formData.get("location") || "Asaba").trim(),
    image_url: String(formData.get("image_url") || "").trim() || null,
  });
  revalidatePath("/products");
  redirect("/products");
}

export async function updateProduct(formData: FormData) {
  await requireAdmin();
  const db = createAdminClient();
  const id = String(formData.get("id"));
  await db
    .from("products")
    .update({
      title: String(formData.get("title") || "").trim(),
      description: String(formData.get("description") || "").trim() || null,
      price: num(formData.get("price")) ?? 0,
      wholesale_price: num(formData.get("wholesale_price")),
      stock: num(formData.get("stock")) ?? 0,
      location: String(formData.get("location") || "Asaba").trim(),
      image_url: String(formData.get("image_url") || "").trim() || null,
    })
    .eq("id", id);
  revalidatePath("/products");
  redirect("/products");
}

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
