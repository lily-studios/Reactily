import { ExternalLink } from "lucide-react";
import { useEffect, useState } from "react";
import { reactilyRuntime } from "../lib/runtime";

type ReleaseStatus = "latest" | "prerelease" | null;

type ReleaseMetadata = {
  readonly tag_name: string;
  readonly prerelease: boolean;
  readonly draft: boolean;
};

const releaseTag = `v${reactilyRuntime.version}`;
const releaseUrl = `https://github.com/lily-studios/Reactily/releases/tag/${releaseTag}`;
const apiUrl = "https://api.github.com/repos/lily-studios/Reactily/releases";

async function getRelease(url: string, signal: AbortSignal): Promise<ReleaseMetadata | null> {
  const response = await fetch(url, {
    headers: { Accept: "application/vnd.github+json" },
    signal,
  });

  if (!response.ok) return null;

  const value: unknown = await response.json();

  if (value === null || typeof value !== "object") return null;

  const release = value as Record<string, unknown>;
  if (
    typeof release.tag_name !== "string" ||
    typeof release.prerelease !== "boolean" ||
    typeof release.draft !== "boolean"
  ) return null;

  return {
    tag_name: release.tag_name,
    prerelease: release.prerelease,
    draft: release.draft,
  };
}

export function VersionSelector() {
  const [status, setStatus] = useState<ReleaseStatus>(null);

  useEffect(() => {
    const controller = new AbortController();

    const resolveStatus = async (): Promise<void> => {
      try {
        const current = await getRelease(
          `${apiUrl}/tags/${encodeURIComponent(releaseTag)}`,
          controller.signal,
        );

        if (current === null || current.draft || controller.signal.aborted) return;

        if (current.prerelease) {
          setStatus("prerelease");
          return;
        }

        const latest = await getRelease(`${apiUrl}/latest`, controller.signal);

        if (!controller.signal.aborted && latest?.tag_name === releaseTag) {
          setStatus("latest");
        }
      } catch {
        // A failed GitHub request never hides the documented version.
      }
    };

    void resolveStatus();
    return () => controller.abort();
  }, []);

  const statusLabel = status === "latest"
    ? "Latest"
    : status === "prerelease"
      ? "Pre-release"
      : null;

  return (
    <a
      className="versionSelectorShell"
      href={releaseUrl}
      target="_blank"
      rel="noopener noreferrer"
      aria-label={`Reactily ${releaseTag}${statusLabel ? `, ${statusLabel}` : ""}; open release on GitHub`}
      title="View this version on GitHub"
    >
      <span className="versionSelectorCurrent">
        {releaseTag}
        {statusLabel ? <span className="versionReleaseStatus">· {statusLabel}</span> : null}
      </span>
      <ExternalLink className="versionSelectorChevron" size={13} aria-hidden="true" />
    </a>
  );
}
