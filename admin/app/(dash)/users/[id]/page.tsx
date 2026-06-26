import { notFound } from "next/navigation";
import { createAdminClient } from "@/lib/supabase/admin";
import { naira, dateTime, shortDate, shortId } from "@/lib/format";
import { updateProfile, deleteUser, endVendorLive } from "../actions";
import { approveKyc, rejectKyc } from "../../kyc/actions";

export const dynamic = "force-dynamic";

const ROLES = ["shopper", "vendor", "provider", "rider"];
const KYC = ["unverified", "pending", "verified", "rejected"];

async function signed(db: ReturnType<typeof createAdminClient>, path: string | null) {
  if (!path) return null;
  const { data } = await db.storage.from("kyc-docs").createSignedUrl(path, 600);
  return data?.signedUrl ?? null;
}

function kycBadge(s: string) {
  return s === "verified" ? "released" : s === "rejected" ? "disputed" : s === "pending" ? "held" : "pending";
}

export default async function UserDossierPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const db = createAdminClient();

  const { data: u } = await db.from("profiles").select("*").eq("id", id).maybeSingle();
  if (!u) notFound();

  const [
    authRes, ordersBuyer, ordersSeller, deliveries, products,
    bookingsShopper, bookingsProvider, escrow, payouts, notifCount, msgCount, idUrl, selfieUrl,
  ] = await Promise.all([
    db.auth.admin.getUserById(id).catch(() => ({ data: { user: null } })),
    db.from("orders").select("id, total_amount, delivery_status, created_at").eq("buyer_id", id).order("created_at", { ascending: false }).limit(50),
    db.from("orders").select("id, total_amount, delivery_status, created_at").eq("seller_id", id).order("created_at", { ascending: false }).limit(50),
    db.from("orders").select("id, total_amount, delivery_status, created_at").eq("rider_id", id).order("created_at", { ascending: false }).limit(50),
    db.from("products").select("id, title, price, stock, created_at").eq("vendor_id", id).order("created_at", { ascending: false }).limit(50),
    db.from("service_bookings").select("id, service_category, amount, status, created_at").eq("shopper_id", id).order("created_at", { ascending: false }).limit(50),
    db.from("service_bookings").select("id, service_category, amount, status, created_at").eq("provider_id", id).order("created_at", { ascending: false }).limit(50),
    db.from("escrow_ledger").select("hold_code, amount, status, order_id").or(`buyer_id.eq.${id},provider_id.eq.${id}`).limit(50),
    db.from("payout_requests").select("id, amount, status, created_at").eq("user_id", id).order("created_at", { ascending: false }).limit(50),
    db.from("notifications").select("id", { count: "exact", head: true }).eq("user_id", id),
    db.from("messages").select("id", { count: "exact", head: true }).or(`sender_id.eq.${id},receiver_id.eq.${id}`),
    signed(db, u.kyc_id_url),
    signed(db, u.kyc_selfie_url),
  ]);

  const authUser: any = (authRes as any)?.data?.user ?? null;
  const buyer = ordersBuyer.data || [];
  const seller = ordersSeller.data || [];
  const deliv = deliveries.data || [];
  const prods = products.data || [];
  const bShopper = bookingsShopper.data || [];
  const bProvider = bookingsProvider.data || [];
  const esc = escrow.data || [];
  const pays = payouts.data || [];

  const sum = (rows: any[], k = "total_amount") => rows.reduce((s, r) => s + Number(r[k] || 0), 0);
  const role = u.active_role || "shopper";

  return (
    <>
      <div className="page-head">
        <div>
          <h2 style={{ fontSize: 20, fontWeight: 700 }}>
            {u.full_name || "Unnamed"} <span className="badge role" style={{ marginLeft: 6 }}>{role}</span>{" "}
            <span className={`badge ${kycBadge(u.kyc_status || "unverified")}`}>{u.kyc_status || "unverified"}</span>
          </h2>
          <p className="mono">{shortId(u.id, 36)}</p>
        </div>
        <a className="btn" href="/users">← All users</a>
      </div>

      {u.is_live && (
        <div className="card" style={{ marginBottom: 16, borderColor: "var(--red)", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
          <span style={{ fontWeight: 650 }}>
            <span className="badge disputed">● LIVE NOW</span>{" "}
            Streaming{u.live_started_at ? ` since ${dateTime(u.live_started_at)}` : ""}
          </span>
          <form action={endVendorLive}>
            <input type="hidden" name="id" value={u.id} />
            <button className="btn btn-sm btn-danger" type="submit">End live stream</button>
          </form>
        </div>
      )}

      {/* Registration + KYC */}
      <div className="grid" style={{ gridTemplateColumns: "1fr 1fr", gap: 16 }}>
        <div className="card">
          <h3 style={{ fontSize: 14, marginBottom: 12 }}>Registration & profile</h3>
          <Row k="Email" v={authUser?.email || "—"} />
          <Row k="Phone" v={u.phone_number || "—"} />
          <Row k="Joined" v={dateTime(u.created_at)} />
          <Row k="Last sign-in" v={authUser?.last_sign_in_at ? dateTime(authUser.last_sign_in_at) : "—"} />
          <Row k="Rating" v={u.rating ?? "—"} />
          <Row k="Landmark" v={u.landmark_address || "—"} />
          {role === "vendor" && <>
            <Row k="Business" v={u.business_name || "—"} />
            <Row k="Market" v={u.business_market || "—"} />
            <Row k="Stall" v={u.business_stall || "—"} />
            <Row k="Type" v={u.business_type || "—"} />
          </>}
          {role === "provider" && <>
            <Row k="Service" v={u.service_category || "—"} />
            <Row k="Experience" v={u.service_experience_years ? `${u.service_experience_years} yrs` : "—"} />
          </>}
          <Row k="Onboarded" v={u.onboarding_completed ? "Yes" : "No"} />
        </div>

        <div className="card">
          <h3 style={{ fontSize: 14, marginBottom: 12 }}>KYC verification</h3>
          <Row k="Status" v={<span className={`badge ${kycBadge(u.kyc_status || "unverified")}`}>{u.kyc_status || "unverified"}</span>} />
          <Row k="ID type" v={u.kyc_id_type || "—"} />
          <Row k="Submitted" v={u.kyc_submitted_at ? dateTime(u.kyc_submitted_at) : "—"} />
          {u.kyc_reject_reason && <Row k="Reject reason" v={u.kyc_reject_reason} />}
          <div className="grid" style={{ gridTemplateColumns: "1fr 1fr", gap: 10, margin: "10px 0" }}>
            <Doc label="ID" url={idUrl} />
            <Doc label="Selfie" url={selfieUrl} />
          </div>
          {u.kyc_status !== "verified" && (u.kyc_id_url || u.kyc_status === "pending") && (
            <form className="row-actions" style={{ marginTop: 4 }}>
              <input type="hidden" name="id" value={u.id} />
              <button className="btn btn-sm btn-primary" formAction={approveKyc}>Approve</button>
              <button className="btn btn-sm btn-danger" formAction={rejectKyc}>Reject</button>
            </form>
          )}
        </div>
      </div>

      {/* Role-aware stats */}
      <div className="grid metrics" style={{ marginTop: 16 }}>
        {(role === "shopper" || buyer.length > 0) && <Stat label="Orders placed" value={`${buyer.length}`} sub={naira(sum(buyer))} />}
        {(role === "vendor" || seller.length > 0) && <Stat label="Sales" value={`${seller.length}`} sub={naira(sum(seller))} />}
        {(role === "vendor" || prods.length > 0) && <Stat label="Products" value={`${prods.length}`} sub="listed" />}
        {(role === "provider" || bProvider.length > 0) && <Stat label="Jobs (provider)" value={`${bProvider.length}`} sub={naira(sum(bProvider, "amount"))} />}
        {(role === "rider" || deliv.length > 0) && <Stat label="Deliveries" value={`${deliv.length}`} sub={`${deliv.filter((d: any) => d.delivery_status === "delivered").length} done`} />}
        {pays.length > 0 && <Stat label="Payouts" value={`${pays.length}`} sub={naira(sum(pays, "amount"))} />}
        <Stat label="Notifications" value={`${notifCount.count ?? 0}`} sub="received" />
        <Stat label="Messages" value={`${msgCount.count ?? 0}`} sub="sent/received" />
      </div>

      {/* Activity tables */}
      {buyer.length > 0 && <OrdersTable title="Orders placed (as shopper)" rows={buyer} />}
      {seller.length > 0 && <OrdersTable title="Sales (as vendor)" rows={seller} />}
      {deliv.length > 0 && <OrdersTable title="Deliveries (as rider)" rows={deliv} />}
      {prods.length > 0 && (
        <Section title={`Products listed (${prods.length})`}>
          <table><thead><tr><th>Title</th><th>Price</th><th>Stock</th><th>Listed</th></tr></thead>
            <tbody>{prods.map((p: any) => <tr key={p.id}><td><a href={`/products/${p.id}`} style={{ color: "var(--emerald-bright)" }}>{p.title}</a></td><td>{naira(p.price)}</td><td>{p.stock}</td><td>{shortDate(p.created_at)}</td></tr>)}</tbody>
          </table>
        </Section>
      )}
      {bShopper.length > 0 && <BookingsTable title="Bookings made (as shopper)" rows={bShopper} />}
      {bProvider.length > 0 && <BookingsTable title="Jobs received (as provider)" rows={bProvider} />}
      {esc.length > 0 && (
        <Section title={`Escrow involvement (${esc.length})`}>
          <table><thead><tr><th>Hold code</th><th>Order</th><th>Amount</th><th>Status</th></tr></thead>
            <tbody>{esc.map((e: any, i: number) => <tr key={i}><td className="mono">{e.hold_code}</td><td><a href={`/orders/${e.order_id}`} className="mono" style={{ color: "var(--emerald-bright)" }}>{shortId(e.order_id)}</a></td><td>{naira(e.amount)}</td><td><span className={`badge ${e.status}`}>{e.status}</span></td></tr>)}</tbody>
          </table>
        </Section>
      )}
      {pays.length > 0 && (
        <Section title={`Payout requests (${pays.length})`}>
          <table><thead><tr><th>Amount</th><th>Status</th><th>Requested</th></tr></thead>
            <tbody>{pays.map((p: any) => <tr key={p.id}><td>{naira(p.amount)}</td><td><span className="badge role">{p.status}</span></td><td>{shortDate(p.created_at)}</td></tr>)}</tbody>
          </table>
        </Section>
      )}

      {/* Edit + danger */}
      <details className="card" style={{ marginTop: 16 }}>
        <summary style={{ cursor: "pointer", fontWeight: 650 }}>Edit profile</summary>
        <form action={updateProfile} style={{ display: "grid", gap: 12, marginTop: 14, maxWidth: 640 }}>
          <input type="hidden" name="id" value={u.id} />
          <div><label>Full name</label><input name="full_name" defaultValue={u.full_name || ""} required /></div>
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 12 }}>
            <div><label>Phone</label><input name="phone_number" defaultValue={u.phone_number || ""} /></div>
            <div><label>Rating</label><input name="rating" type="number" step="0.1" defaultValue={u.rating ?? ""} /></div>
          </div>
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 12 }}>
            <div><label>Role</label><select name="active_role" defaultValue={role}>{ROLES.map((r) => <option key={r} value={r}>{r}</option>)}</select></div>
            <div><label>KYC status</label><select name="kyc_status" defaultValue={u.kyc_status || "unverified"}>{KYC.map((k) => <option key={k} value={k}>{k}</option>)}</select></div>
          </div>
          <div><label>Business name</label><input name="business_name" defaultValue={u.business_name || ""} /></div>
          <div><label>Service category</label><input name="service_category" defaultValue={u.service_category || ""} /></div>
          <div><label>Landmark</label><input name="landmark_address" defaultValue={u.landmark_address || ""} /></div>
          <div><button className="btn btn-primary" type="submit">Save changes</button></div>
        </form>
      </details>

      <form action={deleteUser} style={{ marginTop: 14 }}>
        <input type="hidden" name="id" value={u.id} />
        <button className="btn btn-danger" type="submit">Delete this user</button>
      </form>
    </>
  );
}

