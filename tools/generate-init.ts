/**
 * Reactily · Lily Studios
 * Automatic Luau public API generator.
 *
 * Discovers returned module members and exported types directly from Luau.
 * No JavaScript export registry or @reactily export annotations.
 */

import * as fs from "node:fs";
import * as path from "node:path";
import process from "node:process";
import { fileURLToPath } from "node:url";

const TOOL_DIRECTORY = path.dirname(fileURLToPath(import.meta.url));
const IDENTIFIER = "[A-Za-z_][A-Za-z0-9_]*";
const TOKEN = new RegExp(`^${IDENTIFIER}$`);
const FUNCTION = new RegExp(String.raw`^\s*function\s+module[.:](${IDENTIFIER})(?:\s*<[^>\n]+>)?\s*\(`);
const ASSIGNMENT = new RegExp(String.raw`^\s*module(?:\.(${IDENTIFIER})|\[\s*["'](${IDENTIFIER})["']\s*\])\s*=(?!=)\s*(.*)$`);
const EXPORTED_TYPE = new RegExp(String.raw`^\s*export\s+type\s+(${IDENTIFIER})(\s*<[^>\n]+>)?\s*=`);
const MODULE_RETURN = /^\s*return\s+module\s*(?:--[^\n]*)?$/m;
const SEPARATOR = "--————————————————————————————————————————————————————————————————————--";

type MemberKind = "function" | "assignment";

interface GeneratorOptions {
  root: string | null;
  source: string;
  out: string;
  check: boolean;
  dryRun: boolean;
  verbose: boolean;
  help: boolean;
}

interface ModuleMember {
  name: string;
  key: string;
  type: MemberKind;
  expression: string | null;
}

interface ExportedType {
  name: string;
  key: string;
  generic: string;
}

interface SourceModule {
  key: string;
  namespace: string;
  methods: Map<string, ModuleMember>;
  types: Map<string, ExportedType>;
}

interface GenerationCounts {
  sources: number;
  runtimeMembers: number;
  typeExports: number;
  namespaces: number;
  ambiguousNamespaceOnlyMethods: number;
}

interface GenerationResult {
  text: string;
  counts: GenerationCounts;
  ambiguous: string[];
}

function fail(message: string): never {
  throw new Error(message);
}

function parseOptions(argv: readonly string[]): GeneratorOptions {
  const options: GeneratorOptions = {
    root: null,
    source: "scripts",
    out: "init.luau",
    check: false,
    dryRun: false,
    verbose: false,
    help: false,
  };

  for (let index = 0; index < argv.length; index += 1) {
    const argument = argv[index];
    switch (argument) {
      case "--help":
      case "-h":
        options.help = true;
        break;
      case "--check":
        options.check = true;
        break;
      case "--dry-run":
        options.dryRun = true;
        break;
      case "--verbose":
      case "--debug":
        options.verbose = true;
        break;
      case "--root":
      case "--source":
      case "--out": {
        const value = argv[index + 1];
        if (!value || value.startsWith("--")) {
          fail(`${argument} requires a value`);
        }
        if (argument === "--root") options.root = value;
        if (argument === "--source") options.source = value;
        if (argument === "--out") options.out = value;
        index += 1;
        break;
      }
      default:
        fail(`Unknown argument: ${argument ?? "<empty>"}`);
    }
  }

  if (!TOKEN.test(options.source) || !/^[\w-]+\.luau$/.test(options.out)) {
    fail("--source must be a simple directory name and --out a simple .luau filename");
  }
  return options;
}

function findRoot(options: GeneratorOptions): string {
  const explicit = options.root ?? process.env.REACTILY_ROOT;
  const starts = explicit ? [explicit] : [process.cwd(), TOOL_DIRECTORY];
  for (const start of starts) {
    let current = path.resolve(start);
    for (;;) {
      const directory = path.join(current, options.source);
      if (fs.existsSync(directory) && fs.statSync(directory).isDirectory()) return current;
      const parent = path.dirname(current);
      if (parent === current) break;
      current = parent;
    }
  }
  return fail(`Cannot find the ${options.source} source directory. Use --root <directory>.`);
}

function readLuauFiles(directory: string, outputFile: string, found: string[] = []): string[] {
  const entries = fs.readdirSync(directory, { withFileTypes: true })
    .sort((left, right) => left.name.localeCompare(right.name));

  for (const entry of entries) {
    const target = path.join(directory, entry.name);
    if (entry.isDirectory()) readLuauFiles(target, outputFile, found);
    else if (entry.isFile() && target !== outputFile && entry.name.endsWith(".luau")) found.push(target);
  }
  return found;
}

