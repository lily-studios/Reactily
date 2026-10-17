---
title: Reactily.createStrictMode
description: Creates a StrictMode wrapper around child elements.
---

# `Reactily.createStrictMode`

Creates a StrictMode wrapper around child elements. This export is included in Reactily v2.2.0 (API v1).

## Signature

```luau
Reactily.createStrictMode(children: {any}, key: string?): Element
```

## Usage

```luau
local checked = Reactily.createStrictMode({ app })
```

Use this hook or constructor only in a valid Reactily component/render context, as applicable.

## Understanding this API

StrictMode helps expose render-time assumptions and problematic patterns during development.

### Practical guidance

Code that performs side effects during render is especially likely to behave unexpectedly under diagnostic or preview rendering.

## Additional usage notes

### When to use it

Use strict mode for development checks that identify suspicious component behavior.

### Behavior and ownership

Strict mode exercises development-oriented behaviors and diagnostics, not an extra Roblox rendering layer.

### Pitfalls to avoid

> **Note:** Do not depend on a component rendering only once in development for correctness.
