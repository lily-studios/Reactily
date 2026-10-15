/**
 * Reactily · Lily Studios
 * Bundle this website's current Markdown documentation for offline version loading.
 * Reads only local project files; does not query GitHub or rewrite existing release archives.
 */
import { createHash } from "node:crypto";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const contentRoot = path.join(root, "src", "content");
const snapshotsRoot = path.join(root, "public", "version-snapshots");
const tag = "v2.2.0";
const fileName = Buffer.from(tag, "utf8").toString("hex") + ".json";

function listMarkdown(directory) {
  return fs.readdirSync(directory, { withFileTypes: true })
    .flatMap((entry) => {
      const full = path.join(directory, entry.name);
      if (entry.isDirectory()) return listMarkdown(full);
      return entry.isFile() && entry.name.endsWith(".md") ? [full] : [];
    });
}

function writeIfChanged(destination, data) {
  const output = JSON.stringify(data) + "\n";
  if (!fs.existsSync(destination) || fs.readFileSync(destination, "utf8") !== output) {
    fs.writeFileSync(destination, output, "utf8");
  }
}

if (!fs.existsSync(contentRoot)) {
  throw new Error("Missing documentation source: " + contentRoot);
}

const docs = listMarkdown(contentRoot)
  .map((filename) => ({
    path: "/src/content/" + path.relative(contentRoot, filename).split(path.sep).join("/"),
    source: fs.readFileSync(filename, "utf8"),
  }))
  .sort((a, b) => a.path.localeCompare(b.path));

if (!docs.length) throw new Error("No Markdown documentation was found in src/content.");

const hash = createHash("sha256");
for (const entry of docs) {
  hash.update(entry.path).update("\0").update(entry.source).update("\0");
}
const sourceSha = hash.digest("hex");
const snapshot = { tag, sourceSha, sourceType: "bundled-markdown", docs };
const current = {
  tag,
  name: `Reactily ${tag}`,
  channel: "stable",
  publishedAt: "2026-10-09T00:00:00Z",
  url: "/api?version=" + encodeURIComponent(tag),
  sourceSha,
  exportCount: null,
  typeCount: null,
};

fs.mkdirSync(snapshotsRoot, { recursive: true });
let archived = [];
const indexPath = path.join(snapshotsRoot, "index.json");
if (fs.existsSync(indexPath)) {
  const previous = JSON.parse(fs.readFileSync(indexPath, "utf8"));
  if (previous?.schemaVersion === 1 && Array.isArray(previous.releases)) {
    archived = previous.releases.filter((release) =>
      release && typeof release.tag === "string" && release.tag !== tag &&
      fs.existsSync(path.join(snapshotsRoot, Buffer.from(release.tag, "utf8").toString("hex") + ".json")),
    );
  }
}

writeIfChanged(path.join(snapshotsRoot, fileName), snapshot);
writeIfChanged(indexPath, { schemaVersion: 1, releases: [current, ...archived] });
console.log(`[snapshots] Bundled ${docs.length} local Markdown pages for ${tag}.`);
