---
title: Reactily.Style
sidebar_label: style
sidebar_position: 28
description: Public Reactily style module.
---

# `Reactily.Style`

`Reactily.Style` is a public namespace exported by the runtime. Its methods are listed below.

## Methods

### `Style.Create`

Creates a frozen reusable style table.

```luau
Reactily.Style.Create(values: Style): Style
```

### `Style.Variant`

Resolves a base style and named variant into one style table.

```luau
Reactily.Style.Variant(definition: VariantStyle, variant: string?): Style
```

### `Style.Apply`

Applies a style to a property table without mutating the original table.

```luau
Reactily.Style.Apply<T>(properties: T, styleValue: Style): T
```

### `Style.Merge`

Merges multiple style tables without mutating the input styles.

```luau
Reactily.Style.Merge(styles: { Style }): Style
```

### `Style.When`

Returns a style only when the supplied condition is true.

```luau
Reactily.Style.When(condition: boolean, styleValue: Style): Style
```

### `Style.Without`

Creates a style without one specified property.

```luau
Reactily.Style.Without(styleValue: Style, property: string): Style
```

### `Style.WithProperty`

Creates a style with one property assigned to a new value.

```luau
Reactily.Style.WithProperty(styleValue: Style, property: string, value: any): Style
```
