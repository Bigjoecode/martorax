import { createAdminClient } from "@/lib/supabase/admin";
import { shortDate, shortId, pageOf, PAGE_SIZE } from "@/lib/format";
import { updateRole, deleteUser } from "./actions";
import SearchBox from "@/components/SearchBox";
import Pagination from "@/components/Pagination";

export const dynamic = "force-dynamic";

const ROLES = ["shopper", "vendor", "provider", "rider"];

export default async function UsersPage({
  searchParams,
}: {
  searchParams: Promise<{ q?: string; page?: string }>;
}) {
  const { q, page: pageStr } = await searchParams;
  const page = pageOf(pageStr);
  const from = (page - 1) * PAGE_SIZE;
  const db = createAdminClient();

  let query = db
    .from("profiles")
    .select("id, full_name, active_role, phone_number, rating, kyc_status, created_at")
    .order("created_at", { ascending: false })
    .range(from, from + PAGE_SIZE);
  if (q) query = query.ilike("full_name", `%${q}%`);
  const { data, error } = await query;

  const rows = (data || []).slice(0, PAGE_SIZE);
  const hasMore = (data || []).length > PAGE_SIZE;

  return (
    <>
      <div className="page-head">
        <div>
          <h2 style={{ fontSize: 20, fontWeight: 700 }}>Users</h2>
          <p>Search, edit profiles, change roles, or remove accounts.</p>
        </div>
        <a className="btn btn-sm" href="/export/users">⬇ Export CSV</a>
      </div>

      <div style={{ marginBottom: 14 }}>
        <SearchBox action="/users" defaultValue={q} placeholder="Search by name…" />
      </div>

      {error && <div className="error">{error.message}</div>}

      <div className="table-wrap">
        <table>
          <thead>
            <tr>
              <th>ID</th><th>Name</th><th>Phone</th><th>KYC</th><th>Rating</th><th>Role</th><th>Joined</th><th></th>
            </tr>
          </thead>
          <tbody>
            {rows.length === 0 && <tr><td colSpan={8} className="empty">No users found.</td></tr>}
            {rows.map((u: any) => (
              <tr key={u.id}>
                <td className="mono">{shortId(u.id)}</td>
                <td><a href={`/users/${u.id}`} style={{ color: "var(--emerald-bright)" }}>{u.full_name || "—"}</a></td>
                <td className="mono">{u.phone_number || "—"}</td>
                <td><span className={`badge ${u.kyc_status === "verified" ? "released" : u.kyc_status === "rejected" ? "disputed" : u.kyc_status === "pending" ? "held" : "pending"}`}>{u.kyc_status || "unverified"}</span></td>
                <td>{u.rating ?? "—"}</td>
                <td>
                  <form action={updateRole} style={{ display: "flex", gap: 6, alignItems: "center" }}>
                    <input type="hidden" name="id" value={u.id} />
                    <select name="role" defaultValue={u.active_role || "shopper"} style={{ width: 120 }}>
                      {ROLES.map((r) => <option key={r} value={r}>{r}</option>)}
                    </select>
                    <button className="btn btn-sm" type="submit">Save</button>
                  </form>
                </td>
                <td>{shortDate(u.created_at)}</td>
                <td>
                  <div className="row-actions">
                    <a className="btn btn-sm" href={`/users/${u.id}`}>Edit</a>
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
      <Pagination basePath="/users" page={page} hasMore={hasMore} query={q} />
    </>
  );
}
