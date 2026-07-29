import type { ReactNode } from "react";
import AdminShell from "@/components/layout/AdminShell";

export default function StaffLayout({ children }: { children: ReactNode }) {
    return <AdminShell role="staff">{children}</AdminShell>;
}
