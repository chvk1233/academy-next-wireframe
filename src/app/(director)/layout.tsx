import type { ReactNode } from "react";
import AdminShell from "@/components/layout/AdminShell";

export default function DirectorLayout({ children }: { children: ReactNode }) {
    return <AdminShell role="director">{children}</AdminShell>;
}
