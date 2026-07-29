import type { ReactNode } from "react";
import MemberShell from "@/components/layout/MemberShell";

export default function StudentLayout({ children }: { children: ReactNode }) {
    return <MemberShell role="student">{children}</MemberShell>;
}
