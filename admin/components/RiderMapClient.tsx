"use client";

import dynamic from "next/dynamic";
import type { Pin } from "./RiderMapInner";

// Leaflet touches `window`, so load the map with SSR disabled.
const RiderMapInner = dynamic(() => import("./RiderMapInner"), {
  ssr: false,
  loading: () => (
    <div style={{ height: 560, display: "grid", placeItems: "center", color: "var(--muted)" }}>
      Loading map…
    </div>
  ),
});

export default function RiderMapClient({ pins }: { pins: Pin[] }) {
  return <RiderMapInner pins={pins} />;
}
