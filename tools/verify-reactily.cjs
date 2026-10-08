#!/usr/bin/env node
"use strict";

// Cross-module contract verification. Run from anywhere:
//   node tools/verify-reactily.cjs
// Checks require targets, import/member spelling, cycles and critical host keys.
const fs = require("node:fs");
const path = require("node:path");
const root = path.resolve(__dirname, "..", "scripts");
const modules = new Map();
const errors = [];

function walk(dir) {
  for (const item of fs.readdirSync(dir, { withFileTypes: true })) {
    const p = path.join(dir, item.name);
    if (item.isDirectory()) walk(p);
    else if (item.isFile() && item.name.endsWith(".luau")) {
      modules.set(path.relative(root, p).replaceAll(path.sep, "/").slice(0, -5), fs.readFileSync(p, "utf8"));
    }
  }
}

walk(root);
const contracts = new Map();
for (const [key, source] of modules) {
  const functions = new Set();
  const types = new Set();
  for (const m of source.matchAll(/\bfunction\s+module[.:]([A-Za-z_]\w*)\s*(?:<[^\n>]*>)?\s*\(/g)) functions.add(m[1]);
  for (const m of source.matchAll(/\bmodule\.([A-Za-z_]\w*)\s*=/g)) functions.add(m[1]);
  for (const m of source.matchAll(/\bexport\s+type\s+([A-Za-z_]\w*)\b/g)) types.add(m[1]);
  contracts.set(key, new Set([...functions, ...types]));
}

const graph = new Map();
let checkedImports = 0;
for (const [key, source] of modules) {
  const imports = [];
  for (const m of source.matchAll(/\blocal\s+([A-Za-z_]\w*)\s*=\s*require\s*\(\s*(script(?:\.[A-Za-z_]\w*)+)\s*\)/g)) {
    const [, alias, expression] = m;
    const targetParts = key === "init" ? [] : key.split("/");
    for (const part of expression.split(".").slice(1)) {
      if (part === "Parent") {
        if (targetParts.length === 0) errors.push(`${key}: require walks above root`);
        else targetParts.pop();
      } else targetParts.push(part);
    }
    const target = targetParts.join("/");
    if (!modules.has(target)) {
      errors.push(`${key}: missing require: ${expression} (${target})`);
      continue;
    }
    imports.push(target);
    checkedImports += 1;
    const pattern = new RegExp(`\\b${alias}\\.([A-Za-z_]\\w*)`, "g");
    for (const match of source.matchAll(pattern)) {
      if (!contracts.get(target).has(match[1])) {
        const line = source.slice(0, match.index).split("\n").length;
        errors.push(`${key}:${line}: ${alias}.${match[1]} is not an export of ${target}`);
      }
    }
  }
  graph.set(key, imports);
}

const visited = new Set();
const active = [];
function visit(key) {
  if (active.includes(key)) {
    errors.push(`require cycle: ${active.slice(active.indexOf(key)).concat(key).join(" -> ")}`);
    return;
  }
  if (visited.has(key)) return;
  active.push(key);
  for (const dependency of graph.get(key)) visit(dependency);
  active.pop();
  visited.add(key);
}
for (const key of graph.keys()) visit(key);

function check(condition, message) {
  if (!condition) errors.push(message);
}
const renderer = modules.get("runtime/renderer");
const element = modules.get("virtual/element");
const host = modules.get("runtime/hostConfig");
const hooks = modules.get("state/hooks");
const init = modules.get("init");
check(renderer && !renderer.includes("handle.instance"), "renderer uses lowercase handle.instance");
check(renderer && ["Attributes", "Children", "Key", "OnPropertyChanged", "Ref", "Tags"].every(k => renderer.includes(`${k} = true,`)), "renderer must ignore all special host props");
check(element && element.includes('if propName == "Key" then'), "cloneElement must use Key");
check(hooks && !hooks.includes("existingSlot.kind"), "hook diagnostics must use Kind");
// String literal keys passed to flushEffectQueue must match NewContext's field names.
// These are runtime lookups, so a casing mismatch compiles but crashes on #queue.
if (hooks) {
  const fieldMatch = hooks.match(/export type componentContext\s*=\s*\{([\s\S]*?)\n\}/);
  const contextFields = new Set([...(fieldMatch?.[1] ?? "").matchAll(/^\s*([A-Za-z_]\w*)\s*:/gm)].map(m => m[1]));
  const queueCallNames = [...hooks.matchAll(/flushEffectQueue\(context,\s*"([A-Za-z_]\w*)"\)/g)].map(m => m[1]);
  check(queueCallNames.length === 3, "expected three distinct effect flush queue calls");
  for (const field of ["PendingEffects", "PendingInsertionEffects", "PendingLayoutEffects"]) {
    check(contextFields.has(field), `hook context field ${field} is missing`);
    check(queueCallNames.includes(field), `hook queue name ${field} is incorrect`);
    check(hooks.includes(`${field} = {}`), `NewContext must initialize ${field}`);
  }
  check(!hooks.includes("context[queueName]"), "flushEffectQueue must not use dynamic context field lookups");
  for (const field of ["PendingEffects", "PendingInsertionEffects", "PendingLayoutEffects"]) {
    check(hooks.includes(`queue = context.${field}`), `flushEffectQueue must select ${field} directly`);
    check(hooks.includes(`context.${field} = {}`), `flushEffectQueue must reset ${field}`);
  }
  const typedNames = hooks.match(/queueName:\s*([^\n]+)/)?.[1] ?? "";
  for (const field of queueCallNames) {
    check(typedNames.includes(`"${field}"`), `effect queue typed name does not include ${field}`);
  }
}
check(init && init.includes("return profile.LastReason") && init.includes("return rootValue.Inspect()"), "generated custom API method casing is incorrect");
check(host && host.includes('local attributesKey: "Attributes" = "Attributes"') && host.includes('local tagKey: "Tags" = "Tags"'), "host key constants must use PascalCase");

if (host) {
  const registered = new Set([...host.slice(host.indexOf("local eventNames"), host.indexOf("local propertyNames")).matchAll(/\b(On[A-Za-z0-9]+)\s*=/g)].map(m => m[1]));
  const exported = new Set([...host.slice(host.indexOf("local event: eventKeys"), host.indexOf("local change: changeKeys")).matchAll(/=\s*"(On[A-Za-z0-9]+)"/g)].map(m => m[1]));
  check(registered.size === 18 && registered.size === exported.size && [...registered].every(k => exported.has(k)), "Event public keys must match the host event registry");
}

if (errors.length) {
  for (const error of errors) console.error(`[Reactily] ${error}`);
  process.exitCode = 1;
} else {
  console.log(`[Reactily] PASS: ${modules.size} Luau modules, ${checkedImports} require references, 0 missing exports, 0 require cycles.`);
  console.log("[Reactily] PASS: renderer, hooks, event mapping, and generated API casing invariants.");
}
