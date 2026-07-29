import { NextResponse } from "next/server";
import { auth } from "@/lib/auth";

const protectedPrefixes = [
    "/director",
    "/staff",
    "/parent",
    "/student",
];

export default auth((request) => {
    if (process.env.PREVIEW_MODE === "true") {
        return NextResponse.next();
    }

    const protectedRoute = protectedPrefixes.some((prefix) =>
        request.nextUrl.pathname.startsWith(prefix),
    );

    if (protectedRoute && !request.auth?.user) {
        const loginUrl = new URL("/login", request.url);
        loginUrl.searchParams.set("callbackUrl", request.nextUrl.pathname);
        return NextResponse.redirect(loginUrl);
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
