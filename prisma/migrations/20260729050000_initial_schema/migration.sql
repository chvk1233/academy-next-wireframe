-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "public";

-- CreateEnum
CREATE TYPE "user_role" AS ENUM ('DIRECTOR', 'TEACHER', 'STAFF', 'PARENT', 'STUDENT', 'GUEST');

-- CreateEnum
CREATE TYPE "user_status" AS ENUM ('ACTIVE', 'BLOCKED', 'WITHDRAWN');

-- CreateEnum
CREATE TYPE "student_status" AS ENUM ('ENROLLED', 'PAUSED', 'WITHDRAWN');

-- CreateEnum
CREATE TYPE "enrollment_status" AS ENUM ('ACTIVE', 'COMPLETED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "class_session_status" AS ENUM ('SCHEDULED', 'COMPLETED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "attendance_status" AS ENUM ('PRESENT', 'LATE', 'ABSENT', 'EXCUSED', 'EARLY_LEAVE');

-- CreateEnum
CREATE TYPE "learning_record_type" AS ENUM ('CLASS_NOTE', 'HOMEWORK', 'LIFE_RECORD');

-- CreateEnum
CREATE TYPE "wrong_note_status" AS ENUM ('OPEN', 'REVIEWED', 'MASTERED');

-- CreateEnum
CREATE TYPE "ai_report_status" AS ENUM ('UNWRITTEN', 'DRAFTING', 'PENDING_APPROVAL', 'REJECTED', 'SENT', 'FAILED');

-- CreateEnum
CREATE TYPE "churn_case_status" AS ENUM ('DETECTED', 'COUNSELING', 'IMPROVED', 'WITHDRAWN');

-- CreateEnum
CREATE TYPE "churn_signal_type" AS ENUM ('ATTENDANCE_DROP', 'SCORE_DROP', 'CONSECUTIVE_ABSENCE', 'UNPAID_DAYS');

-- CreateEnum
CREATE TYPE "invoice_status" AS ENUM ('DRAFT', 'ISSUED', 'PAID', 'OVERDUE', 'CANCELLED');

-- CreateEnum
CREATE TYPE "payment_status" AS ENUM ('PENDING', 'SUCCEEDED', 'FAILED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "push_delivery_status" AS ENUM ('PENDING', 'SENT', 'FAILED');

-- CreateEnum
CREATE TYPE "news_kind" AS ENUM ('NOTICE', 'BANNER');

-- CreateEnum
CREATE TYPE "news_category" AS ENUM ('PARENT_ADMISSION', 'PARENT_NOTICE', 'STUDENT_YOUTH', 'GENERAL');

-- CreateEnum
CREATE TYPE "news_audience" AS ENUM ('PARENT', 'STUDENT', 'ALL');

-- CreateEnum
CREATE TYPE "inquiry_status" AS ENUM ('NEW', 'IN_PROGRESS', 'DONE', 'SPAM');

-- CreateTable
CREATE TABLE "users" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "email" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "phone" TEXT,
    "address" TEXT,
    "image_url" TEXT,
    "role" "user_role" NOT NULL DEFAULT 'GUEST',
    "status" "user_status" NOT NULL DEFAULT 'ACTIVE',
    "email_verified_at" TIMESTAMPTZ(6),
    "last_login_at" TIMESTAMPTZ(6),
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "oauth_accounts" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "type" TEXT NOT NULL DEFAULT 'oauth',
    "provider" TEXT NOT NULL,
    "provider_account_id" TEXT NOT NULL,
    "refresh_token" TEXT,
    "access_token" TEXT,
    "expires_at" INTEGER,
    "token_type" TEXT,
    "scope" TEXT,
    "id_token" TEXT,
    "session_state" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "oauth_accounts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "permission_grants" (
    "user_id" UUID NOT NULL,
    "view_all_students" BOOLEAN NOT NULL DEFAULT false,
    "view_parent_contact" BOOLEAN NOT NULL DEFAULT false,
    "edit_life_counseling" BOOLEAN NOT NULL DEFAULT false,
    "write_ai_report" BOOLEAN NOT NULL DEFAULT false,
    "ai_direct_send" BOOLEAN NOT NULL DEFAULT false,
    "own_class_attendance_grade" BOOLEAN NOT NULL DEFAULT false,
    "other_teacher_attendance_grade" BOOLEAN NOT NULL DEFAULT false,
    "send_message" BOOLEAN NOT NULL DEFAULT false,
    "billing" BOOLEAN NOT NULL DEFAULT false,
    "link_parent_student" BOOLEAN NOT NULL DEFAULT false,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "permission_grants_pkey" PRIMARY KEY ("user_id")
);

-- CreateTable
CREATE TABLE "students" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID,
    "name" TEXT NOT NULL,
    "birth_date" DATE,
    "school_name" TEXT,
    "grade" TEXT,
    "phone" TEXT,
    "status" "student_status" NOT NULL DEFAULT 'ENROLLED',
    "enrolled_at" DATE NOT NULL DEFAULT CURRENT_DATE,
    "withdrawn_at" TIMESTAMPTZ(6),
    "view_only_until" TIMESTAMPTZ(6),
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "students_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "parent_student_links" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "parent_user_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "relationship" TEXT,
    "linked_by" UUID,
    "linked_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ended_at" TIMESTAMPTZ(6),
    "ended_by" UUID,
    "end_reason" TEXT,

    CONSTRAINT "parent_student_links_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "classes" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "name" TEXT NOT NULL,
    "subject" TEXT NOT NULL,
    "teacher_user_id" UUID,
    "schedule" JSONB NOT NULL DEFAULT '{}',
    "active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "classes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "class_enrollments" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "class_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "status" "enrollment_status" NOT NULL DEFAULT 'ACTIVE',
    "enrolled_at" DATE NOT NULL DEFAULT CURRENT_DATE,
    "ended_at" DATE,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "class_enrollments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "class_sessions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "class_id" UUID NOT NULL,
    "starts_at" TIMESTAMPTZ(6) NOT NULL,
    "ends_at" TIMESTAMPTZ(6) NOT NULL,
    "classroom" TEXT,
    "status" "class_session_status" NOT NULL DEFAULT 'SCHEDULED',
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "class_sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "attendance_records" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "student_id" UUID NOT NULL,
    "session_id" UUID NOT NULL,
    "status" "attendance_status" NOT NULL DEFAULT 'PRESENT',
    "check_in_at" TIMESTAMPTZ(6),
    "check_out_at" TIMESTAMPTZ(6),
    "note" TEXT,
    "updated_by" UUID,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "attendance_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "absence_requests" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "student_id" UUID NOT NULL,
    "session_id" UUID NOT NULL,
    "requested_by" UUID NOT NULL,
    "reason" TEXT NOT NULL,
    "requested_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "cancelled_at" TIMESTAMPTZ(6),

    CONSTRAINT "absence_requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "learning_records" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "student_id" UUID NOT NULL,
    "class_id" UUID,
    "author_user_id" UUID NOT NULL,
    "type" "learning_record_type" NOT NULL,
    "title" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "record_date" DATE NOT NULL DEFAULT CURRENT_DATE,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "learning_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "grade_records" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "student_id" UUID NOT NULL,
    "class_id" UUID,
    "created_by" UUID NOT NULL,
    "title" TEXT NOT NULL,
    "subject" TEXT NOT NULL,
    "score" DECIMAL(7,2) NOT NULL,
    "max_score" DECIMAL(7,2) NOT NULL,
    "assessed_at" DATE NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "grade_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "wrong_notes" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "student_id" UUID NOT NULL,
    "grade_record_id" UUID,
    "class_id" UUID,
    "author_user_id" UUID NOT NULL,
    "question_no" TEXT,
    "question_text" TEXT,
    "student_answer" TEXT,
    "correct_answer" TEXT,
    "explanation" TEXT,
    "status" "wrong_note_status" NOT NULL DEFAULT 'OPEN',
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "wrong_notes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "wrong_note_images" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "wrong_note_id" UUID NOT NULL,
    "url" TEXT NOT NULL,
    "storage_key" TEXT NOT NULL,
    "mime_type" TEXT,
    "sort_order" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "wrong_note_images_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "counseling_memos" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "student_id" UUID NOT NULL,
    "author_user_id" UUID NOT NULL,
    "content" TEXT NOT NULL,
    "counseled_at" TIMESTAMPTZ(6) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "counseling_memos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ai_reports" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "student_id" UUID NOT NULL,
    "author_user_id" UUID NOT NULL,
    "approver_user_id" UUID,
    "status" "ai_report_status" NOT NULL DEFAULT 'UNWRITTEN',
    "period_start" DATE NOT NULL,
    "period_end" DATE NOT NULL,
    "keywords" JSONB NOT NULL DEFAULT '[]',
    "content" TEXT NOT NULL DEFAULT '',
    "rejection_reason" TEXT,
    "approved_at" TIMESTAMPTZ(6),
    "sent_at" TIMESTAMPTZ(6),
    "parent_read_at" TIMESTAMPTZ(6),
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "ai_reports_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "churn_cases" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "student_id" UUID NOT NULL,
    "assigned_user_id" UUID,
    "status" "churn_case_status" NOT NULL DEFAULT 'DETECTED',
    "summary" TEXT,
    "detected_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "resolved_at" TIMESTAMPTZ(6),
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "churn_cases_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "churn_signal_logs" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "churn_case_id" UUID NOT NULL,
    "type" "churn_signal_type" NOT NULL,
    "value" DECIMAL(10,2),
    "threshold" DECIMAL(10,2),
    "details" JSONB NOT NULL DEFAULT '{}',
    "detected_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "churn_signal_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "churn_threshold_configs" (
    "id" INTEGER NOT NULL DEFAULT 1,
    "attendance_drop_percent_point" DECIMAL(5,2) NOT NULL DEFAULT 15,
    "score_drop_points" DECIMAL(7,2) NOT NULL DEFAULT 10,
    "consecutive_absences" INTEGER NOT NULL DEFAULT 2,
    "unpaid_days" INTEGER NOT NULL DEFAULT 3,
    "updated_by" UUID,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "churn_threshold_configs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "invoices" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "student_id" UUID NOT NULL,
    "parent_user_id" UUID NOT NULL,
    "title" TEXT NOT NULL,
    "items" JSONB NOT NULL DEFAULT '[]',
    "total_amount" INTEGER NOT NULL,
    "status" "invoice_status" NOT NULL DEFAULT 'DRAFT',
    "due_date" DATE NOT NULL,
    "issued_at" TIMESTAMPTZ(6),
    "paid_at" TIMESTAMPTZ(6),
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "invoices_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payments" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "invoice_id" UUID NOT NULL,
    "payer_user_id" UUID,
    "provider" TEXT NOT NULL DEFAULT 'TOSS',
    "order_id" TEXT NOT NULL,
    "payment_key" TEXT,
    "amount" INTEGER NOT NULL,
    "status" "payment_status" NOT NULL DEFAULT 'PENDING',
    "method" TEXT,
    "failure_code" TEXT,
    "failure_message" TEXT,
    "requested_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "approved_at" TIMESTAMPTZ(6),
    "cancelled_at" TIMESTAMPTZ(6),
    "raw_payload" JSONB NOT NULL DEFAULT '{}',
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "payments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "messages" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "sender_user_id" UUID,
    "report_id" UUID,
    "title" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "deep_link" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "messages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "message_recipients" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "message_id" UUID NOT NULL,
    "recipient_user_id" UUID NOT NULL,
    "read_at" TIMESTAMPTZ(6),
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "message_recipients_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "push_subscriptions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "endpoint" TEXT NOT NULL,
    "p256dh" TEXT NOT NULL,
    "auth" TEXT NOT NULL,
    "user_agent" TEXT,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,
    "revoked_at" TIMESTAMPTZ(6),

    CONSTRAINT "push_subscriptions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "push_deliveries" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "recipient_id" UUID NOT NULL,
    "subscription_id" UUID,
    "status" "push_delivery_status" NOT NULL DEFAULT 'PENDING',
    "attempted_at" TIMESTAMPTZ(6),
    "sent_at" TIMESTAMPTZ(6),
    "error" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "push_deliveries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "news_items" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "kind" "news_kind" NOT NULL DEFAULT 'NOTICE',
    "category" "news_category" NOT NULL DEFAULT 'GENERAL',
    "audience" "news_audience" NOT NULL DEFAULT 'ALL',
    "title" TEXT NOT NULL,
    "content" TEXT,
    "image_url" TEXT,
    "link_url" TEXT,
    "sort_order" INTEGER NOT NULL DEFAULT 0,
    "published" BOOLEAN NOT NULL DEFAULT false,
    "starts_at" TIMESTAMPTZ(6),
    "ends_at" TIMESTAMPTZ(6),
    "created_by" UUID,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "news_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "inquiries" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "guardian_name" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "student_grade" TEXT,
    "interested_subject" TEXT,
    "preferred_time" TEXT,
    "message" TEXT,
    "internal_memo" TEXT,
    "status" "inquiry_status" NOT NULL DEFAULT 'NEW',
    "assigned_user_id" UUID,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "inquiries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_logs" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "actor_user_id" UUID,
    "action" TEXT NOT NULL,
    "target_type" TEXT NOT NULL,
    "target_id" UUID,
    "details" JSONB NOT NULL DEFAULT '{}',
    "ip_address" INET,
    "user_agent" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE INDEX "oauth_accounts_user_id_idx" ON "oauth_accounts"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "oauth_accounts_provider_provider_account_id_key" ON "oauth_accounts"("provider", "provider_account_id");

-- CreateIndex
CREATE UNIQUE INDEX "students_user_id_key" ON "students"("user_id");

-- CreateIndex
CREATE INDEX "students_status_name_idx" ON "students"("status", "name");

-- CreateIndex
CREATE INDEX "parent_student_links_parent_user_id_student_id_idx" ON "parent_student_links"("parent_user_id", "student_id");

-- CreateIndex
CREATE INDEX "parent_student_links_student_id_ended_at_idx" ON "parent_student_links"("student_id", "ended_at");

-- CreateIndex
CREATE INDEX "classes_teacher_user_id_active_idx" ON "classes"("teacher_user_id", "active");

-- CreateIndex
CREATE INDEX "class_enrollments_student_id_status_idx" ON "class_enrollments"("student_id", "status");

-- CreateIndex
CREATE INDEX "class_enrollments_class_id_status_idx" ON "class_enrollments"("class_id", "status");

-- CreateIndex
CREATE INDEX "class_sessions_starts_at_status_idx" ON "class_sessions"("starts_at", "status");

-- CreateIndex
CREATE UNIQUE INDEX "class_sessions_class_id_starts_at_key" ON "class_sessions"("class_id", "starts_at");

-- CreateIndex
CREATE INDEX "attendance_records_session_id_status_idx" ON "attendance_records"("session_id", "status");

-- CreateIndex
CREATE INDEX "attendance_records_student_id_created_at_idx" ON "attendance_records"("student_id", "created_at" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "attendance_records_student_id_session_id_key" ON "attendance_records"("student_id", "session_id");

-- CreateIndex
CREATE INDEX "absence_requests_requested_at_idx" ON "absence_requests"("requested_at" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "absence_requests_student_id_session_id_key" ON "absence_requests"("student_id", "session_id");

-- CreateIndex
CREATE INDEX "learning_records_student_id_record_date_idx" ON "learning_records"("student_id", "record_date" DESC);

-- CreateIndex
CREATE INDEX "grade_records_student_id_subject_assessed_at_idx" ON "grade_records"("student_id", "subject", "assessed_at" DESC);

-- CreateIndex
CREATE INDEX "wrong_notes_student_id_status_created_at_idx" ON "wrong_notes"("student_id", "status", "created_at" DESC);

-- CreateIndex
CREATE INDEX "wrong_note_images_wrong_note_id_sort_order_idx" ON "wrong_note_images"("wrong_note_id", "sort_order");

-- CreateIndex
CREATE INDEX "counseling_memos_student_id_counseled_at_idx" ON "counseling_memos"("student_id", "counseled_at" DESC);

-- CreateIndex
CREATE INDEX "ai_reports_student_id_status_created_at_idx" ON "ai_reports"("student_id", "status", "created_at" DESC);

-- CreateIndex
CREATE INDEX "ai_reports_status_created_at_idx" ON "ai_reports"("status", "created_at");

-- CreateIndex
CREATE INDEX "churn_cases_status_detected_at_idx" ON "churn_cases"("status", "detected_at" DESC);

-- CreateIndex
CREATE INDEX "churn_cases_student_id_status_idx" ON "churn_cases"("student_id", "status");

-- CreateIndex
CREATE INDEX "churn_signal_logs_churn_case_id_detected_at_idx" ON "churn_signal_logs"("churn_case_id", "detected_at");

-- CreateIndex
CREATE INDEX "invoices_student_id_status_idx" ON "invoices"("student_id", "status");

-- CreateIndex
CREATE INDEX "invoices_due_date_status_idx" ON "invoices"("due_date", "status");

-- CreateIndex
CREATE UNIQUE INDEX "payments_order_id_key" ON "payments"("order_id");

-- CreateIndex
CREATE UNIQUE INDEX "payments_payment_key_key" ON "payments"("payment_key");

-- CreateIndex
CREATE INDEX "payments_invoice_id_status_idx" ON "payments"("invoice_id", "status");

-- CreateIndex
CREATE INDEX "messages_created_at_idx" ON "messages"("created_at" DESC);

-- CreateIndex
CREATE INDEX "message_recipients_recipient_user_id_read_at_created_at_idx" ON "message_recipients"("recipient_user_id", "read_at", "created_at" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "message_recipients_message_id_recipient_user_id_key" ON "message_recipients"("message_id", "recipient_user_id");

-- CreateIndex
CREATE UNIQUE INDEX "push_subscriptions_endpoint_key" ON "push_subscriptions"("endpoint");

-- CreateIndex
CREATE INDEX "push_subscriptions_user_id_active_idx" ON "push_subscriptions"("user_id", "active");

-- CreateIndex
CREATE INDEX "push_deliveries_recipient_id_status_idx" ON "push_deliveries"("recipient_id", "status");

-- CreateIndex
CREATE INDEX "push_deliveries_subscription_id_created_at_idx" ON "push_deliveries"("subscription_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "news_items_published_audience_category_sort_order_idx" ON "news_items"("published", "audience", "category", "sort_order");

-- CreateIndex
CREATE INDEX "inquiries_status_created_at_idx" ON "inquiries"("status", "created_at" DESC);

-- CreateIndex
CREATE INDEX "audit_logs_target_type_target_id_created_at_idx" ON "audit_logs"("target_type", "target_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "audit_logs_actor_user_id_created_at_idx" ON "audit_logs"("actor_user_id", "created_at" DESC);

-- AddForeignKey
ALTER TABLE "oauth_accounts" ADD CONSTRAINT "oauth_accounts_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "permission_grants" ADD CONSTRAINT "permission_grants_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "students" ADD CONSTRAINT "students_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "parent_student_links" ADD CONSTRAINT "parent_student_links_parent_user_id_fkey" FOREIGN KEY ("parent_user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "parent_student_links" ADD CONSTRAINT "parent_student_links_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "parent_student_links" ADD CONSTRAINT "parent_student_links_linked_by_fkey" FOREIGN KEY ("linked_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "parent_student_links" ADD CONSTRAINT "parent_student_links_ended_by_fkey" FOREIGN KEY ("ended_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "classes" ADD CONSTRAINT "classes_teacher_user_id_fkey" FOREIGN KEY ("teacher_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "class_enrollments" ADD CONSTRAINT "class_enrollments_class_id_fkey" FOREIGN KEY ("class_id") REFERENCES "classes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "class_enrollments" ADD CONSTRAINT "class_enrollments_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "class_sessions" ADD CONSTRAINT "class_sessions_class_id_fkey" FOREIGN KEY ("class_id") REFERENCES "classes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attendance_records" ADD CONSTRAINT "attendance_records_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attendance_records" ADD CONSTRAINT "attendance_records_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "class_sessions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attendance_records" ADD CONSTRAINT "attendance_records_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "absence_requests" ADD CONSTRAINT "absence_requests_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "absence_requests" ADD CONSTRAINT "absence_requests_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "class_sessions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "absence_requests" ADD CONSTRAINT "absence_requests_requested_by_fkey" FOREIGN KEY ("requested_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "learning_records" ADD CONSTRAINT "learning_records_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "learning_records" ADD CONSTRAINT "learning_records_class_id_fkey" FOREIGN KEY ("class_id") REFERENCES "classes"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "learning_records" ADD CONSTRAINT "learning_records_author_user_id_fkey" FOREIGN KEY ("author_user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "grade_records" ADD CONSTRAINT "grade_records_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "grade_records" ADD CONSTRAINT "grade_records_class_id_fkey" FOREIGN KEY ("class_id") REFERENCES "classes"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "grade_records" ADD CONSTRAINT "grade_records_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wrong_notes" ADD CONSTRAINT "wrong_notes_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wrong_notes" ADD CONSTRAINT "wrong_notes_grade_record_id_fkey" FOREIGN KEY ("grade_record_id") REFERENCES "grade_records"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wrong_notes" ADD CONSTRAINT "wrong_notes_class_id_fkey" FOREIGN KEY ("class_id") REFERENCES "classes"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wrong_notes" ADD CONSTRAINT "wrong_notes_author_user_id_fkey" FOREIGN KEY ("author_user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wrong_note_images" ADD CONSTRAINT "wrong_note_images_wrong_note_id_fkey" FOREIGN KEY ("wrong_note_id") REFERENCES "wrong_notes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "counseling_memos" ADD CONSTRAINT "counseling_memos_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "counseling_memos" ADD CONSTRAINT "counseling_memos_author_user_id_fkey" FOREIGN KEY ("author_user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ai_reports" ADD CONSTRAINT "ai_reports_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ai_reports" ADD CONSTRAINT "ai_reports_author_user_id_fkey" FOREIGN KEY ("author_user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ai_reports" ADD CONSTRAINT "ai_reports_approver_user_id_fkey" FOREIGN KEY ("approver_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "churn_cases" ADD CONSTRAINT "churn_cases_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "churn_cases" ADD CONSTRAINT "churn_cases_assigned_user_id_fkey" FOREIGN KEY ("assigned_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "churn_signal_logs" ADD CONSTRAINT "churn_signal_logs_churn_case_id_fkey" FOREIGN KEY ("churn_case_id") REFERENCES "churn_cases"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "churn_threshold_configs" ADD CONSTRAINT "churn_threshold_configs_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoices" ADD CONSTRAINT "invoices_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoices" ADD CONSTRAINT "invoices_parent_user_id_fkey" FOREIGN KEY ("parent_user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_invoice_id_fkey" FOREIGN KEY ("invoice_id") REFERENCES "invoices"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_payer_user_id_fkey" FOREIGN KEY ("payer_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "messages" ADD CONSTRAINT "messages_sender_user_id_fkey" FOREIGN KEY ("sender_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "messages" ADD CONSTRAINT "messages_report_id_fkey" FOREIGN KEY ("report_id") REFERENCES "ai_reports"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "message_recipients" ADD CONSTRAINT "message_recipients_message_id_fkey" FOREIGN KEY ("message_id") REFERENCES "messages"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "message_recipients" ADD CONSTRAINT "message_recipients_recipient_user_id_fkey" FOREIGN KEY ("recipient_user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "push_subscriptions" ADD CONSTRAINT "push_subscriptions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "push_deliveries" ADD CONSTRAINT "push_deliveries_recipient_id_fkey" FOREIGN KEY ("recipient_id") REFERENCES "message_recipients"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "push_deliveries" ADD CONSTRAINT "push_deliveries_subscription_id_fkey" FOREIGN KEY ("subscription_id") REFERENCES "push_subscriptions"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "news_items" ADD CONSTRAINT "news_items_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "inquiries" ADD CONSTRAINT "inquiries_assigned_user_id_fkey" FOREIGN KEY ("assigned_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_actor_user_id_fkey" FOREIGN KEY ("actor_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- Domain constraints that are intentionally maintained as raw SQL.
CREATE UNIQUE INDEX "parent_student_links_one_active_parent"
ON "parent_student_links" ("student_id")
WHERE "ended_at" IS NULL;

CREATE UNIQUE INDEX "parent_student_links_no_active_duplicate"
ON "parent_student_links" ("parent_user_id", "student_id")
WHERE "ended_at" IS NULL;

CREATE UNIQUE INDEX "class_enrollments_one_active_enrollment"
ON "class_enrollments" ("class_id", "student_id")
WHERE "status" = 'ACTIVE';

CREATE UNIQUE INDEX "churn_cases_one_open_case"
ON "churn_cases" ("student_id")
WHERE "status" IN ('DETECTED', 'COUNSELING');

ALTER TABLE "students"
ADD CONSTRAINT "students_withdrawn_at_required"
CHECK ("status" <> 'WITHDRAWN' OR "withdrawn_at" IS NOT NULL);

ALTER TABLE "parent_student_links"
ADD CONSTRAINT "parent_student_links_valid_period"
CHECK ("ended_at" IS NULL OR "ended_at" >= "linked_at");

ALTER TABLE "class_enrollments"
ADD CONSTRAINT "class_enrollments_valid_period"
CHECK ("ended_at" IS NULL OR "ended_at" >= "enrolled_at");

ALTER TABLE "class_sessions"
ADD CONSTRAINT "class_sessions_valid_period"
CHECK ("ends_at" > "starts_at");

ALTER TABLE "attendance_records"
ADD CONSTRAINT "attendance_records_checkout_after_checkin"
CHECK (
  "check_out_at" IS NULL
  OR "check_in_at" IS NULL
  OR "check_out_at" >= "check_in_at"
);

ALTER TABLE "absence_requests"
ADD CONSTRAINT "absence_requests_cancel_after_request"
CHECK ("cancelled_at" IS NULL OR "cancelled_at" >= "requested_at");

ALTER TABLE "grade_records"
ADD CONSTRAINT "grade_records_valid_score"
CHECK ("max_score" > 0 AND "score" >= 0 AND "score" <= "max_score");

ALTER TABLE "ai_reports"
ADD CONSTRAINT "ai_reports_valid_period"
CHECK ("period_end" >= "period_start");

ALTER TABLE "ai_reports"
ADD CONSTRAINT "ai_reports_sent_at_required"
CHECK ("status" <> 'SENT' OR "sent_at" IS NOT NULL);

ALTER TABLE "churn_threshold_configs"
ADD CONSTRAINT "churn_threshold_configs_singleton"
CHECK ("id" = 1);

ALTER TABLE "churn_threshold_configs"
ADD CONSTRAINT "churn_threshold_configs_positive_values"
CHECK (
  "attendance_drop_percent_point" > 0
  AND "score_drop_points" > 0
  AND "consecutive_absences" > 0
  AND "unpaid_days" > 0
);

ALTER TABLE "invoices"
ADD CONSTRAINT "invoices_total_amount_nonnegative"
CHECK ("total_amount" >= 0);

ALTER TABLE "invoices"
ADD CONSTRAINT "invoices_paid_at_required"
CHECK ("status" <> 'PAID' OR "paid_at" IS NOT NULL);

ALTER TABLE "payments"
ADD CONSTRAINT "payments_amount_positive"
CHECK ("amount" > 0);

ALTER TABLE "news_items"
ADD CONSTRAINT "news_items_valid_period"
CHECK ("ends_at" IS NULL OR "starts_at" IS NULL OR "ends_at" >= "starts_at");

ALTER TABLE "news_items"
ADD CONSTRAINT "news_items_banner_image_required"
CHECK ("kind" <> 'BANNER' OR "image_url" IS NOT NULL);

INSERT INTO "churn_threshold_configs" (
  "id",
  "attendance_drop_percent_point",
  "score_drop_points",
  "consecutive_absences",
  "unpaid_days",
  "updated_at"
) VALUES (1, 15, 10, 2, 3, NOW())
ON CONFLICT ("id") DO NOTHING;
