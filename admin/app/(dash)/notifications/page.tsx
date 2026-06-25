import { createAdminClient } from "@/lib/supabase/admin";
import { dateTime, shortId, pageOf, PAGE_SIZE } from "@/lib/format";
import { broadcast } from "./actions";
import Pagination from "@/components/Pagination";

export const dynamic = "force-dynamic";

export default async function NotificationsPage({
  searchParams,
}: {
  searchParams: Promise<{ page?: string }>;
}) {
  const { page: pageStr } = await searchParams;
  const page = pageOf(pageStr);
  const from = (page - 1) * PAGE_SIZE;
  const db = createAdminClient();

  const { data, error } = await db
    .from("notifications")
    .select("id, user_id, title, body, type, is_read, created_at")
    .order("created_at", { ascending: false })
    .range(from, from + PAGE_SIZE);
  const rows = (data || []).slice(0, PAGE_SIZE);
  const hasMore = (data || []).length > PAGE_SIZE;

  return (
    <>
      <div className="page-head">
        <div>
          <h2 style={{ fontSize: 20, fontWeight: 700 }}>Notifications</h2>
          <p>Broadcast a message to everyone or a single user.</p>
        </div>
      </div>

      <form action={broadcast} className="card" style={{ display: "grid", gap: 12, marginBottom: 18, maxWidth: 720 }}>
        <div style={{ display: "grid", gridTemplateColumns: "1fr 240px", gap: 12 }}>
          <div>
            <label>Title</label>
            <input name="title" required placeholder="e.g. Eid sale starts Friday" />
          </div>
          <div>
            <label>Target (user id, or “all”)</label>
            <input name="target" defaultValue="all" />
          </div>
        </div>
        <div>
          <label>Body</label>
          <textarea name="body" rows={2} placeholder="Optional message body" />
        </div>
        <div>
          <button className="btn btn-primary" type="submit">Send notification</button>
        </div>
      </form>

      {error && <div className="error">{error.message}</div>}

      <div className="table-wrap">
        <table>
          <thead><tr><th>User</th><th>Title</th><th>Body</th><th>Type</th><th>Read</th><th>Sent</th></tr></thead>
          <tbody>
            {rows.length === 0 && <tr><td colSpan={6} className="empty">No notifications yet.</td></tr>}
            {rows.map((n: any) => (
              <tr key={n.id}>
                <td className="mono">{shortId(n.user_id)}</td>
                <td>{n.title}</td>
                <td style={{ maxWidth: 280, color: "var(--muted)" }}>{n.body || "—"}</td>
                <td><span className="badge role">{n.type}</span></td>
                <td>{n.is_read ? "✓" : "—"}</td>
                <td>{dateTime(n.created_at)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      <Pagination basePath="/notifications" page={page} hasMore={hasMore} />
    </>
  );
}
