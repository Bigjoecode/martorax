"use client";

import { useState } from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";

const NAV = [
  { href: "/", label: "Dashboard", icon: "▦" },
  { href: "/analytics", label: "Analytics", icon: "📊" },
  { href: "/activity", label: "Activity", icon: "📈" },
  { href: "/map", label: "Rider Map", icon: "🗺️" },
  { href: "/users", label: "Users", icon: "◉" },
  { href: "/kyc", label: "KYC Review", icon: "🪪" },
  { href: "/products", label: "Products", icon: "▤" },
  { href: "/orders", label: "Orders", icon: "🛒" },
  { href: "/bookings", label: "Bookings", icon: "📅" },
  { href: "/escrow", label: "Escrow (SafePay)", icon: "🔒" },
  { href: "/disputes", label: "Disputes", icon: "⚖" },
  { href: "/payouts", label: "Payouts", icon: "💸" },
  { href: "/riders", label: "Riders", icon: "🛵" },
  { href: "/notifications", label: "Notifications", icon: "🔔" },
  { href: "/messages", label: "Messages", icon: "💬" },
  { href: "/audit", label: "Audit Log", icon: "🧾" },
];

export default function AdminShell({
  user,
  role,
  logout,
  children,
}: {
  user: string;
  role: string;
  logout: () => void;
  children: React.ReactNode;
}) {
  const pathname = usePathname();
  const [open, setOpen] = useState(false);

  return (
    <div className="shell">
      {open && <div className="drawer-backdrop" onClick={() => setOpen(false)} />}
      <aside className={`sidebar${open ? " open" : ""}`}>
        <div className="brand">
          <span className="logo">M</span> MartoraX
        </div>
        {NAV.map((item) => {
          const active = item.href === "/" ? pathname === "/" : pathname.startsWith(item.href);
          return (
            <Link
              key={item.href}
              href={item.href}
              className={`navlink${active ? " active" : ""}`}
              onClick={() => setOpen(false)}
            >
              <span style={{ width: 18, textAlign: "center" }}>{item.icon}</span>
              {item.label}
            </Link>
          );
        })}
        <div className="nav-spacer" />
        <form action={logout}>
          <button className="navlink" style={{ width: "100%", border: "none", background: "none", cursor: "pointer" }}>
            <span style={{ width: 18, textAlign: "center" }}>⎋</span> Sign out
          </button>
        </form>
      </aside>

      <div className="main">
        <header className="topbar">
          <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
            <button className="hamburger" onClick={() => setOpen(true)} aria-label="Open menu">☰</button>
            <h1>Control Panel</h1>
          </div>
          <span className="mono" style={{ display: "flex", gap: 8, alignItems: "center" }}>
            <span className={`badge ${role === "super" ? "released" : "role"}`}>{role === "super" ? "super-admin" : "support"}</span>
            <span className="topbar-email">{user}</span>
          </span>
        </header>
        <main className="content">{children}</main>
      </div>
    </div>
  );
}
