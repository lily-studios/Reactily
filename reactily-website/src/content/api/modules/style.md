---
title: Reactily.Style
sidebar_label: style
sidebar_position: 28
description: Public Reactily style module.
---

# `Reactily.Style`

`Reactily.Style` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

Style helpers create and combine declarative property tables. They do not replace Roblox Instance property names; property keys must match the target type.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

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

## Composing styles

Create shared style tables to avoid duplicating a long list of property values across multiple components. Use `merge` to combine styles, `variant` for named alternatives, and `when` for conditional application. `without` drops one property and `withProperty` adds or overrides one property in the resulting style. All property keys still need to match the Roblox class receiving them.

## Notes and common mistakes

- **Input:** Style functions organize reusable property sets. When applied to a host, Roblox properties keep their engine-defined names.
- **Common mistake:** Using custom camelCase replacements for native Roblox property names.

