import { createAdminClient } from "@/lib/supabase/admin";
import { naira, shortDate, shortId } from "@/lib/format";
import BarChart from "@/components/BarChart";

export const dynamic = "force-dynamic";

/** Buckets orders into the last [days] calendar days for count + GMV charts. */
function buildSeries(rows: { created_at: string; total_amount: number | null }[], days = 14) {
  const today = new Date();
  const keys: { label: string; key: string }[] = [];
  for (let i = days - 1; i >= 0; i--) {
    const d = new Date(today);
    d.setDate(today.getDate() - i);
    keys.push({ label: `${d.getDate()}`, key: d.toISOString().slice(0, 10) });
  }
  const countMap = new Map<string, number>();
  const gmvMap = new Map<string, number>();
  for (const r of rows) {
    const k = (r.created_at || "").slice(0, 10);
    countMap.set(k, (countMap.get(k) || 0) + 1);
    gmvMap.set(k, (gmvMap.get(k) || 0) + Number(r.total_amount || 0));
  }
  return {
    counts: keys.map((k) => ({ label: k.label, value: countMap.get(k.key) || 0 })),
    gmv: keys.map((k) => ({ label: k.label, value: gmvMap.get(k.key) || 0 })),
  };
}

async function getStats() {
  const db = createAdminClient();

  const headCount = (table: string, col = "id") =>
    db.from(table).select(col, { count: "exact", head: true });

  const since = new Date();
  since.setDate(since.getDate() - 14);

  const [
    profiles, products, ordersAll, escrowHeld, disputes,
    bookings, pendingKyc, payoutsReq, recentOrders, ordersSeries, liveVendors,
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
    db.from("orders").select("created_at, total_amount").gte("created_at", since.toISOString()),
    db.from("profiles").select("id", { count: "exact", head: true }).eq("is_live", true),
  ]);

  const series = buildSeries((ordersSeries.data || []) as any[]);

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
    liveVendors: liveVendors.count ?? 0,
    series,
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
        <Metric label="Live now" value={s.liveVendors.toLocaleString()} sub="vendors streaming" />
      </div>

      <div className="grid" style={{ gridTemplateColumns: "1fr 1fr", gap: 16, marginTop: 18 }}>
        <BarChart title="Orders — last 14 days" data={s.series.counts} />
        <BarChart title="Revenue (GMV) — last 14 days" data={s.series.gmv} color="var(--amber)" format={(n) => naira(n)} />
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
