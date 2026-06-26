"use client";

import "leaflet/dist/leaflet.css";
import { MapContainer, TileLayer, CircleMarker, Popup } from "react-leaflet";

export type Pin = {
  riderId: string;
  name: string;
  lat: number;
  lng: number;
  orderId?: string;
  updatedAt?: string;
};

export default function RiderMapInner({ pins }: { pins: Pin[] }) {
  const center: [number, number] =
    pins.length > 0 ? [pins[0].lat, pins[0].lng] : [6.2054, 6.7291]; // Asaba

  return (
    <MapContainer
      center={center}
      zoom={13}
      style={{ height: 560, width: "100%", borderRadius: 12 }}
      scrollWheelZoom
    >
      <TileLayer
        attribution='&copy; OpenStreetMap contributors'
        url="https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png"
      />
      {pins.map((p) => (
        <CircleMarker
          key={p.riderId}
          center={[p.lat, p.lng]}
          radius={9}
          pathOptions={{ color: "#22c55e", fillColor: "#059669", fillOpacity: 0.9 }}
        >
          <Popup>
            <strong>{p.name}</strong>
            <br />
            Rider {p.riderId.slice(0, 8)}
            {p.orderId ? (
              <>
                <br />
                Order {p.orderId.slice(0, 8)}
              </>
            ) : null}
            {p.updatedAt ? (
              <>
                <br />
                {new Date(p.updatedAt).toLocaleString()}
              </>
            ) : null}
          </Popup>
        </CircleMarker>
      ))}
    </MapContainer>
  );
}