function pascalCase(stem: string): string {
  const name = stem.replace(/(^|[-_\s]+)([a-zA-Z0-9])/g, (_whole, _separator: string, character: string) => character.toUpperCase());
  if (!/^[A-Z][A-Za-z0-9]*$/.test(name)) fail(`Invalid namespace derived from '${stem}'`);
  return name;
}

function parseSource(file: string, sourceRoot: string): SourceModule | null {
  const key = path.relative(sourceRoot, file).split(path.sep).join("/").replace(/\.luau$/, "");
  const content = fs.readFileSync(file, "utf8");
  if (/---\s*@reactily(?:Export|Type|Value|Namespace)\b/.test(content)) {
    fail(`${key}: legacy @reactily annotations are unsupported; declare module members directly`);
  }
  if (!MODULE_RETURN.test(content)) return null;

  const methods = new Map<string, ModuleMember>();
  const types = new Map<string, ExportedType>();
  const lines = content.split(/\r?\n/);
  for (const [index, line] of lines.entries()) {
    const method = line.match(FUNCTION);
    const assigned = line.match(ASSIGNMENT);
    const exported = line.match(EXPORTED_TYPE);
    if (method || assigned) {
      const name = method?.[1] ?? assigned?.[1] ?? assigned?.[2];
      if (!name) fail(`${key}:${index + 1}: missing module member name`);
      methods.set(name, {
        name,
        key,
        type: method ? "function" : "assignment",
        expression: assigned?.[3] ?? null,
      });
    }
    if (exported) {
      const name = exported[1];
      if (!name) fail(`${key}:${index + 1}: invalid exported type`);
      if (types.has(name)) fail(`${key}:${index + 1}: duplicate exported type '${name}'`);
      if (!/^[A-Z][A-Za-z0-9]*$/.test(name)) {
        fail(`${key}:${index + 1}: exported type '${name}' must be PascalCase`);
      }
      types.set(name, { name, key, generic: (exported[2] ?? "").trim() });
    }
  }
  return { key, namespace: pascalCase(path.posix.basename(key)), methods, types };
}

function sourceVariable(key: string): string {
  return `source_${key.replace(/[^a-zA-Z0-9_]/g, "_")}`;
}

function createRequire(key: string): string {
  return "script" + key.split("/").map((part) =>
    TOKEN.test(part) ? `.${part}` : `[${JSON.stringify(part)}]`,
  ).join("");
}

function genericArguments(generic: string): string {
  if (!generic) return "";
  const argumentsList = generic.slice(1, -1).split(",").map((entry) => {
    const match = entry.trim().match(/^([A-Za-z_]\w*)(\.\.\.)?/);
    if (!match?.[1]) fail(`Unsupported type parameter '${entry}' in '${generic}'`);
    return `${match[1]}${match[2] ?? ""}`;
  });
  return `<${argumentsList.join(", ")}>`;
}

function discover(root: string, source: string, out: string): SourceModule[] {
  const sourceRoot = path.join(root, source);
  const modules = readLuauFiles(sourceRoot, path.join(sourceRoot, out))
    .map((file) => parseSource(file, sourceRoot))
    .filter((moduleInfo): moduleInfo is SourceModule => moduleInfo !== null);
  if (modules.length === 0) fail("No module-returning Luau files were discovered");

  const variables = new Map<string, string>();
  for (const moduleInfo of modules) {
    const variable = sourceVariable(moduleInfo.key);
    const existing = variables.get(variable);
    if (existing) fail(`Generated variable name collision: ${existing} and ${moduleInfo.key}`);
    variables.set(variable, moduleInfo.key);
  }
  return modules;
}

