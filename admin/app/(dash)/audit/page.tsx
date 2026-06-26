import { createAdminClient } from "@/lib/supabase/admin";
import { dateTime, pageOf, PAGE_SIZE } from "@/lib/format";
import Pagination from "@/components/Pagination";

export const dynamic = "force-dynamic";

export default async function AuditPage({
  searchParams,
}: {
  searchParams: Promise<{ page?: string }>;
}) {
  const { page: pageStr } = await searchParams;
  const page = pageOf(pageStr);
  const from = (page - 1) * PAGE_SIZE;
  const db = createAdminClient();

  const { data, error } = await db
    .from("admin_audit_log")
    .select("id, actor_email, action, entity, entity_id, detail, created_at")
    .order("created_at", { ascending: false })
    .range(from, from + PAGE_SIZE);
  const rows = (data || []).slice(0, PAGE_SIZE);
  const hasMore = (data || []).length > PAGE_SIZE;

  return (
    <>
      <div className="page-head">
        <div>
          <h2 style={{ fontSize: 20, fontWeight: 700 }}>Audit Log</h2>
          <p>Every admin action — who did what, and when.</p>
        </div>
      </div>

      {error && <div className="error">{error.message}</div>}

      <div className="table-wrap">
        <table>
          <thead><tr><th>When</th><th>Admin</th><th>Action</th><th>Entity</th><th>Detail</th></tr></thead>
          <tbody>
            {rows.length === 0 && <tr><td colSpan={5} className="empty">No admin actions recorded yet.</td></tr>}
            {rows.map((a: any) => (
              <tr key={a.id}>
                <td className="mono">{dateTime(a.created_at)}</td>
                <td>{a.actor_email}</td>
                <td><span className="badge role">{a.action}</span></td>
                <td className="mono">{a.entity ? `${a.entity} ${(a.entity_id || "").slice(0, 8)}` : "—"}</td>
                <td style={{ color: "var(--muted)" }}>{a.detail || "—"}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      <Pagination basePath="/audit" page={page} hasMore={hasMore} />
    </>
  );
}
