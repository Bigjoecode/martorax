import { createAdminClient } from "@/lib/supabase/admin";
import { dateTime, shortId, naira } from "@/lib/format";

export const dynamic = "force-dynamic";

type Item = { ts: string; icon: string; text: string; href?: string };

export default async function ActivityPage() {
  const db = createAdminClient();

  const [orders, bookings, payouts, kyc, disputes, notifs] = await Promise.all([
    db.from("orders").select("id, total_amount, delivery_status, created_at").order("created_at", { ascending: false }).limit(15),
    db.from("service_bookings").select("id, status, amount, created_at").order("created_at", { ascending: false }).limit(15),
    db.from("payout_requests").select("id, amount, status, created_at").order("created_at", { ascending: false }).limit(15),
    db.from("profiles").select("id, full_name, kyc_status, kyc_submitted_at").not("kyc_submitted_at", "is", null).order("kyc_submitted_at", { ascending: false }).limit(15),
    db.from("escrow_disputes").select("id, dispute_code, is_resolved, created_at").order("created_at", { ascending: false }).limit(15),
    db.from("notifications").select("id, title, type, created_at").eq("type", "admin").order("created_at", { ascending: false }).limit(10),
  ]);

  const items: Item[] = [];

  for (const o of orders.data || [])
    items.push({ ts: o.created_at, icon: "🛒", text: `Order ${shortId(o.id)} — ${naira(o.total_amount)} (${o.delivery_status})`, href: `/orders/${o.id}` });
  for (const b of bookings.data || [])
    items.push({ ts: b.created_at, icon: "📅", text: `Booking ${shortId(b.id)} — ${naira(b.amount)} (${b.status})`, href: "/bookings" });
  for (const p of payouts.data || [])
    items.push({ ts: p.created_at, icon: "💸", text: `Payout request ${naira(p.amount)} (${p.status})`, href: "/payouts" });
  for (const k of kyc.data || [])
    items.push({ ts: k.kyc_submitted_at, icon: "🪪", text: `KYC ${k.kyc_status} — ${k.full_name || shortId(k.id)}`, href: "/kyc" });
  for (const d of disputes.data || [])
    items.push({ ts: d.created_at, icon: "⚖", text: `Dispute ${d.dispute_code} (${d.is_resolved ? "resolved" : "open"})`, href: "/disputes" });
  for (const n of notifs.data || [])
    items.push({ ts: n.created_at, icon: "🔔", text: `Broadcast — “${n.title}”`, href: "/notifications" });

  items.sort((a, b) => (a.ts < b.ts ? 1 : -1));
  const top = items.slice(0, 60);

  return (
    <>
      <div className="page-head">
        <div>
          <h2 style={{ fontSize: 20, fontWeight: 700 }}>Activity</h2>
          <p>Everything happening across the marketplace, newest first.</p>
        </div>
      </div>

      <div className="card" style={{ padding: 0 }}>
        {top.length === 0 && <div className="empty">No activity yet.</div>}
        {top.map((it, i) => (
          <a
            key={i}
            href={it.href || "#"}
            style={{
              display: "flex",
              gap: 12,
              alignItems: "center",
              padding: "12px 16px",
              borderBottom: i === top.length - 1 ? "none" : "1px solid var(--border)",
            }}
          >
            <span style={{ fontSize: 18, width: 24, textAlign: "center" }}>{it.icon}</span>
            <span style={{ flex: 1 }}>{it.text}</span>
            <span className="mono" style={{ color: "var(--muted)", fontSize: 12 }}>{dateTime(it.ts)}</span>
          </a>
        ))}
      </div>
    </>
  );
}
