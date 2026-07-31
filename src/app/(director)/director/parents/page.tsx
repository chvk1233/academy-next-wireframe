import styles from "./page.module.css";
import { prisma } from "@/lib/db";
import ParentStudentLinkForm from "./ParentStudentLinkForm";
import UnlinkParentStudentButton from "./UnlinkParentStudentButton";

export const dynamic = "force-dynamic";

export default async function DirectorParentsPage() {
    const [parents, students, activeLinks] = await Promise.all([
        // 학부모 역할을 가진 활성 사용자
        prisma.user.findMany({
            where: {
                role: "PARENT",
                status: "ACTIVE",
            },
            select: {
                id: true,
                name: true,
                email: true,
                phone: true,
                parentLinks: {
                    where: {
                        endedAt: null,
                    },
                    select: {
                        id: true,
                        studentId: true,
                    },
                },
            },
            orderBy: {
                name: "asc",
            },
        }),

        // 학생 역할이며 활성 학부모 연결이 없는 학생
        prisma.student.findMany({
            where: {
                status: "ENROLLED",
                user: {
                    is: {
                        role: "STUDENT",
                        status: "ACTIVE",
                    },
                },
                parentLinks: {
                    none: {
                        endedAt: null,
                    },
                },
            },
            select: {
                id: true,
                name: true,
                schoolName: true,
                grade: true,
                user: {
                    select: {
                        id: true,
                        email: true,
                        phone: true,
                    },
                },
            },
            orderBy: {
                name: "asc",
            },
        }),
        // 현재 활성 연결 조회
        prisma.parentStudentLink.findMany({
            where: {
                endedAt: null,
            },
            select: {
                id: true,
                relationship: true,
                linkedAt: true,
                parent: {
                    select: {
                        id: true,
                        name: true,
                        email: true,
                        phone: true,
                    },
                },
                student: {
                    select: {
                        id: true,
                        name: true,
                        schoolName: true,
                        grade: true,
                        user: {
                            select: {
                                id: true,
                                email: true,
                            },
                        },
                    },
                },
            },
            orderBy: {
                linkedAt: "desc",
            },
        }),
    ]);

    return (
        <section className={styles.page}>
            <header className={styles.heading}>
                <div>
                    <span className={styles.eyebrow}>PARENTS</span>
                    <h1>학부모 관리</h1>
                    <p>학부모 계정과 학생 계정을 연결합니다.</p>
                </div>
                <div className={styles.activeBadge}>
                    <span className={styles.statusDot} aria-hidden="true"/>연결
                    <strong>{activeLinks.length}건</strong>
                </div>
            </header>
            <section
                className={styles.summary}
                aria-label="연결 가능 계정 요약"
            >
                <article className={styles.summaryCard}>
                    <div
                        className={styles.parentSummaryIcon}
                        aria-hidden="true"
                    >
                        P
                    </div>

                    <div className={styles.summaryContent}>
                        <span>연결 가능한 학부모</span>
                        <strong>{parents.length}명</strong>
                        <p>활성 상태인 학부모 계정입니다.</p>
                    </div>
                </article>

                <article className={styles.summaryCard}>
                    <div
                        className={styles.studentSummaryIcon}
                        aria-hidden="true"
                    >
                        S
                    </div>

                    <div className={styles.summaryContent}>
                        <span>연결 가능한 학생</span>
                        <strong>{students.length}명</strong>
                        <p>현재 학부모가 연결되지 않은 학생입니다.</p>
                    </div>
                </article>
            </section>
            <ParentStudentLinkForm parents={parents} students={students} />
            <section>
                <header>
                    <h2>현재 연결된 학부모와 학생</h2>
                    <span>{activeLinks.length}건</span>
                </header>
                {activeLinks.length === 0 ? (
                    <p>연결된 학부모와 학생이 없습니다.</p>
                ) : (
                    <ul>
                        {activeLinks.map((link) => (
                            <li key={link.id}>
                                <div>
                                    <span>학부모</span>
                                    <strong>{link.parent.name}</strong>
                                    <span>{link.parent.email}</span>
                                </div>
                                <div aria-hidden="true">→</div>
                                <div>
                                    <span>학생</span>
                                    <strong>{link.student.name}</strong>
                                    <small>
                                        {link.student.schoolName ?? "학교 미입력"}
                                        {link.student.grade ? ` ${link.student.grade}학년` : ""}
                                    </small>
                                </div>
                                <div>
                                    <span>
                                        {link.relationship ?? "보호자"}
                                    </span>
                                    <time dateTime={link.linkedAt.toISOString()}>
                                        {new Intl.DateTimeFormat("ko-KR", {
                                            timeZone: "Asia/Seoul",
                                            year: "numeric",
                                            month: "long",
                                            day: "numeric",
                                        }). format(link.linkedAt)}
                                    </time>
                                </div>
                                <UnlinkParentStudentButton
                                    linkId={link.id}
                                    parentName={link.parent.name}
                                    studentName={link.student.name}
                                />
                            </li>
                        ))}
                    </ul>
                )}
            </section>
        </section>
    );
}