---
title: Reactily.new
sidebar_label: new (deprecated)
sidebar_position: 91
description: Deprecated compatibility alias for Reactily.createRoot.
---

# `Reactily.new`

> Deprecated in Reactily 1.4. Use `Reactily.createRoot(parent)` instead.

```luau
local Root = Reactily.new(playerGui)
```

This alias remains available through the Reactily 2.x compatibility line so older applications do not break.

## Understanding this API

Package metadata describes the installed Reactily build and its supported feature surface. Use it to understand compatibility rather than to render UI.

### Practical guidance

The published package version and API compatibility version answer different questions: a package can receive new features without changing the API compatibility identifier.

## Additional usage notes

### When to use it

Use this helper when > Deprecated in Reactily 1.4. Use Reactily.createRoot(parent) instead.

### Behavior and ownership

Package helpers expose metadata, compatibility, or convenience entrypoints.

### Pitfalls to avoid

> **Note:** Check the runtime package version and public API version separately; they represent different things.
