"use server";

import { revalidatePath } from "next/cache";
import { auth } from "@/lib/auth";
import { prisma } from "@/lib/db";

const assignableRoles = ["TEACHER", "STAFF", "PARENT", "STUDENT"] as const;

type AssignableRole = (typeof assignableRoles)[number];

export async function assignUserRole(formData: FormData) {
    const session = await auth();

    // 원장만 역할을 부여할 수 있음
    if (!session?.user || session.user.role !== "DIRECTOR") {
        throw new Error("역할을 부여할 권한이 없습니다.");
    }

    const userId = formData.get("userId");
    const requestedRole = formData.get("role");

    if (typeof userId !== "string" || !userId) {
        throw new Error("사용자 정보가 올바르지 않습니다.");
    }

    if (
        typeof requestedRole !== "string" ||
        !assignableRoles.includes(requestedRole as AssignableRole)
    ) {
        throw new Error("부여할 수 없는 역할입니다.");
    }

    await prisma.$transaction(async (tx) => {
        const user = await tx.user.findFirst({
            where: {
                id: userId,
                role: "GUEST",
                status: "ACTIVE",
            },
            select: {
                id: true,
                name: true,
                phone: true,
                schoolName: true,
                grade: true,
            },
        });
    
        if (!user) {
            throw new Error("역할을 부여할 수 없는 사용자입니다.");
        }
    
        // 학생 역할이면 Student 프로필도 함께 생성
        if (requestedRole === "STUDENT") {
            await tx.student.upsert({
                where: {
                    userId: user.id,
                },
                create: {
                    userId: user.id,
                    name: user.name,
                    phone: user.phone,
                    schoolName: user.schoolName,
                    grade: user.grade,
                },
                update: {
                    name: user.name,
                    phone: user.phone,
                    schoolName: user.schoolName,
                    grade: user.grade,
                },
            });
        }
    
        await tx.user.update({
            where: {
                id: user.id,
            },
            data: {
                role: requestedRole as AssignableRole,
            },
        });
    });
    revalidatePath("/director/users")
}
