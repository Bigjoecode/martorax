import { createAdminClient } from "@/lib/supabase/admin";
import { shortId, dateTime } from "@/lib/format";
import RiderMapClient from "@/components/RiderMapClient";
import type { Pin } from "@/components/RiderMapInner";

export const dynamic = "force-dynamic";

export default async function MapPage() {
  const db = createAdminClient();

  // Latest 300 pings; keep the newest per rider.
  const { data: tracking } = await db
    .from("rider_tracking")
    .select("rider_id, order_id, latitude, longitude, updated_at")
    .order("updated_at", { ascending: false })
    .limit(300);

  const latest = new Map<string, any>();
  for (const t of tracking || []) {
    if (!latest.has(t.rider_id)) latest.set(t.rider_id, t);
  }

  // Resolve rider names.
  const ids = Array.from(latest.keys());
  const names: Record<string, string> = {};
  if (ids.length) {
    const { data: profs } = await db.from("profiles").select("id, full_name").in("id", ids);
    for (const p of profs || []) names[p.id] = p.full_name || shortId(p.id);
  }

  const pins: Pin[] = Array.from(latest.values()).map((t) => ({
    riderId: t.rider_id,
    name: names[t.rider_id] || `Rider ${shortId(t.rider_id)}`,
    lat: Number(t.latitude),
    lng: Number(t.longitude),
    orderId: t.order_id,
    updatedAt: t.updated_at,
  }));

  return (
    <>
      <div className="page-head">
        <div>
          <h2 style={{ fontSize: 20, fontWeight: 700 }}>Rider Map</h2>
          <p>{pins.length} rider{pins.length === 1 ? "" : "s"} with a recent GPS ping.</p>
        </div>
      </div>

      {pins.length === 0 && (
        <div className="card empty" style={{ marginBottom: 16 }}>
          No rider GPS pings yet. Riders appear here once they start sharing location during a delivery.
        </div>
      )}

      <div className="card" style={{ padding: 8 }}>
        <RiderMapClient pins={pins} />
      </div>

      {pins.length > 0 && (
        <div className="table-wrap" style={{ marginTop: 16 }}>
          <table>
            <thead><tr><th>Rider</th><th>Order</th><th>Coordinates</th><th>Last ping</th></tr></thead>
            <tbody>
              {pins.map((p) => (
                <tr key={p.riderId}>
                  <td>{p.name}</td>
                  <td className="mono">{p.orderId ? shortId(p.orderId) : "—"}</td>
                  <td className="mono">{p.lat.toFixed(4)}, {p.lng.toFixed(4)}</td>
                  <td>{p.updatedAt ? dateTime(p.updatedAt) : "—"}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </>
  );
}
