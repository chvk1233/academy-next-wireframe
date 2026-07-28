import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "A학원 SaaS · Apple UI 와이어프레임",
  description: "원장, 교사, 학부모, 학생, 게스트 역할별 학원 운영 UI 와이어프레임",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="ko">
      <body>{children}</body>
    </html>
  );
}
