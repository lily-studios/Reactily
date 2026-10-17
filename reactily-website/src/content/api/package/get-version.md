---
title: Reactily.getVersion
sidebar_label: getVersion (deprecated)
sidebar_position: 90
description: Deprecated compatibility alias that returns Reactily.version.
---

# `Reactily.getVersion`

> Deprecated in Reactily 1.4. Use `Reactily.version` instead.

```luau
local version = Reactily.getVersion()
```

This alias remains available through the Reactily 2.x compatibility line so older applications do not break.

## Understanding this API

Package metadata describes the installed Reactily build and its supported feature surface. Use it to understand compatibility rather than to render UI.

### Practical guidance

The published package version and API compatibility version answer different questions: a package can receive new features without changing the API compatibility identifier.

## Additional usage notes

### When to use it

Use this accessor to read the Version information without replacing the owning value.

### Behavior and ownership

Package helpers expose metadata, compatibility, or convenience entrypoints.

### Pitfalls to avoid

> **Note:** Check the runtime package version and public API version separately; they represent different things.
