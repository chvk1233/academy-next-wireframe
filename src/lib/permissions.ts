import type { AppRole, PermissionKey } from "@/types/roles";

export const staffPermissionPreset: Record<PermissionKey, boolean> = {
    viewAllStudents: false,
    viewParentContact: true,
    editLifeCounseling: false,
    writeAiReport: false,
    aiDirectSend: false,
    ownClassAttendanceGrade: true,
    otherTeacherAttendanceGrade: false,
    sendMessage: false,
    billing: true,
    linkParentStudent: true,
};

export const teacherPermissionPreset: Record<PermissionKey, boolean> = {
    viewAllStudents: false,
    viewParentContact: false,
    editLifeCounseling: true,
    writeAiReport: true,
    aiDirectSend: false,
    ownClassAttendanceGrade: true,
    otherTeacherAttendanceGrade: false,
    sendMessage: false,
    billing: false,
    linkParentStudent: false,
};

export function roleHasAllPermissions(role: AppRole) {
    return role === "DIRECTOR";
}
