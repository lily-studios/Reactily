#!/usr/bin/env node
"use strict";

const crypto = require("node:crypto");
const fs = require("node:fs");
const path = require("node:path");
const process = require("node:process");

const config = require("./reactily-exports.cjs");

const SEPARATOR =
  "--————————————————————————————————————————————————————————————————————--";

// Exported members are discovered from the returned module table. The source
// spelling is preserved; the public alias spelling comes from the config.
const IDENTIFIER = "[A-Za-z_][A-Za-z0-9_]*";

const TYPE_DECLARATION =
  /^\s*export\s+type\s+([A-Za-z_][A-Za-z0-9_]*)(\s*<[^>\n]+>)?/;

const EXPORT_ANNOTATION =
  /^\s*---\s*@reactilyExport(?:\s+([A-Za-z_][A-Za-z0-9_]*))?\s*$/;
const TYPE_ANNOTATION =
  /^\s*---\s*@reactilyType(?:\s+([A-Za-z_][A-Za-z0-9_]*))?\s*$/;

const GENERATED_AT_PATTERN =
  /^-- Generated at: (.+)$/m;

function extractGeneratedAt(source) {
  const match = source.match(GENERATED_AT_PATTERN);
  return match ? match[1].trim() : null;
}

function createGenerationMetadata(iso = null, timeZoneOverride = null) {
  const now = iso === null ? new Date() : new Date(iso);
  const timeZone =
    timeZoneOverride ??
    Intl.DateTimeFormat().resolvedOptions().timeZone ??
    "UTC";
  const local = new Intl.DateTimeFormat("en-US", {
    year: "numeric",
    month: "long",
    day: "numeric",
    hour: "numeric",
    minute: "2-digit",
    second: "2-digit",
    timeZone,
    timeZoneName: "short",
  }).format(now);

  return {
    iso: now.toISOString(),
    local,
    timeZone,
  };
}

function fail(message) {
  throw new Error(message);
}

function log(message) {
  console.log(`[Reactily] ${message}`);
}

function parseArguments(argv) {
  const options = {
    check: false,
    debug: false,
    dryRun: false,
    verbose: false,
    root: null,
    sourceDir: config.sourceDir,
    outputFile: config.outputFile,
    version: null,
  };

  for (let index = 0; index < argv.length; index += 1) {
    const argument = argv[index];

    switch (argument) {
      case "--check":
        options.check = true;
        break;
      case "--debug":
        options.debug = true;
        options.verbose = true;
        break;
      case "--dry-run":
        options.dryRun = true;
        break;
      case "--verbose":
        options.verbose = true;
        break;
      case "--root":
      case "--source":
      case "--out":
      case "--version": {
        const value = argv[index + 1];
        if (!value || value.startsWith("--")) {
          fail(`${argument} requires a value.`);
        }

        index += 1;

        if (argument === "--root") {
          options.root = value;
        } else if (argument === "--source") {
          options.sourceDir = value;
        } else if (argument === "--out") {
          options.outputFile = value;
        } else {
          options.version = value;
        }

        break;
      }
      case "--help":
      case "-h":
        options.help = true;
        break;
      default:
        fail(`Unknown argument: ${argument}`);
    }
  }

  return options;
}

