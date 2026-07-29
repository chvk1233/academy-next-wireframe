import type { DefaultSession } from "next-auth";
import type { AppRole } from "./roles";

declare module "next-auth" {
    interface Session {
        user: {
            id: string;
            role: AppRole;
            onboardingCompleted: boolean;
        } & DefaultSession["user"];
    }
}

declare module "@auth/core/jwt" {
    interface JWT {
        userId?: string;
        role?: AppRole;
        onboardingCompleted?: boolean;
    }
}
