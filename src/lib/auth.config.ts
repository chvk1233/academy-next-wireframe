import type { NextAuthConfig } from "next-auth";
import Google from "next-auth/providers/google";
import { prisma } from "@/lib/db";

const authConfig = {
    trustHost: true,
    providers: [
        Google({
            authorization: {
                params: {
                    prompt: "select_account",
                },
            },
        }),
    ],

    session: {
        strategy: "jwt",
    },

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
        async jwt({ token }) {
            const email = token.email?.trim().toLowerCase();

            if (!email) {
                token.userId = undefined;
                token.role = "GUEST";
                token.onboardingCompleted = false;
                return token;
            }

            const dbUser = await prisma.user.findUnique({
                where: {
                    email,
                },
                select: {
                    id: true,
                    role: true,
                    onboardingCompleteAt: true,
                },
            });

            if (!dbUser) {
                token.userId = undefined;
                token.role = "GUEST";
                token.onboardingCompleted = false;
                return token;
            }

            token.userId = dbUser.id;
            token.role = dbUser.role;
            token.onboardingCompleted = dbUser.onboardingCompleteAt !== null;
            return token;
        },
        async session({ session, token }) {
            if (session.user) {
                session.user.id = token.userId ?? "";
                session.user.role = token.role ?? "GUEST";
                session.user.onboardingCompleted =
                    token.onboardingCompleted ?? false;
            }
            return session;
        },
    },
} satisfies NextAuthConfig;

export default authConfig;
