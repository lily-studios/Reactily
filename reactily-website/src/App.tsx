
/* ============================================================
 * Reactily · Lily Studios
 * Application Router
 * ============================================================ */

import { lazy, Suspense } from "react";

import {
  Navigate,
  Route,
  Routes,
  useLocation,
} from "react-router";

import { Footer } from "./components/Footer";
import { Header } from "./components/Header";

/* ============================================================
 * Lazy-Loaded Pages
 * ============================================================ */

const HomePage = lazy(() =>
  import("./pages/HomePage").then((module) => ({
    default: module.HomePage,
  })),
);

const ApiPage = lazy(() =>
  import("./pages/ApiPage").then((module) => ({
    default: module.ApiPage,
  })),
);

const DocPage = lazy(() =>
  import("./pages/DocPage").then((module) => ({
    default: module.DocPage,
  })),
);

/* ============================================================
 * Page Loading Fallback
 * ============================================================ */

function PageFallback() {
  return (
    <main
      className="container"
      role="status"
      aria-live="polite"
    >
      <p>Loading Reactily documentation...</p>
    </main>
  );
}

/* ============================================================
 * Application
 * ============================================================ */

export function App() {
  const location = useLocation();

  const isDocs = location.pathname.startsWith("/docs/");

  return (
    <div className="appShell">
      <Header />

      <Suspense fallback={<PageFallback />}>
        <Routes>
          <Route
            path="/"
            element={<HomePage />}
          />

          <Route
            path="/api"
            element={<ApiPage />}
          />

          <Route
            path="/docs/*"
            element={<DocPage />}
          />

          <Route
            path="*"
            element={
              <Navigate
                to="/"
                replace
              />
            }
          />
        </Routes>
      </Suspense>

      {!isDocs ? <Footer /> : null}
    </div>
  );
}
