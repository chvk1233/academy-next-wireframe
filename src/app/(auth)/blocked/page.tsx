import Link from "next/link";

export default function BlockedPage() {
    return (
        <main
            style={{
                minHeight: "100vh",
                display: "grid",
                placeItems: "center",
                padding: 24,
                textAlign: "center",
            }}
        >
            <section>
                <p>ACCOUNT NOTICE</p>
                <h1>현재 계정으로 접근할 수 없습니다.</h1>
                <p>계정 상태 또는 학원 등록 정보를 확인해 주세요.</p>
                <Link href="/">학원 홈으로 돌아가기</Link>
            </section>
        </main>
    );
}