function printHelp() {
  process.stdout.write(
    [
      "Reactily init generator",
      "",
      "Usage:",
      "  node tools/generate-init.cjs [options]",
      "",
      "Options:",
      "  --check            Exit 1 when generated init is out of date",
      "  --dry-run          Print generated init without writing it",
      "  --verbose          Print discovery and generation details",
      "  --debug            Print per-module parsing details",
      "  --root <path>      Explicit Reactily repository root",
      "  --source <name>    Runtime source directory (default: scripts)",
      "  --out <name>       Generated file name (default: init.luau)",
      "  --version <value>  Override detected package version",
      "  -h, --help         Show this help",
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

function isRuntimeRoot(directory, sourceDir) {
  const sourceRoot = path.join(directory, sourceDir);

  if (!isDirectory(sourceRoot)) {
    return false;
  }

  return config.requiredRuntimeDirectories.every((name) =>
    isDirectory(path.join(sourceRoot, name)),
  );
}

function resolveProjectRoot(options) {
  const explicit =
    options.root ??
    process.env.REACTILY_ROOT ??
    null;

  if (explicit !== null) {
    const candidate = path.resolve(explicit);
    if (!isRuntimeRoot(candidate, options.sourceDir)) {
      fail(
        `The supplied root is not a Reactily runtime root: ${candidate}\n` +
          `Expected ${options.sourceDir}/{${config.requiredRuntimeDirectories.join(",")}}.`,
      );
    }

    return candidate;
  }

  const starts = [
    process.cwd(),
    __dirname,
  ];

  const visited = new Set();

  for (const start of starts) {
    let current = path.resolve(start);

    for (;;) {
      if (!visited.has(current)) {
        visited.add(current);

        if (isRuntimeRoot(current, options.sourceDir)) {
          return current;
        }
      }

      const parent = path.dirname(current);
      if (parent === current) {
        break;
      }

      current = parent;
    }
  }

  fail(
    `Cannot find the Reactily runtime root.\n` +
      `Expected a directory containing ${options.sourceDir}/{${config.requiredRuntimeDirectories.join(",")}}.\n` +
      `Use --root <path> or set REACTILY_ROOT when needed.`,
  );
}

function readJsonVersion(filePath) {
  if (!fs.existsSync(filePath)) {
    return null;
  }

  try {
    const value = JSON.parse(fs.readFileSync(filePath, "utf8")).version;
    return typeof value === "string" && value.trim()
      ? value.trim()
      : null;
  } catch (error) {
    fail(`Failed to read ${filePath}: ${error.message}`);
  }
}

function resolveVersion(root, override) {
  if (override) {
    return override;
  }

  for (const name of ["package.json", "manifest.json"]) {
    const value = readJsonVersion(path.join(root, name));
    if (value !== null) {
      return value;
    }
  }

  const versionFile = path.join(root, "VERSION");
  if (fs.existsSync(versionFile)) {
    const value = fs.readFileSync(versionFile, "utf8").trim();
    if (value) {
      return value.replace(/-dev$/i, "");
    }
  }

  const wallyFile = path.join(root, "wally.toml");
  if (fs.existsSync(wallyFile)) {
    const source = fs.readFileSync(wallyFile, "utf8");
    const match = source.match(
      /\[package\][\s\S]*?^\s*version\s*=\s*"([^"]+)"/m,
    );

    if (match) {
      return match[1];
    }
  }

  return config.fallbackVersion;
}

function parseSemver(version) {
  const match = String(version).match(/^(\d+)\.(\d+)\.(\d+)/);

  if (!match) {
    fail(`Reactily version is not semver-compatible: ${version}`);
  }

  return {
    major: Number(match[1]),
    minor: Number(match[2]),
    patch: Number(match[3]),
  };
}

function walkLuau(directory, outputFile, results = []) {
  const entries = fs
    .readdirSync(directory, { withFileTypes: true })
    .sort((left, right) => left.name.localeCompare(right.name));

  for (const entry of entries) {
    const target = path.join(directory, entry.name);

    if (entry.isDirectory()) {
      walkLuau(target, outputFile, results);
      continue;
    }

    if (
      entry.isFile() &&
      entry.name.endsWith(".luau") &&
      entry.name !== outputFile
    ) {
      results.push(target);
    }
  }

  return results;
}

function moduleKey(sourceRoot, filePath) {
  return path
    .relative(sourceRoot, filePath)
    .replace(/\\/g, "/")
    .replace(/\.luau$/i, "");
}

function createIdentifier(moduleName) {
  let identifier = moduleName.replace(/[^A-Za-z0-9_]/g, "_");

  if (/^\d/.test(identifier)) {
    identifier = `_${identifier}`;
  }

  return `${identifier}Module`;
}

function assignUniqueIdentifiers(modules) {
  const used = new Map();

  for (const moduleInfo of modules) {
    const base = createIdentifier(moduleInfo.key);
    const existing = used.get(base);

    if (existing === undefined) {
      moduleInfo.varName = base;
      used.set(base, moduleInfo.key);
      continue;
    }

    if (existing === moduleInfo.key) {
      moduleInfo.varName = base;
      continue;
    }

    const suffix = crypto
      .createHash("sha1")
      .update(moduleInfo.key)
      .digest("hex")
      .slice(0, 8);

    const unique = `${base}_${suffix}`;
    moduleInfo.varName = unique;
    used.set(unique, moduleInfo.key);
  }
}

function requireExpression(key) {
  const parts = key.split("/");
  let expression = "script";

  for (const part of parts) {
    if (/^[A-Za-z_][A-Za-z0-9_]*$/.test(part)) {
      expression += `.${part}`;
    } else {
      expression += `[${JSON.stringify(part)}]`;
    }
  }

  return expression;
}

function collectAnnotations(lines, declarationIndex, pattern, fallbackName) {
  const names = [];

  for (let index = declarationIndex - 1; index >= 0; index -= 1) {
    const line = lines[index].trim();

    if (!line) {
      continue;
    }

    if (!line.startsWith("---")) {
      break;
    }

    const match = line.match(pattern);
    if (match) {
      names.push(match[1] || fallbackName);
    }
  }

  return names.reverse();
}

function parseModule(sourceRoot, filePath) {
  const key = moduleKey(sourceRoot, filePath);
  const source = fs.readFileSync(filePath, "utf8");
  const lines = source.split(/\r?\n/);
  const functions = new Map();
  const types = new Map();

  // Most source modules return `module`; other modules return `Module`,
  // `api`, etc. Do not assume the capitalization of that local identifier.
  const returns = [
    ...source.matchAll(
      /^\s*return\s+([A-Za-z_][A-Za-z0-9_]*)\s*(?:--[^\n]*)?$/gm,
    ),
  ];
  const returnedName = returns.length
    ? returns[returns.length - 1][1]
    : "module";
  const exportNames = [...new Set(["module", returnedName])];
  const memberPatterns = exportNames.map((name) => {
    const escaped = name.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
    return {
      declaration: new RegExp(
        `^\\s*function\\s+${escaped}[.:](${IDENTIFIER})(?:\\s*<[^>\\n]+>)?\\s*\\(`,
      ),
      assignment: new RegExp(
        `^\\s*${escaped}(?:\\.(${IDENTIFIER})|` +
          `\\[\\s*["'](${IDENTIFIER})["']\\s*\\])\\s*=(?!=)`,
      ),
    };
  });

  for (let index = 0; index < lines.length; index += 1) {
    const line = lines[index];

    // Supports: function module.Run(...), function module:Run(...),
    // module.Run = function(...), module.Run = Run, module["Run"] = Run.
    let name = null;
    for (const pattern of memberPatterns) {
      const direct = line.match(pattern.declaration);
      const assigned = line.match(pattern.assignment);
      name = direct?.[1] ?? assigned?.[1] ?? assigned?.[2] ?? null;
      if (name !== null) {
        break;
      }
    }

    if (name !== null) {
      const annotations = collectAnnotations(
        lines,
        index,
        EXPORT_ANNOTATION,
        name,
      );
      const existing = functions.get(name) ?? [];
      functions.set(name, [...new Set([...existing, ...annotations])]);
    }

    const typeMatch = line.match(TYPE_DECLARATION);
    if (typeMatch) {
      const typeName = typeMatch[1];
      types.set(typeName, {
        names: collectAnnotations(lines, index, TYPE_ANNOTATION, typeName),
        generic: (typeMatch[2] || "").trim(),
      });
    }
  }

  return {
    filePath,
    key,
    require: requireExpression(key),
    varName: "",
    functions,
    types,
  };
}

function genericArguments(genericDeclaration) {
  if (!genericDeclaration) {
    return "";
  }

  const body = genericDeclaration.slice(1, -1);

  return (
    "<" +
    body
      .split(",")
      .map((entry) => {
        const match = entry
          .trim()
          .match(/^([A-Za-z_][A-Za-z0-9_]*)(\.\.\.)?/);

        return match
          ? `${match[1]}${match[2] || ""}`
          : entry.trim();
      })
      .join(", ") +
    ">"
  );
}

function uniquePublicNames(names) {
  return [...new Set(names)];
}

/**
 * Public Luau type names use PascalCase even when their source declarations
 * or the export configuration still use camelCase or snake_case.
 *
 * The original declaration name is deliberately left unchanged so the
 * generated alias keeps referring to the correct source module type.
 *
 * @param {string} name - Configured or annotated public type name.
 * @returns {string} Normalized PascalCase public type name.
 */
function toPascalCaseType(name) {
  if (typeof name !== "string" || !/^[A-Za-z_][A-Za-z0-9_]*$/.test(name)) {
    fail(`Invalid Reactily public type name: ${String(name)}`);
  }

  const normalized = name
    .replace(/^_+/, "")
    .replace(/_+([A-Za-z0-9])/g, (_match, character) =>
      character.toUpperCase(),
    )
    .replace(/^[a-z]/, (character) => character.toUpperCase());

  if (!/^[A-Z][A-Za-z0-9]*$/.test(normalized)) {
    fail(`Cannot convert Reactily type name to PascalCase: ${name}`);
  }

  return normalized;
}

/**
 * Resolves an exported member against its actual source declaration.
 * The source is authoritative: comparisons only relax casing and underscores
 * when the match is unique. This supports PascalCase source migrations (Run
 * instead of run) without silently mapping to unrelated declarations.
 *
 * @param {Map<string, unknown>} source - Parsed declarations.
 * @param {string} requestedName - Type/function name from export config.
 * @param {string} kind - Declaration category.
 * @param {string} moduleKey - Module path used in diagnostics.
 * @returns {string} The exact name in the source declaration.
 */
function resolveDeclarationName(source, requestedName, kind, moduleKey) {
  // Exact matches always win: a module may expose both `Run` and `run`.
  if (source.has(requestedName)) {
    return requestedName;
  }

  // Accept mixed PascalCase/camelCase/snake_case only when unambiguous.
  const canonical = requestedName.replace(/_/g, "").toLowerCase();
  const matches = [...source.keys()].filter(
    (name) => name.replace(/_/g, "").toLowerCase() === canonical,
  );

  if (matches.length === 1) {
    return matches[0];
  }

  if (matches.length > 1) {
    fail(
      `Ambiguous public ${kind} "${requestedName}" in ${moduleKey}: ` +
        `${matches.join(", ")}. Use the exact source spelling in reactily-exports.cjs.`,
    );
  }

  const available = [...source.keys()].sort((a, b) => a.localeCompare(b));
  fail(
    `Configured public ${kind} does not exist: ${moduleKey}.${requestedName}` +
      (available.length ? ` (detected: ${available.join(", ")})` :
        " (no matching exports detected)"),
  );
}

function collectConfiguredExports(modules, mapping, kind) {
  const used = new Map();
  const output = [];
  const errors = [];
  const moduleKeys = new Set(modules.map((moduleInfo) => moduleInfo.key));

  for (const key of Object.keys(mapping)) {
    if (!moduleKeys.has(key)) {
      errors.push(`Configured ${kind} module is missing: ${key}`);
    }
  }

  for (const moduleInfo of modules) {
    const explicit = mapping[moduleInfo.key] || {};
    const source =
      kind === "function" ? moduleInfo.functions : moduleInfo.types;
    const annotatedNames = [...source]
      .filter(([, value]) =>
        kind === "function" ? value.length > 0 : value.names.length > 0,
      )
      .map(([name]) => name);
    const configuredNames = new Set([
      ...Object.keys(explicit),
      ...annotatedNames,
    ]);

    for (const configuredName of configuredNames) {
      let name;
      try {
        name = resolveDeclarationName(
          source,
          configuredName,
          kind,
          moduleInfo.key,
        );
      } catch (error) {
        errors.push(error.message);
        continue;
      }

      const declaration = source.get(name);
      const annotations = kind === "function" ? declaration : declaration.names;
      const publicNames = uniquePublicNames([
        ...(explicit[configuredName] || []),
        ...annotations,
      ].map((publicName) =>
        kind === "type" ? toPascalCaseType(publicName) : publicName,
      ));

      for (const publicName of publicNames) {
        const owner = `${moduleInfo.key}.${name}`;
        const previous = used.get(publicName);
        if (previous === owner) {
          continue;
        }
        if (previous !== undefined) {
          errors.push(
            `Duplicate public ${kind} "${publicName}": ${previous} and ${owner}`,
          );
          continue;
        }
        used.set(publicName, owner);
        output.push({ publicName, moduleInfo, name, declaration });
      }
    }
  }

  if (errors.length > 0) {
    fail(
      `Found ${errors.length} ${kind} export mapping error(s):\n` +
        errors.map((error) => `  - ${error}`).join("\n"),
    );
  }

  return output.sort((left, right) =>
    left.publicName.localeCompare(right.publicName),
  );
}

function collectMappedValues(moduleMap, mapping, label) {
  const output = [];

  for (const [key, entries] of Object.entries(mapping)) {
    const moduleInfo = moduleMap.get(key);

    if (!moduleInfo) {
      fail(`Missing module "${key}" required by ${label}.`);
    }

    for (const [name, publicNames] of Object.entries(entries)) {
      for (const publicName of publicNames) {
        output.push({
          publicName,
          moduleInfo,
          name,
        });
      }
    }
  }

  return output.sort((left, right) =>
    left.publicName.localeCompare(right.publicName),
  );
}

function collectNamespaces(moduleMap) {
  return Object.entries(config.namespaceExports)
    .sort(([left], [right]) => left.localeCompare(right))
    .map(([publicName, key]) => {
      const moduleInfo = moduleMap.get(key);

      if (!moduleInfo) {
        fail(
          `Missing module "${key}" required by namespace "${publicName}".`,
        );
      }

      return {
        publicName,
        moduleInfo,
      };
    });
}

function collectCallableNamespaces(moduleMap) {
  return Object.entries(config.callableNamespaces)
    .sort(([left], [right]) => left.localeCompare(right))
    .map(([publicName, definition]) => {
      const namespaceModule = moduleMap.get(definition.namespaceModule);
      const componentModule = moduleMap.get(definition.componentModule);
      if (!namespaceModule || !componentModule) {
        fail(`Missing callable namespace dependency for "${publicName}".`);
      }

      const componentFunction = resolveDeclarationName(
        componentModule.functions,
        definition.componentFunction,
        "function",
        definition.componentModule,
      );
      const propsType = resolveDeclarationName(
        componentModule.types,
        definition.propsType,
        "type",
        definition.componentModule,
      );
      return {
        publicName,
        definition,
        namespaceModule,
        componentModule,
        componentFunction,
        propsType,
      };
    });
}

function validateRuntimeNameCollisions(
  functions,
  values,
  namespaces,
  callableNamespaces,
) {
  const owners = new Map();

  const register = (publicName, owner) => {
    const previous = owners.get(publicName);

    if (previous !== undefined) {
      fail(
        `Duplicate runtime public name "${publicName}": ` +
          `${previous} and ${owner}`,
      );
    }

    owners.set(publicName, owner);
  };

  for (const entry of functions) {
    register(
      entry.publicName,
      `function ${entry.moduleInfo.key}.${entry.name}`,
    );
  }

  for (const entry of values) {
    register(
      entry.publicName,
      `value ${entry.moduleInfo.key}.${entry.name}`,
    );
  }

  for (const entry of namespaces) {
    register(
      entry.publicName,
      `namespace ${entry.moduleInfo.key}`,
    );
  }

  for (const entry of callableNamespaces) {
    register(
      entry.publicName,
      `callable namespace ${entry.definition.namespaceModule}`,
    );
  }
}

function renderCompatibilityMetadata(version) {
  const semver = parseSemver(version);
  const flags = [...config.featureFlags].sort();

  const lines = [
    `module.apiVersion = ${config.apiVersion}`,
    "module.versionInfo = table.freeze({",
    `\tmajor = ${semver.major},`,
    `\tminor = ${semver.minor},`,
    `\tpatch = ${semver.patch},`,
    "})",
    "",
    "local featureFlags: { [string]: boolean } = table.freeze({",
    ...flags.map((flag) => `\t[${JSON.stringify(flag)}] = true,`),
    "})",
    "",
    "module.features = featureFlags",
    "module.Experimental = table.freeze({})",
    "",
    "--- Returns whether this Reactily build exposes a named capability.",
    "function module.hasFeature(feature: string): boolean",
    "\treturn featureFlags[feature] == true",
    "end",
    "",
    "--- Returns whether a consumer API version is compatible with this build.",
    "function module.isCompatible(requestedApiVersion: number): boolean",
    "\treturn requestedApiVersion == module.apiVersion",
    "end",
  ];

  return lines.join("\n");
}

function renderCompatibilityAliases() {
  const lines = [
    "-- Deprecated compatibility aliases kept through the Reactily 1.x line.",
  ];

  for (const [alias, target] of Object.entries(
    config.compatibilityAliases,
  ).sort(([left], [right]) => left.localeCompare(right))) {
    lines.push(`module.${alias} = module.${target}`);
  }

  lines.push(
    "",
    "function module.getVersion(): string",
    "\treturn version",
    "end",
  );

  return lines.join("\n");
}

function renderCustomApi(moduleMap) {
  const element = moduleMap.get("virtual/element");
  const profiler = moduleMap.get("diagnostics/profiler");
  const transition = moduleMap.get("runtime/transition");

  if (!element || !profiler || !transition) {
    fail("Missing custom API dependencies.");
  }

  const providerName = resolveDeclarationName(
    element.functions, "createContextProvider", "function", element.key,
  );
  const keyName = resolveDeclarationName(
    element.functions, "key", "function", element.key,
  );
  const profilerGetName = resolveDeclarationName(
    profiler.functions, "get", "function", profiler.key,
  );
  const transitionStartName = resolveDeclarationName(
    transition.functions, "start", "function", transition.key,
  );

  return [
    "--- Creates a provider element for a Reactily context.",
    "function module.createContextProvider<T>(",
    "\tcontextValue: Context<T>,",
    "\tvalue: T,",
    "\tchild: { any },",
    "\tkey: string?",
    "): Element",
    `\treturn ${element.varName}.${providerName}(`,
    "\t\tcontextValue,",
    "\t\tvalue,",
    "\t\tchild,",
    "\t\tkey",
    "\t)",
    "end",
    SEPARATOR,
    "--- Returns the latest recorded reason a component rendered.",
    "function module.getRenderReason(componentValue: any): string?",
    `\tlocal profile = ${profiler.varName}.${profilerGetName}(componentValue)`,
    "",
    "\tif not profile then",
    "\t\treturn nil",
    "\tend",
    "",
    "\treturn profile.LastReason",
    "end",
    SEPARATOR,
    "--- Returns a diagnostic snapshot of a mounted Reactily root tree.",
    "function module.inspectRoot(rootValue: Root): any",
    "\treturn rootValue.Inspect()",
    "end",
    SEPARATOR,
    "--- Returns a clone of an element with a stable key.",
    "function module.key(elementValue: Element, key: string): Element",
    `\treturn ${element.varName}.${keyName}(elementValue, key)`,
    "end",
    SEPARATOR,
    "--- Starts low-priority one-shot transition work.",
    "function module.startTransition(callback: () -> ()): thread",
    `\treturn ${transition.varName}.${transitionStartName}(callback, nil)`,
    "end",
  ].join("\n");
}

function generate(root, options, generationMetadata) {
  const sourceRoot = path.join(root, options.sourceDir);
  const files = walkLuau(
    sourceRoot,
    options.outputFile,
  );
  const modules = files.map((filePath) =>
    parseModule(sourceRoot, filePath),
  );

  assignUniqueIdentifiers(modules);

  const moduleMap = new Map(
    modules.map((moduleInfo) => [
      moduleInfo.key,
      moduleInfo,
    ]),
  );

  const functions = collectConfiguredExports(
    modules,
    config.functionExports,
    "function",
  );
  const types = collectConfiguredExports(
    modules,
    config.typeExports,
    "type",
  );
  const values = collectMappedValues(
    moduleMap,
    config.valueExports,
    "value exports",
  );
  const namespaces = collectNamespaces(moduleMap);
  const callableNamespaces =
    collectCallableNamespaces(moduleMap);

  validateRuntimeNameCollisions(
    functions,
    values,
    namespaces,
    callableNamespaces,
  );

  const requiredModules = new Set([
    "virtual/element",
    "diagnostics/profiler",
    "runtime/transition",
    ...functions.map((entry) => entry.moduleInfo.key),
    ...types.map((entry) => entry.moduleInfo.key),
    ...values.map((entry) => entry.moduleInfo.key),
    ...namespaces.map((entry) => entry.moduleInfo.key),
  ]);

  for (const entry of callableNamespaces) {
    requiredModules.add(entry.namespaceModule.key);
    requiredModules.add(entry.componentModule.key);
  }

  const imports = [...requiredModules]
    .sort()
    .map((key) => {
      const moduleInfo = moduleMap.get(key);

      if (!moduleInfo) {
        fail(`Missing required module "${key}".`);
      }

      return (
        `local ${moduleInfo.varName} = ` +
        `require(${moduleInfo.require})`
      );
    });

  const exportedTypes = types.map((entry) => {
    const generic = entry.declaration.generic;

    return (
      `export type ${entry.publicName}${generic} = ` +
      `${entry.moduleInfo.varName}.${entry.name}` +
      `${genericArguments(generic)}`
    );
  });

  const functionAssignments = functions.map(
    (entry) =>
      `module.${entry.publicName} = ` +
      `${entry.moduleInfo.varName}.${entry.name}`,
  );

  const namespaceAssignments = namespaces.map(
    (entry) =>
      `module.${entry.publicName} = ` +
      `${entry.moduleInfo.varName}`,
  );

  const callableNamespaceAssignments =
    callableNamespaces.map((entry) => {
      const definition = entry.definition;

      return [
        `module.${entry.publicName} = setmetatable(` +
          `${entry.namespaceModule.varName}, {`,
        "\t__call = function(",
        "\t\t_self: any,",
        `\t\tprops: ${entry.componentModule.varName}.` +
          `${entry.propsType}`,
        "\t): Element",
        `\t\treturn ${entry.componentModule.varName}.` +
          `${entry.componentFunction}(props)`,
        "\tend,",
        "})",
      ].join("\n");
    });

  const valueAssignments = values.map(
    (entry) =>
      `module.${entry.publicName} = ` +
      `${entry.moduleInfo.varName}.${entry.name}`,
  );

  const version = resolveVersion(
    root,
    options.version,
  );

  const header = [
    "--[[",
    "\tReactily · Lily Studios",
    "\tCopyright (c) Lily Studios and contributors.",
    "\tLicensed under the MIT License.",
    "]]",
    "",
    "--!strict",
    "",
    "-- Automatically generated by tools/generate-init.cjs.",
    "-- Do not edit this file directly.",
    `-- Generated: ${generationMetadata.local}`,
    `-- Generated at: ${generationMetadata.iso}`,
    `-- Generated timezone: ${generationMetadata.timeZone}`,
    `-- Reactily version: ${version}`,
    `-- Source directory: ${options.sourceDir}/`,
    "",
    "local module = {}",
    `local version = ${JSON.stringify(version)}`,
  ].join("\n");

  const sections = [
    header,
    SEPARATOR,
    imports.join("\n"),
    SEPARATOR,
    exportedTypes.join("\n"),
    SEPARATOR,
    functionAssignments.join("\n\n"),
    SEPARATOR,
    namespaceAssignments.join("\n\n"),
    callableNamespaceAssignments.join("\n\n"),
    SEPARATOR,
    valueAssignments.join("\n\n"),
    "module.version = version",
    SEPARATOR,
    renderCompatibilityMetadata(version),
    SEPARATOR,
    renderCompatibilityAliases(),
    SEPARATOR,
    renderCustomApi(moduleMap),
    "return module",
  ];

  return {
    source: `${sections.join("\n\n")}\n`,
    version,
    modules,
    functions,
    types,
    values,
    namespaces,
    callableNamespaces,
  };
}

function atomicWrite(filePath, source) {
  const directory = path.dirname(filePath);
  fs.mkdirSync(directory, { recursive: true });

  const temporary =
    `${filePath}.tmp-${process.pid}-${Date.now()}`;

  try {
    fs.writeFileSync(temporary, source, "utf8");
    fs.renameSync(temporary, filePath);
  } finally {
    if (fs.existsSync(temporary)) {
      fs.unlinkSync(temporary);
    }
  }
}

function main() {
  const options = parseArguments(process.argv.slice(2));

  if (options.help) {
    printHelp();
    return 0;
  }

  const root = resolveProjectRoot(options);
  const sourceRoot = path.join(
    root,
    options.sourceDir,
  );
  const outputPath = path.join(
    sourceRoot,
    options.outputFile,
  );

  log(`Generator: ${__filename}`);
  log(`Project: ${root}`);
  log(`Runtime source: ${sourceRoot}`);

  const previous = fs.existsSync(outputPath)
    ? fs.readFileSync(outputPath, "utf8")
    : "";

  const currentMetadata = createGenerationMetadata();
  const existingGeneratedAt = extractGeneratedAt(previous);
  const existingTimeZone = (() => {
    const match = previous.match(/^-- Generated timezone: (.+)$/m);
    return match ? match[1].trim() : null;
  })();
  const comparisonMetadata = createGenerationMetadata(
    existingGeneratedAt ?? currentMetadata.iso,
    existingTimeZone ?? currentMetadata.timeZone,
  );

  const result = generate(root, options, comparisonMetadata);

  log(`Version: ${result.version}`);
  log(
    `Public functions: ${result.functions.length}; ` +
      `public types: ${result.types.length}; ` +
      `values: ${result.values.length}; ` +
      `namespaces: ` +
      `${result.namespaces.length + result.callableNamespaces.length}`,
  );

  if (options.verbose) {
    log(`Discovered ${result.modules.length} Luau modules.`);
  }

  if (options.debug) {
    for (const moduleInfo of result.modules) {
      log(
        `${moduleInfo.key}: ` +
          `${moduleInfo.functions.size} functions, ` +
          `${moduleInfo.types.size} types`,
      );
    }
  }

  if (options.dryRun) {
    const dryRunResult = generate(root, options, currentMetadata);
    process.stdout.write(dryRunResult.source);
    return 0;
  }

  if (options.check) {
    if (previous === result.source) {
      log(`${options.sourceDir}/${options.outputFile} is up to date.`);
      return 0;
    }

    log(`${options.sourceDir}/${options.outputFile} is out of date.`);
    return 1;
  }

  if (previous === result.source) {
    log(`No changes: ${outputPath}`);
    return 0;
  }

  const generated = generate(root, options, currentMetadata);

  atomicWrite(outputPath, generated.source);

  log(
    `Generated: ${outputPath} ` +
      `(${generated.source.split("\n").length - 1} lines)`,
  );
  log(`Generated at: ${currentMetadata.iso} (${currentMetadata.timeZone})`);

  return 0;
}

try {
  process.exitCode = main();
} catch (error) {
  console.error(
    `[Reactily] ERROR: ${
      error && error.stack
        ? error.stack
        : error
    }`,
  );

  process.exitCode = 1;
}
