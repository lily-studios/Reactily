import fs from "node:fs";
import path from "node:path";

const root = process.cwd();
let failed = false;

function fail(message) {
	failed = true;
	console.error(`FAIL ${message}`);
}

function pass(message) {
	console.log(`PASS ${message}`);
}

function walk(directory) {
	const files = [];

	for (const entry of fs.readdirSync(directory, {withFileTypes: true})) {
		const absolute = path.join(directory, entry.name);

		if (entry.isDirectory()) {
			files.push(...walk(absolute));
			continue;
		}

		files.push(absolute);
	}

	return files;
}

const required = [
	"docs/intro.md",
	"docs/getting-started.md",
	"docs/api",
	"pages/index.js",
	"pages/api.js",
	".moonwave/sidebars.js",
	".moonwave/static/live-release.js",
	"moonwave.toml",
	"moonwave-source/placeholder.luau",
];

for (const relative of required) {
	if (!fs.existsSync(path.join(root, relative))) {
		fail(`missing ${relative}`);
		continue;
	}

	pass(relative);
}

const forbidden = [
	"docs/api.md",
	"docs/api/index.md",
	"docs/reference/full-reference.md",
	"REFERENCE_SOURCE.md",
	"moonwave-api",
];

for (const relative of forbidden) {
	if (!fs.existsSync(path.join(root, relative))) continue;
	fail(`duplicate/stale artifact ${relative}`);
}

const apiRoot = path.join(root, "docs", "api");
const apiMarkdown = walk(apiRoot).filter((file) => file.endsWith(".md"));

if (apiMarkdown.length !== 134) {
	fail(`expected 134 API function pages, found ${apiMarkdown.length}`);
} else {
	pass("134 unique API function pages");
}

for (const file of apiMarkdown) {
	const relative = path.relative(root, file);
	const text = fs.readFileSync(file, "utf8");

	if (text.includes("/docs/reference/full-reference")) {
		fail(`${relative} links to deleted full-reference page`);
	}

	if (/```(?:lua|luau)(?:\s|$)/m.test(text)) {
		fail(`${relative} contains lua/luau code fencing`);
	}
}

const moonwaveText = fs.readFileSync(path.join(root, "moonwave.toml"), "utf8");

// Moonwave generates GitHub from gitRepoUrl.
// There must be NO manually-added GitHub navbar item.
const manualGithubCount = (moonwaveText.match(/label = "GitHub"/g) ?? []).length;
const releaseCount = (moonwaveText.match(/label = "Release"/g) ?? []).length;

if (manualGithubCount !== 0) {
	fail(`manual GitHub navbar item remains (${manualGithubCount})`);
} else {
	pass("GitHub navbar is owned only by Moonwave");
}

if (!moonwaveText.includes('gitRepoUrl = "https://github.com/lily-studios/Reactily"')) {
	fail("gitRepoUrl is missing");
} else {
	pass("Moonwave GitHub navbar source");
}

if (releaseCount !== 1) {
	fail(`expected one custom Release navbar item, found ${releaseCount}`);
} else {
	pass("one custom Release navbar item");
}

if (!moonwaveText.includes('to = "/api"')) {
	fail("footer API link does not use /api");
} else {
	pass("footer API route");
}

const homeText = fs.readFileSync(path.join(root, "pages", "index.js"), "utf8");

if (!homeText.includes('to="/api"')) {
	fail("homepage API button does not use /api");
} else {
	pass("homepage API route");
}

const apiPageText = fs.readFileSync(path.join(root, "pages", "api.js"), "utf8");

if (!apiPageText.includes("API Reference")) {
	fail("pages/api.js is not the API landing page");
} else {
	pass("real /api landing page");
}

const sidebarText = fs.readFileSync(path.join(root, ".moonwave", "sidebars.js"), "utf8");
const apiCategoryCount = (sidebarText.match(/label:\s*"API"/g) ?? []).length;

if (apiCategoryCount !== 1) {
	fail(`expected one API sidebar category, found ${apiCategoryCount}`);
} else {
	pass("one API sidebar category");
}

if (sidebarText.includes('id: "api"')) {
	fail("sidebar still links to removed docs/api.md");
}

if (moonwaveText.includes("[docusaurus.markdown.hooks]")) {
	fail("unsupported nested Docusaurus markdown hooks block is present");
}

if (!moonwaveText.includes('onBrokenMarkdownLinks = "warn"')) {
	fail("Moonwave-safe onBrokenMarkdownLinks setting is missing");
} else {
	pass("Moonwave-safe Markdown link config");
}

if (failed) {
	process.exit(1);
}

console.log("Reactily production documentation checks passed.");
