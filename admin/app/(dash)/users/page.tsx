import { createAdminClient } from "@/lib/supabase/admin";
import { shortDate, shortId } from "@/lib/format";
import { updateRole, deleteUser } from "./actions";

export const dynamic = "force-dynamic";

const ROLES = ["shopper", "vendor", "provider", "rider"];

export default async function UsersPage() {
  const db = createAdminClient();
  const { data, error } = await db
    .from("profiles")
    .select("id, full_name, active_role, phone_number, rating, created_at")
    .order("created_at", { ascending: false })
    .limit(500);

  return (
    <>
      <div className="page-head">
        <div>
          <h2 style={{ fontSize: 20, fontWeight: 700 }}>Users</h2>
          <p>{data?.length ?? 0} profiles. Change roles or remove accounts.</p>
        </div>
      </div>

      {error && <div className="error">{error.message}</div>}

      <div className="table-wrap">
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Name</th>
              <th>Phone</th>
              <th>Rating</th>
              <th>Role</th>
              <th>Joined</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            {(data || []).length === 0 && (
              <tr><td colSpan={7} className="empty">No users found.</td></tr>
            )}
            {(data || []).map((u: any) => (
              <tr key={u.id}>
                <td className="mono">{shortId(u.id)}</td>
                <td>{u.full_name || "—"}</td>
                <td className="mono">{u.phone_number || "—"}</td>
                <td>{u.rating ?? "—"}</td>
                <td>
                  <form action={updateRole} style={{ display: "flex", gap: 6, alignItems: "center" }}>
                    <input type="hidden" name="id" value={u.id} />
                    <select name="role" defaultValue={u.active_role || "shopper"} style={{ width: 130 }}>
                      {ROLES.map((r) => <option key={r} value={r}>{r}</option>)}
                    </select>
                    <button className="btn btn-sm" type="submit">Save</button>
                  </form>
                </td>
                <td>{shortDate(u.created_at)}</td>
                <td>
                  <form action={deleteUser}>
                    <input type="hidden" name="id" value={u.id} />
                    <button className="btn btn-sm btn-danger" type="submit">Delete</button>
                  </form>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
}
