"use client";

import type { PermissionKey } from "@/types/roles";

export default function PermissionModal({
    open,
    permissions,
    onClose,
}: {
    open: boolean;
    permissions: Partial<Record<PermissionKey, boolean>>;
    onClose: () => void;
}) {
    if (!open) return null;

    return (
        <div role="presentation" onClick={onClose}>
            <section
                role="dialog"
                aria-modal="true"
                aria-labelledby="permission-title"
                onClick={(event) => event.stopPropagation()}
            >
                <h2 id="permission-title">직원 권한 설정</h2>
                <ul>
                    {Object.entries(permissions).map(([key, enabled]) => (
                        <li key={key}>
                            {key}: {enabled ? "허용" : "차단"}
                        </li>
                    ))}
                </ul>
                <button type="button" onClick={onClose}>
                    닫기
                </button>
            </section>
        </div>
    );
}
