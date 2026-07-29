import WorkspaceScreen from "@/features/dashboard/WorkspaceScreen";

export default function DirectorDashboardPage() {
    return (
        <WorkspaceScreen
            eyebrow="DIRECTOR"
            title="운영 대시보드"
            description="오늘의 학원 운영 현황과 확인할 업무를 살펴보세요."
            action="운영 리포트"
        />
    );
}
