import WorkspaceScreen from "@/features/dashboard/WorkspaceScreen";

export default function GuestInquiryPage() {
    return (
        <WorkspaceScreen
            eyebrow="CONTACT"
            title="상담 문의"
            description="희망 과목과 상담 시간을 남겨주시면 학원에서 연락드리겠습니다."
            action="문의 작성"
            compact
        />
    );
}
