import type { ReactNode } from "react";
import MemberShell from "@/components/layout/MemberShell";

export default function GuestLayout({ children }: { children: ReactNode }) {
    return <MemberShell role="guest">{children}</MemberShell>;
}
