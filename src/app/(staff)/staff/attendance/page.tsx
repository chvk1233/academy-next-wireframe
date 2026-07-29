import WorkspaceScreen from "@/features/dashboard/WorkspaceScreen";

export default function StaffAttendancePage() {
    return (
        <WorkspaceScreen
            eyebrow="ATTENDANCE"
            title="출석 체크"
            description="등원, 지각, 결석과 하원 상태를 기록합니다."
            action="출석 저장"
        />
    );
}
