---
title: Reactily.Style
sidebar_label: Style
sidebar_position: 28
description: Public Reactily Style module.
---

# `Reactily.Style`

`Reactily.Style` is a public namespace exported by the runtime. Its methods are listed below.

## Methods

### `Style.create`

Creates a frozen reusable style table.

```luau
Reactily.Style.create(values: style): style
```

### `Style.variant`

Resolves a base style and named variant into one style table.

```luau
Reactily.Style.variant(definition: variantStyle, variant: string?): style
```

### `Style.apply`

Applies a style to a property table without mutating the original table.

```luau
Reactily.Style.apply<T>(properties: T, styleValue: style): T
```

### `Style.merge`

Merges multiple style tables without mutating the input styles.

```luau
Reactily.Style.merge(styles: { style }): style
```

### `Style.when`

Returns a style only when the supplied condition is true.

```luau
Reactily.Style.when(condition: boolean, styleValue: style): style
```

### `Style.without`

Creates a style without one specified property.

```luau
Reactily.Style.without(styleValue: style, property: string): style
```

### `Style.withProperty`

Creates a style with one property assigned to a new value.

```luau
Reactily.Style.withProperty(styleValue: style, property: string, value: any): style
```
