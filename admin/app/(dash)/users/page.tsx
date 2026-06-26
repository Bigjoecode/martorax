import { createAdminClient } from "@/lib/supabase/admin";
import { shortDate, shortId, pageOf, PAGE_SIZE } from "@/lib/format";
import { deleteUser } from "./actions";
import SearchBox from "@/components/SearchBox";
import Pagination from "@/components/Pagination";

export const dynamic = "force-dynamic";

const ROLE_TABS = [
  { key: "all", label: "All" },
  { key: "shopper", label: "Shoppers" },
  { key: "vendor", label: "Vendors" },
  { key: "provider", label: "Providers" },
  { key: "rider", label: "Riders" },
];

export default async function UsersPage({
  searchParams,
}: {
  searchParams: Promise<{ q?: string; page?: string; role?: string }>;
}) {
  const { q, page: pageStr, role } = await searchParams;
  const page = pageOf(pageStr);
  const from = (page - 1) * PAGE_SIZE;
  const db = createAdminClient();

  // Per-role counts for the tab badges.
  const counts = await Promise.all(
    ["shopper", "vendor", "provider", "rider"].map((r) =>
      db.from("profiles").select("id", { count: "exact", head: true }).eq("active_role", r)
    )
  );
  const countByRole: Record<string, number> = {
    shopper: counts[0].count ?? 0,
    vendor: counts[1].count ?? 0,
    provider: counts[2].count ?? 0,
    rider: counts[3].count ?? 0,
  };

  let query = db
    .from("profiles")
    .select("id, full_name, active_role, phone_number, rating, kyc_status, business_name, service_category, created_at")
    .order("created_at", { ascending: false })
    .range(from, from + PAGE_SIZE);
  if (role && role !== "all") query = query.eq("active_role", role);
  if (q) query = query.ilike("full_name", `%${q}%`);
  const { data, error } = await query;
  const rows = (data || []).slice(0, PAGE_SIZE);
  const hasMore = (data || []).length > PAGE_SIZE;

  const activeRole = role || "all";
  const mkHref = (r: string) => (r === "all" ? "/users" : `/users?role=${r}`);

  return (
    <>
      <div className="page-head">
        <div>
          <h2 style={{ fontSize: 20, fontWeight: 700 }}>Users</h2>
          <p>Every shopper, vendor, provider and rider — open one for their full dossier.</p>
        </div>
        <a className="btn btn-sm" href={`/export/users`}>⬇ Export CSV</a>
      </div>

      <div className="row-actions" style={{ marginBottom: 14, flexWrap: "wrap" }}>
        {ROLE_TABS.map((t) => (
          <a key={t.key} className={`btn btn-sm${activeRole === t.key ? " btn-primary" : ""}`} href={mkHref(t.key)}>
            {t.label}{t.key !== "all" ? ` (${countByRole[t.key]})` : ""}
          </a>
        ))}
      </div>

      <div style={{ marginBottom: 14 }}>
        <SearchBox
          action="/users"
          defaultValue={q}
          placeholder="Search by name…"
          hidden={{ role: activeRole === "all" ? undefined : activeRole }}
          clearHref={mkHref(activeRole)}
        />
      </div>

      {error && <div className="error">{error.message}</div>}

      <div className="table-wrap">
        <table>
          <thead>
            <tr><th>ID</th><th>Name</th><th>Role / business</th><th>Phone</th><th>KYC</th><th>Rating</th><th>Joined</th><th></th></tr>
          </thead>
          <tbody>
            {rows.length === 0 && <tr><td colSpan={8} className="empty">No users found.</td></tr>}
            {rows.map((u: any) => (
              <tr key={u.id}>
                <td className="mono">{shortId(u.id)}</td>
                <td><a href={`/users/${u.id}`} style={{ color: "var(--emerald-bright)" }}>{u.full_name || "—"}</a></td>
                <td>
                  <span className="badge role">{u.active_role}</span>{" "}
                  <span style={{ color: "var(--muted)", fontSize: 12 }}>
                    {u.business_name || u.service_category || ""}
                  </span>
                </td>
                <td className="mono">{u.phone_number || "—"}</td>
                <td><span className={`badge ${u.kyc_status === "verified" ? "released" : u.kyc_status === "rejected" ? "disputed" : u.kyc_status === "pending" ? "held" : "pending"}`}>{u.kyc_status || "unverified"}</span></td>
                <td>{u.rating ?? "—"}</td>
                <td>{shortDate(u.created_at)}</td>
                <td>
                  <div className="row-actions">
                    <a className="btn btn-sm" href={`/users/${u.id}`}>View</a>
                    <form action={deleteUser}>
                      <input type="hidden" name="id" value={u.id} />
                      <button className="btn btn-sm btn-danger" type="submit">Delete</button>
                    </form>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      <Pagination basePath="/users" page={page} hasMore={hasMore} query={q} params={{ role: activeRole === "all" ? undefined : activeRole }} />
    </>
  );
}
