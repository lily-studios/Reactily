import { ChevronDown, ChevronRight } from "lucide-react";
import { useEffect, useState } from "react";
import { NavLink, useLocation } from "react-router";
import { apiGroups, conceptDocs, guideDocs, referenceDocs, startDocs } from "../lib/docs";
import type { DocGroup, DocRecord } from "../lib/docs";

function DocLinks({ docs, onNavigate }: { readonly docs: readonly DocRecord[]; readonly onNavigate?: (() => void) | undefined }) {
  return (
    <div className="sidebarLinks">
      {docs.map((doc) => (
        <NavLink key={doc.id} to={doc.slug} onClick={onNavigate} className={({ isActive }: { readonly isActive: boolean }) => (isActive ? "active" : undefined)}>
          {doc.title}
        </NavLink>
      ))}
    </div>
  );
}

function ApiGroup({ group, onNavigate }: { readonly group: DocGroup; readonly onNavigate?: (() => void) | undefined }) {
  const { pathname } = useLocation();
  const containsCurrentPage = group.docs.some((doc) => doc.slug === pathname.replace(/\/$/, ""));
  const [open, setOpen] = useState(containsCurrentPage);

  useEffect(() => {
    if (containsCurrentPage) setOpen(true);
  }, [containsCurrentPage]);

  return (
    <div className="sidebarNestedGroup">
      <button type="button" aria-expanded={open} onClick={() => setOpen((current) => !current)}>
        {open ? <ChevronDown size={14} /> : <ChevronRight size={14} />}
        {group.label}
        <span>{group.docs.length}</span>
      </button>
      {open ? <DocLinks docs={group.docs} onNavigate={onNavigate} /> : null}
    </div>
  );
}

export function DocsSidebar({ onNavigate }: { readonly onNavigate?: (() => void) | undefined }) {
  const { pathname } = useLocation();
  const isApiRoute = pathname.startsWith("/docs/api/");
  const [apiOpen, setApiOpen] = useState(isApiRoute);

  useEffect(() => {
    if (isApiRoute) setApiOpen(true);
  }, [isApiRoute]);

  return (
    <aside className="docsSidebar">
      <div className="sidebarSection">
        <span className="sidebarLabel">Start here</span>
        <DocLinks docs={startDocs} onNavigate={onNavigate} />
      </div>
      <div className="sidebarSection">
        <span className="sidebarLabel">Core concepts</span>
        <DocLinks docs={conceptDocs} onNavigate={onNavigate} />
      </div>
      <div className="sidebarSection">
        <span className="sidebarLabel">Guides</span>
        <DocLinks docs={guideDocs} onNavigate={onNavigate} />
      </div>
      <div className="sidebarSection">
        <button className="sidebarCategoryButton" type="button" aria-expanded={apiOpen} onClick={() => setApiOpen((current) => !current)}>
          <span>API Reference</span>
          {apiOpen ? <ChevronDown size={15} /> : <ChevronRight size={15} />}
        </button>
        {apiOpen ? (
          <div className="sidebarApiGroups">
            {apiGroups.map((group) => <ApiGroup key={group.id} group={group} onNavigate={onNavigate} />)}
          </div>
        ) : null}
      </div>
      <div className="sidebarSection">
        <span className="sidebarLabel">Reference</span>
        <DocLinks docs={referenceDocs} onNavigate={onNavigate} />
      </div>
    </aside>
  );
}
