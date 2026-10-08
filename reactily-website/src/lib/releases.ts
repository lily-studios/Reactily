const GITHUB_OWNER = "lily-studios";
const GITHUB_REPOSITORY = "Reactily";
const GITHUB_API_BASE = `https://api.github.com/repos/${GITHUB_OWNER}/${GITHUB_REPOSITORY}`;

export const GITHUB_RELEASES_URL = `https://github.com/${GITHUB_OWNER}/${GITHUB_REPOSITORY}/releases`;

export type GitHubRelease = {
  readonly id: number;
  readonly tagName: string;
  readonly name: string | null;
  readonly url: string;
  readonly publishedAt: string | null;
  readonly prerelease: boolean;
};

type GitHubReleasePayload = {
  readonly id?: unknown;
  readonly tag_name?: unknown;
  readonly name?: unknown;
  readonly html_url?: unknown;
  readonly published_at?: unknown;
  readonly prerelease?: unknown;
  readonly draft?: unknown;
};

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null;
}

function parseRelease(value: unknown): GitHubRelease | null {
  if (!isRecord(value)) {
    return null;
  }

  const payload: GitHubReleasePayload = value;

  if (
    typeof payload.id !== "number" ||
    typeof payload.tag_name !== "string" ||
    typeof payload.html_url !== "string" ||
    payload.draft === true
  ) {
    return null;
  }

  return {
    id: payload.id,
    tagName: payload.tag_name,
    name: typeof payload.name === "string" ? payload.name : null,
    url: payload.html_url,
    publishedAt:
      typeof payload.published_at === "string" ? payload.published_at : null,
    prerelease: payload.prerelease === true,
  };
}

export async function getGitHubReleases(
  signal?: AbortSignal,
): Promise<readonly GitHubRelease[]> {
  const init: RequestInit = {
    headers: {
      Accept: "application/vnd.github+json",
      "X-GitHub-Api-Version": "2022-11-28",
    },
  };

  if (signal !== undefined) {
    init.signal = signal;
  }

  const response = await fetch(`${GITHUB_API_BASE}/releases?per_page=100`, init);

  if (!response.ok) {
    throw new Error(`GitHub releases request failed with ${response.status}.`);
  }

  const payload: unknown = await response.json();

  if (!Array.isArray(payload)) {
    throw new Error("GitHub releases response was not an array.");
  }

  return payload
    .map(parseRelease)
    .filter((release): release is GitHubRelease => release !== null);
}
