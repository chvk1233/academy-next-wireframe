import type { ReactNode } from "react";
import styles from "./StatusChip.module.css";

export default function StatusChip({
    tone = "neutral",
    children,
}: {
    tone?: "neutral" | "success" | "warning" | "danger";
    children: ReactNode;
}) {
    return (
        <span className={styles.chip} data-tone={tone}>
            {children}
        </span>
    );
}
