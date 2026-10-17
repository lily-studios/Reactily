/**
 * Reactily · Lily Studios
 * Strict Luau naming and cross-module consistency checker.
 *
 * Checks source declarations and their references, not a hardcoded API export map.
 * Roblox-native properties are required to preserve official PascalCase spelling.
 */

import * as fs from "node:fs";
import * as path from "node:path";
import process from "node:process";
import { fileURLToPath } from "node:url";

const TOOL_DIRECTORY = path.dirname(fileURLToPath(import.meta.url));
const IDENTIFIER = "[A-Za-z_][A-Za-z0-9_]*";

const EXPORTED_MEMBER = new RegExp(
  String.raw`\bfunction\s+module[.:](${IDENTIFIER})\b|\bmodule(?:\.(${IDENTIFIER})|\[\s*["'](${IDENTIFIER})["']\s*\])\s*=(?!=)`,
  "g",
);
const EXPORTED_TYPE = new RegExp(
  String.raw`\bexport\s+type\s+(${IDENTIFIER})\b`,
  "g",
);
const IMPORTED_MODULE = new RegExp(
  String.raw`\blocal\s+(${IDENTIFIER})\s*=\s*require\s*\(\s*(script(?:\s*(?:\.\s*${IDENTIFIER}|\[\s*["'][^"']+["']\s*\]))+)\s*\)`,
  "g",
);
const SCRIPT_SEGMENT =
  /\.\s*([A-Za-z_][A-Za-z0-9_]*)|\[\s*["']([^"']+)["']\s*\]/g;
const MODULE_METHOD = new RegExp(
  String.raw`\bfunction\s+module[.:]([A-Z][A-Za-z0-9_]*)\b`,
  "g",
);
const PUBLIC_MEMBER = new RegExp(
  String.raw`^\s*module\.(${IDENTIFIER})\s*=(?!=)`,
  "gm",
);

const COMPONENT_NAMES = new Set([
  "Activity",
  "StrictMode",
  "Suspense",
  "ErrorBoundary",
  "Profiler",
  "ViewTransition",
]);

const NATIVE_PROPERTIES = [
  "BackgroundColor3",
  "BackgroundTransparency",
  "TextSize",
  "AnchorPoint",
  "Position",
  "Size",
  "Visible",
  "Name",
  "BorderSizePixel",
  "ZIndex",
] as const;

const EVENTS = ["Activated", "InputBegan", "FocusLost", "MouseEnter"] as const;

type Issue = [file: string, message: string];
type ReportIssue = (file: string, message: string) => void;
type SourceMap = Map<string, string>;
type SymbolMap = Map<string, Set<string>>;
type ImportMap = Map<string, Map<string, string>>;

interface CheckerOptions {
  root: string;
  json: string;
}

interface CheckResult {
  source_files: number;
  imports: number;
  types: number;
  unresolved_module_members: number;
  issues: Issue[];
}

// Command-line arguments

function parseArguments(args: readonly string[]): CheckerOptions | null {
  let root = path.resolve(TOOL_DIRECTORY, "..");
  let json: string | null = null;

  for (let index = 0; index < args.length; index += 1) {
    const argument = args[index];
    const value = args[index + 1];

    if (argument === "--root" && value && !value.startsWith("--")) {
      root = path.resolve(value);
      index += 1;
    } else if (argument === "--json" && value && !value.startsWith("--")) {
      json = path.resolve(value);
      index += 1;
    } else if (argument === "--help" || argument === "-h") {
      process.stdout.write(
        "Usage: node --experimental-strip-types tools/check-naming.ts [--root <repository>] [--json <report.json>]\n",
      );
      return null;
    } else {
      throw new Error(`Unknown or incomplete argument: ${argument ?? "<empty>"}`);
    }
  }

  return { root, json: json ?? path.join(root, "check-results.json") };
}

// Luau source discovery and parsing

