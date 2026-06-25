import { createAdminClient } from "@/lib/supabase/admin";
import { naira, shortDate, shortId } from "@/lib/format";

export const dynamic = "force-dynamic";

async function getStats() {
  const db = createAdminClient();

  const [profiles, products, orders, escrowHeld, disputes, recentOrders] = await Promise.all([
    db.from("profiles").select("id", { count: "exact", head: true }),
    db.from("products").select("id", { count: "exact", head: true }),
    db.from("orders").select("total_amount"),
    db.from("escrow_ledger").select("amount").eq("status", "held"),
    db.from("escrow_disputes").select("id", { count: "exact", head: true }).eq("is_resolved", false),
    db.from("orders").select("id, buyer_id, total_amount, delivery_status, created_at").order("created_at", { ascending: false }).limit(8),
  ]);

  const gmv = (orders.data || []).reduce((s, o: any) => s + Number(o.total_amount || 0), 0);
  const held = (escrowHeld.data || []).reduce((s, e: any) => s + Number(e.amount || 0), 0);

  return {
    users: profiles.count ?? 0,
    products: products.count ?? 0,
    orders: (orders.data || []).length,
    gmv,
    held,
    openDisputes: disputes.count ?? 0,
    recentOrders: recentOrders.data || [],
    error: profiles.error?.message || orders.error?.message || null,
  };
}

export default async function DashboardPage() {
  const s = await getStats();

  return (
    <>
      <div className="page-head">
        <div>
          <h2 style={{ fontSize: 20, fontWeight: 700 }}>Overview</h2>
          <p>Live metrics across the MartoraX marketplace.</p>
        </div>
      </div>

      {s.error && (
        <div className="error">
          Could not reach the database: {s.error}. Check your SUPABASE_SERVICE_ROLE_KEY env var.
        </div>
      )}

      <div className="grid metrics">
        <Metric label="Total Users" value={s.users.toLocaleString()} sub="profiles" />
        <Metric label="Products" value={s.products.toLocaleString()} sub="active listings" />
        <Metric label="Orders" value={s.orders.toLocaleString()} sub="all-time" />
        <Metric label="GMV" value={naira(s.gmv)} sub="gross merchandise value" />
        <Metric label="Escrow Held" value={naira(s.held)} sub="SafePay in custody" />
        <Metric label="Open Disputes" value={s.openDisputes.toLocaleString()} sub="awaiting resolution" />
      </div>

      <div className="card" style={{ marginTop: 22, padding: 0 }}>
        <div style={{ padding: "16px 18px", borderBottom: "1px solid var(--border)", fontWeight: 650 }}>
          Recent Orders
        </div>
        <div className="table-wrap" style={{ border: "none" }}>
          <table>
            <thead>
              <tr>
                <th>Order</th>
                <th>Buyer</th>
                <th>Amount</th>
                <th>Status</th>
                <th>Date</th>
              </tr>
            </thead>
            <tbody>
              {s.recentOrders.length === 0 && (
                <tr><td colSpan={5} className="empty">No orders yet.</td></tr>
              )}
              {s.recentOrders.map((o: any) => (
                <tr key={o.id}>
                  <td className="mono">{shortId(o.id)}</td>
                  <td className="mono">{shortId(o.buyer_id)}</td>
                  <td>{naira(o.total_amount)}</td>
                  <td><span className={`badge ${String(o.delivery_status || "pending").toLowerCase()}`}>{o.delivery_status || "pending"}</span></td>
                  <td>{shortDate(o.created_at)}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </>
  );
}

function Metric({ label, value, sub }: { label: string; value: string; sub: string }) {
  return (
    <div className="card metric">
      <div className="label">{label}</div>
      <div className="value">{value}</div>
      <div className="sub">{sub}</div>
    </div>
  );
}
