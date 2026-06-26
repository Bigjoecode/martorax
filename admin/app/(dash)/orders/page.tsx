import { createAdminClient } from "@/lib/supabase/admin";
import { naira, shortDate, shortId, pageOf, PAGE_SIZE } from "@/lib/format";
import { updateOrderStatus, deleteOrder } from "./actions";
import Pagination from "@/components/Pagination";

export const dynamic = "force-dynamic";

const STATUSES = ["pending", "processing", "in_transit", "delivered", "completed", "cancelled"];

export default async function OrdersPage({
  searchParams,
}: {
  searchParams: Promise<{ page?: string; status?: string }>;
}) {
  const { page: pageStr, status } = await searchParams;
  const page = pageOf(pageStr);
  const from = (page - 1) * PAGE_SIZE;
  const db = createAdminClient();

  let query = db
    .from("orders")
    .select("id, buyer_id, seller_id, total_amount, delivery_status, landmark_destination, created_at")
    .order("created_at", { ascending: false })
    .range(from, from + PAGE_SIZE);
  if (status) query = query.eq("delivery_status", status);
  const { data, error } = await query;
  const rows = (data || []).slice(0, PAGE_SIZE);
  const hasMore = (data || []).length > PAGE_SIZE;

  const filters = ["all", ...STATUSES];

  return (
    <>
      <div className="page-head">
        <div>
          <h2 style={{ fontSize: 20, fontWeight: 700 }}>Orders</h2>
          <p>Open an order for items + escrow, override status, or delete.</p>
        </div>
        <div className="row-actions" style={{ flexWrap: "wrap" }}>
          <a className="btn btn-sm" href="/export/orders">⬇ CSV</a>
          {filters.map((f) => (
            <a key={f} className={`btn btn-sm${(status || "all") === f ? " btn-primary" : ""}`} href={f === "all" ? "/orders" : `/orders?status=${f}`}>{f}</a>
          ))}
        </div>
      </div>

      {error && <div className="error">{error.message}</div>}

      <div className="table-wrap">
        <table>
          <thead>
            <tr><th>Order</th><th>Buyer</th><th>Seller</th><th>Amount</th><th>Destination</th><th>Status</th><th>Date</th><th></th></tr>
          </thead>
          <tbody>
            {rows.length === 0 && <tr><td colSpan={8} className="empty">No orders found.</td></tr>}
            {rows.map((o: any) => (
              <tr key={o.id}>
                <td><a href={`/orders/${o.id}`} className="mono" style={{ color: "var(--emerald-bright)" }}>{shortId(o.id)}</a></td>
                <td className="mono">{shortId(o.buyer_id)}</td>
                <td className="mono">{shortId(o.seller_id)}</td>
                <td>{naira(o.total_amount)}</td>
                <td style={{ maxWidth: 160 }}>{o.landmark_destination || "—"}</td>
                <td>
                  <form action={updateOrderStatus} style={{ display: "flex", gap: 6, alignItems: "center" }}>
                    <input type="hidden" name="id" value={o.id} />
                    <select name="status" defaultValue={o.delivery_status || "pending"} style={{ width: 120 }}>
                      {STATUSES.map((s) => <option key={s} value={s}>{s}</option>)}
                    </select>
                    <button className="btn btn-sm" type="submit">Save</button>
                  </form>
                </td>
                <td>{shortDate(o.created_at)}</td>
                <td>
                  <div className="row-actions">
                    <a className="btn btn-sm" href={`/orders/${o.id}`}>View</a>
                    <form action={deleteOrder}>
                      <input type="hidden" name="id" value={o.id} />
                      <button className="btn btn-sm btn-danger" type="submit">Delete</button>
                    </form>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      <Pagination basePath="/orders" page={page} hasMore={hasMore} />
    </>
  );
}
