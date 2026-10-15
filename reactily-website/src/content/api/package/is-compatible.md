---
title: Reactily.isCompatible
sidebar_label: isCompatible
sidebar_position: 6
description: Tests whether a consumer API version is compatible with this Reactily build.
---

# `Reactily.isCompatible`

Checks the stable API compatibility number.

## Signature

```luau
Reactily.isCompatible(requestedApiVersion: number): boolean
```

## Usage

```luau
assert(
	Reactily.isCompatible(1),
	"This package requires Reactily API v1"
)
```

## Understanding this API

Package metadata describes the installed Reactily build and its supported feature surface. Use it to understand compatibility rather than to render UI.

### Practical guidance

The published package version and API compatibility version answer different questions: a package can receive new features without changing the API compatibility identifier.

## Additional usage notes

### When to use it

Use this helper when checks the stable API compatibility number.

### Behavior and ownership

Package helpers expose metadata, compatibility, or convenience entrypoints.

### Pitfalls to avoid

> **Note:** Check the runtime package version and public API version separately; they represent different things.
