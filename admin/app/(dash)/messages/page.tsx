import { createAdminClient } from "@/lib/supabase/admin";
import { dateTime, shortId, pageOf, PAGE_SIZE } from "@/lib/format";
import Pagination from "@/components/Pagination";

export const dynamic = "force-dynamic";

export default async function MessagesPage({
  searchParams,
}: {
  searchParams: Promise<{ page?: string; room?: string }>;
}) {
  const { page: pageStr, room } = await searchParams;
  const page = pageOf(pageStr);
  const from = (page - 1) * PAGE_SIZE;
  const db = createAdminClient();

  let query = db
    .from("messages")
    .select("id, chat_room_id, sender_id, receiver_id, message_content, is_read, created_at")
    .order("created_at", { ascending: false })
    .range(from, from + PAGE_SIZE);
  if (room) query = query.eq("chat_room_id", room);
  const { data, error } = await query;
  const rows = (data || []).slice(0, PAGE_SIZE);
  const hasMore = (data || []).length > PAGE_SIZE;

  return (
    <>
      <div className="page-head">
        <div>
          <h2 style={{ fontSize: 20, fontWeight: 700 }}>Messages</h2>
          <p>Read-only view of chat activity{room ? ` · room ${room}` : ""}.</p>
        </div>
        {room && <a className="btn btn-sm" href="/messages">All rooms</a>}
      </div>

      {error && <div className="error">{error.message}</div>}

      <div className="table-wrap">
        <table>
          <thead><tr><th>Room</th><th>From</th><th>To</th><th>Message</th><th>Read</th><th>Sent</th></tr></thead>
          <tbody>
            {rows.length === 0 && <tr><td colSpan={6} className="empty">No messages.</td></tr>}
            {rows.map((m: any) => (
              <tr key={m.id}>
                <td><a href={`/messages?room=${encodeURIComponent(m.chat_room_id)}`} className="mono" style={{ color: "var(--emerald-bright)" }}>{m.chat_room_id?.slice(0, 14)}</a></td>
                <td className="mono">{shortId(m.sender_id)}</td>
                <td className="mono">{shortId(m.receiver_id)}</td>
                <td style={{ maxWidth: 320 }}>{m.message_content}</td>
                <td>{m.is_read ? "✓" : "—"}</td>
                <td>{dateTime(m.created_at)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      <Pagination basePath="/messages" page={page} hasMore={hasMore} query={room} />
    </>
  );
}
