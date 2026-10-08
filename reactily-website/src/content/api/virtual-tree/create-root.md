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
Root.Delete()
```

Call `delete()` when the interface is permanently dismissed. Do not call `render()` on a deleted root.

## Version 2.1.0 conventions

The root render method is lowercase **`Root.render()`**, not `Root.Render()`; cleanup is **`Root.Delete()`**, not `Root.delete()`. Reactily public functions such as `createRoot()` are camelCase; exported types and Roblox host properties are PascalCase.

## Related

[Getting Started](/docs/getting-started) · [Rendering](/docs/concepts/rendering) · [createFrame](/docs/api/typed-creators/create-frame)
