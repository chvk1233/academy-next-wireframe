import Link from "next/link";
import type { ReactNode } from "react";
import { roleNavigation } from "@/lib/dummy-data";
import type { RolePrefix } from "@/types/roles";
import NavLink from "./NavLink";
import styles from "./Shells.module.css";

export default function AdminShell({
    role,
    children,
}: {
    role: Extract<RolePrefix, "director" | "staff">;
    children: ReactNode;
}) {
    const roleLabel = role === "director" ? "원장" : "교직원";

    return (
        <div className={styles.adminPage}>
            <header className={styles.adminHeader}>
                <Link href="/" className={styles.brand}>
                    <span>A</span>
                    <div>
                        <strong>A학원</strong>
                        <small>{roleLabel} 관리</small>
                    </div>
                </Link>
                <div className={styles.headerTools}>
                    <label className={styles.search}>
                        <span aria-hidden="true">⌕</span>
                        <input
                            type="search"
                            placeholder="학생 검색"
                            aria-label="학생 검색"
                        />
                    </label>
                    <Link href="/login" className={styles.sessionLink}>
                        로그인
                    </Link>
                </div>
            </header>
            <div className={styles.adminBody}>
                <aside className={styles.sidebar}>
                    <nav aria-label={`${roleLabel} 메뉴`}>
                        {roleNavigation[role].map((item) => (
                            <NavLink item={item} key={item.href} />
                        ))}
                    </nav>
                </aside>
                <main className={styles.adminContent}>{children}</main>
            </div>
        </div>
    );
}
