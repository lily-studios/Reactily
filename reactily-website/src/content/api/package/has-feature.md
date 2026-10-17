---
title: Reactily.hasFeature
sidebar_label: hasFeature
sidebar_position: 5
description: Tests whether the current Reactily runtime supports a named capability.
---

# `Reactily.hasFeature`

Checks a named feature capability.

## Signature

```luau
Reactily.hasFeature(feature: string): boolean
```

## Usage

```luau
if Reactily.hasFeature("virtual-grid") then
	-- use Reactily.VirtualGrid
end
```

Prefer this over exact-version checks for optional functionality.

## Understanding this API

Package metadata describes the installed Reactily build and its supported feature surface. Use it to understand compatibility rather than to render UI.

### Practical guidance

The published package version and API compatibility version answer different questions: a package can receive new features without changing the API compatibility identifier.

## Additional usage notes

### When to use it

Use this helper when checks a named feature capability.

### Behavior and ownership

Package helpers expose metadata, compatibility, or convenience entrypoints.

### Pitfalls to avoid

> **Note:** Check the runtime package version and public API version separately; they represent different things.
