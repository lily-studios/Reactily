#!/usr/bin/env node

"use strict";

const fs = require("node:fs");
const path = require("node:path");
const process = require("node:process");
const { spawnSync } = require("node:child_process");

const DEFAULT_SOURCE = "scripts";
const DEFAULT_RELEASE_DIR = "release";
const DEFAULT_NAME = "Reactily";
const DEFAULT_FORMAT = "rbxm";

function fail(message) {
	process.stderr.write(`[Reactily] ERROR: ${message}\n`);
	process.exitCode = 1;
	throw new Error(message);
}

function log(message) {
	process.stdout.write(`[Reactily] ${message}\n`);
}

function parseArgs(argv) {
	const options = {
		version: null,
		format: DEFAULT_FORMAT,
		name: DEFAULT_NAME,
		source: DEFAULT_SOURCE,
		releaseDir: DEFAULT_RELEASE_DIR,
		skipGenerate: false,
		clean: false,
		help: false,
	};

	for (let index = 0; index < argv.length; index += 1) {
		const arg = argv[index];

		switch (arg) {
			case "--version":
				options.version = argv[++index] ?? fail("--version requires a value.");
				break;

			case "--format":
				options.format = argv[++index] ?? fail("--format requires rbxm or rbxmx.");
				break;

			case "--name":
				options.name = argv[++index] ?? fail("--name requires a value.");
				break;

			case "--source":
				options.source = argv[++index] ?? fail("--source requires a folder.");
				break;

			case "--release-dir":
				options.releaseDir = argv[++index] ?? fail("--release-dir requires a folder.");
				break;

			case "--skip-generate":
				options.skipGenerate = true;
				break;

			case "--clean":
				options.clean = true;
				break;

			case "--help":
			case "-h":
				options.help = true;
				break;

			default:
				fail(`Unknown argument: ${arg}`);
		}
	}

	if (!["rbxm", "rbxmx"].includes(options.format)) {
		fail(`Unsupported format "${options.format}". Use rbxm or rbxmx.`);
	}

	return options;
}

function printHelp() {
	process.stdout.write(
		[
			"Reactily release builder",
			"",
			"Usage:",
			"  node tools/build-release.cjs [options]",
			"",
			"Options:",
			"  --version <version>       Override package.json version",
			"  --format <rbxm|rbxmx>     Roblox model format (default: rbxm)",
			"  --name <name>             Output model name (default: Reactily)",
			"  --source <folder>         Runtime source folder (default: scripts)",
			"  --release-dir <folder>    Release root folder (default: release)",
			"  --skip-generate           Do not regenerate init.luau first",
			"  --clean                   Remove the version release folder first",
			"  --help, -h                Show this help",
			"",
		].join("\n"),
	);
}

function isDirectory(target) {
	try {
		return fs.statSync(target).isDirectory();
	} catch {
		return false;
	}
}

function isFile(target) {
	try {
		return fs.statSync(target).isFile();
	} catch {
		return false;
	}
}

function looksLikeReactilyRoot(root, sourceFolder) {
	const source = path.join(root, sourceFolder);

	return (
		isFile(path.join(root, "package.json")) &&
		isDirectory(source) &&
		isDirectory(path.join(source, "core")) &&
		isDirectory(path.join(source, "runtime")) &&
		isDirectory(path.join(source, "state")) &&
		isDirectory(path.join(source, "virtual"))
	);
}

function findProjectRoot(startDirectory, sourceFolder) {
	let current = path.resolve(startDirectory);

	for (;;) {
		if (looksLikeReactilyRoot(current, sourceFolder)) {
			return current;
		}

		const parent = path.dirname(current);

		if (parent === current) {
			fail(
				`Could not find the Reactily project root. Expected package.json and ${sourceFolder}/{core,runtime,state,virtual}.`,
			);
		}

		current = parent;
	}
}

function readPackage(root) {
	const packagePath = path.join(root, "package.json");

	try {
		const data = JSON.parse(fs.readFileSync(packagePath, "utf8"));

		if (typeof data !== "object" || data === null) {
			fail("package.json must contain a JSON object.");
		}

		return data;
	} catch (error) {
		fail(`Could not read package.json: ${error instanceof Error ? error.message : String(error)}`);
	}
}

function validateVersion(version) {
	if (typeof version !== "string" || version.trim() === "") {
		fail("A non-empty release version is required.");
	}

	const trimmed = version.trim();

	// Safe for folder names and normal SemVer/prerelease versions.
	if (!/^[0-9A-Za-z][0-9A-Za-z.+_-]*$/.test(trimmed)) {
		fail(`Unsafe release version "${trimmed}".`);
	}

	return trimmed;
}

function validateName(name) {
	if (typeof name !== "string" || name.trim() === "") {
		fail("A non-empty model name is required.");
	}

	const trimmed = name.trim();

	if (!/^[0-9A-Za-z][0-9A-Za-z._ -]*$/.test(trimmed)) {
		fail(`Unsafe model name "${trimmed}".`);
	}

	return trimmed;
}

