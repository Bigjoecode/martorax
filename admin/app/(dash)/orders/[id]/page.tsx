import { notFound } from "next/navigation";
import { createAdminClient } from "@/lib/supabase/admin";
import { naira, dateTime, shortId } from "@/lib/format";
import { updateOrderStatus, assignRider } from "../actions";

export const dynamic = "force-dynamic";

const STATUSES = ["pending", "processing", "in_transit", "delivered", "completed", "cancelled"];

export default async function OrderDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const db = createAdminClient();

  const [{ data: order }, { data: items }, { data: escrow }] = await Promise.all([
    db.from("orders").select("*").eq("id", id).maybeSingle(),
    db.from("order_items").select("product_id, unit_price_at_purchase, quantity").eq("order_id", id),
    db.from("escrow_ledger").select("hold_code, amount, status, released_at").eq("order_id", id),
  ]);

  if (!order) notFound();

  const itemRows = items || [];
  const esc = (escrow || [])[0];

  return (
    <>
      <div className="page-head">
        <div>
          <h2 style={{ fontSize: 20, fontWeight: 700 }}>Order {shortId(order.id)}</h2>
          <p className="mono">{dateTime(order.created_at)}</p>
        </div>
        <a className="btn" href="/orders">← All orders</a>
      </div>

      <div className="grid" style={{ gridTemplateColumns: "1fr 1fr", gap: 16 }}>
        <div className="card">
          <h3 style={{ fontSize: 14, marginBottom: 12 }}>Parties</h3>
          <Row k="Buyer" v={shortId(order.buyer_id, 36)} />
          <Row k="Seller" v={shortId(order.seller_id, 36)} />
          <Row k="Rider" v={order.rider_id ? shortId(order.rider_id, 36) : "—"} />
          <Row k="Destination" v={order.landmark_destination || "—"} />
          <Row k="Total" v={naira(order.total_amount)} />
          <div style={{ marginTop: 12 }}>
            <form action={updateOrderStatus} style={{ display: "flex", gap: 8, alignItems: "center" }}>
              <input type="hidden" name="id" value={order.id} />
              <select name="status" defaultValue={order.delivery_status || "pending"}>
                {STATUSES.map((s) => <option key={s} value={s}>{s}</option>)}
              </select>
              <button className="btn btn-primary btn-sm" type="submit">Update status</button>
            </form>
          </div>
          <div style={{ marginTop: 10 }}>
            <form action={assignRider} style={{ display: "flex", gap: 8, alignItems: "center" }}>
              <input type="hidden" name="id" value={order.id} />
              <input name="rider_id" placeholder="rider profile id…" defaultValue={order.rider_id || ""} />
              <button className="btn btn-sm" type="submit">Assign rider</button>
            </form>
          </div>
        </div>

        <div className="card">
          <h3 style={{ fontSize: 14, marginBottom: 12 }}>Escrow (SafePay)</h3>
          {esc ? (
            <>
              <Row k="Hold code" v={esc.hold_code} />
              <Row k="Amount" v={naira(esc.amount)} />
              <Row k="Status" v={<span className={`badge ${esc.status}`}>{esc.status}</span>} />
              <Row k="Released" v={esc.released_at ? dateTime(esc.released_at) : "—"} />
              <a className="btn btn-sm" style={{ marginTop: 10 }} href="/escrow">Manage in Escrow →</a>
            </>
          ) : (
            <p style={{ color: "var(--muted)" }}>No escrow record for this order.</p>
          )}
        </div>
      </div>

      <div className="card" style={{ marginTop: 16, padding: 0 }}>
        <div style={{ padding: "14px 18px", borderBottom: "1px solid var(--border)", fontWeight: 650 }}>
          Items ({itemRows.length})
        </div>
        <div className="table-wrap" style={{ border: "none" }}>
          <table>
            <thead><tr><th>Product</th><th>Unit price</th><th>Qty</th><th>Line total</th></tr></thead>
            <tbody>
              {itemRows.length === 0 && <tr><td colSpan={4} className="empty">No line items recorded.</td></tr>}
              {itemRows.map((it: any, i: number) => (
                <tr key={i}>
                  <td className="mono">{shortId(it.product_id)}</td>
                  <td>{naira(it.unit_price_at_purchase)}</td>
                  <td>{it.quantity}</td>
                  <td>{naira((it.unit_price_at_purchase || 0) * (it.quantity || 0))}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </>
  );
}

function Row({ k, v }: { k: string; v: React.ReactNode }) {
  return (
    <div style={{ display: "flex", justifyContent: "space-between", padding: "6px 0", borderBottom: "1px solid var(--border)" }}>
      <span style={{ color: "var(--muted)", fontSize: 13 }}>{k}</span>
      <span className="mono" style={{ fontSize: 13 }}>{v}</span>
    </div>
  );
}
