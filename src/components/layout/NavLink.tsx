"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import type { NavItem } from "@/types/roles";
import styles from "./Shells.module.css";

export default function NavLink({
    item,
    compact = false,
}: {
    item: NavItem;
    compact?: boolean;
}) {
    const pathname = usePathname();
    const active =
        pathname === item.href || pathname.startsWith(`${item.href}/`);

    return (
        <Link
            href={item.href}
            className={active ? styles.navActive : styles.navLink}
            aria-current={active ? "page" : undefined}
            data-compact={compact || undefined}
        >
            <span aria-hidden="true">{item.icon}</span>
            <strong>{item.label}</strong>
        </Link>
    );
}
