"use server";

import { revalidatePath } from "next/cache";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/auth";

export async function broadcast(formData: FormData) {
  await requireAdmin();
  const db = createAdminClient();
  const title = String(formData.get("title") || "").trim();
  const body = String(formData.get("body") || "").trim() || null;
  const target = String(formData.get("target") || "all").trim();
  if (!title) throw new Error("Title is required");

  if (target === "all" || target === "") {
    const { data } = await db.from("profiles").select("id");
    const rows = (data || []).map((p: any) => ({
      user_id: p.id,
      title,
      body,
      type: "admin",
    }));
    for (let i = 0; i < rows.length; i += 500) {
      await db.from("notifications").insert(rows.slice(i, i + 500));
    }
  } else {
    await db.from("notifications").insert({ user_id: target, title, body, type: "admin" });
  }
  revalidatePath("/notifications");
}
