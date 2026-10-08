import { ChevronDown, ExternalLink } from "lucide-react";
import { useEffect, useRef, useState } from "react";
import { fetchChangelogReleases } from "../lib/changelog";
import type { GitHubRelease } from "../lib/changelog";
import { reactilyRuntime } from "../lib/runtime";

const fallbackTag = `v${reactilyRuntime.version}`;
const fallbackUrl = `https://github.com/lily-studios/Reactily/releases/tag/${encodeURIComponent(fallbackTag)}`;

export function VersionSelector() {
  const [releases, setReleases] = useState<readonly GitHubRelease[]>([]);
  const [loading, setLoading] = useState(true);
  const [isOpen, setIsOpen] = useState(false);
  const wrapperRef = useRef<HTMLDivElement>(null);
  const triggerRef = useRef<HTMLButtonElement>(null);

  useEffect(() => {
    const controller = new AbortController();

    fetchChangelogReleases(controller.signal)
      .then((result) => {
        if (!controller.signal.aborted) setReleases(result);
      })
      .catch(() => {
        // The documentation's own version remains available if GitHub is offline.
      })
      .finally(() => {
        if (!controller.signal.aborted) setLoading(false);
      });

    return () => controller.abort();
  }, []);

  useEffect(() => {
    if (!isOpen) return;

    const closeOnOutsideClick = (event: PointerEvent): void => {
      if (event.target instanceof Node && !wrapperRef.current?.contains(event.target)) {
        setIsOpen(false);
      }
    };
    const closeOnEscape = (event: KeyboardEvent): void => {
      if (event.key === "Escape") {
        setIsOpen(false);
        triggerRef.current?.focus();
      }
    };
    document.addEventListener("pointerdown", closeOnOutsideClick);
    document.addEventListener("keydown", closeOnEscape);
    return () => {
      document.removeEventListener("pointerdown", closeOnOutsideClick);
      document.removeEventListener("keydown", closeOnEscape);
    };
  }, [isOpen]);

  // GitHub decides release type; tags can be numbers, words, or mixed formats.
  const latestStable = releases.find((release) => !release.prerelease);
  const latestPrerelease = releases.find((release) => release.prerelease);
  const shownTag = latestStable?.tag_name ?? fallbackTag;

  return (
    <div className="versionSelectorWrap" ref={wrapperRef}>
      <button
        ref={triggerRef}
        type="button"
        className="versionSelectorShell"
        aria-label={`Reactily ${shownTag}; choose a release`}
        aria-expanded={isOpen}
        aria-controls="reactily-release-options"
        onClick={() => setIsOpen((open) => !open)}
      >
        <span className="versionSelectorCurrent">
          <span className="versionTag">{shownTag}</span>
          {latestStable ? (
            <>
              <span className="versionReleaseSeparator" aria-hidden="true">·</span>
              <span className="versionReleaseStatus versionReleaseStatus--latest">Latest</span>
            </>
          ) : null}
        </span>
        <ChevronDown className="versionSelectorChevron" size={14} aria-hidden="true" />
      </button>
      {isOpen ? (
        <nav className="versionReleaseMenu" id="reactily-release-options" aria-label="Reactily releases">
          <span className="versionReleaseMenuHeading">Release channels</span>
          {latestStable ? (
            <a
              className="versionReleaseOption"
              href={latestStable.html_url}
              target="_blank"
              rel="noopener noreferrer"
              onClick={() => setIsOpen(false)}
            >
              <span className="versionReleaseOptionStatus versionReleaseOptionStatus--latest">Latest</span>
              <span className="versionReleaseOptionTag">{latestStable.tag_name}</span>
              <ExternalLink size={13} aria-hidden="true" />
            </a>
          ) : null}
          {latestPrerelease ? (
            <a
              className="versionReleaseOption"
              href={latestPrerelease.html_url}
              target="_blank"
              rel="noopener noreferrer"
              onClick={() => setIsOpen(false)}
            >
              <span className="versionReleaseOptionStatus versionReleaseOptionStatus--prerelease">Pre-release</span>
              <span className="versionReleaseOptionTag">{latestPrerelease.tag_name}</span>
              <ExternalLink size={13} aria-hidden="true" />
            </a>
          ) : null}
          {!latestStable && !latestPrerelease ? (
            <>
              {loading ? <span className="versionReleaseMenuInfo">Loading releases…</span> : null}
              <a
                className="versionReleaseOption"
                href={fallbackUrl}
                target="_blank"
                rel="noopener noreferrer"
                onClick={() => setIsOpen(false)}
              >
                <span className="versionReleaseOptionTag">{fallbackTag}</span>
                <ExternalLink size={13} aria-hidden="true" />
              </a>
            </>
          ) : null}
        </nav>
      ) : null}
    </div>
  );
}
