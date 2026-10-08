import { FileText, Search, X } from "lucide-react";
import { useEffect, useEffectEvent, useMemo, useRef, useState } from "react";
import type { ChangeEvent, MouseEvent } from "react";
import { useNavigate } from "react-router";
import { docs, labelForCategory } from "../lib/docs";

export type SearchDialogProps = {
  readonly open: boolean;
  readonly onClose: () => void;
};

export function SearchDialog({ open, onClose }: SearchDialogProps) {
  const [query, setQuery] = useState("");
  const inputRef = useRef<HTMLInputElement | null>(null);
  const navigate = useNavigate();

  const results = useMemo(() => {
    const terms = query.trim().toLowerCase().split(/\s+/).filter(Boolean);
    if (terms.length === 0) return docs.slice(0, 8);

    return docs
      .map((doc) => {
        const title = doc.title.toLowerCase();
        const score = terms.reduce((total, term) => {
          if (title === term) return total + 12;
          if (title.includes(term)) return total + 7;
          if (doc.description.toLowerCase().includes(term)) return total + 3;
          if (doc.searchableText.includes(term)) return total + 1;
          return total;
        }, 0);
        const matchesAll = terms.every((term) => doc.searchableText.includes(term));
        return { doc, score, matchesAll };
      })
      .filter((entry) => entry.matchesAll && entry.score > 0)
      .sort((a, b) => b.score - a.score)
      .slice(0, 10)
      .map((entry) => entry.doc);
  }, [query]);

  useEffect(() => {
    if (!open) return;
    setQuery("");
    window.requestAnimationFrame(() => inputRef.current?.focus());
  }, [open]);

  const closeFromKeyboard = useEffectEvent(() => {
    onClose();
  });

  useEffect(() => {
    if (!open) return;
    const onKeyDown = (event: KeyboardEvent): void => {
      if (event.key === "Escape") closeFromKeyboard();
    };
    window.addEventListener("keydown", onKeyDown);
    return () => window.removeEventListener("keydown", onKeyDown);
  }, [open]);

  if (!open) return null;

  return (
    <div className="searchBackdrop" role="presentation" onMouseDown={onClose}>
      <section
        className="searchDialog"
        role="dialog"
        aria-modal="true"
        aria-label="Search documentation"
        onMouseDown={(event: MouseEvent<HTMLElement>) => event.stopPropagation()}
      >
        <div className="searchInputWrap">
          <Search size={19} />
          <input
            ref={inputRef}
            type="search"
            placeholder="Search Reactily documentation…"
            value={query}
            onChange={(event: ChangeEvent<HTMLInputElement>) => setQuery(event.target.value)}
          />
          <button type="button" aria-label="Close search" onClick={onClose}>
            <X size={17} />
          </button>
        </div>

        <div className="searchResults">
          {results.length === 0 ? (
            <div className="searchEmpty">No documentation matched “{query}”.</div>
          ) : (
            results.map((doc) => (
              <button
                className="searchResult"
                key={doc.id}
                type="button"
                onClick={() => {
                  navigate(doc.slug);
                  onClose();
                }}
              >
                <span className="searchResultIcon"><FileText size={16} /></span>
                <span className="searchResultCopy">
                  <strong>{doc.title}</strong>
                  <small>{labelForCategory(doc.category)}</small>
                </span>
              </button>
            ))
          )}
        </div>
        <div className="searchFooter">Searches all {docs.length} documentation pages locally.</div>
      </section>
    </div>
  );
}
