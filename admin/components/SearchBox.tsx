export default function SearchBox({
  action,
  defaultValue,
  placeholder,
  hidden,
  clearHref,
}: {
  action: string; // path only
  defaultValue?: string;
  placeholder?: string;
  hidden?: Record<string, string | undefined>;
  clearHref?: string;
}) {
  return (
    <form action={action} method="get" style={{ display: "flex", gap: 8 }}>
      {Object.entries(hidden || {}).map(([k, v]) =>
        v ? <input key={k} type="hidden" name={k} value={v} /> : null
      )}
      <input
        name="q"
        defaultValue={defaultValue}
        placeholder={placeholder || "Search…"}
        style={{ maxWidth: 280 }}
      />
      <button className="btn" type="submit">Search</button>
      {defaultValue ? (
        <a className="btn btn-sm" href={clearHref || action}>Clear</a>
      ) : null}
    </form>
  );
}
