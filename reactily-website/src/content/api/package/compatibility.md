---
title: Compatibility policy
sidebar_label: Compatibility
sidebar_position: 2
description: How Reactily versions, deprecations, and feature detection should evolve without breaking applications.
---

# Compatibility policy

Reactily follows semantic-versioning rules for its public API.

- Patch releases fix bugs without intentionally changing public contracts.
- Minor releases may add optional APIs and capabilities while preserving existing supported calls.
- Major releases may remove deprecated APIs or make intentionally breaking changes.

## Prefer capability checks

When adopting optional features, prefer checking whether the feature exists instead of requiring one exact patch version.

```luau
if Reactily.useOptimistic then
	-- use the newer capability
end
```

## Deprecation rule

Public APIs should be deprecated before removal. A replacement should ship first, old code should keep working through the current major line, and removal should wait for the next major release.

## Runtime source of truth

The API reference in this site is validated against the current unreleased Reactily 1.4.0 development runtime. The documentation build includes an API coverage check so stale names are caught before release.
