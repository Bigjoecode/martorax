import { createAdminClient } from "@/lib/supabase/admin";
import { naira, shortDate, shortId } from "@/lib/format";
import { deleteProduct, updateStock } from "./actions";

export const dynamic = "force-dynamic";

export default async function ProductsPage() {
  const db = createAdminClient();
  const { data, error } = await db
    .from("products")
    .select("id, title, price, wholesale_price, stock, location, vendor_id, created_at")
    .order("created_at", { ascending: false })
    .limit(500);

  return (
    <>
      <div className="page-head">
        <div>
          <h2 style={{ fontSize: 20, fontWeight: 700 }}>Products</h2>
          <p>{data?.length ?? 0} listings. Adjust stock or remove listings.</p>
        </div>
      </div>

      {error && <div className="error">{error.message}</div>}

      <div className="table-wrap">
        <table>
          <thead>
            <tr>
              <th>Title</th>
              <th>Vendor</th>
              <th>Price</th>
              <th>Wholesale</th>
              <th>Stock</th>
              <th>Location</th>
              <th>Listed</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            {(data || []).length === 0 && (
              <tr><td colSpan={8} className="empty">No products found.</td></tr>
            )}
            {(data || []).map((p: any) => (
              <tr key={p.id}>
                <td>{p.title}</td>
                <td className="mono">{shortId(p.vendor_id)}</td>
                <td>{naira(p.price)}</td>
                <td>{p.wholesale_price ? naira(p.wholesale_price) : "—"}</td>
                <td>
                  <form action={updateStock} style={{ display: "flex", gap: 6, alignItems: "center" }}>
                    <input type="hidden" name="id" value={p.id} />
                    <input name="stock" type="number" defaultValue={p.stock ?? 0} style={{ width: 80 }} />
                    <button className="btn btn-sm" type="submit">Set</button>
                  </form>
                </td>
                <td>{p.location || "—"}</td>
                <td>{shortDate(p.created_at)}</td>
                <td>
                  <form action={deleteProduct}>
                    <input type="hidden" name="id" value={p.id} />
                    <button className="btn btn-sm btn-danger" type="submit">Remove</button>
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
