---
title: Reactily.Scroll
sidebar_label: Scroll
sidebar_position: 25
description: Public Reactily Scroll module.
---

# `Reactily.Scroll`

`Reactily.Scroll` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

Scroll helpers provide common scrolling operations such as moving by an offset, scrolling to an object, or jumping to an edge.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

## Methods

### `Scroll.by`

Scrolls by a pixel delta while clamping to the canvas bounds.

```luau
Reactily.Scroll.by(frame: ScrollingFrame, delta: Vector2)
```

### `Scroll.toBottom`

Scrolls to the bottom-right canvas limit.

```luau
Reactily.Scroll.toBottom(frame: ScrollingFrame)
```

### `Scroll.toObject`

Scrolls until a descendant GuiObject is visible.

```luau
Reactily.Scroll.toObject(frame: ScrollingFrame, object: GuiObject)
```

### `Scroll.toTop`

Scrolls to the top-left origin.

```luau
Reactily.Scroll.toTop(frame: ScrollingFrame)
```

## Working with scrolling interfaces

Use `toTop` and `toBottom` for navigation to known ends, `by` to move relative to the current position, and `toObject` to reveal a particular GUI object. For large lists, coordinate scrolling with virtual range calculations so the visible item indices match the displayed scroll position.

## Notes and common mistakes

- **Use:** Refer to the available method signatures above for inputs and output types; methods are ordinary Lua functions exported by this namespace.
- **Careful:** Framework method names and option keys must match their documented casing. Do not apply Roblox Instance naming rules to custom Reactily methods.

