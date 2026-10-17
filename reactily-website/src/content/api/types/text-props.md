---
title: "Type: TextProps"
sidebar_label: TextProps
description: Luau type Reactily.TextProps, exported from virtual.element.
api_types: TextProps
---

# `Reactily.TextProps`

`TextProps` is a public Luau type exported from the `virtual.element` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type TextPropsAlias = Reactily.TextProps
```

## Definition

```luau
export type TextProps = {
	Font: Enum.Font?,
	FontFace: Font?,
	LineHeight: number?,
	MaxVisibleGraphemes: number?,
	RichText: boolean?,
	Text: string?,
	TextColor3: Color3?,
	TextDirection: Enum.TextDirection?,
	TextScaled: boolean?,
	TextSize: number?,
	TextStrokeColor3: Color3?,
	TextStrokeTransparency: number?,
	TextTransparency: number?,
	TextTruncate: Enum.TextTruncate?,
	TextWrapped: boolean?,
	TextXAlignment: Enum.TextXAlignment?,
	TextYAlignment: Enum.TextYAlignment?,
}
```

## Notes

- Use `Reactily.TextProps` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

Use this type when creating configuration or component-prop tables. It helps the Luau analyzer catch misspelled field names before runtime.

## Notes and common mistakes

- The table must follow the exact field names shown in the definition. Reactily-owned option keys are usually camelCase; only Roblox native Instance properties use their official PascalCase.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
