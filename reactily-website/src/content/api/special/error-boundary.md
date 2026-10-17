---
title: Reactily.ErrorBoundary
sidebar_label: ErrorBoundary
sidebar_position: 8
description: React-compatible error-boundary component marker.
---

# `Reactily.ErrorBoundary`

React-compatible error-boundary component marker.

## Usage

```luau
local boundary = Reactily.createElement(Reactily.ErrorBoundary, {
	Fallback = fallback,
	Children = { child },
})
```

## Understanding this API

Special elements and host metadata influence how Reactily reconciles children or applies behavior that is not represented by a single ordinary Roblox class.

### Practical guidance

Use the documented input shape rather than guessing Roblox properties. Reactily-specific metadata is different from native Instance properties and may be handled specially by the renderer.

## Additional usage notes

### When to use it

Use this helper when react-compatible error-boundary component marker.

### Behavior and ownership

This API integrates with rendering, lifecycle, or host behavior through Reactily’s public contract.

### Pitfalls to avoid

> **Note:** Check whether the operation must be called during rendering or during an event callback.
