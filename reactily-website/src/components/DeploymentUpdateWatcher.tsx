import { useEffect } from "react";
import { useLocation } from "react-router";

declare const __REACTILY_BUILD_ID__: string;

const buildParameter = "_reactily_build";
const buildEndpoint = `${import.meta.env.BASE_URL}build-version.json`;

/**
 * Refresh outdated SPA bundles on navigation, focus, or tab restoration.
 *
 * GitHub Pages may keep an old application open after a new deployment.
 * A cache-busting navigation is attempted only once for each deployed build,
 * preventing refresh loops while preserving the user's route and version.
 */
export function DeploymentUpdateWatcher() {
  const { pathname, search } = useLocation();

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

        const target = new URL(window.location.href);
        if (latestId !== __REACTILY_BUILD_ID__) {
          // If the browser still serves an old bundle, do not reload forever.
          if (target.searchParams.get(buildParameter) === latestId) return;

          target.searchParams.set(buildParameter, latestId);
          window.location.replace(target.href);
          return;
        }

        // Remove the cache-busting parameter once the new bundle is active.
        if (target.searchParams.has(buildParameter)) {
          target.searchParams.delete(buildParameter);
          window.history.replaceState(
            window.history.state,
            "",
            target.pathname + target.search + target.hash,
          );
        }
      } catch {
        // Keep the current site usable while offline or during deployments.
      } finally {
        checking = false;
      }
    };

    const onVisibilityChange = (): void => {
      if (document.visibilityState === "visible") void checkForUpdate();
    };

    void checkForUpdate();
    window.addEventListener("focus", onVisibilityChange);
    document.addEventListener("visibilitychange", onVisibilityChange);
    const interval = window.setInterval(() => void checkForUpdate(), 120_000);

    return () => {
      cancelled = true;
      window.clearInterval(interval);
      window.removeEventListener("focus", onVisibilityChange);
      document.removeEventListener("visibilitychange", onVisibilityChange);
    };
  }, [pathname, search]);

  return null;
}
