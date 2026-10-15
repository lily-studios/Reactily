---
title: Reactily.Experimental
sidebar_label: Experimental
sidebar_position: 7
description: Reserved namespace for unstable future Reactily APIs.
---

# `Reactily.Experimental`

Reserved namespace for future APIs that are intentionally not covered by the stable API v1 compatibility contract.

Reactily v2.2.0 (API v1) exports an empty frozen table:

```luau
Reactily.Experimental
```

This namespace is currently empty in v2.1.0. Experimental features may change between releases; stable APIs should graduate out of this namespace before production users depend on them.

## Understanding this API

Package metadata describes the installed Reactily build and its supported feature surface. Use it to understand compatibility rather than to render UI.

### Practical guidance

The published package version and API compatibility version answer different questions: a package can receive new features without changing the API compatibility identifier.

## Additional usage notes

### When to use it

Use this helper when reserved namespace for future APIs that are intentionally not covered by the stable API v1 compatibility contract.

### Behavior and ownership

Package helpers expose metadata, compatibility, or convenience entrypoints.

### Pitfalls to avoid

> **Note:** Check the runtime package version and public API version separately; they represent different things.
