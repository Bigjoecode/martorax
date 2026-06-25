import ProductForm from "@/components/ProductForm";
import { createProduct } from "../actions";

export default function NewProductPage() {
  return (
    <>
      <div className="page-head">
        <div>
          <h2 style={{ fontSize: 20, fontWeight: 700 }}>New product</h2>
          <p>Create a listing on behalf of a vendor.</p>
        </div>
      </div>
      <ProductForm action={createProduct} submitLabel="Create product" />
    </>
  );
}