function listLuauFiles(directory: string): string[] {
  const files: string[] = [];

  function visit(folder: string): void {
    const entries = fs.readdirSync(folder, { withFileTypes: true });
    entries.sort((left, right) => left.name.localeCompare(right.name));

    for (const entry of entries) {
      const full = path.join(folder, entry.name);

      if (entry.isDirectory()) {
        visit(full);
      } else if (entry.isFile() && entry.name.endsWith(".luau")) {
        files.push(full);
      }
    }
  }

  visit(directory);
  return files;
}

/** Mask Luau comments without changing code positions or newlines. */
function withoutComments(source: string): string {
  let result = "";
  let index = 0;
  const blank = (value: string): string => value.replace(/[^\n\r]/g, " ");

  while (index < source.length) {
    const character = source[index];

    if (character === '"' || character === "'" || character === "`") {
      let end = index + 1;

      while (end < source.length) {
        if (source[end] === "\\") {
          end += 2;
          continue;
        }
        if (source[end++] === character) break;
      }

      result += source.slice(index, end);
      index = end;
      continue;
    }

    if (source.startsWith("--", index)) {
      const block = source.slice(index).match(/^--\[(=*)\[/);

      if (block) {
        const closing = `]${block[1] ?? ""}]`;
        const position = source.indexOf(closing, index + block[0].length);
        const end = position < 0 ? source.length : position + closing.length;

        result += blank(source.slice(index, end));
        index = end;
        continue;
      }

      let end = source.indexOf("\n", index);
      if (end < 0) end = source.length;

      result += blank(source.slice(index, end));
      index = end;
      continue;
    }

    result += character;
    index += 1;
  }

  return result;
}

/** Mask string literals before checking code references. */
function withoutStrings(source: string): string {
  return source.replace(
    /(?:"(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|`(?:\\.|[^`\\])*`)/g,
    (match) => match.replace(/[^\r\n]/g, " "),
  );
}

function memberSet(source: string): Set<string> {
  const found = new Set<string>();

  for (const match of source.matchAll(EXPORTED_MEMBER)) {
    const name = match[1] ?? match[2] ?? match[3];
    if (name) found.add(name);
  }

  return found;
}

function typeSet(source: string): Set<string> {
  const found = new Set<string>();

  for (const match of source.matchAll(EXPORTED_TYPE)) {
    if (match[1]) found.add(match[1]);
  }

  return found;
}

function resolveRequire(file: string, expression: string): string {
  // scripts/init.luau represents the root ModuleScript; its children live next to it.
  let current = file.endsWith(`${path.sep}init.luau`)
    ? path.dirname(file)
    : file.slice(0, -".luau".length);

  for (const segment of expression.matchAll(SCRIPT_SEGMENT)) {
    const name = segment[1] ?? segment[2];
    if (!name) continue;

    current = name === "Parent" ? path.dirname(current) : path.join(current, name);
  }

  const fileCandidate = `${current}.luau`;
  const folderCandidate = path.join(current, "init.luau");

  if (fs.existsSync(fileCandidate)) return fileCandidate;
  if (fs.existsSync(folderCandidate)) return folderCandidate;
  return fileCandidate;
}

// Type field casing

/** Collect top-level field names from a Luau record type or table literal. */
function recordFields(source: string, start: number, separator: ":" | "="): Set<string> {
  const fields = new Set<string>();
  let depth = 1;
  let fieldStart = start + 1;

  for (let cursor = fieldStart; cursor < source.length && depth > 0; cursor += 1) {
    const char = source[cursor];

    if (char === "{" || char === "(") depth += 1;
    if (char === "}" || char === ")") depth -= 1;

    if ((char === "," && depth === 1) || depth === 0) {
      const piece = source.slice(fieldStart, cursor).trim();
      const match = piece.match(/^([A-Za-z_]\w*)\s*([:=])/);

      if (match?.[1] && match[2] === separator) fields.add(match[1]);
      fieldStart = cursor + 1;
    }
  }

  return fields;
}

/** Report case-only differences between type fields and typed table literals. */
function checkRecordCasing(source: string, report: (message: string) => void): void {
  const definitions = new Map<string, Set<string>>();
  const declarations =
    /\b(?:export\s+)?type\s+([A-Za-z_]\w*)(?:\s*<[^\n]+>)?\s*=\s*\{/g;

  for (const match of source.matchAll(declarations)) {
    const name = match[1];
    if (name && match.index !== undefined) {
      definitions.set(name, recordFields(source, match.index + match[0].length - 1, ":"));
    }
  }

  const literals =
    /\blocal\s+[A-Za-z_]\w*\s*:\s*([A-Za-z_]\w*)(?:\s*<[^\n]+>)?\s*=\s*\{/g;
  const emitted = new Set<string>();

  for (const match of source.matchAll(literals)) {
    const name = match[1];
    if (!name || match.index === undefined) continue;

    const expected = definitions.get(name);
    if (!expected) continue;

    for (const field of recordFields(source, match.index + match[0].length - 1, "=")) {
      if (expected.has(field)) continue;

      const correct = [...expected].find(
        (value) => value.toLowerCase() === field.toLowerCase(),
      );
      if (!correct) continue;

      const message = `${name} literal has field ${field} but type declares ${correct}`;
      if (!emitted.has(message)) {
        emitted.add(message);
        report(message);
      }
    }
  }
}

// Cross-module checks

function collectImports(
  files: string[],
  sources: SourceMap,
  relative: (file: string) => string,
  report: ReportIssue,
): ImportMap {
  const imports: ImportMap = new Map();

  for (const file of files) {
    const aliases = new Map<string, string>();

    for (const match of (sources.get(file) ?? "").matchAll(IMPORTED_MODULE)) {
      const alias = match[1];
      const expression = match[2];
      if (!alias || !expression) continue;

      const target = resolveRequire(file, expression);

      if (!sources.has(target)) {
        report(file, `BROKEN REQUIRE ${alias} ${expression} -> ${relative(target)}`);
      } else {
        aliases.set(alias, target);
      }
    }

    imports.set(file, aliases);
  }

  return imports;
}

function checkImportedMembers(
  files: string[],
  sources: SourceMap,
  imports: ImportMap,
  exportsByFile: SymbolMap,
  typesByFile: SymbolMap,
  relative: (file: string) => string,
  report: ReportIssue,
): number {
  const unresolved = new Set<string>();

  for (const file of files) {
    const code = withoutStrings(sources.get(file) ?? "");

    for (const [alias, target] of imports.get(file) ?? []) {
      const memberPattern = new RegExp(String.raw`\b${alias}\.(${IDENTIFIER})\b`, "g");

      for (const match of code.matchAll(memberPattern)) {
        const member = match[1];
        if (!member) continue;

        if (
          !exportsByFile.get(target)?.has(member) &&
          !typesByFile.get(target)?.has(member)
        ) {
          const message = `UNKNOWN IMPORT MEMBER ${alias}.${member} (in ${relative(target)})`;
          const key = `${relative(file)}\0${message}`;

          if (!unresolved.has(key)) {
            unresolved.add(key);
            report(file, message);
          }
        }
      }
    }
  }

  return unresolved.size;
}

function checkNaming(file: string, source: string, types: Set<string>, report: ReportIssue): void {
  const code = withoutStrings(source);

  checkRecordCasing(source, (message) => report(file, message));

  if (/\bcamera\.viewportSize\b/.test(code)) {
    report(file, "Roblox Camera.ViewportSize must retain PascalCase");
  }

  // Roblox EnumItems must use official Roblox casing.
  for (const match of code.matchAll(/\bEnum\.([A-Za-z_]\w*)\.([a-z][A-Za-z0-9_]*)\b/g)) {
    report(file, `non-PascalCase Roblox enum: Enum.${match[1]}.${match[2]}`);
  }

  // Only directly typed native connections are checked; custom signals are untouched.
  const nativeConnections = new Set<string>();
  for (const match of code.matchAll(/\b([A-Za-z_]\w*)\s*:\s*RBXScriptConnection\??\b/g)) {
    if (match[1]) nativeConnections.add(match[1]);
  }

  for (const name of nativeConnections) {
    const invalid = new RegExp(`\\b${name}\\.connected\\b`, "g");
    if (invalid.test(code)) {
      report(
        file,
        `Roblox RBXScriptConnection.Connected must retain PascalCase: ${name}.connected`,
      );
    }
  }

  for (const type of types) {
    if (!/^[A-Z][A-Za-z0-9]*$/.test(type)) {
      report(file, `non-PascalCase exported type ${type}`);
    }
  }

  for (const match of code.matchAll(MODULE_METHOD)) {
    const name = match[1];
    if (name && !COMPONENT_NAMES.has(name)) {
      report(file, `non-camelCase module method ${name}`);
    }
  }
}

// Required public API and Roblox host mappings

function checkPublicMembers(file: string, source: string, report: ReportIssue): void {
  const counts = new Map<string, number>();

  for (const match of source.matchAll(PUBLIC_MEMBER)) {
    const name = match[1];
    if (name) counts.set(name, (counts.get(name) ?? 0) + 1);
  }

  for (const [name, count] of counts) {
    if (count > 1) report(file, `duplicate public member ${name} (${count})`);
  }
}

function checkHostProperties(file: string, host: string, report: ReportIssue): void {
  for (const key of NATIVE_PROPERTIES) {
    if (!new RegExp(String.raw`\b${key}\s*=\s*["']${key}["']`).test(host)) {
      report(file, `missing native PascalCase property ${key}`);
    }
  }

  const propertyTable = host.match(
    /\blocal\s+propertyNames\s*:[^\n]*=\s*\{([\s\S]*?)\n\}/,
  );

  if (propertyTable?.[1]) {
    for (const match of propertyTable[1].matchAll(
      /\b([A-Za-z_][A-Za-z0-9_]*)\s*=\s*["']([^"']+)["']/g,
    )) {
      if (match[1] !== match[2] || !/^[A-Z][A-Za-z0-9]*$/.test(match[1] ?? "")) {
        report(file, `invalid native PascalCase mapping: ${match[1]} -> ${match[2]}`);
      }
    }
  } else {
    report(file, "missing propertyNames table");
  }
}

function checkHostIntegration(
  elementFile: string,
  element: string,
  rendererFile: string,
  renderer: string,
  hostFile: string,
  host: string,
  report: ReportIssue,
): void {
  if (!/^\s*attributes:\s*AttributeMap\?/m.test(element)) {
    report(elementFile, "custom attributes metadata mismatch");
  }
  if (!/\bpreviousProps\.attributes\s*\~=/m.test(renderer)) {
    report(rendererFile, "host metadata lookup mismatch");
  }
  if (/\bhandle\.Attributes\b/.test(renderer)) {
    report(rendererFile, "legacy HostHandle.Attributes reference");
  }

  for (const event of EVENTS) {
    const callback = `on${event}`;

    if (!new RegExp(String.raw`\b${callback}\s*:`).test(element)) {
      report(elementFile, `missing event prop ${callback}`);
    }
    if (!new RegExp(String.raw`\b${callback}\s*=\s*["']${event}["']`).test(host)) {
      report(hostFile, `missing event decoder ${callback}`);
    }
    if (!new RegExp(String.raw`\b${event}\s*=\s*["']${callback}["']`).test(host)) {
      report(hostFile, `missing event encoder ${callback}`);
    }
  }
}

// Run all checks and build the original JSON report schema.

function check(options: CheckerOptions): CheckResult {
  const sourceRoot = path.join(options.root, "scripts");

  if (!fs.existsSync(sourceRoot) || !fs.statSync(sourceRoot).isDirectory()) {
    throw new Error(`Missing Luau source directory: ${sourceRoot}`);
  }

  const files = listLuauFiles(sourceRoot);
  const sources: SourceMap = new Map(
    files.map((file) => [file, withoutComments(fs.readFileSync(file, "utf8"))]),
  );
  const exportsByFile: SymbolMap = new Map(
    files.map((file) => [file, memberSet(sources.get(file) ?? "")]),
  );
  const typesByFile: SymbolMap = new Map(
    files.map((file) => [file, typeSet(sources.get(file) ?? "")]),
  );

  const issues: Issue[] = [];
  const relative = (file: string): string =>
    path.relative(sourceRoot, file).split(path.sep).join("/");
  const report: ReportIssue = (file, message) => {
    issues.push([relative(file), message]);
  };

  const imports = collectImports(files, sources, relative, report);
  const unresolvedCount = checkImportedMembers(
    files, sources, imports, exportsByFile, typesByFile, relative, report,
  );

  for (const file of files) {
    checkNaming(file, sources.get(file) ?? "", typesByFile.get(file) ?? new Set(), report);
  }

  function requiredSource(relativeName: string): string {
    const file = path.join(sourceRoot, relativeName);
    if (!sources.has(file)) {
      report(file, "required Luau source file is missing");
      return "";
    }
    return sources.get(file) ?? "";
  }

  const entryFile = path.join(sourceRoot, "init.luau");
  checkPublicMembers(entryFile, requiredSource("init.luau"), report);

  const hostFile = path.join(sourceRoot, "runtime", "hostConfig.luau");
  const host = requiredSource("runtime/hostConfig.luau");
  checkHostProperties(hostFile, host, report);

  const elementFile = path.join(sourceRoot, "virtual", "element.luau");
  const element = requiredSource("virtual/element.luau");
  const rendererFile = path.join(sourceRoot, "runtime", "renderer.luau");
  const renderer = requiredSource("runtime/renderer.luau");
  checkHostIntegration(elementFile, element, rendererFile, renderer, hostFile, host, report);

  issues.sort(
    ([fileA, messageA], [fileB, messageB]) =>
      fileA.localeCompare(fileB) || messageA.localeCompare(messageB),
  );

  return {
    source_files: files.length,
    imports: [...imports.values()].reduce((count, group) => count + group.size, 0),
    types: [...typesByFile.values()].reduce((count, group) => count + group.size, 0),
    unresolved_module_members: unresolvedCount,
    issues,
  };
}

function main(): void {
  const options = parseArguments(process.argv.slice(2));
  if (!options) return;

  const result = check(options);
  fs.mkdirSync(path.dirname(options.json), { recursive: true });
  fs.writeFileSync(options.json, `${JSON.stringify(result, null, 2)}\n`, "utf8");

  process.stdout.write(
    `Files: ${result.source_files} module imports: ${result.imports} type exports: ${result.types}\n`,
  );
  process.stdout.write(
    `Unresolved module member refs: ${result.unresolved_module_members}\n`,
  );
  process.stdout.write(`Issues: ${result.issues.length}\n`);

  for (const [file, message] of result.issues.slice(0, 125)) {
    process.stdout.write(`${file}: ${message}\n`);
  }
  if (result.issues.length > 125) {
    process.stdout.write(`... more issues in ${options.json}\n`);
  }

  process.stdout.write(`JSON report: ${options.json}\n`);
  if (result.issues.length > 0) process.exitCode = 1;
}

try {
  main();
} catch (error: unknown) {
  process.stderr.write(
    `[Reactily] ${error instanceof Error ? error.message : String(error)}\n`,
  );
  process.exitCode = 1;
}
