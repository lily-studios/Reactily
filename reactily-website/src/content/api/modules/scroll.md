---
title: Reactily.Scroll
sidebar_label: Scroll
sidebar_position: 25
description: Public Reactily Scroll module.
---

# `Reactily.Scroll`

`Reactily.Scroll` is a public namespace exported by the runtime. Its methods are listed below.

## Methods

### `Scroll.By`

Scrolls by a pixel delta while clamping to the canvas bounds.

```luau
Reactily.Scroll.By(frame: ScrollingFrame, delta: Vector2)
```

### `Scroll.ToBottom`

Scrolls to the bottom-right canvas limit.

```luau
Reactily.Scroll.ToBottom(frame: ScrollingFrame)
```

### `Scroll.ToObject`

Scrolls until a descendant GuiObject is visible.

```luau
Reactily.Scroll.ToObject(frame: ScrollingFrame, object: GuiObject)
```

### `Scroll.ToTop`

Scrolls to the top-left origin.

```luau
Reactily.Scroll.ToTop(frame: ScrollingFrame)
```
