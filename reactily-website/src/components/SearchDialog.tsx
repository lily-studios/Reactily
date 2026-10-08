import { ArrowDown, ArrowUp, CornerDownLeft, FileText, Search, X } from "lucide-react";
import { useEffect, useMemo, useRef, useState } from "react";
import type { ChangeEvent, KeyboardEvent as ReactKeyboardEvent, MouseEvent } from "react";
import { useNavigate } from "react-router";
import { labelForCategory } from "../lib/docs";
import { useVersionedDocs } from "../lib/versioned-docs";

export type SearchDialogProps = {
  readonly open: boolean;
  readonly onClose: () => void;
};

export function SearchDialog({ open, onClose }: SearchDialogProps) {
  const [query, setQuery] = useState("");
  const [selectedIndex, setSelectedIndex] = useState(0);
  const inputRef = useRef<HTMLInputElement>(null);
  const resultRefs = useRef<Array<HTMLButtonElement | null>>([]);
  const navigate = useNavigate();
  const { docs, path } = useVersionedDocs();

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
          return total + (doc.searchableText.includes(term) ? 1 : 0);
        }, 0);
        return { doc, score, matchesAll: terms.every((term) => doc.searchableText.includes(term)) };
      })
      .filter((entry) => entry.matchesAll && entry.score > 0)
      .sort((a, b) => b.score - a.score)
      .slice(0, 10)
      .map((entry) => entry.doc);
  }, [query, docs]);

  useEffect(() => {
    if (!open) return;
    const previousFocus = document.activeElement instanceof HTMLElement ? document.activeElement : null;
    const previousOverflow = document.body.style.overflow;
    document.body.style.overflow = "hidden";
    inputRef.current?.focus();
    return () => {
      document.body.style.overflow = previousOverflow;
      previousFocus?.focus();
    };
  }, [open]);

  const selectResult = (index: number): void => {
    const doc = results[index];
    if (!doc) return;
    navigate(path(doc.slug));
    onClose();
  };

  const onInputKeyDown = (event: ReactKeyboardEvent<HTMLInputElement>): void => {
    if (event.key === "ArrowDown" || event.key === "ArrowUp") {
      event.preventDefault();
      if (!results.length) return;
      setSelectedIndex((current) => (current + (event.key === "ArrowDown" ? 1 : -1) + results.length) % results.length);
    } else if (event.key === "Enter") {
      event.preventDefault();
      selectResult(selectedIndex);
    } else if (event.key === "Escape") {
      event.preventDefault();
      onClose();
    }
  };

  useEffect(() => {
    resultRefs.current[selectedIndex]?.scrollIntoView({ block: "nearest", behavior: "instant" });
  }, [selectedIndex]);

  if (!open) return null;

  return (
    <div className="searchBackdrop" role="presentation" onMouseDown={onClose}>
      <section
        className="searchDialog"
        role="dialog"
        aria-modal="true"
        aria-labelledby="search-dialog-title"
        onMouseDown={(event: MouseEvent<HTMLElement>) => event.stopPropagation()}
      >
        <div className="searchInputWrap">
          <Search size={19} aria-hidden="true" />
          <label id="search-dialog-title" className="srOnly" htmlFor="docs-search-input">Search documentation</label>
          <input
            id="docs-search-input"
            ref={inputRef}
            type="search"
            autoComplete="off"
            role="combobox"
            aria-autocomplete="list"
            aria-controls="docs-search-results"
            aria-expanded={results.length > 0}
            aria-activedescendant={results[selectedIndex] ? `docs-search-result-${selectedIndex}` : undefined}
            placeholder="Search APIs, guides, examples..."
            value={query}
            onKeyDown={onInputKeyDown}
            onChange={(event: ChangeEvent<HTMLInputElement>) => { setQuery(event.target.value); setSelectedIndex(0); }}
          />
          <button type="button" aria-label="Close search" onClick={onClose}><X size={17} /></button>
        </div>
        <div id="docs-search-results" className="searchResults" role="listbox" aria-label="Search results">
          {results.length === 0 ? (
            <div className="searchEmpty">No results for “{query}”. Try an API name or shorter keyword.</div>
          ) : results.map((doc, index) => (
            <button
              id={`docs-search-result-${index}`}
              ref={(element) => { resultRefs.current[index] = element; }}
              role="option"
              aria-selected={index === selectedIndex}
              className={`searchResult${index === selectedIndex ? " selected" : ""}`}
              key={doc.id}
              type="button"
              onMouseEnter={() => setSelectedIndex(index)}
              onClick={() => selectResult(index)}
            >
              <span className="searchResultIcon"><FileText size={16} /></span>
              <span className="searchResultCopy"><strong>{doc.title}</strong><small>{labelForCategory(doc.category)}</small></span>
              <CornerDownLeft size={14} className="searchResultEnter" aria-hidden="true" />
            </button>
          ))}
        </div>
        <div className="searchFooter">
          <span><ArrowUp size={12} /><ArrowDown size={12} /> Navigate</span>
          <span><CornerDownLeft size={12} /> Open</span>
          <span>Esc Close</span>
          <span>{docs.length} docs</span>
        </div>
      </section>
    </div>
  );
}
