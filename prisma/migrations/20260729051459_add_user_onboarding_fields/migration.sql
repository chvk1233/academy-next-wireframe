-- AlterTable
ALTER TABLE "users" ADD COLUMN     "grade" TEXT,
ADD COLUMN     "onboarding_complete_at" TIMESTAMPTZ(6),
ADD COLUMN     "school_name" TEXT;
