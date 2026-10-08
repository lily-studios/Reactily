import { ChevronDown, ChevronRight } from "lucide-react";
import { useEffect, useState } from "react";
import { NavLink, useLocation } from "react-router";
import { makeApiGroups } from "../lib/docs";
import { useVersionedDocs } from "../lib/versioned-docs";
import type { DocGroup, DocRecord } from "../lib/docs";

type NavigationProps = {
  readonly onNavigate?: (() => void) | undefined;
};

type DocLinksProps = NavigationProps & {
  readonly docs: readonly DocRecord[];
};

function DocLinks({ docs, onNavigate }: DocLinksProps) {
  const { path } = useVersionedDocs();
  return (
    <div className="sidebarLinks">
      {docs.map((doc) => (
        <NavLink
          key={doc.id}
          to={path(doc.slug)}
          end
          onClick={onNavigate}
          className={({ isActive }) => isActive ? "active" : undefined}
        >
          {doc.title}
        </NavLink>
      ))}
    </div>
  );
}

function ApiGroup({ group, onNavigate }: NavigationProps & { readonly group: DocGroup }) {
  const { pathname } = useLocation();
  const containsCurrentPage = group.docs.some(
    (doc) => doc.slug === pathname.replace(/\/$/, ""),
  );
  const [open, setOpen] = useState(containsCurrentPage);
  const groupId = `sidebar-api-${group.id}`;

  useEffect(() => {
    if (containsCurrentPage) setOpen(true);
  }, [containsCurrentPage]);

  return (
    <div className={`sidebarNestedGroup${containsCurrentPage ? " currentGroup" : ""}`}>
      <h3 className="sidebarGroupHeading">
        <button
          className="sidebarGroupToggle"
          type="button"
          aria-expanded={open}
          aria-controls={groupId}
          onClick={() => setOpen((current) => !current)}
        >
          <span className="sidebarGroupName">{group.label}</span>
          <span className="sidebarGroupCount" aria-label={`${group.docs.length} pages`}>
            {group.docs.length}
          </span>
          {open ? <ChevronDown size={15} aria-hidden="true" /> : <ChevronRight size={15} aria-hidden="true" />}
        </button>
      </h3>
      {open ? (
        <div id={groupId} className="sidebarNestedLinks">
          <DocLinks docs={group.docs} onNavigate={onNavigate} />
        </div>
      ) : null}
    </div>
  );
}

export function DocsSidebar({ onNavigate }: NavigationProps) {
  const { pathname } = useLocation();
  const { docs } = useVersionedDocs();
  const startDocs = docs.filter((doc) => doc.category === "start");
  const conceptDocs = docs.filter((doc) => doc.category === "concepts");
  const guideDocs = docs.filter((doc) => doc.category === "guides");
  const referenceDocs = docs.filter((doc) => doc.category === "reference");
  const apiGroups = makeApiGroups(docs);
  const isApiRoute = pathname.startsWith("/docs/api/");
  const [apiOpen, setApiOpen] = useState(isApiRoute);

  useEffect(() => {
    if (isApiRoute) setApiOpen(true);
  }, [isApiRoute]);

  return (
    <aside className="docsSidebar">
      <nav aria-label="Documentation sections">
        <section className="sidebarSection">
          <h2 className="sidebarLabel">Get started</h2>
          <DocLinks docs={startDocs} onNavigate={onNavigate} />
        </section>
        <section className="sidebarSection">
          <h2 className="sidebarLabel">Core concepts</h2>
          <DocLinks docs={conceptDocs} onNavigate={onNavigate} />
        </section>
        <section className="sidebarSection">
          <h2 className="sidebarLabel">Guides</h2>
          <DocLinks docs={guideDocs} onNavigate={onNavigate} />
        </section>
        <section className="sidebarSection">
          <h2 className="sidebarLabel sidebarAccordionHeading">
            <button
              className="sidebarCategoryButton"
              type="button"
              aria-expanded={apiOpen}
              aria-controls="sidebar-api-groups"
              onClick={() => setApiOpen((current) => !current)}
            >
              <span>API Reference</span>
              {apiOpen ? <ChevronDown size={16} aria-hidden="true" /> : <ChevronRight size={16} aria-hidden="true" />}
            </button>
          </h2>
          {apiOpen ? (
            <div className="sidebarApiGroups" id="sidebar-api-groups">
              {apiGroups.map((group) => (
                <ApiGroup key={group.id} group={group} onNavigate={onNavigate} />
              ))}
            </div>
          ) : null}
        </section>
        <section className="sidebarSection">
          <h2 className="sidebarLabel">More resources</h2>
          <DocLinks docs={referenceDocs} onNavigate={onNavigate} />
        </section>
      </nav>
    </aside>
  );
}
