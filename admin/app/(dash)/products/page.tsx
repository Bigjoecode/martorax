import { createAdminClient } from "@/lib/supabase/admin";
import { naira, shortDate, shortId, pageOf, PAGE_SIZE } from "@/lib/format";
import { deleteProduct, updateStock } from "./actions";
import SearchBox from "@/components/SearchBox";
import Pagination from "@/components/Pagination";

export const dynamic = "force-dynamic";

export default async function ProductsPage({
  searchParams,
}: {
  searchParams: Promise<{ q?: string; page?: string }>;
}) {
  const { q, page: pageStr } = await searchParams;
  const page = pageOf(pageStr);
  const from = (page - 1) * PAGE_SIZE;
  const db = createAdminClient();

  let query = db
    .from("products")
    .select("id, title, price, wholesale_price, stock, location, vendor_id, created_at")
    .order("created_at", { ascending: false })
    .range(from, from + PAGE_SIZE); // one extra to detect "hasMore"
  if (q) query = query.ilike("title", `%${q}%`);
  const { data, error } = await query;

  const rows = (data || []).slice(0, PAGE_SIZE);
  const hasMore = (data || []).length > PAGE_SIZE;

  return (
    <>
      <div className="page-head">
        <div>
          <h2 style={{ fontSize: 20, fontWeight: 700 }}>Products</h2>
          <p>Create, edit stock, or remove listings.</p>
        </div>
        <div className="row-actions">
          <a className="btn btn-sm" href="/export/products">⬇ CSV</a>
          <a className="btn btn-primary" href="/products/new">+ New product</a>
        </div>
      </div>

      <div style={{ marginBottom: 14 }}>
        <SearchBox action="/products" defaultValue={q} placeholder="Search by title…" />
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
              <th>Listed</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            {rows.length === 0 && <tr><td colSpan={7} className="empty">No products found.</td></tr>}
            {rows.map((p: any) => (
              <tr key={p.id}>
                <td><a href={`/products/${p.id}`} style={{ color: "var(--emerald-bright)" }}>{p.title}</a></td>
                <td className="mono">{shortId(p.vendor_id)}</td>
                <td>{naira(p.price)}</td>
                <td>{p.wholesale_price ? naira(p.wholesale_price) : "—"}</td>
                <td>
                  <form action={updateStock} style={{ display: "flex", gap: 6, alignItems: "center" }}>
                    <input type="hidden" name="id" value={p.id} />
                    <input name="stock" type="number" defaultValue={p.stock ?? 0} style={{ width: 76 }} />
                    <button className="btn btn-sm" type="submit">Set</button>
                  </form>
                </td>
                <td>{shortDate(p.created_at)}</td>
                <td>
                  <div className="row-actions">
                    <a className="btn btn-sm" href={`/products/${p.id}`}>Edit</a>
                    <form action={deleteProduct}>
                      <input type="hidden" name="id" value={p.id} />
                      <button className="btn btn-sm btn-danger" type="submit">Delete</button>
                    </form>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      <Pagination basePath="/products" page={page} hasMore={hasMore} query={q} />
    </>
  );
}
