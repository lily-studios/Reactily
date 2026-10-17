import { useEffect } from "react";
import { Navigate, Route, Routes, useLocation, useNavigate } from "react-router";
import { VersionedDocsProvider } from "./lib/versioned-docs";
import { DeploymentUpdateWatcher } from "./components/DeploymentUpdateWatcher";
import { Footer } from "./components/Footer";
import { Header } from "./components/Header";
import { ApiPage } from "./pages/ApiPage";
import { ChangelogPage } from "./pages/ChangelogPage";
import { DocPage } from "./pages/DocPage";
import { HomePage } from "./pages/HomePage";

function AppView() {
  const location = useLocation();
  const navigate = useNavigate();
  const isDocs = location.pathname.startsWith("/docs/");

  useEffect(() => {
    // React Router links already navigate without reloading. This also catches
    // ordinary internal anchors before GitHub Pages requests a new document.
    const handleInternalLink = (event: MouseEvent): void => {
      if (event.defaultPrevented || event.button !== 0 || event.metaKey ||
          event.ctrlKey || event.shiftKey || event.altKey) return;
      if (!(event.target instanceof Element)) return;

      const anchor = event.target.closest("a[href]");
      if (!(anchor instanceof HTMLAnchorElement) || anchor.hasAttribute("download") ||
          (anchor.target && anchor.target !== "_self")) return;

      const destination = new URL(anchor.href);
      if (destination.origin !== window.location.origin) return;

      const base = import.meta.env.BASE_URL.replace(/\/+$/, "");
      if (base && destination.pathname !== base &&
          !destination.pathname.startsWith(`${base}/`)) return;

      const route = destination.pathname.slice(base.length) || "/";
      if (route !== "/" && route !== "/api" && route !== "/changelog" &&
          !route.startsWith("/docs/")) return;

      const current = new URL(window.location.href);
      if (destination.pathname === current.pathname &&
          destination.search === current.search &&
          destination.hash === current.hash) return;

      // Same-document anchors retain native browser scrolling.
      if (destination.pathname === current.pathname &&
          destination.search === current.search && destination.hash) return;

      event.preventDefault();
      navigate(route + destination.search + destination.hash);
    };

    document.addEventListener("click", handleInternalLink);
    return () => document.removeEventListener("click", handleInternalLink);
  }, [navigate]);

  return (
    <div className="appShell">
      <DeploymentUpdateWatcher />
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
