/**
 * Execute the real Luau modules with a small, deterministic engine fixture.
 * Only Roblox-style require paths are rewritten; implementation code is unchanged.
 */
import { spawnSync } from "node:child_process";
import * as fs from "node:fs";
import * as os from "node:os";
import * as path from "node:path";
import process from "node:process";
import { fileURLToPath } from "node:url";

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const temporary = fs.mkdtempSync(path.join(os.tmpdir(), "reactily-internals-"));
const sourceRoot = path.join(root, "scripts");
const requirePattern = /\brequire\(\s*(script(?:\.[A-Za-z_][A-Za-z0-9_]*)+)\s*\)/g;

function relativeRequire(from: string, to: string): string {
  const relative = path.relative(path.dirname(from), to).split(path.sep).join("/").replace(/\.luau$/, "");
  return JSON.stringify(relative.startsWith(".") ? relative : `./${relative}`);
}

function copyModules(directory: string): void {
  for (const entry of fs.readdirSync(directory, { withFileTypes: true })) {
    const filename = path.join(directory, entry.name);
    if (entry.isDirectory()) {
      copyModules(filename);
      continue;
    }
    if (!entry.name.endsWith(".luau")) continue;
    const destination = path.join(temporary, "scripts", path.relative(sourceRoot, filename));
    const contents = fs.readFileSync(filename, "utf8").replace(requirePattern, (_match: string, expression: string) => {
      let target = filename === path.join(sourceRoot, "init.luau") ? sourceRoot : filename.slice(0, -5);
      for (const segment of expression.split(".").slice(1)) {
        target = segment === "Parent" ? path.dirname(target) : path.join(target, segment);
      }
      return `require(${relativeRequire(filename, `${target}.luau`)})`;
    });
    const fixture = relativeRequire(destination, path.join(temporary, "environment.luau"));
    fs.mkdirSync(path.dirname(destination), { recursive: true });
    fs.writeFileSync(destination, `local environment = require(${fixture})\nlocal game, task, warn = environment.game, environment.task, environment.warn\n${contents}`);
  }
}

try {
  copyModules(sourceRoot);
  fs.copyFileSync(path.join(root, "tests", "internals.environment.luau"), path.join(temporary, "environment.luau"));
  const suites = fs.readdirSync(path.join(root, "tests")).filter((name) => name.endsWith(".spec.luau")).sort();
  if (suites.length === 0) throw new Error("No internal regression suites found.");
  for (const suite of suites) fs.copyFileSync(path.join(root, "tests", suite), path.join(temporary, suite));
  const modules = {
    batching: "core/batching", scheduler: "core/scheduler", objectPool: "core/objectPool", signal: "core/signal",
    hooks: "state/hooks", atom: "state/atom", history: "state/history", store: "state/store",
    resource: "runtime/resource", binding: "runtime/binding", lazy: "runtime/lazy",
  };
  const runner = [
    'local environment = require("./environment")',
    "local modules = {",
    ...Object.entries(modules).map(([name, filename]) => `  ${name} = require("./scripts/${filename}"),`),
    "  heartbeat = environment.heartbeat, tasks = environment.tasks,",
    "}",
    "local passed, failed = 0, 0",
    "local function expectEqual(actual, expected, message)",
    '  assert(actual == expected, `{message or "Values differ"}: expected {tostring(expected)}, got {tostring(actual)}`)',
    "end",
    "local function test(name, callback)",
    "  local success, failure = pcall(function()",
    "    callback()",
    "    environment.assertClean()",
    "  end)",
    "  environment.reset()",
    "  if success then",
    "    passed += 1",
    '    print(`PASS: {name}`)',
    "  else",
    "    failed += 1",
    '    print(`FAIL: {name}: {failure}`)',
    "  end",
    "end",
    ...suites.map((suite) => `require("./${suite.slice(0, -5)}")(modules, test, expectEqual)`),
    'print(`Reactily internals: {passed} passed, {failed} failed`)',
    'assert(failed == 0, "Internal regression tests failed.")',
  ].join("\n");
  const runnerPath = path.join(temporary, "run.luau");
  fs.writeFileSync(runnerPath, runner);
  const result = spawnSync(process.env.REACTILY_LUAU ?? "luau", [runnerPath], { stdio: "inherit" });
  if (result.error) throw new Error(`Could not run Luau: ${result.error.message}. Install the Luau CLI or set REACTILY_LUAU to its executable.`);
  process.exitCode = result.status ?? 1;
} finally {
  fs.rmSync(temporary, { recursive: true, force: true });
}
