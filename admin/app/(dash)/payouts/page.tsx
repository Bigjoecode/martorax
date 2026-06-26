import { createAdminClient } from "@/lib/supabase/admin";
import { naira, dateTime, shortId, pageOf, PAGE_SIZE } from "@/lib/format";
import { approvePayout, markPaid, rejectPayout } from "./actions";
import Pagination from "@/components/Pagination";

export const dynamic = "force-dynamic";

const STATUSES = ["requested", "approved", "paid", "rejected"];

function badgeFor(s: string) {
  if (s === "paid") return "released";
  if (s === "rejected") return "disputed";
  if (s === "approved") return "resolved";
  return "held";
}

export default async function PayoutsPage({
  searchParams,
}: {
  searchParams: Promise<{ page?: string; status?: string }>;
}) {
  const { page: pageStr, status } = await searchParams;
  const page = pageOf(pageStr);
  const from = (page - 1) * PAGE_SIZE;
  const db = createAdminClient();

  let query = db
    .from("payout_requests")
    .select("id, user_id, amount, status, bank_name, account_number, account_name, created_at")
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
          <h2 style={{ fontSize: 20, fontWeight: 700 }}>Payout Requests</h2>
          <p>Withdrawals requested by vendors / providers / riders.</p>
        </div>
        <div className="row-actions" style={{ flexWrap: "wrap" }}>
          <a className="btn btn-sm" href="/export/payouts">⬇ CSV</a>
          {["all", ...STATUSES].map((f) => (
            <a key={f} className={`btn btn-sm${(status || "all") === f ? " btn-primary" : ""}`} href={f === "all" ? "/payouts" : `/payouts?status=${f}`}>{f}</a>
          ))}
        </div>
      </div>

      {error && <div className="error">{error.message}</div>}

      <div className="table-wrap">
        <table>
          <thead>
            <tr><th>User</th><th>Amount</th><th>Bank</th><th>Account</th><th>Status</th><th>Requested</th><th></th></tr>
          </thead>
          <tbody>
            {rows.length === 0 && <tr><td colSpan={7} className="empty">No payout requests.</td></tr>}
            {rows.map((p: any) => (
              <tr key={p.id}>
                <td className="mono">{shortId(p.user_id)}</td>
                <td>{naira(p.amount)}</td>
                <td>{p.bank_name || "—"}</td>
                <td className="mono">{p.account_number || "—"}{p.account_name ? ` · ${p.account_name}` : ""}</td>
                <td><span className={`badge ${badgeFor(p.status)}`}>{p.status}</span></td>
                <td>{dateTime(p.created_at)}</td>
                <td>
                  <div className="row-actions">
                    {p.status === "requested" && (
                      <form action={approvePayout}><input type="hidden" name="id" value={p.id} /><button className="btn btn-sm" type="submit">Approve</button></form>
                    )}
                    {(p.status === "requested" || p.status === "approved") && (
                      <>
                        <form action={markPaid}><input type="hidden" name="id" value={p.id} /><button className="btn btn-sm btn-primary" type="submit">Mark paid</button></form>
                        <form action={rejectPayout}><input type="hidden" name="id" value={p.id} /><button className="btn btn-sm btn-danger" type="submit">Reject</button></form>
                      </>
                    )}
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      <Pagination basePath="/payouts" page={page} hasMore={hasMore} />
    </>
  );
}
