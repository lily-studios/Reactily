import { ArrowLeft, ArrowRight, Menu, TriangleAlert } from "lucide-react";
import { useEffect, useMemo, useState } from "react";
import { Link, useLocation } from "react-router";
import { DocsSidebar } from "../components/DocsSidebar";
import { MarkdownArticle } from "../components/MarkdownArticle";
import { TableOfContents } from "../components/TableOfContents";
import { extractHeadings, isDocDeprecated, labelForCategory } from "../lib/docs";
import { reactilyRuntime } from "../lib/runtime";
import { useVersionedDocs } from "../lib/versioned-docs";

export function DocPage() {
  const location = useLocation();
  const { tag, docs, status, error, path } = useVersionedDocs();
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const slug = location.pathname.replace(/\/$/, "") || "/docs/intro";
  const doc = docs.find((record) => record.slug === slug);

  useEffect(() => {
    setSidebarOpen(false);
    window.scrollTo({ top: 0, behavior: "auto" });
  }, [slug, tag]);

  const navigation = useMemo(() => {
    if (!doc) return { previous: undefined, next: undefined };
    const section = docs.filter((candidate) => candidate.category === doc.category);
    const index = section.findIndex((candidate) => candidate.id === doc.id);
    return {
      previous: index > 0 ? section[index - 1] : undefined,
      next: index >= 0 && index < section.length - 1 ? section[index + 1] : undefined,
    };
  }, [docs, doc]);

  if (status === "loading") {
    return <main className="container versionDocsMessage" role="status">Loading {tag ?? "release"} documentation…</main>;
  }
  if (status === "error") {
    return (
      <main className="container versionDocsMessage" role="alert">
        <h1>Version documentation unavailable</h1>
        <p>{error}</p>
        <Link to={path("/api")}>Back to the version's API reference</Link>
      </main>
    );
  }
  if (!doc) {
    return (
      <main className="notFoundPage container">
        <span className="sectionEyebrow">Documentation</span>
        <h1>{tag ? `This page is not available in ${tag}.` : "Documentation page not found."}</h1>
        <p>{tag ? "The selected release does not contain this API or documentation page." : "The route does not match a documentation page."}</p>
        <Link className="button primaryButton" to={path(tag ? "/api" : "/docs/intro")}>Browse available docs</Link>
      </main>
    );
  }

  const deprecated = isDocDeprecated(doc, tag ?? `v${reactilyRuntime.version}`);
  const headings = extractHeadings(doc.body);
  return (
    <main className="docsShell">
      <button className="mobileDocsToggle" type="button" aria-expanded={sidebarOpen}
        aria-controls="docs-sidebar" onClick={() => setSidebarOpen((current) => !current)}>
        <Menu size={16} /> Documentation menu
      </button>
      <div id="docs-sidebar" className={`docsSidebarWrap${sidebarOpen ? " open" : ""}`}>
        <DocsSidebar onNavigate={() => setSidebarOpen(false)} />
      </div>
      <article className="docsArticle">
        <div className="docBreadcrumb">
          <Link to={path("/docs/intro")}>Docs</Link><span>/</span>
          <span>{labelForCategory(doc.category)}</span>
          {tag ? <><span>/</span><span>{tag}</span></> : null}
        </div>
        <header className="docHeader">
          <h1>
            {doc.title}
            {doc.experimental ? <span className="experimentalFlag">Experimental</span> : null}
            {deprecated ? <span className="deprecatedFlag">Deprecated</span> : null}
          </h1>
          <p>{doc.description}</p>
        </header>
        {doc.experimental ? (
          <div className="experimentalNotice experimentalNotice--page" role="note" aria-label="Experimental API warning">
            <TriangleAlert size={18} aria-hidden="true" />
            <div><strong>Experimental API</strong>
              <p>This API may contain bugs, cause errors, or change without notice. Test it before using it in production.</p>
            </div>
          </div>
        ) : null}
        {deprecated ? (
          <div className="deprecatedNotice" role="note" aria-label="Deprecated API warning">
            <TriangleAlert size={18} aria-hidden="true" />
            <div><strong>Deprecated API</strong>
              <p>
                {doc.deprecationMessage ?? "This API is deprecated and may be removed in a future release."}
                {doc.replacement ? ` Use ${doc.replacement} instead.` : ""}
              </p>
            </div>
          </div>
        ) : null}
        <div className="markdownBody"><MarkdownArticle doc={doc} /></div>
        <nav className="docPagination" aria-label="Documentation pagination">
          {navigation.previous ? (
            <Link to={path(navigation.previous.slug)}>
              <span><ArrowLeft size={14} /> Previous</span>
              <strong>{navigation.previous.title}</strong>
            </Link>
          ) : <span />}
          {navigation.next ? (
            <Link to={path(navigation.next.slug)} className="next">
              <span>Next <ArrowRight size={14} /></span>
              <strong>{navigation.next.title}</strong>
            </Link>
          ) : null}
        </nav>
      </article>
      <TableOfContents headings={headings} />
    </main>
  );
}
