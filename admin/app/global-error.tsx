"use client";

export default function GlobalError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  return (
    <html lang="en">
      <body style={{ background: "#0d1b2a", color: "#e8eef5", fontFamily: "system-ui, sans-serif", display: "grid", placeItems: "center", minHeight: "100vh", margin: 0 }}>
        <div style={{ maxWidth: 520, padding: 24, textAlign: "center" }}>
          <h2 style={{ marginBottom: 12 }}>Something went wrong</h2>
          <p style={{ color: "#94a3b8", marginBottom: 16 }}>{error.message || "Unknown error"}</p>
          {error.digest && <p style={{ color: "#64748b", fontSize: 12, marginBottom: 16 }}>digest: {error.digest}</p>}
          <button onClick={() => reset()} style={{ padding: "10px 18px", borderRadius: 9, border: "none", background: "#22c55e", color: "#04121f", fontWeight: 700, cursor: "pointer" }}>
            Try again
          </button>
        </div>
      </body>
    </html>
  );
}
