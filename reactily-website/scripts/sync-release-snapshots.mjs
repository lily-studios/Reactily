import fs from "node:fs";
import path from "node:path";
import { execFileSync } from "node:child_process";
import { fileURLToPath } from "node:url";
const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "../..");
const folder = path.join(root, "reactily-website/public/version-snapshots");
const repository = process.env.GITHUB_REPOSITORY || "lily-studios/Reactily";
const token = process.env.GITHUB_TOKEN;
const git = (...args) => execFileSync("git", args, { cwd: root, encoding: "utf8", maxBuffer: 20_000_000 }).trimEnd();
const read = (tag, filename) => git("show", tag + ":" + filename);
const doc = (name, content) => ({ path: "/src/content/" + name, source: content });
const label = (release) => /experimental/i.test((release.name || "") + " " + release.tag_name)
  ? "experimental" : release.prerelease ? "prerelease" : "stable";
const save = (filename, value) => {
  const next = JSON.stringify(value) + "\n";
  if (!fs.existsSync(filename) || fs.readFileSync(filename, "utf8") !== next) fs.writeFileSync(filename, next);
};
async function releases() {
  const all = [];
  for (let page = 1; page <= 20; page++) {
    const headers = { Accept: "application/vnd.github+json", "User-Agent": "ReactilyDocs" };
    if (token) headers.Authorization = "Bearer " + token;
    const response = await fetch("https://api.github.com/repos/" + repository + "/releases?per_page=100&page=" + page, { headers });
    if (!response.ok) throw Error("GitHub API HTTP " + response.status);
    const items = await response.json();
    if (!Array.isArray(items)) throw Error("Invalid release list");
    all.push(...items.filter((item) => !item.draft && item.tag_name));
    if (items.length < 100) break;
  }
  return all.sort((a,b) => (Date.parse(b.published_at || "") || 0) - (Date.parse(a.published_at || "") || 0) || b.id - a.id);
}
function generateLegacy(ref, tag) {
  const readme = read(ref, "README.md");
  const init = read(ref, "src/init.luau");
  const sections = [...readme.matchAll(/^## (.+)$/gm)];
  const docs = [doc("intro.md", "---\ntitle: Reactily " + tag + "\ndescription: Original " + tag + " release reference.\n---\n\n" + readme.slice(0, sections[0]?.index ?? readme.length))];
  const slugs = new Set();
  for (let i = 0; i < sections.length; i++) {
    const title = sections[i][1].trim();
    const base = title.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/^-|-$/g, "") || "section";
    let slug = base;
    let next = 2;
    while (slugs.has(slug)) slug = base + "-" + next++;
    slugs.add(slug);
    docs.push(doc("guides/" + slug + ".md", "---\ntitle: " + JSON.stringify(title) + "\ndescription: Original " + tag + " documentation.\n---\n\n" + readme.slice(sections[i].index, sections[i+1]?.index ?? readme.length)));
  }
  const api = new Set([...init.matchAll(/^module\.([A-Za-z_][A-Za-z0-9_]*)\s*=/gm)].map((match) => match[1]));
  if (!api.size) throw Error("No public API in " + tag);
  for (const name of [...api].sort()) {
    const uri = "https://github.com/" + repository + "/blob/" + encodeURIComponent(tag) + "/src/init.luau";
    docs.push(doc("api/legacy/" + name + ".md", "---\ntitle: Reactily." + name + "\ndescription: Public API exported in " + tag + ".\n---\n\n# Reactily." + name + "\n\nThis public export exists in the original " + tag + " source. Refer to the [original implementation](" + uri + ") and its [release guide](https://github.com/" + repository + "/blob/" + encodeURIComponent(tag) + "/README.md) for its exact behavior.\n"));
  }
  const types = new Set([...init.matchAll(/^export type\s+([A-Za-z_][A-Za-z0-9_]*)/gm)].map((match) => match[1]));
  for (const name of [...types].sort()) {
    docs.push(doc("api/legacy-types/" + name + ".md", "---\ntitle: " + name + "\ndescription: Public type from " + tag + ".\n---\n\n# " + name + "\n\nSee the type's declaration in the [original " + tag + " source](https://github.com/" + repository + "/blob/" + encodeURIComponent(tag) + "/src/init.luau).\n"));
  }
  return { docs, sourceType: "legacy-readme", exportCount: api.size, typeCount: types.size };
}
function generateTag(ref, tag) {
  const prefix = "reactily-website/src/content/";
  const paths = git("ls-tree", "-r", "--name-only", ref).split("\n");
  const markdown = paths.filter((entry) => entry.startsWith(prefix) && entry.endsWith(".md"));
  if (!markdown.length) return generateLegacy(ref, tag);
  const docs = markdown.map((entry) => doc(entry.slice(prefix.length), read(ref, entry)));
  const manifest = "reactily-website/src/lib/public-api-manifest.json";
  let exportCount = null;
  let typeCount = null;
  if (paths.includes(manifest)) {
    const data = JSON.parse(read(ref, manifest));
    const values = new Set(data.valueExports ?? []);
    const types = new Set(data.typeExports ?? []);
    const documented = new Set(docs.map((item) => /^title:\s*Reactily\.([A-Za-z_][A-Za-z0-9_]*)\s*$/m.exec(item.source)?.[1]).filter(Boolean));
    const missing = [...values].filter((name) => !documented.has(name));
    const stale = [...documented].filter((name) => !values.has(name));
    if (missing.length || stale.length) throw Error("API coverage mismatch for " + tag + ": missing " + missing.join(",") + "; stale " + stale.join(","));
    exportCount = values.size;
    typeCount = types.size;
  }
  return { docs, sourceType: "tagged-markdown", exportCount, typeCount };
}
fs.mkdirSync(folder, { recursive: true });
const index = [];
for (const release of await releases()) {
  const tag = release.tag_name;
  if (!/^[A-Za-z0-9][A-Za-z0-9._/-]{0,150}$/.test(tag) || tag.includes("..") || tag.includes("//")) throw Error("Unsupported Git tag " + tag);
  const ref = "refs/tags/" + tag;
  const sourceSha = git("rev-parse", "--verify", ref + "^{commit}");
  const destination = path.join(folder, encodeURIComponent(tag) + ".json");
  if (fs.existsSync(destination) && JSON.parse(fs.readFileSync(destination, "utf8")).sourceSha !== sourceSha) throw Error("Immutable release tag moved: " + tag);
  const snapshot = generateTag(ref, tag);
  if (!snapshot.docs.length || new Set(snapshot.docs.map((item) => item.path)).size !== snapshot.docs.length) throw Error("Invalid snapshot " + tag);
  save(destination, { tag, sourceSha, ...snapshot });
  index.push({ tag, name: release.name || tag, channel: label(release), publishedAt: release.published_at, url: release.html_url, sourceSha, exportCount: snapshot.exportCount, typeCount: snapshot.typeCount });
  console.log("[snapshots] " + tag + ": " + snapshot.docs.length + " pages from " + snapshot.sourceType);
}
const keep = new Set(["index.json", ...index.map((version) => encodeURIComponent(version.tag) + ".json")]);
for (const file of fs.readdirSync(folder)) if (file.endsWith(".json") && !keep.has(file)) fs.rmSync(path.join(folder, file));
save(path.join(folder, "index.json"), { schemaVersion: 1, releases: index });
console.log("[snapshots] Synchronized " + index.length + " immutable release archives.");
