export default function SearchBox({
  action,
  defaultValue,
  placeholder,
}: {
  action: string;
  defaultValue?: string;
  placeholder?: string;
}) {
  return (
    <form action={action} method="get" style={{ display: "flex", gap: 8 }}>
      <input
        name="q"
        defaultValue={defaultValue}
        placeholder={placeholder || "Search…"}
        style={{ maxWidth: 280 }}
      />
      <button className="btn" type="submit">Search</button>
      {defaultValue ? (
        <a className="btn btn-sm" href={action}>Clear</a>
      ) : null}
    </form>
  );
}
