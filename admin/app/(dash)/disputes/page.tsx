import { createAdminClient } from "@/lib/supabase/admin";
import { shortDate, shortId } from "@/lib/format";
import { resolveDispute } from "./actions";

export const dynamic = "force-dynamic";

export default async function DisputesPage() {
  const db = createAdminClient();
  const { data, error } = await db
    .from("escrow_disputes")
    .select("id, escrow_id, dispute_code, reason, details, is_resolved, mediator_notes, created_at")
    .order("created_at", { ascending: false })
    .limit(500);

  const open = (data || []).filter((d: any) => !d.is_resolved);
  const closed = (data || []).filter((d: any) => d.is_resolved);

  return (
    <>
      <div className="page-head">
        <div>
          <h2 style={{ fontSize: 20, fontWeight: 700 }}>Disputes</h2>
          <p>{open.length} open · {closed.length} resolved. Decide the escrow outcome.</p>
        </div>
      </div>

      {error && <div className="error">{error.message}</div>}

      <div className="grid" style={{ gridTemplateColumns: "1fr", gap: 14 }}>
        {open.length === 0 && <div className="card empty">No open disputes. 🎉</div>}
        {open.map((d: any) => (
          <div key={d.id} className="card">
            <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 10 }}>
              <div>
                <span className="badge disputed">{d.dispute_code}</span>
                <span className="mono" style={{ marginLeft: 8 }}>escrow {shortId(d.escrow_id)}</span>
              </div>
              <span className="mono">{shortDate(d.created_at)}</span>
            </div>
            <div style={{ marginBottom: 6 }}><strong>Reason:</strong> {d.reason}</div>
            {d.details && <div style={{ color: "var(--muted)", marginBottom: 12 }}>{d.details}</div>}
            <form action={resolveDispute} className="grid" style={{ gridTemplateColumns: "1fr auto auto", gap: 8, alignItems: "end" }}>
              <input type="hidden" name="id" value={d.id} />
              <input type="hidden" name="escrow_id" value={d.escrow_id} />
              <div>
                <label>Mediator notes</label>
                <input name="notes" placeholder="Decision rationale…" />
              </div>
              <button className="btn btn-primary" name="outcome" value="release" type="submit">Release to provider</button>
              <button className="btn btn-danger" name="outcome" value="refund" type="submit">Refund buyer</button>
            </form>
          </div>
        ))}
      </div>

      {closed.length > 0 && (
        <>
          <h3 style={{ margin: "26px 0 12px", fontSize: 15, color: "var(--muted)" }}>Resolved</h3>
          <div className="table-wrap">
            <table>
              <thead>
                <tr><th>Code</th><th>Reason</th><th>Notes</th><th>Date</th></tr>
              </thead>
              <tbody>
                {closed.map((d: any) => (
                  <tr key={d.id}>
                    <td className="mono">{d.dispute_code}</td>
                    <td>{d.reason}</td>
                    <td style={{ color: "var(--muted)" }}>{d.mediator_notes || "—"}</td>
                    <td>{shortDate(d.created_at)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </>
      )}
    </>
  );
}
