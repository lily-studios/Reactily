---
title: Reactily.createRoot
sidebar_label: createRoot
sidebar_position: 6
description: Mount and manage one Reactily UI tree under a Roblox Instance.
---

`createRoot` connects a virtual Reactily tree to a Roblox parent such as `PlayerGui`. Its root owns rendering and cleanup for that tree.

## Signature

```luau
Reactily.createRoot(parent: Instance): Root
```

## Parameters

| Parameter | Type | Meaning |
| --- | --- | --- |
| `parent` | `Instance` | Roblox Instance where the rendered tree belongs. |

## Example: mount a panel

```luau
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Reactily = require(ReplicatedStorage:WaitForChild("Reactily"))

local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local Root = Reactily.createRoot(PlayerGui)

Root.render(Reactily.createFrame({
    Size = UDim2.fromOffset(300, 120),
    BackgroundColor3 = Color3.fromRGB(30, 35, 42),
}))
```

Run the example in a client `LocalScript`. Rendering again on the same root updates the existing tree through reconciliation.

## Cleanup

```luau
Root.delete()
```

Call `delete()` when the interface is permanently dismissed. Do not call `render()` on a deleted root.

## Version 2.1.0 conventions

The root render method is lowercase **`Root.render()`**, not `Root.Render()`; cleanup is **`Root.Delete()`**, not `Root.delete()`. Reactily public functions such as `createRoot()` are camelCase; exported types and Roblox host properties are PascalCase.

## Related

[Getting Started](/docs/getting-started) · [Rendering](/docs/concepts/rendering) · [createFrame](/docs/api/typed-creators/create-frame)

## Understanding this API

A root manages the reconciliation lifecycle under a specific Roblox parent. `render` sets the virtual tree that the root should display.

### Practical guidance

Keep the root handle while the UI exists, and call its deletion method when the owner is destroyed. Updating the same root lets Reactily reconcile changes instead of creating a new root for every update.

## Additional usage notes

### When to use it

Create one root for each Roblox parent that Reactily should manage. Render elements through that root instead of creating duplicate UI parents on each state change.

### Behavior and ownership

A root is an owner of rendered instances and associated component state. Hold on to it until the interface is no longer needed.

### Pitfalls to avoid

> **Note:** Creating a new root on every render can create duplicate UI and leave old roots active. Keep the root stable and dispose of it when its host is removed.
