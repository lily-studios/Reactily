import { useEffect, useState } from "react";

declare const __REACTILY_BUILD_ID__: string;

const buildParameter = "_reactily_build";
const buildEndpoint = `${import.meta.env.BASE_URL}build-version.json`;

/**
 * Check for newly deployed documentation without interrupting navigation.
 * Reload only when the visitor explicitly chooses to update.
 */
export function DeploymentUpdateWatcher() {
  const [availableBuild, setAvailableBuild] = useState<string | null>(null);
  const [dismissedBuild, setDismissedBuild] = useState<string | null>(null);

  useEffect(() => {
    if (!import.meta.env.PROD) return;

    let cancelled = false;
    let checking = false;

    const checkForUpdate = async (): Promise<void> => {
      if (checking || document.visibilityState === "hidden") return;
      checking = true;

      try {
        const response = await fetch(`${buildEndpoint}?t=${Date.now()}`, {
          cache: "no-store",
        });
        if (cancelled || !response.ok) return;

        const result: unknown = await response.json();
        if (cancelled || typeof result !== "object" || result === null) return;

        const latestId = (result as { id?: unknown }).id;
        if (typeof latestId !== "string" || latestId.length === 0) return;

        if (latestId !== __REACTILY_BUILD_ID__) {
          setAvailableBuild(latestId);
          return;
        }

        setAvailableBuild(null);

        // Clean up a cache-busting parameter after a user-initiated update.
        const current = new URL(window.location.href);
        if (current.searchParams.has(buildParameter)) {
          current.searchParams.delete(buildParameter);
          window.history.replaceState(
            window.history.state,
            "",
            current.pathname + current.search + current.hash,
          );
        }
      } catch {
        // Navigation must remain usable even if update checks fail.
      } finally {
        checking = false;
      }
    };

    const onFocus = (): void => {
      if (document.visibilityState === "visible") void checkForUpdate();
    };

    void checkForUpdate();
    window.addEventListener("focus", onFocus);
    document.addEventListener("visibilitychange", onFocus);
    const interval = window.setInterval(() => void checkForUpdate(), 120_000);

    return () => {
      cancelled = true;
      window.clearInterval(interval);
      window.removeEventListener("focus", onFocus);
      document.removeEventListener("visibilitychange", onFocus);
    };
  }, []);

  if (!availableBuild || availableBuild === dismissedBuild) return null;

  const reloadForUpdate = (): void => {
    // A full navigation is allowed only after clicking the update button.
    const target = new URL(window.location.href);
    target.searchParams.set(buildParameter, availableBuild);
    window.location.assign(target.href);
  };

  return (
    <aside className="deploymentUpdateNotice" role="status" aria-live="polite">
      <span>A newer version of the docs is available.</span>
      <button type="button" className="deploymentUpdateAction" onClick={reloadForUpdate}>
        Update
      </button>
      <button
        type="button"
        className="deploymentUpdateDismiss"
        onClick={() => setDismissedBuild(availableBuild)}
        aria-label="Dismiss update notice"
      >
        ×
      </button>
    </aside>
  );
}
