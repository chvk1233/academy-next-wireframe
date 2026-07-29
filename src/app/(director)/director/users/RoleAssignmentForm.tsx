"use client";

import { useFormStatus } from "react-dom";
import { assignUserRole } from "./actions";
import styles from "./page.module.css";

export default function RoleAssignmentForm({
    userId,
    userName,
}: {
    userId: string;
    userName: string;
}) {
    const selectId = `role-${userId}`;

    return (
        <form action={assignUserRole} className={styles.roleForm}>
            <input type="hidden" name="userId" value={userId} />
            <label htmlFor={selectId}>부여할 역할</label>
            <div className={styles.roleControls}>
                <select
                    id={selectId}
                    name="role"
                    defaultValue=""
                    aria-label={`${userName} 역할 선택`}
                    required
                >
                    <option value="" disabled>
                        역할을 선택하세요
                    </option>
                    <option value="TEACHER">선생님</option>
                    <option value="STAFF">교직원</option>
                    <option value="PARENT">학부모</option>
                    <option value="STUDENT">학생</option>
                </select>
                <AssignButton />
            </div>
        </form>
    );
}

function AssignButton() {
    const { pending } = useFormStatus();

    return (
        <button type="submit" disabled={pending}>
            {pending ? "부여 중…" : "역할 부여"}
        </button>
    );
}
