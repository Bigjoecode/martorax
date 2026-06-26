"use client";

import { usePathname } from "next/navigation";
import Link from "next/link";

const NAV = [
  { href: "/", label: "Dashboard", icon: "▦" },
  { href: "/activity", label: "Activity", icon: "📈" },
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
];

export default function Sidebar({ logout }: { logout: () => void }) {
  const pathname = usePathname();
  return (
    <aside className="sidebar">
      <div className="brand">
        <span className="logo">M</span> MartoraX
      </div>
      {NAV.map((item) => {
        const active = item.href === "/" ? pathname === "/" : pathname.startsWith(item.href);
        return (
          <Link key={item.href} href={item.href} className={`navlink${active ? " active" : ""}`}>
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
  );
}
