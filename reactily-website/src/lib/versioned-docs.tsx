import { createContext, useContext, useEffect, useMemo, useState } from "react";
import type { ReactNode } from "react";
import { useLocation, useNavigate } from "react-router";
import { createDoc, docs as currentDocs, isDocAvailable } from "./docs";
import type { DocRecord } from "./docs";

export type ArchivedRelease = {
  readonly tag: string;
  readonly name: string;
  readonly channel: "stable" | "prerelease" | "experimental";
  readonly publishedAt: string | null;
  readonly url: string;
  readonly sourceSha: string;
  readonly exportCount: number | null;
  readonly typeCount: number | null;
};

type LoadStatus = "loading" | "ready" | "error";
type VersionDocsContext = {
  readonly tag: string | null;
  readonly releases: readonly ArchivedRelease[];
  readonly docs: readonly DocRecord[];
  readonly status: LoadStatus;
  readonly error: string | null;
  readonly sourceType: string | null;
  readonly selectTag: (tag: string | null) => void;
  readonly path: (target: string) => string;
};

type DocsIndex = { readonly schemaVersion: 1; readonly releases: readonly ArchivedRelease[] };
type ArchivedFile = { readonly path: string; readonly source: string };
type DocsSnapshot = {
  readonly tag: string;
  readonly sourceSha: string;
  readonly sourceType: string;
  readonly docs: readonly ArchivedFile[];
};

const context = createContext<VersionDocsContext | null>(null);
const base = import.meta.env.BASE_URL + "version-snapshots/";
const snapshots = new Map<string, Promise<readonly DocRecord[]>>();

async function json(url: string, signal: AbortSignal): Promise<unknown> {
  const response = await fetch(url, { signal, cache: "no-cache" });
  if (!response.ok) throw new Error("Archived documentation unavailable (HTTP " + response.status + ").");
  return response.json() as Promise<unknown>;
}

function validIndex(value: unknown): value is DocsIndex {
  return !!value && typeof value === "object" &&
    (value as { schemaVersion?: unknown }).schemaVersion === 1 &&
    Array.isArray((value as { releases?: unknown }).releases) &&
    (value as DocsIndex).releases.every((release) =>
      typeof release.tag === "string" &&
      typeof release.url === "string" &&
      typeof release.sourceSha === "string" &&
      (release.channel === "stable" || release.channel === "prerelease" || release.channel === "experimental"),
    );
}

async function loadSnapshot(release: ArchivedRelease, signal: AbortSignal): Promise<readonly DocRecord[]> {
  const value = await json(base + encodeURIComponent(release.tag) + ".json", signal);
  if (!value || typeof value !== "object") throw new Error("Invalid release snapshot.");
  const archive = value as DocsSnapshot;
  if (archive.tag !== release.tag || archive.sourceSha !== release.sourceSha ||
      !Array.isArray(archive.docs) || !archive.docs.every((item) =>
        item && typeof item.path === "string" && typeof item.source === "string" &&
        /^\/src\/content\/.+\.md$/.test(item.path))) {
    throw new Error("This release's documentation snapshot failed integrity checks.");
  }
  const docs = archive.docs.map((entry) => createDoc(entry.path, entry.source))
    .filter((doc) => isDocAvailable(doc, release.tag))
    .sort((left, right) => left.sidebarPosition - right.sidebarPosition || left.title.localeCompare(right.title));
  if (!docs.length) throw new Error("This release has no documentation.");
  return docs;
}

export function VersionedDocsProvider({ children }: { readonly children: ReactNode }) {
  const location = useLocation();
  const navigate = useNavigate();
  const explicitTag = new URLSearchParams(location.search).get("version");
  const [index, setIndex] = useState<DocsIndex | null>(null);
  const [indexError, setIndexError] = useState<string | null>(null);
  const [ready, setReady] = useState(false);
  const latest = index?.releases.find((release) => release.channel === "stable");
  const development = explicitTag === "development";
  const tag = development ? null : explicitTag || latest?.tag || null;
  const [data, setData] = useState<{ tag: string | null; docs: readonly DocRecord[]; status: LoadStatus; error: string | null }>({
    tag: null, docs: [], status: "loading", error: null,
  });

  useEffect(() => {
    const controller = new AbortController();
    void json(base + "index.json", controller.signal)
      .then((value) => {
        if (!validIndex(value)) throw new Error("Invalid release index.");
        if (!controller.signal.aborted) setIndex(value);
      })
      .catch((reason: unknown) => {
        if (!controller.signal.aborted) setIndexError(reason instanceof Error ? reason.message : "No release archive found.");
      })
      .finally(() => { if (!controller.signal.aborted) setReady(true); });
    return () => controller.abort();
  }, []);

  useEffect(() => {
    if (!ready) return;
    if (!tag) {
      setData({ tag: null, docs: currentDocs, status: "ready", error: indexError });
      return;
    }
    const release = index?.releases.find((item) => item.tag === tag);
    if (!release) {
      setData({ tag, docs: [], status: "error", error: "No archived documentation exists for release " + tag + "." });
      return;
    }
    const controller = new AbortController();
    setData({ tag, docs: [], status: "loading", error: null });
    let task = snapshots.get(tag);
    if (!task) {
      task = loadSnapshot(release, controller.signal);
      snapshots.set(tag, task);
      void task.catch(() => { snapshots.delete(tag); });
    }
    void task.then(
      (docs) => { if (!controller.signal.aborted) setData({ tag, docs, status: "ready", error: null }); },
      (reason: unknown) => {
        if (!controller.signal.aborted) setData({
          tag, docs: [], status: "error",
          error: reason instanceof Error ? reason.message : "Unable to load versioned documentation.",
        });
      },
    );
    return () => controller.abort();
  }, [tag, index, indexError, ready]);

  const path = (target: string): string => {
    if (/^(?:https?:)?\/\//i.test(target) || target.startsWith("#")) return target;
    const [beforeHash, hash] = target.split("#", 2);
    const [pathname, query] = (beforeHash ?? "").split("?", 2);
    const params = new URLSearchParams(query);
    if (tag) params.set("version", tag);
    else if (development) params.set("version", "development");
    const queryString = params.toString();
    return pathname + (queryString ? "?" + queryString : "") + (hash ? "#" + hash : "");
  };

  const selectTag = (nextTag: string | null): void => {
    const params = new URLSearchParams(location.search);
    params.set("version", nextTag ?? "development");
    navigate({ pathname: "/api", search: "?" + params.toString() });
  };

  const value = useMemo<VersionDocsContext>(() => ({
    tag, releases: index?.releases ?? [],
    docs: ready && data.tag === tag ? data.docs : [],
    status: ready && data.tag === tag ? data.status : "loading",
    error: ready && data.tag === tag ? data.error : null,
    sourceType: tag ? "tagged-release" : null,
    selectTag, path,
  }), [tag, index, data, ready, location.pathname, location.search, navigate]);

  return <context.Provider value={value}>{children}</context.Provider>;
}

export function useVersionedDocs(): VersionDocsContext {
  const value = useContext(context);
  if (!value) throw new Error("VersionedDocsProvider must wrap the documentation website.");
  return value;
}
