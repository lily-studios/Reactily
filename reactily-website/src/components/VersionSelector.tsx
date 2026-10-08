import { Check, ChevronDown, ExternalLink } from "lucide-react";
import { useEffect, useRef, useState } from "react";
import { useLocation } from "react-router";
import { fetchChangelogReleases, getReleaseChannel } from "../lib/changelog";
import type { GitHubRelease } from "../lib/changelog";
import { reactilyRuntime } from "../lib/runtime";
import { highestNumberedReleaseTag, isSupersededRelease } from "../lib/release-lifecycle";
import { useVersionedDocs } from "../lib/versioned-docs";

const fallbackTag = `v${reactilyRuntime.version}`;

export function VersionSelector() {
  const { tag, selectTag } = useVersionedDocs();
  const location = useLocation();
  const isDevelopment = new URLSearchParams(location.search).get("version") === "development";
  const [releases, setReleases] = useState<readonly GitHubRelease[]>([]);
  const [loading, setLoading] = useState(true);
  const [open, setOpen] = useState(false);
  const wrapperRef = useRef<HTMLDivElement>(null);
  const triggerRef = useRef<HTMLButtonElement>(null);

  useEffect(() => {
    const controller = new AbortController();
    fetchChangelogReleases(controller.signal)
      .then((result) => { if (!controller.signal.aborted) setReleases(result); })
      .catch(() => { /* Bundled docs remain available if GitHub is offline. */ })
      .finally(() => { if (!controller.signal.aborted) setLoading(false); });
    return () => controller.abort();
  }, []);

  useEffect(() => {
    if (!open) return;
    const outside = (event: PointerEvent): void => {
      if (event.target instanceof Node && !wrapperRef.current?.contains(event.target)) setOpen(false);
    };
    const escape = (event: KeyboardEvent): void => {
      if (event.key === "Escape") { setOpen(false); triggerRef.current?.focus(); }
    };
    document.addEventListener("pointerdown", outside);
    document.addEventListener("keydown", escape);
    return () => {
      document.removeEventListener("pointerdown", outside);
      document.removeEventListener("keydown", escape);
    };
  }, [open]);

  const latestStable = releases.find((release) => getReleaseChannel(release) === "stable");
  const highestTag = highestNumberedReleaseTag(releases.map((release) => release.tag_name));
  const shownTag = isDevelopment ? "Development" : tag ?? latestStable?.tag_name ?? fallbackTag;
  const superseded = !isDevelopment && isSupersededRelease(shownTag, highestTag);
  const current = releases.find((release) => release.tag_name === shownTag);
  const channel = current ? getReleaseChannel(current) : null;
  const currentStatus = superseded ? "Deprecated" :
    channel === "experimental" ? "Experimental" :
    channel === "prerelease" ? "Pre-release" :
      shownTag === latestStable?.tag_name ? "Latest" : channel === "stable" ? "Stable" : null;
  const choose = (next: string | null): void => { selectTag(next); setOpen(false); };

  return (
    <div className="versionSelectorWrap" ref={wrapperRef}>
      <button ref={triggerRef} type="button" className="versionSelectorShell"
        aria-label={`Reactily ${shownTag}; choose documentation version`}
        aria-expanded={open} aria-controls="reactily-release-options"
        onClick={() => setOpen((value) => !value)}>
        <span className="versionSelectorCurrent">
          <span className="versionTag">{shownTag}</span>
          {currentStatus ? (
            <>
              <span className="versionReleaseSeparator" aria-hidden="true">·</span>
              <span className={`versionReleaseStatus versionReleaseStatus--${superseded ? "deprecated" : channel === "stable" ? "latest" : channel}`}>{currentStatus}</span>
            </>
          ) : null}
        </span>
        <ChevronDown className="versionSelectorChevron" size={14} aria-hidden="true" />
      </button>
      {open ? (
        <nav id="reactily-release-options" className="versionReleaseMenu" aria-label="Documentation versions">
          <span className="versionReleaseMenuHeading">Documentation versions</span>
          <div className="versionReleaseOption">
            <button className="versionReleasePick" type="button" onClick={() => choose(null)}>
              <span className="versionReleaseOptionTag">Current website docs</span>
              {!tag ? <Check size={14} aria-hidden="true" /> : null}
            </button>
          </div>
          {releases.map((release) => {
            const releaseChannel = getReleaseChannel(release);
            const outdated = isSupersededRelease(release.tag_name, highestTag);
            const status = releaseChannel === "experimental" ? "Experimental" :
              releaseChannel === "prerelease" ? "Pre-release" :
              release.id === latestStable?.id && !outdated ? "Latest" : "Stable";
            return (
              <div className="versionReleaseOption" key={release.id}>
                <button className="versionReleasePick" type="button"
                  onClick={() => choose(release.tag_name)}
                  aria-current={tag === release.tag_name ? "true" : undefined}
                  title={`View documentation for ${release.tag_name}`}>
                  <span className={`versionReleaseOptionStatus versionReleaseOptionStatus--${releaseChannel === "stable" ? "latest" : releaseChannel}`}>{status}</span>
                  <span className="versionReleaseOptionTag">{release.tag_name}</span>
                  {outdated ? <span className="versionReleaseOptionStatus versionReleaseOptionStatus--deprecated">Deprecated</span> : null}
                  {tag === release.tag_name ? <Check size={14} aria-hidden="true" /> : null}
                </button>
                <a className="versionReleaseGitHub" href={release.html_url} target="_blank"
                  rel="noopener noreferrer" aria-label={`View ${release.tag_name} release on GitHub`}>
                  <ExternalLink size={13} aria-hidden="true" />
                </a>
              </div>
            );
          })}
          {loading ? <span className="versionReleaseMenuInfo">Loading GitHub releases…</span> : null}
          {!loading && releases.length === 0 ? <span className="versionReleaseMenuInfo">Release list unavailable.</span> : null}
        </nav>
      ) : null}
    </div>
  );
}
