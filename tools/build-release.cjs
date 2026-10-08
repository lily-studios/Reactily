#!/usr/bin/env node
"use strict";

/**
 * Reactily · Lily Studios
 * Copyright (c) Lily Studios and contributors.
 * Licensed under the MIT License.
 * See LICENSE in the repository root for full terms.
 *
 * Generate Reactily's public API and package scripts/ as a Roblox model.
 */

const crypto = require("node:crypto");
const fs = require("node:fs");
const path = require("node:path");
const process = require("node:process");
const { spawnSync } = require("node:child_process");

const DEFAULT_SOURCE = "scripts";
const DEFAULT_RELEASE_DIR = "release";
const DEFAULT_NAME = "Reactily";
const DEFAULT_FORMAT = "rbxm";

function log(message) {
  process.stdout.write(`[Reactily] ${message}\n`);
}

function fail(message) {
  throw new Error(message);
}

function getArgumentValue(argv, index, option) {
  const value = argv[index + 1];
  if (!value || value.startsWith("--")) {
    fail(`${option} requires a value.`);
  }
  return value;
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
    const argument = argv[index];

    switch (argument) {
      case "--version":
      case "--format":
      case "--name":
      case "--source":
      case "--release-dir": {
        const value = getArgumentValue(argv, index, argument);
        index += 1;

        if (argument === "--version") options.version = value;
        if (argument === "--format") options.format = value;
        if (argument === "--name") options.name = value;
        if (argument === "--source") options.source = value;
        if (argument === "--release-dir") options.releaseDir = value;
        break;
      }
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
        fail(`Unknown argument: ${argument}`);
    }
  }

  if (!new Set(["rbxm", "rbxmx"]).has(options.format)) {
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
      "  --format <rbxm|rbxmx>     Model format (default: rbxm)",
      "  --name <name>             Model name (default: Reactily)",
      "  --source <folder>         Runtime source folder (default: scripts)",
      "  --release-dir <folder>    Release folder (default: release)",
      "  --skip-generate           Do not regenerate init.luau",
      "  --clean                   Delete the versioned release folder first",
      "  --help, -h                Show this help",
      "",
    ].join("\n"),
  );
}

function isFile(target) {
  try {
    return fs.statSync(target).isFile();
  } catch {
    return false;
  }
}

function isDirectory(target) {
  try {
    return fs.statSync(target).isDirectory();
  } catch {
    return false;
  }
}

function isWithin(parent, target) {
  const relative = path.relative(parent, target);
  return relative === "" || (relative !== ".." && !relative.startsWith(`..${path.sep}`) && !path.isAbsolute(relative));
}

function findProjectRoot(startDirectory, sourceFolder) {
  let current = fs.realpathSync(startDirectory);

  while (true) {
    const source = path.resolve(current, sourceFolder);
    if (
      isWithin(current, source) &&
      isFile(path.join(current, "package.json")) &&
      ["core", "runtime", "state", "virtual"].every((name) => isDirectory(path.join(source, name)))
    ) {
      return current;
    }

    const parent = path.dirname(current);
    if (parent === current) {
      fail(
        `Cannot find the Reactily project root. Expected package.json and ${sourceFolder}/{core,runtime,state,virtual}.`,
      );
    }
    current = parent;
  }
}

function readPackage(root) {
  const filename = path.join(root, "package.json");
  let result;
  try {
    result = JSON.parse(fs.readFileSync(filename, "utf8"));
  } catch (error) {
    fail(`Could not parse ${filename}: ${error.message}`);
  }

  if (!result || typeof result !== "object" || Array.isArray(result)) {
    fail("package.json must contain a JSON object.");
  }
  return result;
}

function validateVersion(value) {
  if (typeof value !== "string" || !/^[0-9A-Za-z][0-9A-Za-z.+_-]*$/.test(value.trim())) {
    fail(`Invalid release version: ${String(value)}`);
  }
  return value.trim();
}

function validateName(value) {
  if (typeof value !== "string" || !/^[A-Za-z0-9][A-Za-z0-9._ -]*$/.test(value.trim())) {
    fail(`Invalid model name: ${String(value)}`);
  }
  return value.trim();
}

// Prevent an accidental --clean from deleting scripts/, tools/, or the repository.
// Also reject any symbolic link on the output path (including the version folder).
function ensureSafeOutputPath(root, sourcePath, releaseRoot, versionDirectory) {
  if (!isWithin(root, releaseRoot) || releaseRoot === root) {
    fail("--release-dir must point to a subdirectory of the Reactily project.");
  }

  const protectedDirectories = [
    sourcePath,
    path.join(root, "tools"),
    path.join(root, ".git"),
    path.join(root, "node_modules"),
  ];

  for (const protectedPath of protectedDirectories) {
    if (isWithin(protectedPath, releaseRoot) || isWithin(releaseRoot, protectedPath)) {
      fail(`Unsafe release directory: ${releaseRoot} overlaps protected path ${protectedPath}`);
    }
  }

  const relativeParts = path.relative(root, versionDirectory).split(path.sep);
  let current = root;
  for (const part of relativeParts) {
    current = path.join(current, part);
    try {
      if (fs.lstatSync(current).isSymbolicLink()) {
        fail(`Refusing a release path containing a symbolic link: ${current}`);
      }
    } catch (error) {
      if (error.code !== "ENOENT") throw error;
    }
  }
}

