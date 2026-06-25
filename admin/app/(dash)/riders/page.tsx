import { createAdminClient } from "@/lib/supabase/admin";
import { shortDate, shortId } from "@/lib/format";

export const dynamic = "force-dynamic";

export default async function RidersPage() {
  const db = createAdminClient();

  const [riders, tracking] = await Promise.all([
    db.from("profiles").select("id, full_name, phone_number, rating, created_at").eq("active_role", "rider").order("created_at", { ascending: false }),
    db.from("rider_tracking").select("rider_id, order_id, latitude, longitude, bearing, updated_at").order("updated_at", { ascending: false }).limit(100),
  ]);

  // Latest ping per rider.
  const latest = new Map<string, any>();
  for (const t of tracking.data || []) {
    if (!latest.has(t.rider_id)) latest.set(t.rider_id, t);
  }

  return (
    <>
      <div className="page-head">
        <div>
          <h2 style={{ fontSize: 20, fontWeight: 700 }}>Riders</h2>
          <p>{riders.data?.length ?? 0} registered riders · {latest.size} with recent GPS pings.</p>
        </div>
      </div>

      {(riders.error || tracking.error) && (
        <div className="error">{riders.error?.message || tracking.error?.message}</div>
      )}

      <div className="table-wrap">
        <table>
          <thead>
            <tr>
              <th>Rider</th>
              <th>Name</th>
              <th>Phone</th>
              <th>Rating</th>
              <th>Active Order</th>
              <th>Last Location</th>
              <th>Last Ping</th>
            </tr>
          </thead>
          <tbody>
            {(riders.data || []).length === 0 && (
              <tr><td colSpan={7} className="empty">No riders registered yet.</td></tr>
            )}
            {(riders.data || []).map((r: any) => {
              const t = latest.get(r.id);
              return (
                <tr key={r.id}>
                  <td className="mono">{shortId(r.id)}</td>
                  <td>{r.full_name || "—"}</td>
                  <td className="mono">{r.phone_number || "—"}</td>
                  <td>{r.rating ?? "—"}</td>
                  <td className="mono">{t ? shortId(t.order_id) : "—"}</td>
                  <td className="mono">
                    {t ? (
                      <a className="navlink" style={{ padding: 0, color: "var(--blue)" }} target="_blank" rel="noreferrer"
                        href={`https://www.google.com/maps?q=${t.latitude},${t.longitude}`}>
                        {Number(t.latitude).toFixed(4)}, {Number(t.longitude).toFixed(4)} ↗
                      </a>
                    ) : "—"}
                  </td>
                  <td>{t ? shortDate(t.updated_at) : "—"}</td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </>
  );
}
