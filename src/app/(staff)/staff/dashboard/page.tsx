import WorkspaceScreen from "@/features/dashboard/WorkspaceScreen";

export default function StaffDashboardPage() {
    return (
        <WorkspaceScreen
            eyebrow="STAFF"
            title="내 수업"
            description="오늘 담당 수업과 학생 현황을 확인하세요."
            action="수업 기록"
        />
    );
}
