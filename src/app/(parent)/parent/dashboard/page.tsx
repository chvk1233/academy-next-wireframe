import WorkspaceScreen from "@/features/dashboard/WorkspaceScreen";

export default function ParentDashboardPage() {
    return (
        <WorkspaceScreen
            eyebrow="MY CHILD"
            title="자녀 홈"
            description="선택한 자녀의 오늘 일정과 학습 소식을 확인하세요."
        />
    );
}
