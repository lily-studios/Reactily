---
title: Reactily.Children
sidebar_label: Children
sidebar_position: 1
description: Public Reactily Children module.
---

# `Reactily.Children`

`Reactily.Children` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

Use this namespace when a component accepts arbitrary child values or nested child arrays and needs to normalize them consistently. `toArray` produces a flat list, `count` reports its length, and `only` asserts that exactly one normalized child was supplied.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

## Methods

### `Children.count`

Counts normalized Reactily children.

```luau
Reactily.Children.count(children: { any }): number
```

### `Children.forEach`

Invokes a callback for every normalized child.

```luau
Reactily.Children.forEach(children: { any }, callback: (child: Reactily.Element, index: number) -> ())
```

### `Children.map`

Maps normalized children and flattens returned child arrays.

```luau
Reactily.Children.map( children: { any }, callback: (child: Reactily.Element, index: number) -> any ): { Reactily.Element }
```

### `Children.only`

Returns the only normalized child and errors when the count differs from one.

```luau
Reactily.Children.only(children: { any }): Reactily.Element
```

### `Children.toArray`

Flattens nested children into a new ordered array.

```luau
Reactily.Children.toArray(children: { any }): { Reactily.Element }
```

## Example: normalize optional children

```luau
local first = Reactily.createTextLabel({ Text = "First" })
local second = Reactily.createTextLabel({ Text = "Second" })
local input = { first, { second } }

local flattened = Reactily.Children.toArray(input)
print(Reactily.Children.count(input)) -- 2
print(Reactily.Children.only({ first }) == first) -- true
```

**Choosing a method:** Use `count` to inspect the number of normalized children; `forEach` for side-effect-free inspection; `map` when creating a transformed child list; `only` when an API accepts exactly one child; and `toArray` when passing a flattened array into a different helper. `only` raises an error when zero or multiple children remain after normalization.

## Notes and common mistakes

- **Input:** Nested child lists are normalized before applying `count`, `forEach`, `map`, `only`, or `toArray`.
- **Common mistake:** Calling `only` with zero or more than one normalized child raises an error. Use `toArray` when the number is not fixed.

