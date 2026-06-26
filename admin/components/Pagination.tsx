export default function Pagination({
  basePath,
  page,
  hasMore,
  query,
  params,
}: {
  basePath: string; // path only, no query string
  page: number;
  hasMore: boolean;
  query?: string; // shorthand for ?q=
  params?: Record<string, string | undefined>;
}) {
  const mk = (p: number) => {
    const usp = new URLSearchParams();
    usp.set("page", String(p));
    if (query) usp.set("q", query);
    for (const [k, v] of Object.entries(params || {})) {
      if (v) usp.set(k, v);
    }
    return `${basePath}?${usp.toString()}`;
  };
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
