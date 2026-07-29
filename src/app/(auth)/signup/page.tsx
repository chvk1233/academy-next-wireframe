import Link from "next/link";
import { auth, signIn } from "@/lib/auth";
import SignupFlow from "./SignupFlow";
import styles from "./page.module.css";

export const dynamic = "force-dynamic";

export default async function SignupPage({
    searchParams,
}: {
    searchParams: Promise<{ step?: string; error?: string }>;
}) {
    const params = await searchParams;
    const session = await auth();

    const googleVerified =
        params.step === "details" && Boolean(session?.user?.email);

    async function signUpWithGoogle() {
        "use server";

        await signIn("google", {
            redirectTo: "/signup?step=details",
        });
    }

    return (
        <main className={styles.page}>
            <header className={styles.header}>
                <Link href="/" className={styles.brand} aria-label="A학원 홈">
                    <span className={styles.brandMark}>A</span>
                    <strong>A학원</strong>
                </Link>

                <Link href="/login" className={styles.loginLink}>
                    이미 계정이 있으신가요? <strong>로그인</strong>
                </Link>
            </header>

            <div className={styles.content}>
                <SignupFlow
                    googleVerified={googleVerified}
                    googleSignInAction={signUpWithGoogle}
                />
            </div>
        </main>
    );
}
