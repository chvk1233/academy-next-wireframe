import WorkspaceScreen from "@/features/dashboard/WorkspaceScreen";

export default function StaffCounselingPage() {
    return (
        <WorkspaceScreen
            eyebrow="COUNSELING"
            title="상담 관리"
            description="학부모 상담 요청과 진행 기록을 관리합니다."
            action="상담 등록"
        />
    );
}
