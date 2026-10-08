import { formatDocumentationMarkdown } from "./doc-format";

export type DocFrontmatter = {
  readonly title?: string;
  readonly description?: string;
  readonly sidebarPosition?: number;
  readonly experimental?: boolean;
  readonly since?: string;
  readonly removedIn?: string;
  readonly deprecated?: boolean;
  readonly deprecatedSince?: string;
  readonly deprecationMessage?: string;
  readonly replacement?: string;
};

export type DocRecord = {
  readonly id: string;
  readonly slug: string;
  readonly sourcePath: string;
  readonly title: string;
  readonly description: string;
  readonly sidebarPosition: number;
  readonly category: string;
  readonly body: string;
  readonly searchableText: string;
  readonly experimental: boolean;
  readonly since?: string;
  readonly removedIn?: string;
  readonly deprecated: boolean;
  readonly deprecatedSince?: string;
  readonly deprecationMessage?: string;
  readonly replacement?: string;
  readonly archivePath?: string;
};

export type DocGroup = {
  readonly id: string;
  readonly label: string;
  readonly docs: readonly DocRecord[];
};

const rawModules = import.meta.glob<string>("/src/content/**/*.md", {
  eager: true,
  query: "?raw",
  import: "default",
});

const categoryLabels: Readonly<Record<string, string>> = {
  concepts: "Core concepts",
  guides: "Guides",
  reference: "Reference",
  "advanced-components": "Advanced Components",
  animation: "Animation & Transitions",
  bindings: "Bindings",
  diagnostics: "Diagnostics & Strict Mode",
  focus: "Focus & Interaction",
  hooks: "Hooks",
  modules: "Public Modules",
  package: "Package",
  "pools-runtime": "Pools & Runtime",
  signals: "Signals",
  special: "Special APIs",
  state: "State & Stores",
  "theme-style": "Theme & Style",
  "typed-creators": "Typed Creators",
  legacy: "Version 1.1 public API",
  "virtual-tree": "Virtual Tree & Roots",
  virtualization: "Virtualization",
};

function titleCase(value: string): string {
  return value
    .split("-")
    .filter(Boolean)
    .map((part) => `${part.charAt(0).toUpperCase()}${part.slice(1)}`)
    .join(" ");
}

function unquote(value: string): string {
  const trimmed = value.trim();
  if (
    (trimmed.startsWith('"') && trimmed.endsWith('"')) ||
    (trimmed.startsWith("'") && trimmed.endsWith("'"))
  ) {
    return trimmed.slice(1, -1);
  }
  return trimmed;
}

function parseFrontmatter(source: string): { frontmatter: DocFrontmatter; body: string } {
  if (!source.startsWith("---\n")) {
    return { frontmatter: {}, body: source };
  }

  const closingIndex = source.indexOf("\n---\n", 4);
  if (closingIndex === -1) {
    return { frontmatter: {}, body: source };
  }

  const rawFrontmatter = source.slice(4, closingIndex);
  const body = source.slice(closingIndex + 5);
  const values: Record<string, string> = {};

  for (const line of rawFrontmatter.split("\n")) {
    const separator = line.indexOf(":");
    if (separator === -1) continue;
    values[line.slice(0, separator).trim()] = unquote(line.slice(separator + 1));
  }

  const position = Number(values.sidebar_position ?? Number.POSITIVE_INFINITY);

  return {
    frontmatter: {
      ...(values.title ? { title: values.title } : {}),
      ...(values.description ? { description: values.description } : {}),
      sidebarPosition: Number.isFinite(position) ? position : Number.POSITIVE_INFINITY,
      experimental: values.experimental?.toLowerCase() === "true",
      ...(values.since ? { since: values.since } : {}),
      ...(values.removed_in ? { removedIn: values.removed_in } : {}),
      deprecated: values.deprecated?.toLowerCase() === "true",
      ...(values.deprecated_since ? { deprecatedSince: values.deprecated_since } : {}),
      ...(values.deprecation_message ? { deprecationMessage: values.deprecation_message } : {}),
      ...(values.replacement ? { replacement: values.replacement } : {}),
    },
    body,
  };
}

