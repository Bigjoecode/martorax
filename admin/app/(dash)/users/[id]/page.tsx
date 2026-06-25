import { notFound } from "next/navigation";
import { createAdminClient } from "@/lib/supabase/admin";
import { shortId } from "@/lib/format";
import { updateProfile } from "../actions";

export const dynamic = "force-dynamic";

const ROLES = ["shopper", "vendor", "provider", "rider"];
const KYC = ["unverified", "pending", "verified", "rejected"];

export default async function EditUserPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const db = createAdminClient();
  const { data: u } = await db
    .from("profiles")
    .select("*")
    .eq("id", id)
    .maybeSingle();
  if (!u) notFound();

  return (
    <>
      <div className="page-head">
        <div>
          <h2 style={{ fontSize: 20, fontWeight: 700 }}>Edit user</h2>
          <p className="mono">{shortId(u.id, 36)}</p>
        </div>
      </div>

      <form action={updateProfile} className="card" style={{ maxWidth: 640, display: "grid", gap: 14 }}>
        <input type="hidden" name="id" value={u.id} />
        <div>
          <label>Full name</label>
          <input name="full_name" defaultValue={u.full_name || ""} required />
        </div>
        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 12 }}>
          <div>
            <label>Phone</label>
            <input name="phone_number" defaultValue={u.phone_number || ""} />
          </div>
          <div>
            <label>Rating</label>
            <input name="rating" type="number" step="0.1" min="0" max="5" defaultValue={u.rating ?? ""} />
          </div>
        </div>
        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 12 }}>
          <div>
            <label>Role</label>
            <select name="active_role" defaultValue={u.active_role || "shopper"}>
              {ROLES.map((r) => <option key={r} value={r}>{r}</option>)}
            </select>
          </div>
          <div>
            <label>KYC status</label>
            <select name="kyc_status" defaultValue={u.kyc_status || "unverified"}>
              {KYC.map((k) => <option key={k} value={k}>{k}</option>)}
            </select>
          </div>
        </div>
        <div>
          <label>Business name (vendors)</label>
          <input name="business_name" defaultValue={u.business_name || ""} />
        </div>
        <div>
          <label>Service category (providers)</label>
          <input name="service_category" defaultValue={u.service_category || ""} />
        </div>
        <div>
          <label>Landmark address</label>
          <input name="landmark_address" defaultValue={u.landmark_address || ""} />
        </div>
        <div className="row-actions">
          <button className="btn btn-primary" type="submit">Save changes</button>
          <a className="btn" href="/users">Cancel</a>
        </div>
      </form>
    </>
  );
}
