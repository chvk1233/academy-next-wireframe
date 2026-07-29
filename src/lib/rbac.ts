import type { AppRole, RolePrefix } from "@/types/roles";

const allowedPrefixes: Record<AppRole, RolePrefix[]> = {
    DIRECTOR: ["director"],
    TEACHER: ["staff"],
    STAFF: ["staff"],
    PARENT: ["parent"],
    STUDENT: ["student"],
    GUEST: ["guest"],
};

export function canAccessRolePrefix(role: AppRole, prefix: RolePrefix) {
    return allowedPrefixes[role].includes(prefix);
}

export function getDefaultRoute(role: AppRole) {
    const routes: Record<AppRole, string> = {
        DIRECTOR: "/director/dashboard",
        TEACHER: "/staff/dashboard",
        STAFF: "/staff/dashboard",
        PARENT: "/parent/dashboard",
        STUDENT: "/student/dashboard",
        GUEST: "/guest/waiting",
    };

    return routes[role];
}
