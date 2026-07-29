import { NextResponse } from "next/server";
import { auth } from "@/lib/auth";
import type { AppRole } from "@/types/roles";

const routeRoles: Array<{
    prefix: string;
    roles: AppRole[];
}> = [
    { prefix: "/director", roles: ["DIRECTOR"] },
    { prefix: "/staff", roles: ["STAFF", "TEACHER"] },
    { prefix: "/parent", roles: ["PARENT"] },
    { prefix: "/student", roles: ["STUDENT"] },
];

export default auth((request) => {
    if (process.env.PREVIEW_MODE === "true") {
        return NextResponse.next();
    }

    const pathname = request.nextUrl.pathname;

    const route = routeRoles.find(({ prefix }) => pathname.startsWith(prefix));

    if (!route) return NextResponse.next();

    const user = request.auth?.user;

    // 로그인하지 않은 사용자는 로그인 페이지로 이동
    if (!user) {
        const loginUrl = new URL("/login", request.url);
        loginUrl.searchParams.set(
            "callbackUrl",
            pathname + request.nextUrl.search,
        );
        return NextResponse.redirect(loginUrl);
    }

    // 원장 페이지는 DIRECTOR 권한이 필요
    if (pathname.startsWith("/director") && user.role !== "DIRECTOR") {
        return NextResponse.redirect(new URL("/", request.url));
    }

    if (!route.roles.includes(user.role)) {
        return NextResponse.redirect(new URL("/post-login", request.url));
    }

    return NextResponse.next();
});

export const config = {
    matcher: [
        "/director/:path*",
        "/staff/:path*",
        "/parent/:path*",
        "/student/:path*",
    ],
};
