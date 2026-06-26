export default function BarChart({
  data,
  title,
  color = "var(--emerald)",
  format,
}: {
  data: { label: string; value: number }[];
  title: string;
  color?: string;
  format?: (n: number) => string;
}) {
  const max = Math.max(1, ...data.map((d) => d.value));
  return (
    <div className="card">
      <div style={{ fontWeight: 650, marginBottom: 14 }}>{title}</div>
      <div style={{ display: "flex", alignItems: "flex-end", gap: 5, height: 130 }}>
        {data.map((d, i) => (
          <div
            key={i}
            title={`${d.label}: ${format ? format(d.value) : d.value}`}
            style={{ flex: 1, display: "flex", flexDirection: "column", alignItems: "center", gap: 6 }}
          >
            <div
              style={{
                width: "100%",
                height: `${(d.value / max) * 104}px`,
                minHeight: d.value > 0 ? 3 : 0,
                background: color,
                borderRadius: "4px 4px 0 0",
                transition: "height .2s",
              }}
            />
            <span style={{ fontSize: 9, color: "var(--muted)" }}>{d.label}</span>
          </div>
        ))}
      </div>
    </div>
  );
}
