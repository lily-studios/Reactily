---
title: Reactily.Activity
description: Compatibility component that controls whether its children are rendered.
---

# `Reactily.Activity`

Compatibility component that controls whether its children are rendered. Use `Mode = "visible"` to display the subtree or `Mode = "hidden"` to hide it while retaining the Activity subtree. This export is present in the Reactily v2.1.0 package (API v1).

## Signature

```luau
Reactily.Activity(props: { Mode: "visible" | "hidden", Children: {any}, Key: string? }): Element
```

## Usage

```luau
local activity = Reactily.Activity({ Mode = "visible", Children = { child } })
```

See the related API pages for parameter details and supported behavior. Check the v2.1.0 release source when integrating APIs whose callback or option types are important to your project.

## Understanding this API

Special elements and host metadata influence how Reactily reconciles children or applies behavior that is not represented by a single ordinary Roblox class.

### Practical guidance

Use the documented input shape rather than guessing Roblox properties. Reactily-specific metadata is different from native Instance properties and may be handled specially by the renderer.

## Additional usage notes

### When to use it

Use this helper when compatibility component that controls whether its children are rendered. Use Mode = "visible" to display the subtree or Mode = "hidden" to hide it while retaining the.

### Behavior and ownership

This API integrates with rendering, lifecycle, or host behavior through Reactily’s public contract.

### Pitfalls to avoid

> **Note:** Check whether the operation must be called during rendering or during an event callback.
