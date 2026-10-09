/**
 * Reactily · Lily Studios
 * Source-discovery generator regression tests.
 */

import assert from "node:assert/strict";
import { spawnSync, type SpawnSyncReturns } from "node:child_process";
import * as fs from "node:fs";
import * as os from "node:os";
import * as path from "node:path";
import process from "node:process";
import { fileURLToPath } from "node:url";

const TOOL_DIRECTORY = path.dirname(fileURLToPath(import.meta.url));
const generator = path.join(TOOL_DIRECTORY, "generate-init.ts");
const root = fs.mkdtempSync(path.join(os.tmpdir(), "reactily-auto-exports-ts-"));
const source = path.join(root, "scripts");
const alpha = path.join(source, "core", "alpha.luau");
const beta = path.join(source, "runtime", "beta.luau");
const outputFile = path.join(source, "init.luau");

function run(...args: string[]): SpawnSyncReturns<string> {
  return spawnSync(process.execPath, ["--experimental-strip-types", generator, "--root", root, ...args], {
    encoding: "utf8",
    cwd: path.resolve(TOOL_DIRECTORY, ".."),
  });
}

function write(file: string, content: string): void {
  fs.writeFileSync(file, content, "utf8");
}

function output(): string {
  return fs.readFileSync(outputFile, "utf8");
}

function mustPass(args: string[], reason: string): void {
  const result = run(...args);
  assert.equal(result.status, 0, `${reason}: ${result.stderr}`);
}

function mustFail(args: string[], reason: string): void {
  const result = run(...args);
  assert.notEqual(result.status, 0, `${reason}: ${result.stdout}`);
}

try {
  fs.mkdirSync(path.dirname(alpha), { recursive: true });
  fs.mkdirSync(path.dirname(beta), { recursive: true });

  write(alpha, [
    "--!strict",
    "local module = {}",
    "export type Profile<T> = { value: T }",
    "type LocalOnly = { n: number }",
    "local function internalHelper() end",
    "function module.new() return {} end",
    "function module.createAlpha() return module.new() end",
    "function module.getValue() return 10 end",
    "module.SETTING = 12",
    "return module",
  ].join("\n"));
  write(beta, [
    "--!strict",
    "local module = {}",
    "function module.createBeta() return true end",
    "function module.new() end",
    "return module",
  ].join("\n"));

  mustPass([], "initial generation");
  assert.match(output(), /module\.createAlpha = source_core_alpha\.createAlpha/);
  assert.match(output(), /module\.createBeta = source_runtime_beta\.createBeta/);
  assert.match(output(), /module\.Alpha = source_core_alpha/);
  assert.match(output(), /module\.Beta = source_runtime_beta/);
  assert.match(output(), /module\.SETTING = source_core_alpha\.SETTING/);
  assert.match(output(), /export type Profile<T> = source_core_alpha\.Profile<T>/);
  assert.doesNotMatch(output(), /module\.internalHelper/);
  assert.doesNotMatch(output(), /module\.new =/);
  assert.doesNotMatch(output(), /LocalOnly/);
  mustPass(["--check"], "initial --check");
  mustPass([], "deterministic regeneration");
  mustPass(["--check"], "repeated --check");

  write(alpha, fs.readFileSync(alpha, "utf8").replace(/^return module$/m,
    "function module.useNewFeature() end\nreturn module"));
  mustFail(["--check"], "new Luau member invalidates init");
  mustPass([], "regenerate after new API");
  assert.match(output(), /module\.useNewFeature = source_core_alpha\.useNewFeature/);

  write(alpha, fs.readFileSync(alpha, "utf8").replaceAll("createAlpha", "createWidget"));
  mustPass([], "regenerate after rename");
  assert.match(output(), /module\.createWidget = source_core_alpha\.createWidget/);
  assert.doesNotMatch(output(), /module\.createAlpha =/);

  write(beta, fs.readFileSync(beta, "utf8").replace(/^return module$/m,
    "function module.createWidget() end\nreturn module"));
  mustFail([], "reject duplicate public API");
  write(beta, fs.readFileSync(beta, "utf8").replace("function module.createWidget() end\n", ""));
  mustPass([], "restore public API uniqueness");

  write(beta, fs.readFileSync(beta, "utf8").replace(/^return module$/m,
    "export type Profile = { age: number }\nreturn module"));
  mustFail([], "reject duplicate type exports");
  write(beta, fs.readFileSync(beta, "utf8").replace("export type Profile", "type Profile"));
  mustPass([], "local types remain private");

  write(alpha, fs.readFileSync(alpha, "utf8").replace(/^return module$/m,
    "module.createAlias = module.new\nreturn module"));
  mustPass([], "source-owned public alias");
  assert.match(output(), /module\.createAlias = source_core_alpha\.createAlias/);

  // Renaming a file must not silently drop an explicitly exported public namespace.
  const child = path.join(source, "virtual", "child.luau");
  fs.mkdirSync(path.dirname(child), { recursive: true });
  write(child, [
    "--!strict",
    "local module = {}",
    "function module.count() return 0 end",
    "module.Children = { count = module.count }",
    "return module",
  ].join("\n"));
  mustFail(["--check"], "a new public namespace invalidates generated init");
  mustPass([], "source-owned namespace alias from renamed child module");
  assert.match(output(), /local source_virtual_child = require\(script\.virtual\.child\)/);
  assert.match(output(), /module\.Children = source_virtual_child\.Children/);
  mustPass(["--check"], "renamed module namespace alias remains deterministic");

  write(alpha, fs.readFileSync(alpha, "utf8").replace("function module.getValue",
    "--- @reactilyExport getValue\nfunction module.getValue"));
  mustFail([], "legacy annotations rejected");

  process.stdout.write("PASS: automatic exports, namespaces, types, values, private helpers, duplicate detection, aliases, explicit namespaces, --check, determinism, renames\n");
} finally {
  fs.rmSync(root, { recursive: true, force: true });
}
