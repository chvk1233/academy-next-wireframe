import WorkspaceScreen from "@/features/dashboard/WorkspaceScreen";

export default function StudentInboxPage() {
    return (
        <WorkspaceScreen
            eyebrow="MESSAGES"
            title="공지·쪽지"
            description="학원 공지와 선생님이 보낸 메시지를 확인합니다."
        />
    );
}
