import AcademyWireframe from "@/app/AcademyWireframe";

export default function LandingPage() {
    return (
        <AcademyWireframe
            initialRole="guest"
            initialScreenId="landing"
            showPreviewControls={false}
        />
    );
}
