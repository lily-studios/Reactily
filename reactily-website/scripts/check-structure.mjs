import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const projectRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");

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

const missing = requiredPaths.filter((relative) =>
  !fs.existsSync(path.join(projectRoot, relative)),
);

if (fs.existsSync(path.join(projectRoot, "src/src"))) {
  console.error("[structure] Invalid nested source folder detected: src/src");
  console.error("[structure] Extract the package at the project root, not inside src/.");
  process.exit(1);
}

if (missing.length > 0) {
  console.error("[structure] Project structure is incomplete.");
  for (const relative of missing) console.error(`[structure] Missing: ${relative}`);
  process.exit(1);
}

console.log("[structure] OK — project root and src/content/api are in the expected locations.");
