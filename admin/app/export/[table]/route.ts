import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/auth";

export const dynamic = "force-dynamic";

// Whitelisted tables + the columns to export.
const TABLES: Record<string, string> = {
  orders: "id, buyer_id, seller_id, rider_id, total_amount, delivery_status, landmark_destination, created_at",
  users: "id, full_name, phone_number, active_role, kyc_status, rating, business_name, created_at",
  products: "id, vendor_id, title, price, wholesale_price, stock, location, created_at",
  payouts: "id, user_id, amount, status, bank_name, account_number, account_name, created_at, processed_at",
  bookings: "id, shopper_id, provider_id, service_category, amount, status, created_at",
  escrow: "id, order_id, hold_code, buyer_id, provider_id, amount, status, created_at",
};

// Table name -> actual Supabase table.
const SOURCE: Record<string, string> = {
  orders: "orders",
  users: "profiles",
  products: "products",
  payouts: "payout_requests",
  bookings: "service_bookings",
  escrow: "escrow_ledger",
};

function csvCell(v: unknown): string {
  if (v == null) return "";
  const s = String(v);
  return /[",\n]/.test(s) ? `"${s.replace(/"/g, '""')}"` : s;
}

export async function GET(_req: NextRequest, ctx: { params: Promise<{ table: string }> }) {
  await requireAdmin();
  const { table } = await ctx.params;
  const cols = TABLES[table];
  const source = SOURCE[table];
  if (!cols || !source) {
    return new NextResponse("Unknown export", { status: 400 });
  }

  const db = createAdminClient();
  const { data, error } = await db
    .from(source)
    .select(cols)
    .order("created_at", { ascending: false })
    .limit(10000);

  if (error) return new NextResponse(error.message, { status: 500 });

  const headers = cols.split(",").map((c) => c.trim());
  const lines = [headers.join(",")];
  for (const row of (data || []) as unknown as Record<string, unknown>[]) {
    lines.push(headers.map((h) => csvCell(row[h])).join(","));
  }
  const csv = lines.join("\n");
  const date = new Date().toISOString().slice(0, 10);

  return new NextResponse(csv, {
    headers: {
      "Content-Type": "text/csv; charset=utf-8",
      "Content-Disposition": `attachment; filename="martorax-${table}-${date}.csv"`,
    },
  });
}
