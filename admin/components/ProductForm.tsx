type Product = {
  id?: string;
  vendor_id?: string;
  title?: string;
  description?: string | null;
  price?: number;
  wholesale_price?: number | null;
  stock?: number;
  location?: string | null;
  category?: string | null;
  image_url?: string | null;
};

export default function ProductForm({
  product,
  action,
  submitLabel,
}: {
  product?: Product;
  action: (formData: FormData) => void;
  submitLabel: string;
}) {
  const p = product || {};
  return (
    <form action={action} className="card" style={{ maxWidth: 640, display: "grid", gap: 14 }}>
      {p.id && <input type="hidden" name="id" value={p.id} />}
      {!p.id && (
        <div>
          <label>Vendor ID (a profile id with role vendor)</label>
          <input name="vendor_id" defaultValue={p.vendor_id || ""} required placeholder="uuid…" />
        </div>
      )}
      <div>
        <label>Title</label>
        <input name="title" defaultValue={p.title || ""} required />
      </div>
      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 1fr", gap: 12 }}>
        <div>
          <label>Price (₦)</label>
          <input name="price" type="number" step="0.01" defaultValue={p.price ?? ""} required />
        </div>
        <div>
          <label>Wholesale (₦)</label>
          <input name="wholesale_price" type="number" step="0.01" defaultValue={p.wholesale_price ?? ""} />
        </div>
        <div>
          <label>Stock</label>
          <input name="stock" type="number" defaultValue={p.stock ?? 0} />
        </div>
      </div>
      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 12 }}>
        <div>
          <label>Location</label>
          <input name="location" defaultValue={p.location || "Asaba"} />
        </div>
        <div>
          <label>Category</label>
          <input name="category" defaultValue={p.category || ""} placeholder="e.g. Grocery, Fashion" list="cat-list" />
          <datalist id="cat-list">
            <option value="Grocery" /><option value="Fashion" /><option value="Electronics" />
            <option value="Food" /><option value="Home" /><option value="Health" /><option value="Other" />
          </datalist>
        </div>
      </div>
      <div>
        <label>Image URL</label>
        <input name="image_url" defaultValue={p.image_url || ""} placeholder="https://…" />
      </div>
      <div>
        <label>Description</label>
        <textarea name="description" rows={3} defaultValue={p.description || ""} />
      </div>
      <div className="row-actions">
        <button className="btn btn-primary" type="submit">{submitLabel}</button>
        <a className="btn" href="/products">Cancel</a>
      </div>
    </form>
  );
}
