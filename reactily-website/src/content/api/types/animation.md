---
title: "Type: Animation"
sidebar_label: Animation
description: Luau type Reactily.Animation, exported from runtime.animation.
api_types: Animation
---

# `Reactily.Animation`

`Animation` is a public Luau type exported from the `runtime.animation` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type AnimationAlias = Reactily.Animation
```

## Definition

```luau
export type Animation = {
	cancel: () -> boolean,
	delete: () -> boolean,
	isDeleted: () -> boolean,
	onCompleted: (callback: (playbackState: Enum.PlaybackState) -> ()) -> RBXScriptConnection,
	play: () -> (),
	tween: Tween,
}
```

## Notes

- Use `Reactily.Animation` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

Use this exported type in strict Luau files to document expected values and receive useful editor diagnostics.

## Notes and common mistakes

- Types are erased at runtime. Do not call them as functions or attempt to `require()` them as ModuleScripts.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
