import { requireAdmin } from "@/lib/auth";
import { logout } from "../login/actions";
import AdminShell from "@/components/AdminShell";

export default async function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const { user, role } = await requireAdmin();

  return (
    <AdminShell user={user.email ?? ""} role={role} logout={logout}>
      {children}
    </AdminShell>
  );
}