function collectRuntime(modules: readonly SourceModule[]): {
  available: Map<string, ModuleMember>;
  ambiguous: string[];
} {
  const candidates = new Map<string, ModuleMember[]>();
  for (const source of modules) {
    for (const member of source.methods.values()) {
      const group = candidates.get(member.name) ?? [];
      group.push(member);
      candidates.set(member.name, group);
    }
  }

  const available = new Map<string, ModuleMember>();
  const ambiguous: string[] = [];
  for (const [name, group] of [...candidates].sort(([left], [right]) => left.localeCompare(right))) {
    if (group.length === 1 && group[0]) {
      available.set(name, group[0]);
      continue;
    }
    const callable = group.filter((item) => item.type === "assignment" && /^setmetatable\s*\(/.test(item.expression ?? ""));
    if (callable.length === 1 && callable[0]) {
      available.set(name, callable[0]);
      continue;
    }
    if (/^(?:create|use|resolve|apply|bind|format)[A-Z]/.test(name)) {
      fail(`Duplicate public API '${name}' in ${group.map((member) => member.key).join(", ")}. Rename one Luau member.`);
    }
    ambiguous.push(`${name} (${group.map((member) => member.key).join(", ")})`);
  }
  return { available, ambiguous };
}

function collectTypes(modules: readonly SourceModule[]): Map<string, ExportedType> {
  const types = new Map<string, ExportedType>();
  for (const source of modules) {
    for (const type of source.types.values()) {
      const previous = types.get(type.name);
      if (previous) {
        fail(`Duplicate public type '${type.name}' in ${previous.key} and ${type.key}`);
      }
      types.set(type.name, type);
    }
  }
  return types;
}

function generate(modules: readonly SourceModule[]): GenerationResult {
  const { available, ambiguous } = collectRuntime(modules);
  const types = collectTypes(modules);
  const namespaces = new Map<string, SourceModule>();
  for (const source of modules) {
    const other = namespaces.get(source.namespace);
    if (other) fail(`Namespace '${source.namespace}' derives from ${other.key} and ${source.key}; rename a file`);
    namespaces.set(source.namespace, source);
  }

  const output = [
    "--[[",
    "\tReactily · Lily Studios",
    "\tCopyright (c) Lily Studios and contributors.",
    "\tLicensed under the MIT License.",
    "\tSee LICENSE in the repository root for full terms.",
    "]]",
    "",
    "--!strict",
    "",
    "-- Generated by tools/generate-init.ts",
    "-- No annotations or external export maps. Do not edit by hand.",
    "",
    "local module = {}",
    "",
    SEPARATOR,
    "",
  ];

  for (const source of [...modules].sort((left, right) => left.key.localeCompare(right.key))) {
    output.push(`local ${sourceVariable(source.key)} = require(${createRequire(source.key)})`);
  }
  output.push("", SEPARATOR, "");
  for (const type of [...types.values()].sort((left, right) => left.name.localeCompare(right.name))) {
    output.push(`export type ${type.name}${type.generic} = ${sourceVariable(type.key)}.${type.name}${genericArguments(type.generic)}`);
  }
  output.push("", SEPARATOR, "");
  for (const member of available.values()) {
    output.push(`module.${member.name} = ${sourceVariable(member.key)}.${member.name}`);
  }
  output.push("", SEPARATOR, "");
  let generatedNamespaces = 0;
  for (const source of [...namespaces.values()].sort((left, right) => left.namespace.localeCompare(right.namespace))) {
    if (available.has(source.namespace)) continue;
    output.push(`module.${source.namespace} = ${sourceVariable(source.key)}`);
    generatedNamespaces += 1;
  }
  output.push("", SEPARATOR, "", "return module", "");
  return {
    text: output.join("\n"),
    counts: {
      sources: modules.length,
      runtimeMembers: available.size,
      typeExports: types.size,
      namespaces: generatedNamespaces,
      ambiguousNamespaceOnlyMethods: ambiguous.length,
    },
    ambiguous,
  };
}

function main(): void {
  const options = parseOptions(process.argv.slice(2));
  if (options.help) {
    process.stdout.write("Reactily automatic Luau API generator\n\nnode --experimental-strip-types tools/generate-init.ts [--check] [--dry-run] [--verbose] [--root <path>] [--source scripts] [--out init.luau]\n");
    return;
  }
  const root = findRoot(options);
  const outputFile = path.join(root, options.source, options.out);
  const result = generate(discover(root, options.source, options.out));
  if (options.verbose) {
    process.stderr.write(`[Reactily] ${JSON.stringify(result.counts)}\n`);
    for (const name of result.ambiguous) process.stderr.write(`[Reactily] Namespace only: ${name}\n`);
  }
  if (options.check) {
    if (!fs.existsSync(outputFile) || fs.readFileSync(outputFile, "utf8") !== result.text) {
      fail(`${options.source}/${options.out} is out of date. Run node --experimental-strip-types tools/generate-init.ts`);
    }
    process.stdout.write("[Reactily] generated init is current\n");
  } else if (options.dryRun) {
    process.stdout.write(result.text);
  } else {
    fs.writeFileSync(outputFile, result.text, "utf8");
    process.stdout.write(`[Reactily] generated ${options.source}/${options.out}: ${JSON.stringify(result.counts)}\n`);
  }
}

try {
  main();
} catch (error: unknown) {
  process.stderr.write(`[Reactily] ${error instanceof Error ? error.message : String(error)}\n`);
  process.exitCode = 1;
}
