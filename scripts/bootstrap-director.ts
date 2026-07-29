const appUrl = process.env.NEXT_PUBLIC_APP_URL ?? "http://localhost:3000";
const bootstrapSecret = process.env.BOOTSTRAP_SECRET;

if (!bootstrapSecret) {
    throw new Error("BOOTSTRAP_SECRET이 필요합니다.");
}

const response = await fetch(`${appUrl}/api/admin/bootstrap-director`, {
    method: "POST",
    headers: {
        "content-type": "application/json",
        "x-bootstrap-secret": bootstrapSecret,
    },
});

const result = await response.json();

if (!response.ok) {
    throw new Error(JSON.stringify(result));
}

console.log(result);

export {};