function run(command, arguments_, cwd, capture = false) {
  const result = spawnSync(command, arguments_, {
    cwd,
    encoding: "utf8",
    stdio: capture ? ["ignore", "pipe", "pipe"] : "inherit",
  });

  if (result.error) {
    if (result.error.code === "ENOENT") {
      fail(`Cannot find "${command}". Ensure Rojo is installed with Rokit and available on PATH.`);
    }
    fail(`${command}: ${result.error.message}`);
  }

  if (result.status !== 0) {
    if (capture && result.stderr) process.stderr.write(result.stderr);
    fail(`${command} exited with code ${result.status ?? "unknown"}.`);
  }

  return capture ? (result.stdout || "").trim() : "";
}

function regenerateInit(root) {
  const generator = path.join(root, "tools", "generate-init.cjs");
  if (!isFile(generator)) fail(`Missing init generator: ${generator}`);

  log("Generating scripts/init.luau...");
  run(process.execPath, [generator], root);
  log("Checking generated init.luau...");
  run(process.execPath, [generator, "--check"], root);
}

function validateBuiltFile(filename, format) {
  if (!isFile(filename)) fail(`Rojo did not create the model: ${filename}`);
  const stat = fs.statSync(filename);
  if (stat.size === 0) fail(`Built model is empty: ${filename}`);

  const handle = fs.openSync(filename, "r");
  let buffer;
  try {
    buffer = Buffer.alloc(Math.min(stat.size, 4096));
    fs.readSync(handle, buffer, 0, buffer.length, 0);
  } finally {
    fs.closeSync(handle);
  }

  if (format === "rbxm") {
    if (!buffer.subarray(0, 8).equals(Buffer.from("<roblox!", "ascii"))) {
      fail(`Invalid .rbxm header: ${filename}`);
    }
    return;
  }

  // Rojo may emit an XML declaration before the <roblox> root element.
  const text = buffer.toString("utf8").replace(/^\uFEFF/, "");
  const xmlModel = /^\s*(?:<\?xml\s[^?]*\?>\s*)?(?:<!--[^]*?-->\s*)*<roblox(?:\s|>)/;
  if (!xmlModel.test(text)) {
    fail(`Invalid .rbxmx XML header: ${filename}`);
  }
}

function createTemporaryProject(root, source, modelName) {
  const filename = path.join(root, `.reactily-release-${crypto.randomUUID()}.project.json`);
  const project = {
    name: modelName,
    tree: { $path: source.split(path.sep).join("/") },
  };
  // Exclusive create avoids overwriting a user's project file.
  fs.writeFileSync(filename, `${JSON.stringify(project, null, 2)}\n`, { flag: "wx" });
  return filename;
}

function buildRelease(options) {
  const root = findProjectRoot(__dirname, options.source);
  const pkg = readPackage(root);
  const version = validateVersion(options.version ?? pkg.version);
  const modelName = validateName(options.name);
  const sourcePath = path.resolve(root, options.source);
  const releaseRoot = path.resolve(root, options.releaseDir);
  const versionDirectory = path.join(releaseRoot, version);
  const outputFile = path.join(versionDirectory, `${modelName}.${options.format}`);

  ensureSafeOutputPath(root, sourcePath, releaseRoot, versionDirectory);

  log(`Project: ${root}`);
  log(`Runtime source: ${sourcePath}`);
  log(`Version: ${version}`);

  if (!options.skipGenerate) regenerateInit(root);

  const initPath = path.join(sourcePath, "init.luau");
  if (!isFile(initPath)) fail(`Missing generated runtime entry point: ${initPath}`);

  // Check Rojo before deleting an existing release with --clean.
  const rojoVersion = run("rojo", ["--version"], root, true);
  if (rojoVersion) log(`Rojo: ${rojoVersion}`);

  if (options.clean && isDirectory(versionDirectory)) {
    log(`Cleaning: ${versionDirectory}`);
    fs.rmSync(versionDirectory, { recursive: true, force: true });
  }
  fs.mkdirSync(versionDirectory, { recursive: true });

  const projectPath = createTemporaryProject(root, options.source, modelName);
  const temporaryOutput = path.join(
    versionDirectory,
    `.${modelName}.${crypto.randomUUID()}.${options.format}`,
  );

  try {
    log(`Building ${modelName}.${options.format}...`);
    run("rojo", ["build", projectPath, "-o", temporaryOutput], root);
    validateBuiltFile(temporaryOutput, options.format);

    // Only replace a previous release once the new artifact passed validation.
    if (isFile(outputFile)) fs.unlinkSync(outputFile);
    fs.renameSync(temporaryOutput, outputFile);
  } finally {
    fs.rmSync(projectPath, { force: true });
    fs.rmSync(temporaryOutput, { force: true });
  }

  log("Release build complete.");
  log(`Output: ${path.relative(root, outputFile)}`);
  log(`Size: ${fs.statSync(outputFile).size.toLocaleString("en-US")} bytes`);
}

try {
  const options = parseArgs(process.argv.slice(2));
  if (options.help) printHelp();
  else buildRelease(options);
} catch (error) {
  process.exitCode = 1;
  process.stderr.write(`[Reactily] ERROR: ${error instanceof Error ? error.message : String(error)}\n`);
}
