import { ChevronDown, ChevronRight } from "lucide-react";
import { useState } from "react";
import { NavLink } from "react-router";
import { apiGroups, conceptDocs, guideDocs, referenceDocs, startDocs } from "../lib/docs";
import type { DocGroup, DocRecord } from "../lib/docs";

function DocLinks({ docs }: { readonly docs: readonly DocRecord[] }) {
  return (
    <div className="sidebarLinks">
      {docs.map((doc) => (
        <NavLink key={doc.id} to={doc.slug} className={({ isActive }: { readonly isActive: boolean }) => (isActive ? "active" : undefined)}>
          {doc.title}
        </NavLink>
      ))}
    </div>
  );
}

function ApiGroup({ group }: { readonly group: DocGroup }) {
  const [open, setOpen] = useState(false);
  return (
    <div className="sidebarNestedGroup">
      <button type="button" onClick={() => setOpen((current) => !current)}>
        {open ? <ChevronDown size={14} /> : <ChevronRight size={14} />}
        {group.label}
        <span>{group.docs.length}</span>
      </button>
      {open ? <DocLinks docs={group.docs} /> : null}
    </div>
  );
}

export function DocsSidebar() {
  const [apiOpen, setApiOpen] = useState(false);

  return (
    <aside className="docsSidebar">
      <div className="sidebarSection">
        <span className="sidebarLabel">Start here</span>
        <DocLinks docs={startDocs} />
      </div>
      <div className="sidebarSection">
        <span className="sidebarLabel">Core concepts</span>
        <DocLinks docs={conceptDocs} />
      </div>
      <div className="sidebarSection">
        <span className="sidebarLabel">Guides</span>
        <DocLinks docs={guideDocs} />
      </div>
      <div className="sidebarSection">
        <button className="sidebarCategoryButton" type="button" onClick={() => setApiOpen((current) => !current)}>
          <span>API Reference</span>
          {apiOpen ? <ChevronDown size={15} /> : <ChevronRight size={15} />}
        </button>
        {apiOpen ? (
          <div className="sidebarApiGroups">
            {apiGroups.map((group) => <ApiGroup key={group.id} group={group} />)}
          </div>
        ) : null}
      </div>
      <div className="sidebarSection">
        <span className="sidebarLabel">Reference</span>
        <DocLinks docs={referenceDocs} />
      </div>
    </aside>
  );
}
