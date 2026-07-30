"use client";

import {useActionState, useEffect, useRef} from "react";
import { linkParentStudent, type ParentLinkState} from "./actions";

const initialState: ParentLinkState = {
    status: "idle",
    message: "",
}

type ParentOption = {
    id: string;
    name: string;
    email: string;
    parentLinks: Array<{
        id: string;
        studentId: string;
    }>;
};

type StudentOption = {
    id: string;
    name: string;
    schoolName: string | null;
    grade: string | null;
    user: {
        id: string;
        email: string;
    } | null;
}

export default function ParentStudentLinkForm({
    parents,
    students,
} : {
    parents: ParentOption[];
    students: StudentOption[];
}) {
    const formRef = useRef<HTMLFormElement>(null);
    const canSubmit = parents.length > 0 && students.length > 0;
    const [state, formAction, pending] = useActionState(linkParentStudent, initialState);

    useEffect(() => {
        if (state.status === "success") {
            formRef.current?.reset();
        }
    }, [state.status]);

    return (
        <form ref={formRef} action={formAction}>
            <label>
                학부모
                <select
                    name="parentUserId"
                    defaultValue=""
                    required
                >
                    <option value="" disabled>
                        학부모를 선택해주세요.
                    </option>
                    {parents.map((parent) => (
                        <option key={parent.id} value={parent.id}>
                            {parent.name} ({parent.email})
                        </option>
                    ))}
                </select>
            </label>
            <label>
                학생
                <select
                    name="studentId"
                    defaultValue=""
                    required
                >
                    <option value="" disabled>
                        학생을 선택해주세요.
                    </option>
                    {students.map((student) => (
                        <option key={student.id} value={student.id}>
                            {student.name}
                            {student.schoolName
                                ? `${student.schoolName}`
                                : ""}
                            {student.grade
                                ? ` ${student.grade}학년`
                                : ""}
                        </option>
                    ))}
                </select>
            </label>
            <label>
                학생과의 관계
                <select
                    name="relationship"
                    defaultValue="보호자"
                >
                    <option value="어머니">어머니</option>
                    <option value="아버지">아버지</option>
                    <option value="보호자">보호자</option>
                    <option value="조부모">조부모</option>
                </select>
            </label>
            {state.message && (
                <p role={state.status === "error" ? "alert" : "status"} data-status={state.status}>
                    {state.message}
                </p>
            )}
            <button type="submit" disabled={!canSubmit || pending}>
                {pending ? "연결중..." : "학부모 연결"}
            </button>
        </form>
    );
}