import { redirect } from "next/navigation";
import { auth } from "@/lib/auth";

export default async function PostLoginPage() {
    const session = await auth();

    // 세션이 없으면 로그인 화면으로 이동
    if (!session?.user) {
        redirect("/login");
    }

    // 가입 완료 사용자는 역할별 화면으로 이동
    switch (session.user.role) {
        case "DIRECTOR":
            redirect("/director/dashboard");
        case "STAFF":
        case "TEACHER":
            redirect("/staff/dashboard");
        case "PARENT":
            redirect("/parent/dashboard");
        case "STUDENT":
            redirect("/student/dashboard");
        case "GUEST":
            redirect("/");
        default:
            redirect("/");
    }
}
