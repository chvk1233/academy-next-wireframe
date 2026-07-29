import WorkspaceScreen from "@/features/dashboard/WorkspaceScreen";

export default function DirectorParentsPage() {
    return (
        <WorkspaceScreen
            eyebrow="PARENTS"
            title="학부모 관리"
            description="학부모 계정과 자녀 연결 상태를 확인합니다."
            action="자녀 연결"
        />
    );
}
