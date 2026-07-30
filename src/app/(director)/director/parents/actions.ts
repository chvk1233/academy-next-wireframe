"use server";

import { revalidatePath } from "next/cache";
import { auth } from "@/lib/auth";
import { prisma } from "@/lib/db";

export type ParentLinkState = {
    status: "idle" | "success" | "error";
    message: string;
}

export async function linkParentStudent(_prevState: ParentLinkState, formData: FormData) : Promise<ParentLinkState> {
    try {
        const session = await auth();

        if (!session?.user || session.user.role !== "DIRECTOR") {
            return {
                status: "error",
                message: "권한이 없습니다."
            }
        }

        const parentUserId = formData.get("parentUserId");
        const studentId = formData.get("studentId");
        const relationshipValue = formData.get("relationshipValue");

        if (typeof parentUserId !== "string" || !parentUserId) {
            return {
                status: "error",
                message: "학부모를 선택해주세요."
            }
        }

        if (typeof studentId !== "string" || !studentId) {
            return {
                status: "error",
                message: "학생을 선택해주세요."
            }
        }

        const relationship = 
            typeof relationshipValue === "string"
            ? relationshipValue.trim()
            : "";

        await prisma.$transaction(async (tx) => {
            const parent = await tx.user.findFirst({
                where: {
                    id: parentUserId,
                    role: "PARENT",
                    status: "ACTIVE",
                },
                select: {
                    id: true,
                }
            });

            if (!parent) {
                return {
                    status: "error",
                    message: "연결할 수 없는 학부모입니다."
                }
            }

            const student = await tx.student.findFirst({
                where: {
                    id: studentId,
                    status: "ENROLLED",
                    user: {
                        is: {
                            role: "STUDENT",
                            status: "ACTIVE",
                        }
                    }
                },
                select: {
                    id: true,
                }
            });
            if (!student) {
                return {
                    status: "error",
                    message: "연결할 수 없는 학생입니다."
                }
            }

            const activeLink = await tx.parentStudentLink.findFirst({
                where: {
                    studentId: student.id,
                    endedAt: null,
                },
                select: {
                    id: true, 
                },
            });

            if (activeLink) {
                return {
                    status: "error",
                    message: "이미 학부모가 연결된 학생입니다."
                }
            }

            await tx.parentStudentLink.create({
                data: {
                    parentUserId: parent.id,
                    studentId: student.id,
                    relationship: relationship || null,
                    linkedBy: session.user.id,
                }
            })
        })

        revalidatePath("/director/parents");

        return {
            status: "success",
            message: "학부모와 학생이 성공적으로 연결되었습니다."
        }
    } catch (error) {
        console.error(error);
        return {
            status: "error",
            message: 
                error instanceof Error
                ? error.message
                : "알 수 없는 오류가 발생했습니다."
        }
    }
}
export async function unlinkParentStudent(_prevState: ParentLinkState, formData: FormData) : Promise<ParentLinkState> {
    try {
        const session = await auth();

        if (!session?.user || session.user.role !== "DIRECTOR") {
            return {
                status: "error",
                message: "권한이 없습니다."
            }
        }
        const linkId = formData.get("linkId");
        const reasonValue = formData.get("reason");

        if (typeof linkId !== "string" || !linkId) {
            return {
                status: "error",
                message: "연결을 해제할 수 없습니다."
            }
        }

        const reason =
            typeof reasonValue === "string"
                ? reasonValue.trim()
                : "원장 수동 해제";

        await prisma.$transaction(async (tx) => {
            const link = await tx.parentStudentLink.findFirst({
                where: {
                    id: linkId,
                    endedAt: null,
                },
                select: {
                    id: true,
                    parentUserId: true,
                    student: {
                        select: {
                            userId: true,
                        },
                    },
                },
            });

            if (!link) {
                throw new Error("이미 해제됐거나 존재하지 않는 연결입니다.");
            }

            await tx.parentStudentLink.update({
                where: {
                    id: link.id,
                },
                data: {
                    endedAt: new Date(),
                    endedBy: session.user.id,
                    endReason: reason || "원장 수동 해제",
                },
            });

            // 학부모에게 다른 활성 자녀 연결이 있는지 확인
            const remainingParentLinks =
                await tx.parentStudentLink.count({
                    where: {
                        parentUserId: link.parentUserId,
                        endedAt: null,
                    },
                });

            // 연결된 자녀가 더 없다면 학부모를 GUEST로 변경
            if (remainingParentLinks === 0) {
                await tx.user.updateMany({
                    where: {
                        id: link.parentUserId,
                        role: "PARENT",
                    },
                    data: {
                        role: "GUEST",
                    },
                });
            }

            // 학생은 한 명의 학부모만 지원하므로 GUEST로 변경
            if (link.student.userId) {
                await tx.user.updateMany({
                    where: {
                        id: link.student.userId,
                        role: "STUDENT",
                    },
                    data: {
                        role: "GUEST",
                    },
                });
            }
        });
        revalidatePath("/director/parents");
        return {
            status: "success",
            message: "학부모와 학생의 연결이 성공적으로 해제되었습니다."
        }
    } catch (error) {
        console.error(error);
        return {
            status: "error",
            message: 
                error instanceof Error
                ? error.message
                : "알 수 없는 오류가 발생했습니다."
        }
    }
}