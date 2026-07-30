"use client";

import { useActionState, useEffect, useRef } from "react";
import { unlinkParentStudent, type ParentLinkState } from "./actions";

const initialState: ParentLinkState = {
    status: "idle",
    message: "",
}

export default function UnlinkParentStudentButton({
    linkId,
    parentName,
    studentName,
}: {
    linkId: string;
    parentName: string;
    studentName: string;
}) {
    const dialogRef = useRef<HTMLDialogElement>(null);
    const [state, formAction, pending] = useActionState(unlinkParentStudent, initialState);

    useEffect(() => {
        if (state.status === "success") {
            dialogRef.current?.close();
        }
    }, [state.status]);
    
    function openDialog() {
        dialogRef.current?.showModal();
    }

    function closeDialog() {
        dialogRef.current?.close();
    }

    return (
        <>
            <button type="button" onClick={openDialog}>
                연결 해제
            </button>
            <dialog ref={dialogRef}>
                <section>
                    <header>
                        <span aria-hidden="true">!</span>
                        <div>
                            <h2>연결을 해제할까요?</h2>
                            <p>
                                해제 후 학부모와 학생은 전용 화면에
                                접근할 수 없게 됩니다.
                            </p>
                        </div>
                    </header>
                    <div>
                        <p>
                            <span>학부모</span>
                            <strong>{parentName}</strong>
                        </p>
                        <p>
                            <span>학생</span>
                            <strong>{studentName}</strong>
                        </p>
                    </div>

                    <form action={formAction}>
                        <input
                            type="hidden"
                            name="linkId"
                            value={linkId}
                        />
                        <label>
                            해제 사유
                            <select
                                name="reason"
                                defaultValue="원장 수동 해제"
                            >
                                <option value="원장 수동 해제">
                                    원장 수동 해제
                                </option>
                                <option value="잘못된 연결">
                                    잘못된 연결
                                </option>
                                <option value="학생 퇴원">
                                    학생 퇴원
                                </option>
                                <option value="보호자 변경">
                                    보호자 변경
                                </option>
                            </select>
                        </label>
                        {state.status === "error" && (
                            <p role="alert">
                                {state.message}
                            </p>
                        )}
                        <div>
                            <button
                                type="button"
                                onClick={closeDialog}
                                disabled={pending}
                            >
                                취소
                            </button>
                            <button type="submit" disabled={pending}>
                                {pending ? "해제하는 중…" : "연결 해제"}
                            </button>
                        </div>
                    </form>
                </section>
            </dialog>
        </>
    );
}