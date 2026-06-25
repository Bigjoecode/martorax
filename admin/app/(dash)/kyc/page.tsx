import { createAdminClient } from "@/lib/supabase/admin";
import { shortDate, shortId } from "@/lib/format";
import { approveKyc, rejectKyc } from "./actions";

export const dynamic = "force-dynamic";

const BUCKET = "kyc-docs";

async function signed(db: ReturnType<typeof createAdminClient>, path: string | null) {
  if (!path) return null;
  const { data } = await db.storage.from(BUCKET).createSignedUrl(path, 60 * 10);
  return data?.signedUrl ?? null;
}

export default async function KycPage({
  searchParams,
}: {
  searchParams: Promise<{ status?: string }>;
}) {
  const { status } = await searchParams;
  const filter = status || "pending";
  const db = createAdminClient();

  let query = db
    .from("profiles")
    .select(
      "id, full_name, active_role, phone_number, kyc_status, kyc_id_type, kyc_id_url, kyc_selfie_url, kyc_submitted_at, kyc_reject_reason"
    )
    .order("kyc_submitted_at", { ascending: false, nullsFirst: false })
    .limit(200);
  if (filter !== "all") query = query.eq("kyc_status", filter);
  const { data, error } = await query;

  const rows = await Promise.all(
    (data || []).map(async (p: any) => ({
      ...p,
      idUrl: await signed(db, p.kyc_id_url),
      selfieUrl: await signed(db, p.kyc_selfie_url),
    }))
  );

  const filters = ["pending", "verified", "rejected", "all"];

  return (
    <>
      <div className="page-head">
        <div>
          <h2 style={{ fontSize: 20, fontWeight: 700 }}>KYC Verification</h2>
          <p>Review submitted identity documents and approve or reject.</p>
        </div>
        <div className="row-actions">
          {filters.map((f) => (
            <a key={f} className={`btn btn-sm${filter === f ? " btn-primary" : ""}`} href={f === "all" ? "/kyc" : `/kyc?status=${f}`}>
              {f}
            </a>
          ))}
        </div>
      </div>

      {error && <div className="error">{error.message}</div>}

      <div className="grid" style={{ gridTemplateColumns: "1fr", gap: 14 }}>
        {rows.length === 0 && (
          <div className="card empty">Nothing to review in “{filter}”.</div>
        )}
        {rows.map((p: any) => (
          <div key={p.id} className="card">
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: 12 }}>
              <div>
                <div style={{ fontWeight: 700, fontSize: 15 }}>{p.full_name || "—"}</div>
                <div className="mono" style={{ marginTop: 2 }}>
                  {shortId(p.id)} · <span className="badge role">{p.active_role}</span> · {p.phone_number || "no phone"}
                </div>
                <div style={{ color: "var(--muted)", fontSize: 12, marginTop: 4 }}>
                  {p.kyc_id_type || "ID"} · submitted {shortDate(p.kyc_submitted_at)}
                </div>
              </div>
              <span className={`badge ${p.kyc_status === "verified" ? "released" : p.kyc_status === "rejected" ? "disputed" : "held"}`}>
                {p.kyc_status}
              </span>
            </div>

            <div className="grid" style={{ gridTemplateColumns: "1fr 1fr", gap: 12, marginBottom: 14 }}>
              <DocThumb label="ID Document" url={p.idUrl} />
              <DocThumb label="Selfie" url={p.selfieUrl} />
            </div>

            {p.kyc_status === "rejected" && p.kyc_reject_reason && (
              <div className="error" style={{ marginBottom: 12 }}>Reason: {p.kyc_reject_reason}</div>
            )}

            {p.kyc_status !== "verified" && (
              <form action={rejectKyc} className="grid" style={{ gridTemplateColumns: "1fr auto auto", gap: 8, alignItems: "end" }}>
                <input type="hidden" name="id" value={p.id} />
                <div>
                  <label>Rejection reason (optional)</label>
                  <input name="reason" placeholder="e.g. ID photo blurry" />
                </div>
                <button className="btn btn-danger" formAction={rejectKyc} type="submit">Reject</button>
                <button className="btn btn-primary" formAction={approveKyc} type="submit">Approve</button>
              </form>
            )}
          </div>
        ))}
      </div>
    </>
  );
}

function DocThumb({ label, url }: { label: string; url: string | null }) {
  return (
    <div>
      <div style={{ fontSize: 11, color: "var(--muted)", textTransform: "uppercase", letterSpacing: "0.04em", marginBottom: 6 }}>{label}</div>
      {url ? (
        <a href={url} target="_blank" rel="noreferrer">
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img src={url} alt={label} style={{ width: "100%", height: 160, objectFit: "cover", borderRadius: 8, border: "1px solid var(--border)" }} />
        </a>
      ) : (
        <div style={{ height: 160, display: "grid", placeItems: "center", borderRadius: 8, border: "1px dashed var(--border)", color: "var(--muted)", fontSize: 12 }}>
          No document
        </div>
      )}
    </div>
  );
}
