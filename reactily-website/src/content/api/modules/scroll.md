---
title: Reactily.Scroll
sidebar_label: Scroll
sidebar_position: 25
description: Public Reactily Scroll module.
---

# `Reactily.Scroll`

`Reactily.Scroll` is a public namespace exported by the runtime. Its methods are listed below.

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
