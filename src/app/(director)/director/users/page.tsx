import WorkspaceScreen from "@/features/dashboard/WorkspaceScreen";

export default function DirectorUsersPage() {
    return (
        <WorkspaceScreen
            eyebrow="NEW USERS"
            title="가입 사용자"
            description="Google 인증을 마친 게스트 계정에 역할을 부여합니다."
            action="역할 부여"
        />
    );
}
