import { createAdminClient } from "@/lib/supabase/admin";
import { naira, shortDate, shortId, pageOf, PAGE_SIZE } from "@/lib/format";
import { updateBookingStatus, deleteBooking } from "./actions";
import Pagination from "@/components/Pagination";

export const dynamic = "force-dynamic";

const STATUSES = ["requested", "accepted", "completed", "cancelled"];

export default async function BookingsPage({
  searchParams,
}: {
  searchParams: Promise<{ page?: string; status?: string }>;
}) {
  const { page: pageStr, status } = await searchParams;
  const page = pageOf(pageStr);
  const from = (page - 1) * PAGE_SIZE;
  const db = createAdminClient();

  let query = db
    .from("service_bookings")
    .select("id, shopper_id, provider_id, service_category, description, amount, status, scheduled_for, created_at")
    .order("created_at", { ascending: false })
    .range(from, from + PAGE_SIZE);
  if (status) query = query.eq("status", status);
  const { data, error } = await query;
  const rows = (data || []).slice(0, PAGE_SIZE);
  const hasMore = (data || []).length > PAGE_SIZE;

  return (
    <>
      <div className="page-head">
        <div>
          <h2 style={{ fontSize: 20, fontWeight: 700 }}>Service Bookings</h2>
          <p>Provider jobs requested by shoppers.</p>
        </div>
        <div className="row-actions" style={{ flexWrap: "wrap" }}>
          {["all", ...STATUSES].map((f) => (
            <a key={f} className={`btn btn-sm${(status || "all") === f ? " btn-primary" : ""}`} href={f === "all" ? "/bookings" : `/bookings?status=${f}`}>{f}</a>
          ))}
        </div>
      </div>

      {error && <div className="error">{error.message}</div>}

      <div className="table-wrap">
        <table>
          <thead>
            <tr><th>Booking</th><th>Shopper</th><th>Provider</th><th>Category</th><th>Amount</th><th>Status</th><th>Created</th><th></th></tr>
          </thead>
          <tbody>
            {rows.length === 0 && <tr><td colSpan={8} className="empty">No bookings found.</td></tr>}
            {rows.map((b: any) => (
              <tr key={b.id}>
                <td className="mono">{shortId(b.id)}</td>
                <td className="mono">{shortId(b.shopper_id)}</td>
                <td className="mono">{shortId(b.provider_id)}</td>
                <td>{b.service_category || "—"}</td>
                <td>{naira(b.amount)}</td>
                <td>
                  <form action={updateBookingStatus} style={{ display: "flex", gap: 6, alignItems: "center" }}>
                    <input type="hidden" name="id" value={b.id} />
                    <select name="status" defaultValue={b.status || "requested"} style={{ width: 120 }}>
                      {STATUSES.map((s) => <option key={s} value={s}>{s}</option>)}
                    </select>
                    <button className="btn btn-sm" type="submit">Save</button>
                  </form>
                </td>
                <td>{shortDate(b.created_at)}</td>
                <td>
                  <form action={deleteBooking}>
                    <input type="hidden" name="id" value={b.id} />
                    <button className="btn btn-sm btn-danger" type="submit">Delete</button>
                  </form>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      <Pagination basePath="/bookings" page={page} hasMore={hasMore} />
    </>
  );
}
