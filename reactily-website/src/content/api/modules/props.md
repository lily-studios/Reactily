---
title: Reactily.Props
sidebar_label: Props
sidebar_position: 21
description: Public Reactily Props module.
---

# `Reactily.Props`

`Reactily.Props` is a public namespace exported by the runtime. Its methods are listed below.

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
