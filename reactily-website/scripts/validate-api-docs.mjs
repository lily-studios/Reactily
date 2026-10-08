import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const projectRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const apiRoot = path.join(projectRoot, "src/content/api");
const manifestPath = path.join(projectRoot, "src/lib/public-api-manifest.json");
const runtimePath = path.join(projectRoot, "src/lib/runtime.ts");

function fail(message) {
  console.error(`[validate:api] ${message}`);
  process.exitCode = 1;
}

if (!fs.existsSync(apiRoot)) {
  fail(`Missing API documentation directory: ${apiRoot}`);
  process.exit(1);
}
if (!fs.existsSync(manifestPath)) {
  fail("Missing src/lib/public-api-manifest.json; API docs must be pinned to a tagged Reactily release.");
  process.exit(1);
}

const manifest = JSON.parse(fs.readFileSync(manifestPath, "utf8"));
const runtime = fs.readFileSync(runtimePath, "utf8");
const version = /version:\s*"([^"]+)"/.exec(runtime)?.[1];
const apiVersion = /apiVersion:\s*(\d+)/.exec(runtime)?.[1];
const valueCount = /apiExportCount:\s*(\d+)/.exec(runtime)?.[1];
const typeCount = /apiTypeCount:\s*(\d+)/.exec(runtime)?.[1];

if (!manifest.release || !manifest.source || manifest.repository !== "lily-studios/Reactily") {
  fail("Manifest must identify the repository, release tag, and exact source path.");
}
if (manifest.release !== `v${version}`) fail(`Runtime version ${version} does not match manifest release ${manifest.release}.`);
if (String(manifest.apiVersion) !== apiVersion) fail(`Runtime API v${apiVersion} does not match manifest API v${manifest.apiVersion}.`);
if (manifest.valueExports.length !== Number(valueCount)) fail(`Runtime export count ${valueCount} does not match manifest count ${manifest.valueExports.length}.`);
if (manifest.typeExports.length !== Number(typeCount)) fail(`Runtime type count ${typeCount} does not match manifest count ${manifest.typeExports.length}.`);

function walk(directory) {
  return fs.readdirSync(directory, { withFileTypes: true }).flatMap((entry) => {
    const fullPath = path.join(directory, entry.name);
    return entry.isDirectory() ? walk(fullPath) : entry.name.endsWith(".md") ? [fullPath] : [];
  });
}

const documentedValues = new Map();
const documentedTypes = new Set();
for (const file of walk(apiRoot)) {
  const source = fs.readFileSync(file, "utf8");
  const title = /^title:\s*Reactily\.([A-Za-z_][A-Za-z0-9_]*)\s*$/m.exec(source)?.[1];
  if (title) {
    if (documentedValues.has(title)) fail(`Duplicate API page for Reactily.${title}: ${path.relative(projectRoot, file)} and ${path.relative(projectRoot, documentedValues.get(title))}.`);
    documentedValues.set(title, file);
  }
  const typeLine = /^api_types:\s*(.+)$/m.exec(source)?.[1];
  if (typeLine) for (const name of typeLine.split(",").map((entry) => entry.trim()).filter(Boolean)) documentedTypes.add(name);
}

const expectedValues = new Set(manifest.valueExports);
const expectedTypes = new Set(manifest.typeExports);
const missingValues = [...expectedValues].filter((name) => !documentedValues.has(name));
const staleValues = [...documentedValues.keys()].filter((name) => !expectedValues.has(name));
const missingTypes = [...expectedTypes].filter((name) => !documentedTypes.has(name));
const staleTypes = [...documentedTypes].filter((name) => !expectedTypes.has(name));
if (missingValues.length) fail(`Missing value export docs: ${missingValues.join(", ")}`);
if (staleValues.length) fail(`Stale value export docs: ${staleValues.join(", ")}`);
if (missingTypes.length) fail(`Missing public type docs: ${missingTypes.join(", ")}`);
if (staleTypes.length) fail(`Stale public type docs: ${staleTypes.join(", ")}`);

if (process.exitCode) process.exit(process.exitCode);
console.log(`Reactily ${manifest.release} API coverage OK: ${expectedValues.size} value exports and ${expectedTypes.size} public types.`);