function Row({ k, v }: { k: string; v: React.ReactNode }) {
  return (
    <div style={{ display: "flex", justifyContent: "space-between", padding: "6px 0", borderBottom: "1px solid var(--border)", gap: 12 }}>
      <span style={{ color: "var(--muted)", fontSize: 13 }}>{k}</span>
      <span style={{ fontSize: 13, textAlign: "right" }}>{v}</span>
    </div>
  );
}

function Stat({ label, value, sub }: { label: string; value: string; sub: string }) {
  return (
    <div className="card metric"><div className="label">{label}</div><div className="value" style={{ fontSize: 24 }}>{value}</div><div className="sub">{sub}</div></div>
  );
}

function Section({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <div className="card" style={{ marginTop: 16, padding: 0 }}>
      <div style={{ padding: "14px 18px", borderBottom: "1px solid var(--border)", fontWeight: 650 }}>{title}</div>
      <div className="table-wrap" style={{ border: "none" }}>{children}</div>
    </div>
  );
}

function OrdersTable({ title, rows }: { title: string; rows: any[] }) {
  return (
    <Section title={`${title} (${rows.length})`}>
      <table><thead><tr><th>Order</th><th>Amount</th><th>Status</th><th>Date</th></tr></thead>
        <tbody>{rows.map((o: any) => (
          <tr key={o.id}><td><a href={`/orders/${o.id}`} className="mono" style={{ color: "var(--emerald-bright)" }}>{shortId(o.id)}</a></td><td>{naira(o.total_amount)}</td><td><span className={`badge ${String(o.delivery_status || "pending").toLowerCase()}`}>{o.delivery_status || "pending"}</span></td><td>{shortDate(o.created_at)}</td></tr>
        ))}</tbody>
      </table>
    </Section>
  );
}

