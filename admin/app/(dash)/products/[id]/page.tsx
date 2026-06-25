import { notFound } from "next/navigation";
import { createAdminClient } from "@/lib/supabase/admin";
import { shortId } from "@/lib/format";
import ProductForm from "@/components/ProductForm";
import { updateProduct } from "../actions";

export const dynamic = "force-dynamic";

export default async function EditProductPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const db = createAdminClient();
  const { data } = await db
    .from("products")
    .select("id, vendor_id, title, description, price, wholesale_price, stock, location, image_url")
    .eq("id", id)
    .maybeSingle();

  if (!data) notFound();

  return (
    <>
      <div className="page-head">
        <div>
          <h2 style={{ fontSize: 20, fontWeight: 700 }}>Edit product</h2>
          <p className="mono">{shortId(data.id)} · vendor {shortId(data.vendor_id)}</p>
        </div>
      </div>
      <ProductForm product={data} action={updateProduct} submitLabel="Save changes" />
    </>
  );
}
