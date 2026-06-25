import { requireAdmin } from "@/lib/auth";
import { logout } from "../login/actions";
import Sidebar from "@/components/Sidebar";

export default async function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const user = await requireAdmin();

  return (
    <div className="shell">
      <Sidebar logout={logout} />
      <div className="main">
        <header className="topbar">
          <h1>Control Panel</h1>
          <span className="mono">{user.email}</span>
        </header>
        <main className="content">{children}</main>
      </div>
    </div>
  );
}
