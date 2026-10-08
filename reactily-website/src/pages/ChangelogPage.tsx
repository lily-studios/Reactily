import { ArrowDown, ArrowUpRight, RefreshCcw } from "lucide-react";
import { useEffect, useState } from "react";
import ReactMarkdown from "react-markdown";
import type { Components } from "react-markdown";
import remarkGfm from "remark-gfm";
import {
  fetchChangelogReleases,
  getReleaseChannel,
  releaseDate,
  releaseDescription,
} from "../lib/changelog";
import type { GitHubRelease } from "../lib/changelog";
import { highestNumberedReleaseTag, isSupersededRelease } from "../lib/release-lifecycle";

type LoadStatus = "loading" | "ready" | "error";

const markdownComponents: Components = {
  h1({ children }) { return <h3>{children}</h3>; },
  h2({ children }) { return <h3>{children}</h3>; },
  h3({ children }) { return <h4>{children}</h4>; },
  h4({ children }) { return <h5>{children}</h5>; },
  a({ children, href }) {
    return <a href={href} target="_blank" rel="noopener noreferrer">{children}</a>;
  },
};

export function ChangelogPage() {
  const [releases, setReleases] = useState<readonly GitHubRelease[]>([]);
  const [status, setStatus] = useState<LoadStatus>("loading");
  const [errorMessage, setErrorMessage] = useState("");
  const [refreshCount, setRefreshCount] = useState(0);
  const latestStable = releases.find((release) => getReleaseChannel(release) === "stable");
  const highestTag = highestNumberedReleaseTag(releases.map((release) => release.tag_name));

  useEffect(() => {
    const controller = new AbortController();
    setStatus("loading");

    fetchChangelogReleases(controller.signal)
      .then((latest) => {
        if (controller.signal.aborted) return;
        setReleases(latest);
        setErrorMessage("");
        setStatus("ready");
      })
      .catch((error: unknown) => {
        if (controller.signal.aborted) return;
        setErrorMessage(error instanceof Error ? error.message : "Unable to load GitHub releases.");
        setStatus("error");
      });

    return () => controller.abort();
  }, [refreshCount]);

  return (
    <main className="changelogPage">
      <header className="container changelogHero">
        <span className="sectionEyebrow">Release history</span>
        <h1>Changelog</h1>
        <p>
          Every update directly from the{" "}
          <a href="https://github.com/lily-studios/Reactily/releases" target="_blank" rel="noopener noreferrer">
            Reactily GitHub releases
          </a>. Browse all published releases, including pre-releases, experimental builds, and named versions.
        </p>
      </header>

      {status === "loading" ? (
        <section className="container changelogMessage" role="status" aria-live="polite">
          <span className="changelogLoading" aria-hidden="true" />
          Loading release notes from GitHub…
        </section>
      ) : null}

      {status === "error" ? (
        <section className="container changelogMessage changelogError" role="alert">
          <strong>Release notes could not be loaded.</strong>
          <p>{errorMessage}</p>
          <div className="changelogErrorActions">
            <button type="button" className="button secondaryButton" onClick={() => setRefreshCount((count) => count + 1)}>
              <RefreshCcw size={15} /> Retry
            </button>
            <a className="button secondaryButton" href="https://github.com/lily-studios/Reactily/releases" target="_blank" rel="noopener noreferrer">
              View on GitHub <ArrowUpRight size={15} />
            </a>
          </div>
        </section>
      ) : null}

      {status === "ready" && releases.length === 0 ? (
        <section className="container changelogMessage" role="status">
          No published GitHub releases were found.
        </section>
      ) : null}

      {status === "ready" && releases.length > 0 ? (
        <div className="container changelogLayout">
          <nav className="changelogJump" aria-label="Jump to release">
            <div className="changelogJumpHeading">Versions</div>
            <ol>
              {releases.map((release) => (
                <li key={release.id}>
                  <a href={`#release-${release.id}`}>
                    <span>{release.tag_name}</span>
                    {getReleaseChannel(release) === "experimental" ? (
                      <span className="changelogExperimental">Experimental</span>
                    ) : getReleaseChannel(release) === "prerelease" ? (
                      <span className="changelogPrerelease">Pre-release</span>
                    ) : release.id === latestStable?.id && !isSupersededRelease(release.tag_name, highestTag) ? (
                      <span className="changelogLatest">Latest</span>
                    ) : null}
                    {isSupersededRelease(release.tag_name, highestTag) ? (
                      <span className="changelogDeprecated">Deprecated</span>
                    ) : null}
                  </a>
                </li>
              ))}
            </ol>
            <a className="changelogJumpAll" href="https://github.com/lily-studios/Reactily/releases" target="_blank" rel="noopener noreferrer">
              All GitHub releases <ArrowUpRight size={14} />
            </a>
          </nav>

          <div className="changelogEntries">
            <div className="changelogSummary">
              <span>{releases.length} published {releases.length === 1 ? "release" : "releases"}</span>
              <span><ArrowDown size={14} /> Newest first</span>
            </div>

            {releases.map((release) => (
              <article
                className="changelogEntry"
                key={release.id}
                id={`release-${release.id}`}
                aria-labelledby={`release-heading-${release.id}`}
              >
                <div className="changelogEntryHeader">
                  <div>
                    <div className="changelogEntryMeta">
                      <span>{releaseDate(release.published_at)}</span>
                      {getReleaseChannel(release) === "experimental" ? (
                        <span className="changelogExperimental">Experimental</span>
                      ) : getReleaseChannel(release) === "prerelease" ? (
                        <span className="changelogPrerelease">Pre-release</span>
                      ) : release.id === latestStable?.id && !isSupersededRelease(release.tag_name, highestTag) ? (
                        <span className="changelogLatest">Latest stable</span>
                      ) : null}
                      {isSupersededRelease(release.tag_name, highestTag) ? (
                        <span className="changelogDeprecated">Deprecated version</span>
                      ) : null}
                    </div>
                    <h2 id={`release-heading-${release.id}`}>{release.name || `Reactily ${release.tag_name}`}</h2>
                  </div>
                  <a className="changelogSource" href={release.html_url} target="_blank" rel="noopener noreferrer">
                    GitHub release <ArrowUpRight size={15} />
                  </a>
                </div>

                {isSupersededRelease(release.tag_name, highestTag) ? (
                  <p className="changelogOutdatedNotice">
                    This release is superseded by {highestTag}. Its release notes and archived documentation remain available.
                  </p>
                ) : null}
                <div className="changelogBody">
                  {releaseDescription(release.body) ? (
                    <ReactMarkdown remarkPlugins={[remarkGfm]} components={markdownComponents}>
                      {releaseDescription(release.body)}
                    </ReactMarkdown>
                  ) : (
                    <p>GitHub did not provide release notes for this version.</p>
                  )}
                </div>
              </article>
            ))}
          </div>
        </div>
      ) : null}
    </main>
  );
}
