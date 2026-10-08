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

  // A GitHub release tag is an arbitrary string, not necessarily a SemVer value.
  // Show every published release, including names such as "nightly", "v.2.1.1",
  // "2.2.0-beta.1", and "October Release".
  return releases
    .filter((release) => release.tag_name.trim().length > 0)
    .sort((left, right) => {
      const leftDate = Date.parse(left.published_at ?? "") || 0;
      const rightDate = Date.parse(right.published_at ?? "") || 0;
      return rightDate - leftDate || right.id - left.id;
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
