---
title: Reactily.Layout
sidebar_label: Layout
sidebar_position: 14
description: Public Reactily Layout module.
---

# `Reactily.Layout`

`Reactily.Layout` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

Use the layout helpers to construct transparent containers plus the relevant Roblox layout objects. The choice between `horizontal`, `vertical`, `wrap`, and `grid` changes how children are arranged; the result is still a virtual Reactily element.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

## Methods

### `Layout.horizontal`

Creates a transparent horizontal list container.

```luau
Reactily.Layout.horizontal(options: ListOptions?, children: { any }): Reactily.Element
```

### `Layout.vertical`

Creates a transparent vertical list container.

```luau
Reactily.Layout.vertical(options: ListOptions?, children: { any }): Reactily.Element
```

### `Layout.wrap`

Creates a transparent wrapping list container.

```luau
Reactily.Layout.wrap(options: ListOptions?, children: { any }): Reactily.Element
```

### `Layout.grid`

Creates a grid container backed by UIGridLayout.

```luau
Reactily.Layout.grid(options: GridOptions, children: { any }): Reactily.Element
```

### `Layout.stack`

Creates a transparent stacking container where children share the same bounds.

```luau
Reactily.Layout.stack(options: CommonOptions?, children: { any }): Reactily.Element
```

### `Layout.center`

Creates a container whose children are centered by UIListLayout.

```luau
Reactily.Layout.center(options: CommonOptions?, children: { any }): Reactily.Element
```

## Example: group elements horizontally

```luau
local layout = Reactily.Layout.horizontal(nil, {
    Reactily.createTextLabel({ Text = "Left" }),
    Reactily.createTextLabel({ Text = "Right" }),
})

local root = Reactily.createRoot(playerGui)
root.render(layout)
```

**Choosing a method:** `horizontal` and `vertical` use linear list arrangements; `wrap` handles multi-row content; `grid` is appropriate for fixed-size cells. Use `stack` when children should share a container, or `center` when the content must be centered. These helpers return virtual elements and do not mount UI until a root renders them.

## Notes and common mistakes

- **Input:** Layout helpers build virtual GUI compositions, not immediate Roblox layout Instances.
- **Common mistake:** Confusing native Roblox layout properties (`FillDirection`, `HorizontalAlignment`, etc.) with Reactily helper names.

