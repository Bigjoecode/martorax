export default function Pagination({
  basePath,
  page,
  hasMore,
  query,
}: {
  basePath: string;
  page: number;
  hasMore: boolean;
  query?: string;
}) {
  const mk = (p: number) =>
    `${basePath}?page=${p}${query ? `&q=${encodeURIComponent(query)}` : ""}`;
  return (
    <div
      className="row-actions"
      style={{ justifyContent: "flex-end", marginTop: 14, alignItems: "center", gap: 10 }}
    >
      {page > 1 ? (
        <a className="btn btn-sm" href={mk(page - 1)}>← Prev</a>
      ) : (
        <span className="btn btn-sm" style={{ opacity: 0.4 }}>← Prev</span>
      )}
      <span className="mono">Page {page}</span>
      {hasMore ? (
        <a className="btn btn-sm" href={mk(page + 1)}>Next →</a>
      ) : (
        <span className="btn btn-sm" style={{ opacity: 0.4 }}>Next →</span>
      )}
    </div>
  );
}
