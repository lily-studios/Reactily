---
title: Reactily.apiVersion
sidebar_label: apiVersion
sidebar_position: 2
description: Stable compatibility-line identifier for Reactily consumers.
---

# `Reactily.apiVersion`

The stable compatibility identifier for Reactily's public API.

```luau
Reactily.apiVersion: number
```

Reactily v2.2.0 (API v1) exports:

```luau
Reactily.apiVersion == 1
```

Use this instead of requiring one exact patch version when your package depends on the Reactily API v1 contract.

## Understanding this API

Package metadata describes the installed Reactily build and its supported feature surface. Use it to understand compatibility rather than to render UI.

### Practical guidance

The published package version and API compatibility version answer different questions: a package can receive new features without changing the API compatibility identifier.

## Additional usage notes

### When to use it

Use this helper when the stable compatibility identifier for Reactily's public API.

### Behavior and ownership

Package helpers expose metadata, compatibility, or convenience entrypoints.

### Pitfalls to avoid

> **Note:** Check the runtime package version and public API version separately; they represent different things.
