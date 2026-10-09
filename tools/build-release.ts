#!/usr/bin/env node
/**
 * Reactily · Lily Studios
 * Copyright (c) Lily Studios and contributors.
 * Licensed under the MIT License.
 * See LICENSE in the repository root for full terms.
 *
 * Generate Reactily's public API and package scripts/ as a Roblox model.
 */

import * as crypto from "node:crypto";
import * as fs from "node:fs";
import * as path from "node:path";
import { spawnSync } from "node:child_process";
import process from "node:process";
import { fileURLToPath } from "node:url";

const TOOL_DIRECTORY = path.dirname(fileURLToPath(import.meta.url));
const DEFAULT_SOURCE = "scripts";
const DEFAULT_RELEASE_DIR = "release";
const DEFAULT_NAME = "Reactily";
const DEFAULT_FORMAT = "rbxm";

type ModelFormat = "rbxm" | "rbxmx";

interface BuildOptions {
  version: string | null;
  format: ModelFormat;
  name: string;
  source: string;
  releaseDir: string;
  skipGenerate: boolean;
  clean: boolean;
  help: boolean;
}

interface PackageMetadata {
  version: string;
}

interface RojoProject {
  name: string;
  tree: { $path: string };
}

function log(message: string): void {
  process.stdout.write(`[Reactily] ${message}\n`);
}

function fail(message: string): never {
  throw new Error(message);
}

function getArgumentValue(args: readonly string[], index: number, option: string): string {
  const value = args[index + 1];
  if (!value || value.startsWith("--")) {
    fail(`${option} requires a value.`);
  }
  return value;
}

function parseArguments(args: readonly string[]): BuildOptions {
  const options: BuildOptions = {
    version: null,
    format: DEFAULT_FORMAT,
    name: DEFAULT_NAME,
    source: DEFAULT_SOURCE,
    releaseDir: DEFAULT_RELEASE_DIR,
    skipGenerate: false,
    clean: false,
    help: false,
  };

  for (let index = 0; index < args.length; index += 1) {
    const argument = args[index];
    switch (argument) {
      case "--version":
      case "--format":
      case "--name":
      case "--source":
      case "--release-dir": {
        const value = getArgumentValue(args, index, argument);
        index += 1;
        switch (argument) {
          case "--version": options.version = value; break;
          case "--format": {
            if (value !== "rbxm" && value !== "rbxmx") {
              fail(`Unsupported format "${value}". Use rbxm or rbxmx.`);
            }
            options.format = value;
            break;
          }
          case "--name": options.name = value; break;
          case "--source": options.source = value; break;
          case "--release-dir": options.releaseDir = value; break;
          default: break;
        }
        break;
      }
      case "--skip-generate": options.skipGenerate = true; break;
      case "--clean": options.clean = true; break;
      case "--help":
      case "-h": options.help = true; break;
      default: fail(`Unknown argument: ${argument}`);
    }
  }

  return options;
}

function printHelp(): void {
  process.stdout.write([
    "Reactily release builder",
    "",
    "Usage:",
    "  node --experimental-strip-types tools/build-release.ts [options]",
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
  ].join("\n"));
}

function isFile(target: string): boolean {
  try { return fs.statSync(target).isFile(); }
  catch { return false; }
}

function isDirectory(target: string): boolean {
  try { return fs.statSync(target).isDirectory(); }
  catch { return false; }
}

function isWithin(parent: string, target: string): boolean {
  const relative = path.relative(parent, target);
  return relative === "" ||
    (relative !== ".." && !relative.startsWith(`..${path.sep}`) && !path.isAbsolute(relative));
}

function findProjectRoot(startDirectory: string, sourceFolder: string): string {
  let current = fs.realpathSync(startDirectory);
  while (true) {
    const sourcePath = path.resolve(current, sourceFolder);
    if (
      isWithin(current, sourcePath) &&
      isFile(path.join(current, "package.json")) &&
      ["core", "runtime", "state", "virtual"].every((name) => isDirectory(path.join(sourcePath, name)))
    ) {
      return current;
    }
    const parent = path.dirname(current);
    if (parent === current) {
      fail(`Cannot find the Reactily project root. Expected package.json and ${sourceFolder}/{core,runtime,state,virtual}.`);
    }
    current = parent;
  }
}

function readPackage(root: string): PackageMetadata {
  const filename = path.join(root, "package.json");
  let parsed: unknown;
  try {
    parsed = JSON.parse(fs.readFileSync(filename, "utf8")) as unknown;
  } catch (error: unknown) {
    fail(`Could not parse ${filename}: ${error instanceof Error ? error.message : String(error)}`);
  }
  if (typeof parsed !== "object" || parsed === null || Array.isArray(parsed)) {
    fail("package.json must contain a JSON object.");
  }
  const version = (parsed as Record<string, unknown>)["version"];
  if (typeof version !== "string") {
    fail(`Missing package.json version: ${filename}`);
  }
  return { version };
}

function validateVersion(value: string): string {
  const version = value.trim();
  if (!/^[0-9A-Za-z][0-9A-Za-z.+_-]*$/.test(version)) {
    fail(`Invalid release version: ${value}`);
  }
  return version;
}

