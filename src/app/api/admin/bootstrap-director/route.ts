import { auth } from "@/lib/auth";

export async function POST(request: Request) {
    const session = await auth();
    const bootstrapSecret = request.headers.get("x-bootstrap-secret");

    if (
        !process.env.BOOTSTRAP_SECRET ||
        bootstrapSecret !== process.env.BOOTSTRAP_SECRET
    ) {
        return Response.json({ error: "FORBIDDEN" }, { status: 403 });
    }

    if (!session?.user?.email) {
        return Response.json({ error: "UNAUTHORIZED" }, { status: 401 });
    }

    return Response.json(
        {
            error: "DATABASE_NOT_CONNECTED",
            message:
                "Prisma 연결 후 최초 원장 승격 트랜잭션을 이 경로에 구현합니다.",
        },
        { status: 501 },
    );
}
