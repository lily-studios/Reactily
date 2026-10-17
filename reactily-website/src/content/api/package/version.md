---
title: Reactily.version
sidebar_label: version
sidebar_position: 1
description: Current Reactily runtime version string.
---

# `Reactily.version`

The public version string exported by the Reactily package.

## Type

```luau
Reactily.version: string
```

## Current runtime

```luau
print(Reactily.version) -- "2.1.0"
```

Use this for diagnostics and display. Production packages should prefer feature detection over exact-version equality when possible.

## Understanding this API

Package metadata describes the installed Reactily build and its supported feature surface. Use it to understand compatibility rather than to render UI.

### Practical guidance

The published package version and API compatibility version answer different questions: a package can receive new features without changing the API compatibility identifier.

## Additional usage notes

### When to use it

Use this helper when the public version string exported by the Reactily package.

### Behavior and ownership

Package helpers expose metadata, compatibility, or convenience entrypoints.

### Pitfalls to avoid

> **Note:** Check the runtime package version and public API version separately; they represent different things.
