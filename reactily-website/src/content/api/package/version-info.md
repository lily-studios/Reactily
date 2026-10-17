---
title: Reactily.versionInfo
sidebar_label: versionInfo
sidebar_position: 3
description: Structured semantic version information for the current Reactily runtime.
---

# `Reactily.versionInfo`

Structured semantic-version information.

```luau
Reactily.versionInfo = {
	major = 2,
	minor = 1,
	patch = 0,
}
```

This is useful for diagnostics and tooling that needs numeric version fields.

## Understanding this API

Package metadata describes the installed Reactily build and its supported feature surface. Use it to understand compatibility rather than to render UI.

### Practical guidance

The published package version and API compatibility version answer different questions: a package can receive new features without changing the API compatibility identifier.

## Additional usage notes

### When to use it

Use this helper when structured semantic-version information.

### Behavior and ownership

Package helpers expose metadata, compatibility, or convenience entrypoints.

### Pitfalls to avoid

> **Note:** Check the runtime package version and public API version separately; they represent different things.