function firstHeading(body: string): string | undefined {
  const match = /^#\s+(.+)$/m.exec(body);
  return match?.[1]?.replace(/[`*_]/g, "").trim();
}

function descriptionFromBody(body: string): string {
  const paragraph = body
    .split(/\n\s*\n/)
    .map((part) => part.trim())
    .find((part) => part.length > 40 && !part.startsWith("#") && !part.startsWith("```"));

  if (!paragraph) return "Reactily documentation.";

  return paragraph
    .replace(/\[([^\]]+)\]\([^\)]+\)/g, "$1")
    .replace(/[`*_>#-]/g, "")
    .replace(/\s+/g, " ")
    .trim()
    .slice(0, 180);
}

function stripDuplicateTitle(body: string, title: string): string {
  const lines = body.split("\n");
  const firstContentIndex = lines.findIndex((line) => line.trim().length > 0);
  if (firstContentIndex === -1) return body;

  const first = lines[firstContentIndex]?.trim() ?? "";
  if (first === `# ${title}`) {
    lines.splice(firstContentIndex, 1);
  }
  return lines.join("\n").trim();
}

function pathToSlug(path: string): string {
  const relative = path.replace("/src/content/", "").replace(/\.md$/, "");
  if (relative === "intro") return "/docs/intro";
  return `/docs/${relative}`;
}

function categoryFor(path: string): string {
  const relative = path.replace("/src/content/", "");
  const parts = relative.split("/");
  if (parts.length === 1) return "start";
  if (parts[0] === "api") return parts[1] ?? "api";
  return parts[0] ?? "other";
}

export function createDoc(path: string, source: string): DocRecord {
  const { frontmatter, body: rawBody } = parseFrontmatter(source);
  const fallbackTitle = firstHeading(rawBody) ?? titleCase(path.split("/").at(-1)?.replace(/\.md$/, "") ?? "Document");
  const title = frontmatter.title ?? fallbackTitle;
  const body = formatDocumentationMarkdown(stripDuplicateTitle(rawBody, title));
  const category = categoryFor(path);
  const description = frontmatter.description ?? descriptionFromBody(body);

  return {
    id: path,
    slug: pathToSlug(path),
    sourcePath: path.replace("/src/content/", ""),
    title,
    description,
    sidebarPosition: frontmatter.sidebarPosition ?? Number.POSITIVE_INFINITY,
    category,
    body,
    experimental: frontmatter.experimental ?? false,
    deprecated: frontmatter.deprecated ?? false,
    ...(frontmatter.since ? { since: frontmatter.since } : {}),
    ...(frontmatter.removedIn ? { removedIn: frontmatter.removedIn } : {}),
    ...(frontmatter.deprecatedSince ? { deprecatedSince: frontmatter.deprecatedSince } : {}),
    ...(frontmatter.deprecationMessage ? { deprecationMessage: frontmatter.deprecationMessage } : {}),
    ...(frontmatter.replacement ? { replacement: frontmatter.replacement } : {}),
    searchableText: `${title} ${description} ${body} ${frontmatter.experimental ? "experimental" : ""} ${frontmatter.deprecated ? "deprecated" : ""}`.toLowerCase(),
  };
}

export const docs: readonly DocRecord[] = Object.entries(rawModules)
  .map(([path, source]) => createDoc(path, source))
  .sort((a, b) => {
    if (a.sidebarPosition !== b.sidebarPosition) return a.sidebarPosition - b.sidebarPosition;
    return a.title.localeCompare(b.title);
  });

export const docsBySlug: ReadonlyMap<string, DocRecord> = new Map(docs.map((doc) => [doc.slug, doc]));

export const startDocs: readonly DocRecord[] = docs.filter((doc) => doc.category === "start");
export const conceptDocs: readonly DocRecord[] = docs.filter((doc) => doc.category === "concepts");
export const guideDocs: readonly DocRecord[] = docs.filter((doc) => doc.category === "guides");
export const referenceDocs: readonly DocRecord[] = docs.filter((doc) => doc.category === "reference");
export const apiDocs: readonly DocRecord[] = docs.filter((doc) => doc.sourcePath.startsWith("api/"));

export function makeApiGroups(records: readonly DocRecord[]): readonly DocGroup[] {
  const apiDocsByCategory = records.filter((doc) => doc.sourcePath.startsWith("api/")).reduce<Record<string, DocRecord[]>>((groups, doc) => {
  const group = groups[doc.category] ?? [];
  group.push(doc);
  groups[doc.category] = group;
  return groups;
}, {});

  return Object.entries(apiDocsByCategory)
    .map(([id, groupDocs]) => ({
      id,
      label: categoryLabels[id] ?? titleCase(id),
      docs: [...groupDocs].sort((a, b) => a.title.localeCompare(b.title)),
    }))
    .sort((a, b) => a.label.localeCompare(b.label));
}

export const apiGroups: readonly DocGroup[] = makeApiGroups(docs);

/** Compare numeric release tags; other names only match literally. */
export function compareDocVersions(a: string, b: string): number | null {
  const normalize = (tag: string): number[] | null => {
    const match = /^(?:v\\.?)?(\\d+)(?:\\.(\\d+))?(?:\\.(\\d+))?(?:[-+].*)?$/i.exec(tag);
    return match ? [Number(match[1]), Number(match[2] ?? 0), Number(match[3] ?? 0)] : null;
  };
  const left = normalize(a);
  const right = normalize(b);
  if (!left || !right) return a === b ? 0 : null;
  for (let i = 0; i < 3; i += 1) {
    const difference = (left[i] ?? 0) - (right[i] ?? 0);
    if (difference !== 0) return difference;
  }
  return 0;
}

/** Version annotations are optional; tagged archives remain the source of truth. */
export function isDocAvailable(doc: DocRecord, tag: string): boolean {
  const since = doc.since ? compareDocVersions(tag, doc.since) : null;
  const removed = doc.removedIn ? compareDocVersions(tag, doc.removedIn) : null;
  return (since === null || since >= 0) && (removed === null || removed < 0);
}

export function isDocDeprecated(doc: DocRecord, tag: string): boolean {
  if (doc.deprecated) return true;
  if (!doc.deprecatedSince) return false;
  const comparison = compareDocVersions(tag, doc.deprecatedSince);
  return comparison !== null && comparison >= 0;
}

export function labelForCategory(category: string): string {
  return categoryLabels[category] ?? titleCase(category);
}

export function resolveDocHref(current: DocRecord, href: string): string {
  if (href === "/api" || href === "/api/") return "/api";
  if (href.startsWith("http://") || href.startsWith("https://") || href.startsWith("#")) return href;
  if (href.startsWith("/docs/")) return href.replace(/\.md$/, "");
  if (href.startsWith("/")) return href;

  const [pathPart, hash] = href.split("#", 2);
  const sourceDir = current.sourcePath.includes("/")
    ? current.sourcePath.slice(0, current.sourcePath.lastIndexOf("/") + 1)
    : "";
  const pathSegments = `${sourceDir}${pathPart ?? ""}`.split("/");
  const normalized: string[] = [];

  for (const segment of pathSegments) {
    if (!segment || segment === ".") continue;
    if (segment === "..") {
      normalized.pop();
    } else {
      normalized.push(segment);
    }
  }

  const withoutExtension = normalized.join("/").replace(/\.md$/, "");
  const route = `/docs/${withoutExtension}`;
  return hash ? `${route}#${hash}` : route;
}

export function headingId(text: string): string {
  return text
    .toLowerCase()
    .replace(/<[^>]+>/g, "")
    .replace(/[`*_~]/g, "")
    .replace(/[^a-z0-9\s-]/g, "")
    .trim()
    .replace(/\s+/g, "-")
    .replace(/-+/g, "-");
}

export type TocHeading = {
  readonly id: string;
  readonly text: string;
  readonly level: 2 | 3;
};

export function extractHeadings(body: string): readonly TocHeading[] {
  const headings: TocHeading[] = [];
  const pattern = /^(##|###)\s+(.+)$/gm;
  let match: RegExpExecArray | null;

  while ((match = pattern.exec(body)) !== null) {
    const marker = match[1];
    const rawText = match[2];
    if (!marker || !rawText) continue;
    const text = rawText.replace(/\[([^\]]+)\]\([^\)]+\)/g, "$1").replace(/[`*_~]/g, "").trim();
    headings.push({
      id: headingId(text),
      text,
      level: marker === "##" ? 2 : 3,
    });
  }

  return headings;
}
