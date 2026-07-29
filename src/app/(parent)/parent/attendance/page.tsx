import WorkspaceScreen from "@/features/dashboard/WorkspaceScreen";

export default function ParentAttendancePage() {
    return (
        <WorkspaceScreen
            eyebrow="ATTENDANCE"
            title="출결·수업"
            description="자녀의 등하원 상태와 수업 일정을 확인합니다."
            action="결석 요청"
        />
    );
}
