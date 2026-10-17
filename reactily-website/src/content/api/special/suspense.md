---
title: Reactily.Suspense
sidebar_label: Suspense
sidebar_position: 7
description: React-compatible Suspense component marker for fallback rendering.
---

# `Reactily.Suspense`

React-compatible Suspense component marker for fallback rendering.

## Usage

```luau
local tree = Reactily.createElement(Reactily.Suspense, {
	Fallback = loading,
	Children = { content },
})
```

## Understanding this API

Special elements and host metadata influence how Reactily reconciles children or applies behavior that is not represented by a single ordinary Roblox class.

### Practical guidance

Use the documented input shape rather than guessing Roblox properties. Reactily-specific metadata is different from native Instance properties and may be handled specially by the renderer.

## Additional usage notes

### When to use it

Use this helper when react-compatible Suspense component marker for fallback rendering.

### Behavior and ownership

This API integrates with rendering, lifecycle, or host behavior through Reactily’s public contract.

### Pitfalls to avoid

> **Note:** Check whether the operation must be called during rendering or during an event callback.
