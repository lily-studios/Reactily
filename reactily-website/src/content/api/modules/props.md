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
Reactily.Props.defaults<T>(props: T, defaults: propMap): T
```

### `Props.equal`

Returns whether two prop tables are shallowly equal.

```luau
Reactily.Props.equal(first: propMap, second: propMap): boolean
```

### `Props.changed`

Returns changed current values plus keys that were removed.

```luau
Reactily.Props.changed(previous: propMap, current: propMap): (propMap, { any })
```

### `Props.merge`

Merges prop tables from left to right without mutating any input.

```luau
Reactily.Props.merge(...: propMap): propMap
```

### `Props.omit`

Returns a copy without the supplied keys.

```luau
Reactily.Props.omit(props: propMap, keys: { any }): propMap
```

### `Props.pick`

Returns a new table containing only the supplied keys.

```luau
Reactily.Props.pick(props: propMap, keys: { any }): propMap
```
