import { ArrowRight, Box, Search } from "lucide-react";
import { useMemo, useState } from "react";
import type { ChangeEvent } from "react";
import { Link } from "react-router";
import { apiGroups } from "../lib/docs";
import { reactilyRuntime } from "../lib/runtime";

export function ApiPage() {
  const [query, setQuery] = useState("");

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

  return (
    <main className="apiPage">
      <section className="apiHero">
        <div className="container">
          <span className="sectionEyebrow">Reference</span>
          <div className="apiHeroGrid">
            <div>
              <h1>Reactily API</h1>
              <p>Reference for Reactily v{reactilyRuntime.version}: runtime exports, public Luau types, signatures, behavior notes, parameters, and examples.</p>
            </div>
            <div className="apiStatCard">
              <strong>{reactilyRuntime.apiExportCount}</strong>
              <span>runtime exports documented · {reactilyRuntime.apiTypeCount} public types</span>
            </div>
          </div>
          <label className="apiSearch">
            <Search size={18} />
            <input value={query} onChange={(event: ChangeEvent<HTMLInputElement>) => setQuery(event.target.value)} placeholder="Filter the API reference…" />
          </label>
        </div>
      </section>

      <section className="container apiGroupsGrid">
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
              {group.docs.slice(0, 6).map((doc) => (
                <Link key={doc.id} to={doc.slug}>
                  <code>{doc.title}</code><ArrowRight size={14} />
                </Link>
              ))}
            </div>
            {group.docs.length > 6 ? (
              <Link className="apiMore" to={group.docs[0]?.slug ?? "/docs/intro"}>
                Browse all {group.docs.length} <ArrowRight size={14} />
              </Link>
            ) : null}
          </article>
        ))}
        {groups.length === 0 ? <div className="apiNoResults">No API entries matched “{query}”.</div> : null}
      </section>
    </main>
  );
}
