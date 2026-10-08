---
title: Reactily.Props
sidebar_label: Props
sidebar_position: 21
description: Public Reactily Props module.
---

# `Reactily.Props`

`Reactily.Props` is a public namespace exported by the runtime. Its methods are listed below.

## Methods

### `Props.Defaults`

Returns a copy of props with missing values filled from defaults.

```luau
Reactily.Props.Defaults<T>(props: T, defaults: PropMap): T
```

### `Props.Equal`

Returns whether two prop tables are shallowly equal.

```luau
Reactily.Props.Equal(first: PropMap, second: PropMap): boolean
```

### `Props.Changed`

Returns changed current values plus keys that were removed.

```luau
Reactily.Props.Changed(previous: PropMap, current: PropMap): (PropMap, { any })
```

### `Props.Merge`

Merges prop tables from left to right without mutating any input.

```luau
Reactily.Props.Merge(...: PropMap): PropMap
```

### `Props.Omit`

Returns a copy without the supplied keys.

```luau
Reactily.Props.Omit(props: PropMap, keys: { any }): PropMap
```

### `Props.Pick`

Returns a new table containing only the supplied keys.

```luau
Reactily.Props.Pick(props: PropMap, keys: { any }): PropMap
```
