---
title: Reactily.createActivity
description: Creates an Activity element with a visible or hidden mode and child elements.
---

# `Reactily.createActivity`

Creates an Activity element with a visible or hidden mode and child elements. This export is included in Reactily v2.2.0 (API v1).

## Signature

```luau
Reactily.createActivity(mode: "visible" | "hidden", children: {any}, key: string?): Element
```

## Usage

```luau
local panel = Reactily.createActivity("visible", { Reactily.createTextLabel({ Text = "Ready" }) })
```

Use this hook or constructor only in a valid Reactily component/render context, as applicable.

## Understanding this API

Special elements and host metadata influence how Reactily reconciles children or applies behavior that is not represented by a single ordinary Roblox class.

### Practical guidance

Use the documented input shape rather than guessing Roblox properties. Reactily-specific metadata is different from native Instance properties and may be handled specially by the renderer.

## Additional usage notes

### When to use it

Use this creator when you need the Activity capability described above, and keep its result under a clear owner.

### Behavior and ownership

This API integrates with rendering, lifecycle, or host behavior through Reactily’s public contract.

### Pitfalls to avoid

> **Note:** Check whether the operation must be called during rendering or during an event callback.
