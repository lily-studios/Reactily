import { ArrowRight, Box, Search, ChevronDown, Menu } from "lucide-react";
import "./api-sidebar.css";
import { DeprecatedVersionNotice } from "../components/DeprecatedVersionNotice";
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
  const highestTag = highestNumberedReleaseTag(releases.filter((release) => release.channel === "stable").map((release) => release.tag));
  const outdatedVersion = tag !== null && isSupersededRelease(tag, highestTag);
  const apiGroups = useMemo(() => makeApiGroups(docs), [docs]);
  const apiCount = apiGroups.reduce((sum, group) => sum + group.docs.length, 0);
  const [expanded, setExpanded] = useState<ReadonlySet<string>>(() => new Set());
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [activeGroup, setActiveGroup] = useState<string | null>(null);

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

      {status === "ready" && outdatedVersion && tag && highestTag ? (
        <DeprecatedVersionNotice currentVersion={tag} latestVersion={highestTag} context="api" />
      ) : null}
      {status === "loading" ? <div className="container versionDocsMessage" role="status">Loading {tag} documentation…</div> : null}
      {status === "error" ? <div className="container versionDocsMessage" role="alert">{error}</div> : null}
      {status === "ready" && tag ? <p className="container versionDocsCaption">Documented APIs for Reactily {tag}. Other releases may have different APIs.</p> : null}
      {status === "ready" ? (
        <div className="container apiReferenceLayout">
          <button className="apiSidebarMobileToggle" type="button" onClick={() => setMobileMenuOpen((value) => !value)} aria-expanded={mobileMenuOpen} aria-controls="api-reference-sidebar">
            <Menu size={16} /> Browse API categories
          </button>
          <aside id="api-reference-sidebar" className={`apiReferenceSidebar${mobileMenuOpen ? " open" : ""}`} aria-label="API reference navigation">
            <p className="apiReferenceSidebarHeading">API Reference <span>{apiCount}</span></p>
            {groups.map((group) => (
              <div className="apiSidebarGroup" key={group.id}>
                <button type="button" className={`apiSidebarGroupToggle${activeGroup === group.id ? " selected" : ""}`} aria-expanded={expanded.has(group.id) || !!query.trim()} onClick={() => { toggleGroup(group.id); setActiveGroup(group.id); }}>
                  <span>{group.label} <small>{group.docs.length}</small></span><ChevronDown size={15} />
                </button>
                {(expanded.has(group.id) || !!query.trim()) && (
                  <div className="apiSidebarEntries">
                    {group.docs.map((doc) => <Link key={doc.id} to={path(doc.slug)} onClick={() => setMobileMenuOpen(false)}>{doc.title}</Link>)}
                  </div>
                )}
              </div>
            ))}
            {groups.length === 0 ? <p>No matching categories.</p> : null}
          </aside>
          <section className="apiReferenceContent" aria-label="API categories">
            <div className="apiReferenceIntro"><h2>Browse the API</h2><p>Select a category in the sidebar, or search by name or functionality. Each entry links to its explanation, types, and usage examples.</p></div>
            {groups.map((group) => (
              <article className="apiGroupCard" key={group.id} id={`api-group-${group.id}`}>
                <div className="apiGroupHeader"><span><Box size={17} /></span><div><h2>{group.label}</h2><p>{group.docs.length} {group.docs.length === 1 ? "API" : "APIs"}</p></div></div>
                <div className="apiFunctionList">
                  {(query.trim() || expanded.has(group.id) ? group.docs : group.docs.slice(0, 8)).map((doc) => (
                    <Link key={doc.id} to={path(doc.slug)}><span className="apiFunctionLabel"><code>{doc.title}</code>{doc.experimental ? <span className="experimentalFlag experimentalFlag--small">Experimental</span> : null}{isDocDeprecated(doc, tag ?? `v${reactilyRuntime.version}`) ? <span className="deprecatedFlag deprecatedFlag--small">Deprecated</span> : null}</span><ArrowRight size={14} /></Link>
                  ))}
                </div>
                {group.docs.length > 8 && !query.trim() ? <button type="button" className="apiMore" onClick={() => toggleGroup(group.id)}>{expanded.has(group.id) ? "Show fewer" : `Show all ${group.docs.length}`} <ArrowRight size={14} /></button> : null}
              </article>
            ))}
            {groups.length === 0 ? <div className="apiNoResults">No API entries matched “{query}”.</div> : null}
          </section>
        </div>
      ) : null}
    </main>
  );
}
