---
title: Reactily.Change
sidebar_label: Change
sidebar_position: 2
description: Host metadata key family used to subscribe to Roblox property changes.
---

# `Reactily.Change`

Host metadata key family used to subscribe to Roblox property changes.

## Usage

```luau
props[Reactily.Change.Size] = function(size)
	print(size)
end
```

## Understanding this API

Special elements and host metadata influence how Reactily reconciles children or applies behavior that is not represented by a single ordinary Roblox class.

### Practical guidance

Use the documented input shape rather than guessing Roblox properties. Reactily-specific metadata is different from native Instance properties and may be handled specially by the renderer.

## Additional usage notes

### When to use it

Use this helper when host metadata key family used to subscribe to Roblox property changes.

### Behavior and ownership

This API integrates with rendering, lifecycle, or host behavior through Reactily’s public contract.

### Pitfalls to avoid

> **Note:** Check whether the operation must be called during rendering or during an event callback.
