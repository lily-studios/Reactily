---
title: "Type: MotionOptions"
sidebar_label: MotionOptions
description: Luau type Reactily.MotionOptions, exported from runtime.motion.
api_types: MotionOptions
---

# `Reactily.MotionOptions`

`MotionOptions` is a public Luau type exported from the `runtime.motion` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type MotionOptionsAlias = Reactily.MotionOptions
```

## Definition

```luau
export type MotionOptions = {
	delay: number?,
	Direction: Enum.EasingDirection?,
	duration: number?,
	RepeatCount: number?,
	Reverses: boolean?,
	Style: Enum.EasingStyle?,
}
```

## Notes

- Use `Reactily.MotionOptions` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

Use this type when creating configuration or component-prop tables. It helps the Luau analyzer catch misspelled field names before runtime.

## Notes and common mistakes

- The table must follow the exact field names shown in the definition. Reactily-owned option keys are usually camelCase; only Roblox native Instance properties use their official PascalCase.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
