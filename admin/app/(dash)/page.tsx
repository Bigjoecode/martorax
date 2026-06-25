import { createAdminClient } from "@/lib/supabase/admin";
import { naira, shortDate, shortId } from "@/lib/format";

export const dynamic = "force-dynamic";

async function getStats() {
  const db = createAdminClient();

  const headCount = (table: string, col = "id") =>
    db.from(table).select(col, { count: "exact", head: true });

  const [
    profiles, products, ordersAll, escrowHeld, disputes,
    bookings, pendingKyc, payoutsReq, recentOrders,
  ] = await Promise.all([
    headCount("profiles"),
    headCount("products"),
    db.from("orders").select("total_amount"),
    db.from("escrow_ledger").select("amount").eq("status", "held"),
    db.from("escrow_disputes").select("id", { count: "exact", head: true }).eq("is_resolved", false),
    headCount("service_bookings"),
    db.from("profiles").select("id", { count: "exact", head: true }).eq("kyc_status", "pending"),
    db.from("payout_requests").select("amount").eq("status", "requested"),
    db.from("orders").select("id, buyer_id, total_amount, delivery_status, created_at").order("created_at", { ascending: false }).limit(8),
  ]);

  const gmv = (ordersAll.data || []).reduce((s, o: any) => s + Number(o.total_amount || 0), 0);
  const held = (escrowHeld.data || []).reduce((s, e: any) => s + Number(e.amount || 0), 0);
  const payoutSum = (payoutsReq.data || []).reduce((s, p: any) => s + Number(p.amount || 0), 0);

  return {
    users: profiles.count ?? 0,
    products: products.count ?? 0,
    orders: (ordersAll.data || []).length,
    gmv, held,
    openDisputes: disputes.count ?? 0,
    bookings: bookings.count ?? 0,
    pendingKyc: pendingKyc.count ?? 0,
    payoutsCount: (payoutsReq.data || []).length,
    payoutSum,
    recentOrders: recentOrders.data || [],
    error: profiles.error?.message || ordersAll.error?.message || null,
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
        <div className="error">Could not reach the database: {s.error}. Check SUPABASE_SERVICE_ROLE_KEY.</div>
      )}

      <div className="grid metrics">
        <Metric label="Total Users" value={s.users.toLocaleString()} sub="profiles" />
        <Metric label="Products" value={s.products.toLocaleString()} sub="listings" />
        <Metric label="Orders" value={s.orders.toLocaleString()} sub="all-time" />
        <Metric label="GMV" value={naira(s.gmv)} sub="gross merchandise value" />
        <Metric label="Escrow Held" value={naira(s.held)} sub="SafePay in custody" />
        <Metric label="Bookings" value={s.bookings.toLocaleString()} sub="service jobs" />
      </div>

      {(s.pendingKyc > 0 || s.payoutsCount > 0 || s.openDisputes > 0) && (
        <div className="card" style={{ marginTop: 18 }}>
          <div style={{ fontWeight: 650, marginBottom: 12 }}>⚠️ Needs attention</div>
          <div className="grid" style={{ gridTemplateColumns: "repeat(auto-fit, minmax(200px,1fr))", gap: 12 }}>
            <Attn show={s.pendingKyc > 0} href="/kyc" label="KYC to review" value={`${s.pendingKyc}`} />
            <Attn show={s.payoutsCount > 0} href="/payouts" label="Payouts requested" value={`${s.payoutsCount} · ${naira(s.payoutSum)}`} />
            <Attn show={s.openDisputes > 0} href="/disputes" label="Open disputes" value={`${s.openDisputes}`} />
          </div>
        </div>
      )}

      <div className="card" style={{ marginTop: 18, padding: 0 }}>
        <div style={{ padding: "16px 18px", borderBottom: "1px solid var(--border)", fontWeight: 650 }}>Recent Orders</div>
        <div className="table-wrap" style={{ border: "none" }}>
          <table>
            <thead><tr><th>Order</th><th>Buyer</th><th>Amount</th><th>Status</th><th>Date</th></tr></thead>
            <tbody>
              {s.recentOrders.length === 0 && <tr><td colSpan={5} className="empty">No orders yet.</td></tr>}
              {s.recentOrders.map((o: any) => (
                <tr key={o.id}>
                  <td><a href={`/orders/${o.id}`} className="mono" style={{ color: "var(--emerald-bright)" }}>{shortId(o.id)}</a></td>
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

function Attn({ show, href, label, value }: { show: boolean; href: string; label: string; value: string }) {
  if (!show) return null;
  return (
    <a href={href} className="card" style={{ background: "var(--surface-2)", display: "block" }}>
      <div className="label" style={{ color: "var(--amber)" }}>{label}</div>
      <div className="value" style={{ fontSize: 22 }}>{value}</div>
      <div className="sub">Tap to review →</div>
    </a>
  );
}
