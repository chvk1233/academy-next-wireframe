import type { NextAuthConfig } from "next-auth";
import Google from "next-auth/providers/google";
import { prisma } from "@/lib/db";

const authConfig = {
    trustHost: true,
    providers: [Google],

    pages: {
        signIn: "/login",
    },

    callbacks: {
        async signIn({ user, account }) {
            if (
                !user.email ||
                !account ||
                account.provider !== "google" ||
                !account.providerAccountId
            ) {
                return false;
            }

            const email = user.email.trim().toLowerCase();

            const dbUser = await prisma.user.upsert({
                where: {
                    email,
                },
                create: {
                    email,
                    name: user.name?.trim() || email.split("@")[0],
                    imageUrl: user.image,
                    lastLoginAt: new Date(),
                },
                update: {
                    imageUrl: user.image,
                    lastLoginAt: new Date(),
                },
            });

            const accountKey = {
                provider: account.provider,
                providerAccountId: account.providerAccountId,
            };

            const existingAccount = await prisma.oAuthAccount.findUnique({
                where: {
                    provider_providerAccountId: accountKey,
                },
            });

            if (existingAccount && existingAccount.userId !== dbUser.id) {
                return false;
            }

            await prisma.oAuthAccount.upsert({
                where: {
                    provider_providerAccountId: accountKey,
                },
                create: {
                    userId: dbUser.id,
                    type: account.type,
                    provider: account.provider,
                    providerAccountId: account.providerAccountId,
                },
                update: {
                    updatedAt: new Date(),
                },
            });

            // Auth.js에 로그인을 허용한다고 명시
            return true;
        },
    },
} satisfies NextAuthConfig;

export default authConfig;
