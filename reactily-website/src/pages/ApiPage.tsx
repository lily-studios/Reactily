import { ArrowRight, Box, Search } from "lucide-react";
import { useMemo, useState } from "react";
import type { ChangeEvent } from "react";
import { Link } from "react-router";
import { apiGroups } from "../lib/docs";
import { reactilyRuntime } from "../lib/runtime";

export function ApiPage() {
  const [query, setQuery] = useState("");
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
  }, [query]);

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
              <p>Find the right function, learn what it does, and follow its usage examples. This reference follows Reactily v{reactilyRuntime.version}.</p>
            </div>
            <div className="apiStatCard">
              <strong>{reactilyRuntime.apiExportCount}</strong>
              <span>runtime exports documented · {reactilyRuntime.apiTypeCount} public types</span>
            </div>
          </div>
          <label className="apiSearch">
            <Search size={18} />
            <input type="search" aria-label="Search APIs" value={query} onChange={(event: ChangeEvent<HTMLInputElement>) => setQuery(event.target.value)} placeholder="Search functions, types, and usage…" />
          </label>
        </div>
      </section>

      <section className="container apiGroupsGrid" aria-label="API categories">
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
                <Link key={doc.id} to={doc.slug}>
                  <span className="apiFunctionLabel">
                    <code>{doc.title}</code>
                    {doc.experimental ? <span className="experimentalFlag experimentalFlag--small">Experimental</span> : null}
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
      </section>
    </main>
  );
}
