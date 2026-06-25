import { createAdminClient } from "@/lib/supabase/admin";
import { naira, shortDate, shortId } from "@/lib/format";
import { releaseEscrow, refundEscrow } from "./actions";

export const dynamic = "force-dynamic";

export default async function EscrowPage({
  searchParams,
}: {
  searchParams: Promise<{ status?: string }>;
}) {
  const { status } = await searchParams;
  const db = createAdminClient();
  let query = db
    .from("escrow_ledger")
    .select("id, order_id, hold_code, buyer_id, provider_id, amount, status, released_at, created_at")
    .order("created_at", { ascending: false })
    .limit(500);
  if (status) query = query.eq("status", status);
  const { data, error } = await query;

  const filters = ["all", "held", "released", "disputed", "resolved"];

  return (
    <>
      <div className="page-head">
        <div>
          <h2 style={{ fontSize: 20, fontWeight: 700 }}>Escrow — SafePay Ledger</h2>
          <p>Funds held in custody. Release to provider or refund a buyer.</p>
        </div>
        <div className="row-actions">
          {filters.map((f) => (
            <a key={f} className={`btn btn-sm${(status || "all") === f ? " btn-primary" : ""}`} href={f === "all" ? "/escrow" : `/escrow?status=${f}`}>
              {f}
            </a>
          ))}
        </div>
      </div>

      {error && <div className="error">{error.message}</div>}

      <div className="table-wrap">
        <table>
          <thead>
            <tr>
              <th>Hold Code</th>
              <th>Order</th>
              <th>Buyer</th>
              <th>Provider</th>
              <th>Amount</th>
              <th>Status</th>
              <th>Created</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            {(data || []).length === 0 && (
              <tr><td colSpan={8} className="empty">No escrow records.</td></tr>
            )}
            {(data || []).map((e: any) => (
              <tr key={e.id}>
                <td className="mono">{e.hold_code}</td>
                <td className="mono">{shortId(e.order_id)}</td>
                <td className="mono">{shortId(e.buyer_id)}</td>
                <td className="mono">{shortId(e.provider_id)}</td>
                <td>{naira(e.amount)}</td>
                <td><span className={`badge ${e.status}`}>{e.status}</span></td>
                <td>{shortDate(e.created_at)}</td>
                <td>
                  {(e.status === "held" || e.status === "disputed") ? (
                    <div className="row-actions">
                      <form action={releaseEscrow}>
                        <input type="hidden" name="id" value={e.id} />
                        <button className="btn btn-sm btn-primary" type="submit">Release</button>
                      </form>
                      <form action={refundEscrow}>
                        <input type="hidden" name="id" value={e.id} />
                        <button className="btn btn-sm btn-danger" type="submit">Refund</button>
                      </form>
                    </div>
                  ) : (
                    <span className="mono">{e.released_at ? shortDate(e.released_at) : "—"}</span>
                  )}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
}
