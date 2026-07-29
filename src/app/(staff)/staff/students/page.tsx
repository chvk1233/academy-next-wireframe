import WorkspaceScreen from "@/features/dashboard/WorkspaceScreen";

export default function StaffStudentsPage() {
    return (
        <WorkspaceScreen
            eyebrow="MY STUDENTS"
            title="담당 학생"
            description="담당 학생의 출결과 최근 학습 기록을 확인합니다."
            action="기록 작성"
        />
    );
}
