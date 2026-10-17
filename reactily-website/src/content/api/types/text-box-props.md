---
title: "Type: TextBoxProps"
sidebar_label: TextBoxProps
description: Luau type Reactily.TextBoxProps, exported from virtual.element.
api_types: TextBoxProps
---

# `Reactily.TextBoxProps`

`TextBoxProps` is a public Luau type exported from the `virtual.element` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type TextBoxPropsAlias = Reactily.TextBoxProps
```

## Definition

```luau
export type TextBoxProps = CommonGuiProps<TextBox> & TextProps & {
	ClearTextOnFocus: boolean?,
	CursorPosition: number?,
	MultiLine: boolean?,
	PlaceholderColor3: Color3?,
	PlaceholderText: string?,
	SelectionStart: number?,
	ShowNativeInput: boolean?,
	TextEditable: boolean?,
	onFocused: (() -> ())?,
	onFocusLost: ((enterPressed: boolean, input: InputObject?) -> ())?,
}
```

## Notes

- Use `Reactily.TextBoxProps` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

Use this type when creating configuration or component-prop tables. It helps the Luau analyzer catch misspelled field names before runtime.

## Notes and common mistakes

- The table must follow the exact field names shown in the definition. Reactily-owned option keys are usually camelCase; only Roblox native Instance properties use their official PascalCase.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