function BookingsTable({ title, rows }: { title: string; rows: any[] }) {
  return (
    <Section title={`${title} (${rows.length})`}>
      <table><thead><tr><th>Booking</th><th>Category</th><th>Amount</th><th>Status</th><th>Date</th></tr></thead>
        <tbody>{rows.map((b: any) => (
          <tr key={b.id}><td className="mono">{shortId(b.id)}</td><td>{b.service_category || "—"}</td><td>{naira(b.amount)}</td><td><span className="badge role">{b.status}</span></td><td>{shortDate(b.created_at)}</td></tr>
        ))}</tbody>
      </table>
    </Section>
  );
}

function Doc({ label, url }: { label: string; url: string | null }) {
  return (
    <div>
      <div style={{ fontSize: 10, color: "var(--muted)", textTransform: "uppercase", marginBottom: 4 }}>{label}</div>
      {url ? (
        // eslint-disable-next-line @next/next/no-img-element
        <a href={url} target="_blank" rel="noreferrer"><img src={url} alt={label} style={{ width: "100%", height: 120, objectFit: "cover", borderRadius: 8, border: "1px solid var(--border)" }} /></a>
      ) : (
        <div style={{ height: 120, display: "grid", placeItems: "center", borderRadius: 8, border: "1px dashed var(--border)", color: "var(--muted)", fontSize: 11 }}>None</div>
      )}
    </div>
  );
}
