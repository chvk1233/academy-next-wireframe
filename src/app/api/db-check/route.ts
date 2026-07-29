import { prisma } from "@/lib/db";
import { NextResponse } from "next/server";

export async function GET() {
    try {
        const userCount = await prisma.user.count();

        return NextResponse.json({
            success: true,
            message: "데이터베이스 연결에 성공했습니다.",
            userCount,
        });
    } catch (error) {
        console.error("데이터베이스 연결 오류", error);

        return NextResponse.json(
            {
                success: false,
                message: "데이터베이스 연결 오류가 발생했습니다.",
            },
            { status: 500 },
        );
    }
}
