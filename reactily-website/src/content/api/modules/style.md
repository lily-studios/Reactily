---
title: Reactily.Style
sidebar_label: style
sidebar_position: 28
description: Public Reactily style module.
---

# `Reactily.Style`

`Reactily.Style` is a public namespace exported by the runtime. Its methods are listed below.

## Methods

### `Style.create`

Creates a frozen reusable style table.

```luau
Reactily.Style.create(values: Style): Style
```

### `Style.variant`

Resolves a base style and named variant into one style table.

```luau
Reactily.Style.variant(definition: VariantStyle, variant: string?): Style
```

### `Style.apply`

Applies a style to a property table without mutating the original table.

```luau
Reactily.Style.apply<T>(properties: T, styleValue: Style): T
```

### `Style.merge`

Merges multiple style tables without mutating the input styles.

```luau
Reactily.Style.merge(styles: { Style }): Style
```

### `Style.when`

Returns a style only when the supplied condition is true.

```luau
Reactily.Style.when(condition: boolean, styleValue: Style): Style
```

### `Style.without`

Creates a style without one specified property.

```luau
Reactily.Style.without(styleValue: Style, property: string): Style
```

### `Style.withProperty`

Creates a style with one property assigned to a new value.

```luau
Reactily.Style.withProperty(styleValue: Style, property: string, value: any): Style
```
