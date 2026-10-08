/** Live public release data; descriptions come from GitHub Releases, never static docs. */
export type GitHubRelease = {
  readonly id: number;
  readonly tag_name: string;
  readonly name: string | null;
  readonly body: string | null;
  readonly html_url: string;
  readonly published_at: string | null;
  readonly draft: boolean;
  readonly prerelease: boolean;
};

const RELEASES_URL = "https://api.github.com/repos/lily-studios/Reactily/releases";
const MINIMUM_VERSION = [1, 1, 0] as const;
const MAX_PAGES = 20;

function isRelease(value: unknown): value is GitHubRelease {
  if (value === null || typeof value !== "object") return false;
  const record = value as Record<string, unknown>;
  return (
    typeof record.id === "number" &&
    typeof record.tag_name === "string" &&
    (typeof record.name === "string" || record.name === null) &&
    (typeof record.body === "string" || record.body === null) &&
    typeof record.html_url === "string" &&
    (typeof record.published_at === "string" || record.published_at === null) &&
    typeof record.draft === "boolean" &&
    typeof record.prerelease === "boolean"
  );
}

function parseVersion(tag: string): readonly [number, number, number] | null {
  const match = /^v?(\d+)\.(\d+)\.(\d+)(?:[-+].*)?$/i.exec(tag);
  if (!match) return null;
  const parts = match.slice(1).map(Number);
  if (parts.length !== 3 || parts.some((part) => !Number.isSafeInteger(part))) return null;
  return [parts[0]!, parts[1]!, parts[2]!];
}

function compareVersions(a: readonly number[], b: readonly number[]): number {
  for (let index = 0; index < 3; index += 1) {
    const difference = (a[index] ?? 0) - (b[index] ?? 0);
    if (difference !== 0) return difference;
  }
  return 0;
}

export async function fetchChangelogReleases(signal: AbortSignal): Promise<readonly GitHubRelease[]> {
  const releases: GitHubRelease[] = [];

  for (let page = 1; page <= MAX_PAGES; page += 1) {
    const response = await fetch(`${RELEASES_URL}?per_page=100&page=${page}`, {
      signal,
      headers: { Accept: "application/vnd.github+json" },
      cache: "no-cache",
    });

    if (!response.ok) {
      throw new Error(
        response.status === 403 || response.status === 429
          ? "GitHub's public API is temporarily rate-limited. Try again shortly."
          : `GitHub returned HTTP ${response.status}. Try again shortly.`,
      );
    }

    const data: unknown = await response.json();
    if (!Array.isArray(data) || !data.every(isRelease)) {
      throw new Error("GitHub returned an unexpected release response.");
    }

    releases.push(...data.filter((release) => !release.draft));
    const morePages = /rel="next"/.test(response.headers.get("link") ?? "");
    if (!morePages) break;
    if (page === MAX_PAGES) throw new Error("The release history is too large to load.");
  }

  return releases
    .filter((release) => {
      const version = parseVersion(release.tag_name);
      return version !== null && compareVersions(version, MINIMUM_VERSION) >= 0;
    })
    .sort((left, right) => {
      const a = parseVersion(left.tag_name)!;
      const b = parseVersion(right.tag_name)!;
      return compareVersions(b, a) ||
        Number(left.prerelease) - Number(right.prerelease) ||
        Date.parse(right.published_at ?? "") - Date.parse(left.published_at ?? "") ||
        right.id - left.id;
    });
}

export function releaseDate(value: string | null): string {
  if (!value) return "Date unavailable";
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "Date unavailable";
  return new Intl.DateTimeFormat("en-US", {
    month: "long",
    day: "numeric",
    year: "numeric",
    timeZone: "UTC",
  }).format(date);
}

/** The release title is already displayed above the Markdown article. */
export function releaseDescription(body: string | null): string {
  if (!body?.trim()) return "";
  return body
    .replace(/\r\n?/g, "\n")
    .replace(/^\s*#\s+(?:Changelog|Reactily\s+v?\d+\.\d+\.\d+)\s*\n+/i, "")
    .trim();
}
