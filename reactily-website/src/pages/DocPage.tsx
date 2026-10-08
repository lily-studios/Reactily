import { ArrowLeft, ArrowRight, Menu } from "lucide-react";
import { useEffect, useMemo, useState } from "react";
import { Link, useLocation } from "react-router";
import { DocsSidebar } from "../components/DocsSidebar";
import { MarkdownArticle } from "../components/MarkdownArticle";
import { TableOfContents } from "../components/TableOfContents";
import { docs, docsBySlug, extractHeadings, labelForCategory } from "../lib/docs";

export function DocPage() {
  const location = useLocation();
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const slug = location.pathname.replace(/\/$/, "") || "/docs/intro";
  const doc = docsBySlug.get(slug);

  useEffect(() => {
    setSidebarOpen(false);
    window.scrollTo({ top: 0, behavior: "auto" });
  }, [slug]);

  const navigation = useMemo(() => {
    if (!doc) return { previous: undefined, next: undefined };
    const sectionDocs = docs.filter((candidate) => candidate.category === doc.category);
    const index = sectionDocs.findIndex((candidate) => candidate.id === doc.id);
    return {
      previous: index > 0 ? sectionDocs[index - 1] : undefined,
      next: index >= 0 && index < sectionDocs.length - 1 ? sectionDocs[index + 1] : undefined,
    };
  }, [doc]);

  if (!doc) {
    return (
      <main className="notFoundPage container">
        <span className="sectionEyebrow">404</span>
        <h1>Documentation page not found.</h1>
        <p>The route does not match any page bundled with this documentation site.</p>
        <Link className="button primaryButton" to="/docs/intro">Back to docs</Link>
      </main>
    );
  }

  const headings = extractHeadings(doc.body);

  return (
    <main className="docsShell">
      <button className="mobileDocsToggle" type="button" aria-expanded={sidebarOpen} aria-controls="docs-sidebar" onClick={() => setSidebarOpen((current) => !current)}>
        <Menu size={16} /> Documentation menu
      </button>
      <div id="docs-sidebar" className={`docsSidebarWrap${sidebarOpen ? " open" : ""}`}>
        <DocsSidebar onNavigate={() => setSidebarOpen(false)} />
      </div>

      <article className="docsArticle">
        <div className="docBreadcrumb">
          <Link to="/docs/intro">Docs</Link>
          <span>/</span>
          <span>{labelForCategory(doc.category)}</span>
        </div>
        <header className="docHeader">
          <h1>{doc.title}</h1>
          <p>{doc.description}</p>
        </header>
        <div className="markdownBody">
          <MarkdownArticle doc={doc} />
        </div>
        <nav className="docPagination" aria-label="Documentation pagination">
          {navigation.previous ? (
            <Link to={navigation.previous.slug}>
              <span><ArrowLeft size={14} /> Previous</span>
              <strong>{navigation.previous.title}</strong>
            </Link>
          ) : <span />}
          {navigation.next ? (
            <Link to={navigation.next.slug} className="next">
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
