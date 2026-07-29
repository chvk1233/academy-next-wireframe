import Link from "next/link";

export default function SessionActions() {
    return (
        <nav aria-label="계정 메뉴">
            <Link href="/login">로그인</Link>
            <Link href="/signup">회원가입</Link>
        </nav>
    );
}
