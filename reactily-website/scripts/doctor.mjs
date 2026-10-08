import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const projectRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const packageJson = JSON.parse(fs.readFileSync(path.join(projectRoot, "package.json"), "utf8"));

function parseVersion(value) {
  const [major = 0, minor = 0, patch = 0] = value.split(".").map((part) => Number.parseInt(part, 10) || 0);
  return { major, minor, patch };
}

function atLeast(actual, required) {
  if (actual.major !== required.major) return actual.major > required.major;
  if (actual.minor !== required.minor) return actual.minor > required.minor;
  return actual.patch >= required.patch;
}

const requiredNode = { major: 22, minor: 22, patch: 0 };
const actualNode = parseVersion(process.versions.node);

if (!atLeast(actualNode, requiredNode) && actualNode.major < 23) {
  console.error(`[doctor] Node ${process.versions.node} is too old. React Router 8 requires Node 22.22.0+ (or a newer active LTS major).`);
  process.exitCode = 1;
}

const requiredFiles = [
  "index.html",
  "src/bootstrap.ts",
  "src/main.tsx",
  "src/App.tsx",
  "src/lib/docs.ts",
  "src/lib/runtime.ts",
  "src/content/api",
  "src/styles.css",
];

for (const relative of requiredFiles) {
  if (!fs.existsSync(path.join(projectRoot, relative))) {
    console.error(`[doctor] Missing required file: ${relative}`);
    process.exitCode = 1;
  }
}

if (fs.existsSync(path.join(projectRoot, "src/src"))) {
  console.error("[doctor] Invalid nested source directory: src/src. Extract the project at the reactily-website root.");
  process.exitCode = 1;
}

const packages = [
  ...Object.keys(packageJson.dependencies ?? {}),
  ...Object.keys(packageJson.devDependencies ?? {}),
];

for (const dependency of packages) {
  const packageManifest = path.join(projectRoot, "node_modules", ...dependency.split("/"), "package.json");
  if (!fs.existsSync(packageManifest)) {
    console.error(`[doctor] Missing dependency: ${dependency}. Run npm install from ${projectRoot}`);
    process.exitCode = 1;
  }
}

if (!process.exitCode) {
  console.log(`[doctor] OK — Node ${process.versions.node}, ${packages.length} dependencies resolved.`);
  console.log("[doctor] Development URL: http://localhost:5173/");
  console.log("[doctor] Use `npm run dev`; do not use VS Code Live Server for the source tree.");
}
