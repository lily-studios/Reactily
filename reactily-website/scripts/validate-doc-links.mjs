import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const projectRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const contentRoot = path.join(projectRoot, "src/content");
const failures = [];

function walk(directory) {
  return fs.readdirSync(directory, { withFileTypes: true }).flatMap((entry) => {
    const fullPath = path.join(directory, entry.name);
    return entry.isDirectory() ? walk(fullPath) : entry.name.endsWith(".md") ? [fullPath] : [];
  });
}

for (const file of walk(contentRoot)) {
  const source = fs.readFileSync(file, "utf8");
  for (const [, destination] of source.matchAll(/\[[^\]]*\]\(([^)]+)\)/g)) {
    const [targetPath, fragment] = destination.split("#", 2);
    if (!targetPath || /^(https?:|mailto:|tel:)/i.test(targetPath)) continue;

    let targetFile;
    if (targetPath === "/api" || targetPath === "/api/") continue;
    if (targetPath.startsWith("/docs/")) {
      targetFile = path.join(contentRoot, `${targetPath.slice("/docs/".length).replace(/\.md$/, "")}.md`);
    } else if (targetPath.startsWith("/")) {
      continue;
    } else {
      targetFile = path.resolve(path.dirname(file), targetPath);
    }

    if (!fs.existsSync(targetFile) || !fs.statSync(targetFile).isFile()) {
      failures.push(`${path.relative(projectRoot, file)}: unresolved link ${destination}`);
      continue;
    }

    if (fragment) {
      const target = fs.readFileSync(targetFile, "utf8");
      const headings = [...target.matchAll(/^#{1,6}\s+(.+)$/gm)].map((match) =>
        match[1]
          .toLowerCase()
          .replace(/[`*_~]/g, "")
          .replace(/[^a-z0-9\s-]/g, "")
          .trim()
          .replace(/\s+/g, "-"),
      );
      if (!headings.includes(decodeURIComponent(fragment))) {
        failures.push(`${path.relative(projectRoot, file)}: missing heading #${fragment} in ${path.relative(projectRoot, targetFile)}`);
      }
    }
  }
}

if (failures.length) {
  console.error(`[validate:links] Found ${failures.length} broken internal documentation link(s):`);
  for (const failure of failures) console.error(`- ${failure}`);
  process.exit(1);
}

console.log(`[validate:links] OK — all internal links resolve across ${walk(contentRoot).length} Markdown pages.`);
