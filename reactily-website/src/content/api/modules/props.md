---
title: Reactily.Props
sidebar_label: Props
sidebar_position: 21
description: Public Reactily Props module.
---

# `Reactily.Props`

`Reactily.Props` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

These helpers work with plain props tables. `defaults` fills absent keys, `merge` combines tables, `pick` and `omit` filter keys, while `equal` and `changed` compare prop sets.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

## Methods

### `Props.defaults`

Returns a copy of props with missing values filled from defaults.

```luau
Reactily.Props.defaults<T>(props: T, defaults: PropMap): T
```

### `Props.equal`

Returns whether two prop tables are shallowly equal.

```luau
Reactily.Props.equal(first: PropMap, second: PropMap): boolean
```

### `Props.changed`

Returns changed current values plus keys that were removed.

```luau
Reactily.Props.changed(previous: PropMap, current: PropMap): (PropMap, { any })
```

### `Props.merge`

Merges prop tables from left to right without mutating any input.

```luau
Reactily.Props.merge(...: PropMap): PropMap
```

### `Props.omit`

Returns a copy without the supplied keys.

```luau
Reactily.Props.omit(props: PropMap, keys: { any }): PropMap
```

### `Props.pick`

Returns a new table containing only the supplied keys.

```luau
Reactily.Props.pick(props: PropMap, keys: { any }): PropMap
```

## Example: apply defaults and compare props

```luau
local props = Reactily.Props.defaults({ Text = "Ready" }, {
    Text = "Untitled",
    TextSize = 18,
})

local changed = Reactily.Props.changed({ Text = "Old" }, props)
print(props.Text, props.TextSize)
print(changed.Text)
```

**Choosing a method:** `defaults` only fills missing values, while `merge` lets later tables override earlier ones. `equal` performs a shallow comparison, and `changed` also reports removed keys in a second return value. `pick` and `omit` return new tables rather than modifying the original props table.

## Notes and common mistakes

- **Input:** Property utilities work on Reactily property tables; they do not modify a host Instance until those properties are rendered or explicitly applied.
- **Common mistake:** Expecting `pick`, `omit`, or `merge` to perform host mutation.

