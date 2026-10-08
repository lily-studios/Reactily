import { ArrowRight, Box, Search } from "lucide-react";
import { useMemo, useState } from "react";
import type { ChangeEvent } from "react";
import { Link } from "react-router";
import { isDocDeprecated, makeApiGroups } from "../lib/docs";
import { useVersionedDocs } from "../lib/versioned-docs";
import { reactilyRuntime } from "../lib/runtime";
import { highestNumberedReleaseTag, isSupersededRelease } from "../lib/release-lifecycle";

export function ApiPage() {
  const [query, setQuery] = useState("");
  const { tag, docs, releases, status, error, path } = useVersionedDocs();
  const highestTag = highestNumberedReleaseTag(releases.map((release) => release.tag));
  const outdatedVersion = tag !== null && isSupersededRelease(tag, highestTag);
  const apiGroups = useMemo(() => makeApiGroups(docs), [docs]);
  const apiCount = apiGroups.reduce((sum, group) => sum + group.docs.length, 0);
  const [expanded, setExpanded] = useState<ReadonlySet<string>>(() => new Set());

  const groups = useMemo(() => {
    const normalized = query.trim().toLowerCase();
    if (!normalized) return apiGroups;
    return apiGroups
      .map((group) => ({
        ...group,
        docs: group.docs.filter((doc) => doc.searchableText.includes(normalized)),
      }))
      .filter((group) => group.docs.length > 0 || group.label.toLowerCase().includes(normalized));
  }, [query, apiGroups]);

  const toggleGroup = (id: string): void => {
    setExpanded((current) => {
      const next = new Set(current);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  };

  return (
    <main className="apiPage">
      <section className="apiHero">
        <div className="container">
          <span className="sectionEyebrow">Reference</span>
          <div className="apiHeroGrid">
            <div>
              <h1>Reactily API</h1>
              <p>Find the right function, learn what it does, and follow its usage examples. This reference follows Reactily {tag ?? `v${reactilyRuntime.version}`}.</p>
            </div>
            <div className="apiStatCard">
              <strong>{tag ? apiCount : reactilyRuntime.apiExportCount}</strong>
              <span>{tag ? "Public API pages in this release" : `Runtime exports · ${reactilyRuntime.apiTypeCount} public types`}</span>
            </div>
          </div>
          <label className="apiSearch">
            <Search size={18} />
            <input type="search" aria-label="Search APIs" value={query} onChange={(event: ChangeEvent<HTMLInputElement>) => setQuery(event.target.value)} placeholder="Search functions, types, and usage…" />
          </label>
        </div>
      </section>

      {status === "ready" && outdatedVersion ? (
        <div className="container deprecatedNotice deprecatedNotice--release" role="note">
          <div><strong>Deprecated version: {tag}</strong>
            <p>A newer release ({highestTag}) exists. These APIs are preserved from {tag}; this does not automatically deprecate each API.</p>
          </div>
        </div>
      ) : null}
      {status === "loading" ? <div className="container versionDocsMessage" role="status">Loading {tag} documentation…</div> : null}
      {status === "error" ? <div className="container versionDocsMessage" role="alert">{error}</div> : null}
      {status === "ready" && tag ? <p className="container versionDocsCaption">Documented APIs for Reactily {tag}. Other releases may have different APIs.</p> : null}
      {status === "ready" ? <section className="container apiGroupsGrid" aria-label="API categories">
        {groups.map((group) => (
          <article className="apiGroupCard" key={group.id}>
            <div className="apiGroupHeader">
              <span><Box size={17} /></span>
              <div>
                <h2>{group.label}</h2>
                <p>{group.docs.length} {group.docs.length === 1 ? "API" : "APIs"}</p>
              </div>
            </div>
            <div className="apiFunctionList">
              {(query.trim() || expanded.has(group.id) ? group.docs : group.docs.slice(0, 6)).map((doc) => (
                <Link key={doc.id} to={path(doc.slug)}>
                  <span className="apiFunctionLabel">
                    <code>{doc.title}</code>
                    {doc.experimental ? <span className="experimentalFlag experimentalFlag--small">Experimental</span> : null}
                    {isDocDeprecated(doc, tag ?? `v${reactilyRuntime.version}`) ? <span className="deprecatedFlag deprecatedFlag--small">Deprecated</span> : null}
                  </span>
                  <ArrowRight size={14} />
                </Link>
              ))}
            </div>
            {group.docs.length > 6 && !query.trim() ? (
              <button type="button" className="apiMore" aria-expanded={expanded.has(group.id)} onClick={() => toggleGroup(group.id)}>
                {expanded.has(group.id) ? "Show fewer" : `Show all ${group.docs.length}`} <ArrowRight size={14} />
              </button>
            ) : null}
          </article>
        ))}
        {groups.length === 0 ? <div className="apiNoResults">No API entries matched “{query}”.</div> : null}
      </section> : null}
    </main>
  );
}
