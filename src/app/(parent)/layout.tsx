import type { ReactNode } from "react";
import MemberShell from "@/components/layout/MemberShell";

export default function ParentLayout({ children }: { children: ReactNode }) {
    return <MemberShell role="parent">{children}</MemberShell>;
}
