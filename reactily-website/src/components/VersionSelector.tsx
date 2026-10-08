import { ChevronDown } from "lucide-react";
import { useEffect, useState } from "react";

import {
  GITHUB_RELEASES_URL,
  getGitHubReleases,
  type GitHubRelease,
} from "../lib/releases";

type LoadState = "idle" | "loading" | "ready" | "error";

const DEVELOPMENT_VALUE = "__development__";
const ALL_RELEASES_VALUE = "__all__";

export function VersionSelector() {
  const [releases, setReleases] = useState<readonly GitHubRelease[]>([]);
  const [loadState, setLoadState] = useState<LoadState>("idle");

  useEffect(() => {
    const controller = new AbortController();

    setLoadState("loading");

    void getGitHubReleases(controller.signal)
      .then((nextReleases) => {
        setReleases(nextReleases);
        setLoadState("ready");
      })
      .catch((error: unknown) => {
        if (error instanceof DOMException && error.name === "AbortError") {
          return;
        }

        console.warn("[Reactily Docs] Failed to load GitHub releases.", error);
        setLoadState("error");
      });

    return () => {
      controller.abort();
    };
  }, []);

  const latestStableRelease = releases.find((release) => !release.prerelease);

  const handleChange = (value: string): void => {
    if (value === DEVELOPMENT_VALUE) {
      return;
    }

    if (value === ALL_RELEASES_VALUE) {
      window.location.assign(GITHUB_RELEASES_URL);
      return;
    }

    const release = releases.find((item) => item.tagName === value);

    if (release !== undefined) {
      window.location.assign(release.url);
    }
  };

  return (
    <div className="versionSelectorWrap">
      <label className="srOnly" htmlFor="reactily-version-selector">
        Reactily documentation channel and published releases
      </label>

      <div className="versionSelectorShell">
        <span className="versionSelectorCurrent">
          Development
          <span className="versionDevBadge">Current docs</span>
        </span>

        <select
          id="reactily-version-selector"
          className="versionSelector"
          aria-label="Reactily documentation channel and published releases"
          value={DEVELOPMENT_VALUE}
          onChange={(event) => {
            handleChange(event.target.value);
          }}
        >
          <option value={DEVELOPMENT_VALUE}>Development — current docs</option>

          {releases.map((release) => (
            <option key={release.id} value={release.tagName}>
              {release.tagName}
              {latestStableRelease?.id === release.id ? " — Latest release" : ""}
              {release.prerelease ? " — Pre-release" : ""}
            </option>
          ))}

          {loadState === "loading" ? (
            <option value="__loading__" disabled>
              Loading GitHub releases…
            </option>
          ) : null}

          {loadState === "error" ? (
            <option value="__error__" disabled>
              GitHub releases unavailable
            </option>
          ) : null}

          <option value={ALL_RELEASES_VALUE}>All GitHub releases</option>
        </select>

        <ChevronDown
          className="versionSelectorChevron"
          size={15}
          aria-hidden="true"
        />
      </div>
    </div>
  );
}
