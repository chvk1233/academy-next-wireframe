import { auth } from "@/lib/auth";

export async function GET() {
    const session = await auth();

    if (!session?.user) {
        return Response.json({ error: "UNAUTHORIZED" }, { status: 401 });
    }

    return Response.json({ user: session.user });
}
