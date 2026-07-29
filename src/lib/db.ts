/**
 * Prisma 설치 전 데이터베이스 연결 경계입니다.
 *
 * Prisma Client를 생성한 뒤 이 파일에서 싱글턴 인스턴스를 내보내면
 * Server Action과 Route Handler가 동일한 연결 방식을 사용하게 됩니다.
 */
import { PrismaClient } from "@/generate/prisma/client";
import { PrismaPg } from "@prisma/adapter-pg";

const connectionString = process.env.DATABASE_URL;

if (!connectionString) {
    throw new Error("DATABASE_URL이 설정되지 않았습니다.");
}

const globalForPrisma = globalThis as unknown as {
    prisma: PrismaClient | undefined;
};

export const prisma =
    globalForPrisma.prisma ??
    new PrismaClient({
        adapter: new PrismaPg(connectionString),
    });

if (process.env.NODE_ENV !== "production") globalForPrisma.prisma = prisma;
