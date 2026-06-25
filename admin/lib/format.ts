export function naira(amount: number | null | undefined): string {
  const n = Number(amount || 0);
  return "₦" + n.toLocaleString("en-NG", { maximumFractionDigits: 0 });
}

export function shortDate(iso: string | null | undefined): string {
  if (!iso) return "—";
  const d = new Date(iso);
  return d.toLocaleDateString("en-NG", { year: "numeric", month: "short", day: "numeric" });
}

export function shortId(id: string | null | undefined, len = 8): string {
  if (!id) return "—";
  return id.slice(0, len);
}
