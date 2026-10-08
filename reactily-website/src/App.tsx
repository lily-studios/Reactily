import { Navigate, Route, Routes, useLocation } from "react-router";
import { VersionedDocsProvider } from "./lib/versioned-docs";
import { Footer } from "./components/Footer";
import { Header } from "./components/Header";
import { ApiPage } from "./pages/ApiPage";
import { ChangelogPage } from "./pages/ChangelogPage";
import { DocPage } from "./pages/DocPage";
import { HomePage } from "./pages/HomePage";

function AppView() {
  const location = useLocation();
  const isDocs = location.pathname.startsWith("/docs/");

  return (
    <div className="appShell">
      <Header />
      <Routes>
        <Route path="/" element={<HomePage />} />
        <Route path="/api" element={<ApiPage />} />
        <Route path="/changelog" element={<ChangelogPage />} />
        <Route path="/docs/*" element={<DocPage />} />
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
      {!isDocs ? <Footer /> : null}
    </div>
  );
}

export function App() {
  return <VersionedDocsProvider><AppView /></VersionedDocsProvider>;
}
