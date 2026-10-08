import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const projectRoot = path.resolve(
  path.dirname(fileURLToPath(import.meta.url)),
  "..",
);

const repositoryRoot = path.resolve(projectRoot, "..");

const requiredPaths = [
  "package.json",
  "index.html",
  "src/App.tsx",
  "src/main.tsx",
  "src/pages/HomePage.tsx",
  "src/lib/docs.ts",
  "src/lib/runtime.ts",
  "src/content/api",
  "scripts/validate-api-docs.mjs",
];

const requiredRepositoryPaths = [
  ".github/workflows/pages.yml",
];

const missing = [
  ...requiredPaths.filter(
    (relative) => !fs.existsSync(path.join(projectRoot, relative)),
  ),
  ...requiredRepositoryPaths.filter(
    (relative) => !fs.existsSync(path.join(repositoryRoot, relative)),
  ),
];

if (fs.existsSync(path.join(projectRoot, "src/src"))) {
  console.error("[structure] Invalid nested source folder detected: src/src");
  process.exitCode = 1;
}

if (missing.length > 0) {
  console.error("[structure] Project structure is incomplete.");

  for (const relative of missing) {
    console.error(`[structure] Missing: ${relative}`);
  }

  process.exitCode = 1;
}

if (!process.exitCode) {
  console.log("[structure] OK — project structure is valid.");
}