function validateName(value: string): string {
  const name = value.trim();
  if (!/^[A-Za-z0-9][A-Za-z0-9._ -]*$/.test(name)) {
    fail(`Invalid model name: ${value}`);
  }
  return name;
}

function ensureSafeOutputPath(root: string, sourcePath: string, releaseRoot: string, versionDirectory: string): void {
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

  // Refuse symlink traversal, particularly before --clean removes any directory.
  const parts = path.relative(root, versionDirectory).split(path.sep);
  let current = root;
  for (const part of parts) {
    current = path.join(current, part);
    try {
      if (fs.lstatSync(current).isSymbolicLink()) {
        fail(`Refusing a release path containing a symbolic link: ${current}`);
      }
    } catch (error: unknown) {
      if (!(error instanceof Error && "code" in error && error.code === "ENOENT")) {
        throw error;
      }
    }
  }
}

function run(command: string, args: readonly string[], cwd: string, capture = false): string {
  const result = spawnSync(command, [...args], {
    cwd,
    encoding: "utf8",
    stdio: capture ? ["ignore", "pipe", "pipe"] : "inherit",
  });
  if (result.error) {
    if ("code" in result.error && result.error.code === "ENOENT") {
      fail(`Cannot find "${command}". Ensure Rojo is installed with Rokit and available on PATH.`);
    }
    fail(`${command}: ${result.error.message}`);
  }
  if (result.status !== 0) {
    if (capture && result.stderr) process.stderr.write(result.stderr);
    fail(`${command} exited with code ${result.status ?? "unknown"}.`);
  }
  return capture ? (result.stdout ?? "").trim() : "";
}

function regenerateInit(root: string): void {
  const generator = path.join(root, "tools", "generate-init.ts");
  if (!isFile(generator)) {
    fail(`Missing TypeScript init generator: ${generator}`);
  }
  log("Generating scripts/init.luau...");
  run(process.execPath, ["--experimental-strip-types", generator], root);
  log("Checking generated init.luau...");
  run(process.execPath, ["--experimental-strip-types", generator, "--check"], root);
}

function validateBuiltFile(filename: string, format: ModelFormat): void {
  if (!isFile(filename)) fail(`Rojo did not create the model: ${filename}`);
  const stat = fs.statSync(filename);
  if (stat.size === 0) fail(`Built model is empty: ${filename}`);

  const descriptor = fs.openSync(filename, "r");
  let buffer: Buffer;
  try {
    buffer = Buffer.alloc(Math.min(stat.size, 4096));
    fs.readSync(descriptor, buffer, 0, buffer.length, 0);
  } finally {
    fs.closeSync(descriptor);
  }
  if (format === "rbxm") {
    if (!buffer.subarray(0, 8).equals(Buffer.from("<roblox!", "ascii"))) {
      fail(`Invalid .rbxm header: ${filename}`);
    }
    return;
  }
  const xml = buffer.toString("utf8").replace(/^\uFEFF/, "");
  const xmlModel = /^\s*(?:<\?xml\s[^?]*\?>\s*)?(?:<!--[\s\S]*?-->\s*)*<roblox(?:\s|>)/;
  if (!xmlModel.test(xml)) {
    fail(`Invalid .rbxmx XML header: ${filename}`);
  }
}

function createTemporaryProject(root: string, source: string, modelName: string): string {
  const filename = path.join(root, `.reactily-release-${crypto.randomUUID()}.project.json`);
  const project: RojoProject = {
    name: modelName,
    tree: { $path: source.split(path.sep).join("/") },
  };
  fs.writeFileSync(filename, `${JSON.stringify(project, null, 2)}\n`, { flag: "wx" });
  return filename;
}

function buildRelease(options: BuildOptions): void {
  const root = findProjectRoot(TOOL_DIRECTORY, options.source);
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

  // Ensure Rojo exists before --clean removes an older release.
  const rojoVersion = run("rojo", ["--version"], root, true);
  if (rojoVersion) log(`Rojo: ${rojoVersion}`);

  if (options.clean && isDirectory(versionDirectory)) {
    log(`Cleaning: ${versionDirectory}`);
    fs.rmSync(versionDirectory, { recursive: true, force: true });
  }
  fs.mkdirSync(versionDirectory, { recursive: true });

  const projectPath = createTemporaryProject(root, options.source, modelName);
  const temporaryOutput = path.join(versionDirectory, `.${modelName}.${crypto.randomUUID()}.${options.format}`);
  try {
    log(`Building ${modelName}.${options.format}...`);
    run("rojo", ["build", projectPath, "-o", temporaryOutput], root);
    validateBuiltFile(temporaryOutput, options.format);
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
  const options = parseArguments(process.argv.slice(2));
  if (options.help) printHelp();
  else buildRelease(options);
} catch (error: unknown) {
  process.exitCode = 1;
  process.stderr.write(`[Reactily] ERROR: ${error instanceof Error ? error.message : String(error)}\n`);
}
