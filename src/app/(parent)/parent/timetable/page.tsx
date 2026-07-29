import WorkspaceScreen from "@/features/dashboard/WorkspaceScreen";

export default function ParentTimetablePage() {
    return (
        <WorkspaceScreen
            eyebrow="CHILD TIMETABLE"
            title="자녀 시간표"
            description="선택한 자녀의 수업 시간과 강의실을 확인합니다."
        />
    );
}
