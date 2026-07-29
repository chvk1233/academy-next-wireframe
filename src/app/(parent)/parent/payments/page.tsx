import WorkspaceScreen from "@/features/dashboard/WorkspaceScreen";

export default function ParentPaymentsPage() {
    return (
        <WorkspaceScreen
            eyebrow="PAYMENTS"
            title="결제"
            description="수강료와 교재비 청구 내역을 확인하고 결제합니다."
            action="결제하기"
        />
    );
}
