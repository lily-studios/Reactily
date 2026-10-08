import type { TocHeading } from "../lib/docs";

export function TableOfContents({ headings }: { readonly headings: readonly TocHeading[] }) {
  if (headings.length === 0) return null;

  return (
    <aside className="tableOfContents">
      <span>On this page</span>
      <nav>
        {headings.map((heading) => (
          <a key={`${heading.level}-${heading.id}`} href={`#${heading.id}`} className={heading.level === 3 ? "nested" : undefined}>
            {heading.text}
          </a>
        ))}
      </nav>
    </aside>
  );
}
