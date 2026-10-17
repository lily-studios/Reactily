---
title: Reactily.createFrame
sidebar_label: createFrame
sidebar_position: 4
description: Describe a Roblox Frame with typed PascalCase properties and optional children.
---

`createFrame` creates a **virtual element**, not an immediate Roblox `Frame` Instance. A render root mounts and updates its underlying Roblox Instance.

## Signature

```luau
Reactily.createFrame(props: FrameProps?, children: {Element}?): Element
```

## Parameters

| Parameter | Type | Meaning |
| --- | --- | --- |
| `props` | `FrameProps?` | Frame properties such as `Size`, `Position`, and `BackgroundColor3`. |
| `children` | `{Element}?` | Optional virtual children rendered inside the frame. |

## Example

```luau
local Panel = Reactily.createFrame({
    Size = UDim2.fromOffset(360, 140),
    Position = UDim2.fromOffset(20, 20),
    BackgroundColor3 = Color3.fromRGB(30, 35, 42),
    BorderSizePixel = 0,
}, {
    Reactily.createTextLabel({
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "Hello, Roblox",
    }),
})

Root.render(Panel)
```

This example assumes `Reactily` and `Root` were initialized as shown in [Getting Started](/docs/getting-started).

## Property naming

Roblox property names stay in PascalCase: `BackgroundColor3`, not `backgroundColor3`. Public Luau types are also PascalCase, such as `Reactily.FrameProps`.

## Related

[Rendering](/docs/concepts/rendering) · [createRoot](/docs/api/virtual-tree/create-root) · [Examples](/docs/guides/examples)

## Understanding this API

`createFrame` is the normal building block for grouping UI elements. It describes a Frame without creating it until the root renders.

### Practical guidance

Place child elements in the optional children array. Use official Roblox properties such as `Size`, `Position`, and `BackgroundColor3` inside the props table.

## Additional usage notes

### When to use it

Use `createFrame` for containers, grouping elements, and defining UI regions using Roblox Frame properties.

### Behavior and ownership

Properties are passed in a table and applied when Reactily mounts or reconciles the element.

### Pitfalls to avoid

> **Note:** Keep native Roblox prop keys PascalCase (`Size`, `Position`, `BackgroundColor3`). Reactily-specific metadata keys are defined by their typed props.
