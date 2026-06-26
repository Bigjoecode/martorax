import { createAdminClient } from "@/lib/supabase/admin";
import { naira, shortId } from "@/lib/format";
import { RevenueLine, OrdersBar, CategoryPie, TopVendorsBar } from "@/components/AnalyticsCharts";

export const dynamic = "force-dynamic";

function dayKey(d: Date) {
  return d.toISOString().slice(0, 10);
}

export default async function AnalyticsPage() {
  const db = createAdminClient();
  const since = new Date();
  since.setDate(since.getDate() - 30);
  const since8w = new Date();
  since8w.setDate(since8w.getDate() - 56);

  const [orders, items, signups] = await Promise.all([
    db.from("orders").select("seller_id, total_amount, created_at").gte("created_at", since.toISOString()),
    db.from("order_items").select("unit_price_at_purchase, quantity, products(category)").limit(5000),
    db.from("profiles").select("created_at").gte("created_at", since8w.toISOString()),
  ]);

  // Daily revenue + orders (last 30 days)
  const days: { label: string; key: string }[] = [];
  for (let i = 29; i >= 0; i--) {
    const d = new Date();
    d.setDate(d.getDate() - i);
    days.push({ label: `${d.getDate()}`, key: dayKey(d) });
  }
  const revMap = new Map<string, number>();
  const cntMap = new Map<string, number>();
  const vendorMap = new Map<string, number>();
  for (const o of orders.data || []) {
    const k = (o.created_at || "").slice(0, 10);
    revMap.set(k, (revMap.get(k) || 0) + Number(o.total_amount || 0));
    cntMap.set(k, (cntMap.get(k) || 0) + 1);
    if (o.seller_id) vendorMap.set(o.seller_id, (vendorMap.get(o.seller_id) || 0) + Number(o.total_amount || 0));
  }
  const revenue = days.map((d) => ({ label: d.label, value: revMap.get(d.key) || 0 }));
  const ordersDaily = days.map((d) => ({ label: d.label, value: cntMap.get(d.key) || 0 }));

  // Revenue by category (from order_items joined to products.category)
  const catMap = new Map<string, number>();
  for (const it of items.data || []) {
    const cat = ((it as any).products?.category as string) || "Uncategorized";
    catMap.set(cat, (catMap.get(cat) || 0) + Number(it.unit_price_at_purchase || 0) * Number(it.quantity || 0));
  }
  const byCategory = Array.from(catMap.entries())
    .map(([label, value]) => ({ label, value }))
    .sort((a, b) => b.value - a.value)
    .slice(0, 7);

  // Top vendors (resolve names)
  const topVendorIds = Array.from(vendorMap.entries()).sort((a, b) => b[1] - a[1]).slice(0, 8);
  let nameById: Record<string, string> = {};
  if (topVendorIds.length) {
    const { data: profs } = await db.from("profiles").select("id, full_name, business_name").in("id", topVendorIds.map(([id]) => id));
    for (const p of profs || []) nameById[p.id] = p.business_name || p.full_name || shortId(p.id);
  }
  const topVendors = topVendorIds.map(([id, value]) => ({ label: nameById[id] || shortId(id), value }));

  // Signups per week (last 8 weeks)
  const weeks: { label: string; start: number }[] = [];
  const now = Date.now();
  for (let i = 7; i >= 0; i--) {
    const start = now - i * 7 * 86400000;
    weeks.push({ label: `W${8 - i}`, start });
  }
  const signupBuckets = weeks.map((w) => ({ label: w.label, value: 0 }));
  for (const p of signups.data || []) {
    const t = new Date(p.created_at).getTime();
    for (let i = 0; i < weeks.length; i++) {
      const end = weeks[i].start + 7 * 86400000;
      if (t >= weeks[i].start && t < end) { signupBuckets[i].value++; break; }
    }
  }

  const totalRev = revenue.reduce((s, r) => s + r.value, 0);

  return (
    <>
      <div className="page-head">
        <div>
          <h2 style={{ fontSize: 20, fontWeight: 700 }}>Analytics</h2>
          <p>Revenue {naira(totalRev)} over the last 30 days.</p>
        </div>
      </div>

      <div className="grid" style={{ gridTemplateColumns: "1fr 1fr", gap: 16 }}>
        <div className="card"><h3 style={{ fontSize: 14, marginBottom: 10 }}>Revenue — 30 days</h3><RevenueLine data={revenue} /></div>
        <div className="card"><h3 style={{ fontSize: 14, marginBottom: 10 }}>Orders — 30 days</h3><OrdersBar data={ordersDaily} /></div>
        <div className="card"><h3 style={{ fontSize: 14, marginBottom: 10 }}>Revenue by category</h3><CategoryPie data={byCategory} /></div>
        <div className="card"><h3 style={{ fontSize: 14, marginBottom: 10 }}>New users — 8 weeks</h3><OrdersBar data={signupBuckets} /></div>
      </div>

      <div className="card" style={{ marginTop: 16 }}>
        <h3 style={{ fontSize: 14, marginBottom: 10 }}>Top vendors by sales (30 days)</h3>
        <TopVendorsBar data={topVendors} />
      </div>
    </>
  );
}
