/**
 * Release lifecycle detection for documentation navigation.
 *
 * A numerically newer published version supersedes an older one, regardless
 * of whether either release is stable, pre-release, or experimental.
 * This does not imply that the older version's individual APIs are deprecated.
 */

/** Find the first version-like number sequence in a GitHub release tag. */
export function parseReleaseNumbers(tag: string): readonly string[] | null {
  // Prefer explicit v-prefixed versions; otherwise use the most specific
  // numeric group (and the last match on ties, e.g. "2026-release-2").
  const prefixed = /(?:^|[^a-z0-9])v\.?(\d+(?:\.\d+)*)/i.exec(tag);
  const candidates = [...tag.matchAll(/\d+(?:\.\d+)*/g)];
  const selected = candidates.reduce<RegExpMatchArray | null>((best, candidate) => {
    if (!best) return candidate;
    const currentSegments = (candidate[0]?.match(/\./g) ?? []).length;
    const bestSegments = (best[0]?.match(/\./g) ?? []).length;
    return currentSegments >= bestSegments ? candidate : best;
  }, null);
  const version = prefixed?.[1] ?? selected?.[0];
  if (!version) return null;

  return version.split(".").map((part) => part.replace(/^0+/, "") || "0");
}

function compareNumberStrings(left: string, right: string): number {
  if (left.length !== right.length) return left.length > right.length ? 1 : -1;
  return left === right ? 0 : left > right ? 1 : -1;
}

/**
 * Compare version numbers; missing segments count as zero.
 * Non-numeric names are incomparable, not automatically deprecated.
 */
export function compareReleaseNumbers(leftTag: string, rightTag: string): number | null {
  const left = parseReleaseNumbers(leftTag);
  const right = parseReleaseNumbers(rightTag);
  if (!left || !right) return null;

  for (let i = 0; i < Math.max(left.length, right.length); i += 1) {
    const comparison = compareNumberStrings(left[i] ?? "0", right[i] ?? "0");
    if (comparison !== 0) return comparison;
  }
  return 0;
}

/** Highest numeric tag among published releases; ties preserve the input order. */
export function highestNumberedReleaseTag(tags: readonly string[]): string | null {
  let highest: string | null = null;
  for (const tag of tags) {
    if (!parseReleaseNumbers(tag)) continue;
    if (highest === null || compareReleaseNumbers(tag, highest) === 1) highest = tag;
  }
  return highest;
}

/** Mark a release deprecated only when a strictly higher numbered tag exists. */
export function isSupersededRelease(tag: string, highestTag: string | null): boolean {
  return highestTag !== null && compareReleaseNumbers(tag, highestTag) === -1;
}
