import { createAdminClient } from "@/lib/supabase/admin";
import { naira, shortDate, shortId } from "@/lib/format";
import { updateOrderStatus } from "./actions";

export const dynamic = "force-dynamic";

const STATUSES = ["pending", "processing", "in_transit", "delivered", "completed", "cancelled"];

export default async function OrdersPage() {
  const db = createAdminClient();
  const { data, error } = await db
    .from("orders")
    .select("id, buyer_id, seller_id, total_amount, delivery_status, landmark_destination, created_at")
    .order("created_at", { ascending: false })
    .limit(500);

  return (
    <>
      <div className="page-head">
        <div>
          <h2 style={{ fontSize: 20, fontWeight: 700 }}>Orders</h2>
          <p>{data?.length ?? 0} orders. Override delivery status when needed.</p>
        </div>
      </div>

      {error && <div className="error">{error.message}</div>}

      <div className="table-wrap">
        <table>
          <thead>
            <tr>
              <th>Order</th>
              <th>Buyer</th>
              <th>Seller</th>
              <th>Amount</th>
              <th>Destination</th>
              <th>Status</th>
              <th>Date</th>
            </tr>
          </thead>
          <tbody>
            {(data || []).length === 0 && (
              <tr><td colSpan={7} className="empty">No orders found.</td></tr>
            )}
            {(data || []).map((o: any) => (
              <tr key={o.id}>
                <td className="mono">{shortId(o.id)}</td>
                <td className="mono">{shortId(o.buyer_id)}</td>
                <td className="mono">{shortId(o.seller_id)}</td>
                <td>{naira(o.total_amount)}</td>
                <td style={{ maxWidth: 180 }}>{o.landmark_destination || "—"}</td>
                <td>
                  <form action={updateOrderStatus} style={{ display: "flex", gap: 6, alignItems: "center" }}>
                    <input type="hidden" name="id" value={o.id} />
                    <select name="status" defaultValue={o.delivery_status || "pending"} style={{ width: 130 }}>
                      {STATUSES.map((s) => <option key={s} value={s}>{s}</option>)}
                    </select>
                    <button className="btn btn-sm" type="submit">Save</button>
                  </form>
                </td>
                <td>{shortDate(o.created_at)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
}