function run(command, args, cwd, capture = false) {
	const result = spawnSync(command, args, {
		cwd,
		encoding: "utf8",
		stdio: capture ? ["ignore", "pipe", "pipe"] : "inherit",
	});

	if (result.error) {
		if (result.error.code === "ENOENT") {
			fail(
				`Could not find "${command}" on PATH. Install Rojo with Rokit, then try again.`,
			);
		}

		fail(result.error.message);
	}

	if (result.status !== 0) {
		if (capture) {
			const stderr = (result.stderr ?? "").trim();

			if (stderr !== "") {
				process.stderr.write(`${stderr}\n`);
			}
		}

		fail(`${command} exited with code ${result.status}.`);
	}

	return capture ? (result.stdout ?? "").trim() : "";
}

function regenerateInit(root) {
	const generator = path.join(root, "tools", "generate-init.cjs");

	if (!isFile(generator)) {
		fail(`Missing init generator: ${generator}`);
	}

	log("Generating scripts/init.luau...");
	run(process.execPath, [generator], root);

	log("Checking generated init...");
	run(process.execPath, [generator, "--check"], root);
}

function writeTemporaryProject(root, sourceFolder, modelName) {
	const projectPath = path.join(root, ".reactily-release.project.json");

	const project = {
		name: modelName,
		tree: {
			$path: sourceFolder,
		},
	};

	fs.writeFileSync(projectPath, `${JSON.stringify(project, null, 2)}\n`, "utf8");

	return projectPath;
}

function validateBuiltFile(filePath, format) {
	if (!isFile(filePath)) {
		fail(`Rojo did not create the expected output: ${filePath}`);
	}

	const stat = fs.statSync(filePath);

	if (stat.size === 0) {
		fail(`Built Roblox model is empty: ${filePath}`);
	}

	const handle = fs.openSync(filePath, "r");

	try {
		const buffer = Buffer.alloc(Math.min(32, stat.size));
		fs.readSync(handle, buffer, 0, buffer.length, 0);

		if (format === "rbxm") {
			const expected = Buffer.from("<roblox!", "ascii");

			if (!buffer.subarray(0, expected.length).equals(expected)) {
				fail("Output does not look like a Roblox binary model (.rbxm).");
			}
		} else {
			const text = buffer.toString("utf8").replace(/^\uFEFF/, "").trimStart();

			if (!text.startsWith("<roblox")) {
				fail("Output does not look like a Roblox XML model (.rbxmx).");
			}
		}
	} finally {
		fs.closeSync(handle);
	}
}

function main() {
	const options = parseArgs(process.argv.slice(2));

	if (options.help) {
		printHelp();
		return;
	}

	const root = findProjectRoot(__dirname, options.source);
	const packageJson = readPackage(root);
	const version = validateVersion(options.version ?? packageJson.version);
	const modelName = validateName(options.name);

	const sourcePath = path.join(root, options.source);
	const releaseRoot = path.resolve(root, options.releaseDir);
	const versionDirectory = path.join(releaseRoot, version);
	const outputFile = path.join(versionDirectory, `${modelName}.${options.format}`);

	log(`Project: ${root}`);
	log(`Source: ${sourcePath}`);
	log(`Version: ${version}`);

	if (!options.skipGenerate) {
		regenerateInit(root);
	}

	const initPath = path.join(sourcePath, "init.luau");

	if (!isFile(initPath)) {
		fail(`Missing generated runtime entry point: ${initPath}`);
	}

	if (options.clean && isDirectory(versionDirectory)) {
		log(`Cleaning: ${versionDirectory}`);
		fs.rmSync(versionDirectory, { recursive: true, force: true });
	}

	fs.mkdirSync(versionDirectory, { recursive: true });

	if (isFile(outputFile)) {
		fs.rmSync(outputFile, { force: true });
	}

	const rojoVersion = run("rojo", ["--version"], root, true);

	if (rojoVersion !== "") {
		log(`Rojo: ${rojoVersion}`);
	}

	const projectPath = writeTemporaryProject(root, options.source, modelName);

	try {
		log(`Building ${modelName}.${options.format}...`);
		run("rojo", ["build", projectPath, "-o", outputFile], root);
		validateBuiltFile(outputFile, options.format);
	} finally {
		fs.rmSync(projectPath, { force: true });
	}

	const size = fs.statSync(outputFile).size;

	log("Release build complete.");
	log(`Output: ${path.relative(root, outputFile)}`);
	log(`Size: ${size.toLocaleString("en-US")} bytes`);
}

try {
	main();
} catch (error) {
	if (process.exitCode !== 1) {
		process.exitCode = 1;
		console.error(
			`[Reactily] ERROR: ${error instanceof Error ? error.stack ?? error.message : String(error)}`,
		);
	}
}
