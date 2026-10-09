#!/usr/bin/env node
/**
 * Reactily · Lily Studios
 * Cross-module dependency and generated API verification.
 *
 * The naming/host contract checks remain in check-naming.ts; this verifier
 * adds require cycle detection and checks the generated public entry point.
 */

import * as fs from "node:fs";
import * as path from "node:path";
import { spawnSync } from "node:child_process";
import process from "node:process";
import { fileURLToPath } from "node:url";

const TOOL_DIRECTORY = path.dirname(fileURLToPath(import.meta.url));
const REQUIRE_PATTERN = /\brequire\s*\(\s*(script(?:\s*\.\s*[A-Za-z_][A-Za-z0-9_]*|\s*\[\s*["'][^"']+["']\s*\])+?)\s*\)/g;
const SEGMENT_PATTERN = /\.\s*([A-Za-z_][A-Za-z0-9_]*)|\[\s*["']([^"']+)["']\s*\]/g;

function fail(message: string): never { throw new Error(message); }

function getRoot(args: readonly string[]): string | null {
  let root = path.resolve(TOOL_DIRECTORY, "..");
  for (let index = 0; index < args.length; index += 1) {
    const arg = args[index];
    if (arg === "--help" || arg === "-h") {
      process.stdout.write("Usage: node --experimental-strip-types tools/verify-reactily.ts [--root <repository>]\n");
      return null;
    }
    if (arg === "--root") {
      const value = args[index + 1];
      if (!value || value.startsWith("--")) fail("--root requires a repository path");
      root = path.resolve(value);
      index += 1;
    } else {
      fail(`Unknown argument: ${arg}`);
    }
  }
  return root;
}

function listModules(directory: string, output: string[] = []): string[] {
  for (const entry of fs.readdirSync(directory, { withFileTypes: true })) {
    const absolute = path.join(directory, entry.name);
    if (entry.isDirectory()) listModules(absolute, output);
    else if (entry.isFile() && entry.name.endsWith(".luau")) output.push(absolute);
  }
  return output;
}

function parseRequire(sourceRoot: string, file: string, expression: string): string {
  let current = path.basename(file) === "init.luau" && file === path.join(sourceRoot, "init.luau")
    ? sourceRoot
    : file.slice(0, -".luau".length);
  for (const segment of expression.matchAll(SEGMENT_PATTERN)) {
    const name = segment[1] ?? segment[2];
    if (!name) continue;
    current = name === "Parent" ? path.dirname(current) : path.join(current, name);
  }
  return `${current}.luau`;
}

function verifyDependencies(root: string): void {
  const sourceRoot = path.join(root, "scripts");
  if (!fs.existsSync(sourceRoot)) fail(`Missing Luau source directory: ${sourceRoot}`);
  const files = listModules(sourceRoot);
  const fileSet = new Set(files);
  const graph = new Map<string, string[]>();
  const errors: string[] = [];
  let checkedImports = 0;
  const relative = (filename: string): string => path.relative(sourceRoot, filename).split(path.sep).join("/");

  for (const filename of files) {
    const contents = fs.readFileSync(filename, "utf8").replace(/--\[\[[\s\S]*?\]\]/g, "").replace(/--[^\n]*/g, "");
    const dependencies: string[] = [];
    for (const match of contents.matchAll(REQUIRE_PATTERN)) {
      const expression = match[1];
      if (!expression) continue;
      const dependency = parseRequire(sourceRoot, filename, expression);
      checkedImports += 1;
      if (!fileSet.has(dependency)) {
        errors.push(`${relative(filename)}: unresolved require ${expression} -> ${relative(dependency)}`);
      } else {
        dependencies.push(dependency);
      }
    }
    graph.set(filename, dependencies);
  }

  const visited = new Set<string>();
  const active = new Set<string>();
  const trace: string[] = [];
  function visit(filename: string): void {
    if (active.has(filename)) {
      const index = trace.indexOf(filename);
      errors.push(`Circular require: ${[...trace.slice(index), filename].map(relative).join(" -> ")}`);
      return;
    }
    if (visited.has(filename)) return;
    active.add(filename);
    trace.push(filename);
    for (const dependency of graph.get(filename) ?? []) visit(dependency);
    trace.pop();
    active.delete(filename);
    visited.add(filename);
  }
  for (const filename of graph.keys()) visit(filename);

  if (errors.length > 0) fail(errors.join("\n"));
  process.stdout.write(`[Reactily] PASS: ${files.length} Luau modules, ${checkedImports} requires, no missing targets or cycles.\n`);
}

function runTool(root: string, filename: string, args: readonly string[]): void {
  const target = path.join(root, "tools", filename);
  if (!fs.existsSync(target)) fail(`Missing tool: ${target}`);
  const result = spawnSync(process.execPath, ["--experimental-strip-types", target, ...args], {
    cwd: root,
    stdio: "inherit",
  });
  if (result.error) fail(`${filename}: ${result.error.message}`);
  if (result.status !== 0) fail(`${filename} failed (${result.status ?? "unknown"})`);
}

try {
  const root = getRoot(process.argv.slice(2));
  if (root !== null) {
    verifyDependencies(root);
    runTool(root, "check-naming.ts", ["--root", root]);
    runTool(root, "generate-init.ts", ["--root", root, "--check"]);
    process.stdout.write("[Reactily] PASS: dependency, naming, host, and generated API checks.\n");
  }
} catch (error: unknown) {
  process.exitCode = 1;
  process.stderr.write(`[Reactily] ERROR: ${error instanceof Error ? error.message : String(error)}\n`);
}
