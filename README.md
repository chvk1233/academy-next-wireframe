# A학원 SaaS · Next.js

학원 SaaS 폴더 구조 V3를 기준으로 구성한 단일 Next.js 풀스택 프로젝트입니다.

## 실행

```bash
npm install
npm run dev
```

브라우저에서 `http://localhost:3000`을 열면 됩니다.

## Google 로그인 설정

1. Google Cloud Console에서 OAuth 클라이언트 유형을 **웹 애플리케이션**으로 생성합니다.
2. 승인된 리디렉션 URI에 `http://localhost:3000/api/auth/callback/google`을 등록합니다.
3. `.env.example`을 `.env.local`로 복사하고 Google 클라이언트 ID와 보안 비밀을 입력합니다.
4. `npx auth secret`으로 `AUTH_SECRET`을 생성한 뒤 개발 서버를 다시 실행합니다.

`.env.local`은 저장소에 커밋하지 않습니다. 배포 환경에서는 실제 도메인의
`https://도메인/api/auth/callback/google`도 Google Cloud Console에 등록해야 합니다.

## 주요 기능

- `/director`, `/staff`, `/parent`, `/student`, `/guest` 역할별 라우트
- 교직원용 `AdminShell`, 회원용 `MemberShell`
- Auth.js 기반 Google OAuth 로그인
- Google 인증 후 추가 정보를 입력하는 회원가입 흐름
- Apple 디자인 토큰 기반의 반응형 UI
- PostgreSQL 초기 SQL 및 Prisma 연결 스키마
- `/preview`에서 기존 전체 역할 와이어프레임 제공

## 주요 구조

```text
prisma/                     PostgreSQL·Prisma 스키마
scripts/                    운영 스크립트
src/app/(auth)/             로그인·회원가입·차단
src/app/(director)/         원장 라우트
src/app/(staff)/            교직원 라우트
src/app/(parent)/           학부모 라우트
src/app/(student)/          학생 라우트
src/app/(guest)/            게스트 라우트
src/components/layout/      AdminShell·MemberShell
src/features/               화면 단위 기능
src/lib/                    인증·DB·권한·미리보기 데이터
src/types/                  공통 역할·권한 타입
```

Next.js 16에서는 `middleware.ts`가 폐기되어 동일한 역할을 하는
`src/proxy.ts`를 사용합니다.

## 데이터베이스

```bash
docker compose up -d
psql "$DATABASE_URL" -f prisma/sql/schema.sql
```

`prisma/schema.prisma`는 인증 및 학부모·학생 연결의 핵심 모델부터 정의되어
있습니다. 전체 MVP 테이블 원본은 `prisma/sql/schema.sql`에 있습니다.
