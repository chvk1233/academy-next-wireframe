# A학원 SaaS · Next.js 와이어프레임

`academy-ui-wireframe.html`을 기반으로 새로 구성한 Next.js + TypeScript 프로젝트입니다.

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

- 원장·교사·학부모·학생·게스트 역할 전환
- 역할별 화면 선택 및 사이드 메뉴 연동
- Auth.js 기반 Google OAuth 로그인
- Apple 디자인 토큰 기반의 반응형 UI
- 모바일에서 가로 메뉴와 1열 카드 레이아웃 적용
- React 상태로 화면 전환과 폼 컨트롤 관리

## 주요 파일

- `src/app/page.tsx`: 역할·화면 데이터 및 React UI
- `src/app/login/page.tsx`: Google 로그인 화면
- `src/auth.ts`: Auth.js와 Google 공급자 설정
- `src/app/page.module.css`: Stripe 스타일과 반응형 레이아웃
- `src/app/globals.css`: 전역 타이포그래피와 기본 스타일
- `src/app/layout.tsx`: 한국어 문서 설정과 메타데이터
