import fs from "node:fs";
import path from "node:path";

const root = process.cwd();

const stalePaths = [
	"moonwave-api",
	"REFERENCE_SOURCE.md",
	"docs/reference/full-reference.md",
	"scripts/sync-reference.mjs",
	"docs/api/index.md",
	"docs/api.md",
];

for (const relative of stalePaths) {
	const absolute = path.join(root, relative);

	if (!fs.existsSync(absolute)) continue;

	fs.rmSync(absolute, {
		force: true,
		recursive: true,
	});

	console.log(`Removed stale documentation artifact: ${relative}`);
}

const apiRoot = path.join(root, "docs", "api");

if (fs.existsSync(apiRoot)) {
	for (const entry of fs.readdirSync(apiRoot, {withFileTypes: true})) {
		if (!entry.isDirectory()) continue;

		const staleIndex = path.join(apiRoot, entry.name, "index.md");

		if (!fs.existsSync(staleIndex)) continue;

		fs.rmSync(staleIndex, {force: true});
		console.log(`Removed duplicate API category index: docs/api/${entry.name}/index.md`);
	}
}
