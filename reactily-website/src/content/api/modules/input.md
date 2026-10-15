---
title: Reactily.Input
sidebar_label: Input
sidebar_position: 11
description: Public Reactily Input module.
---

# `Reactily.Input`

`Reactily.Input` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

Input bindings register input callbacks against Roblox input sources or selected input kinds. Keep their controller handles and release them when the associated UI is removed.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

## Methods

### `Input.bind`

Binds a filtered UserInputService InputBegan callback.

```luau
Reactily.Input.bind( predicate: (input: InputObject) -> boolean, callback: (input: InputObject) -> (), options: InputOptions? ): InputBinding
```

### `Input.bindKey`

Binds a keyboard key with optional required modifiers.

```luau
Reactily.Input.bindKey(keyCode: Enum.KeyCode, callback: (input: InputObject) -> (), options: KeyOptions?): InputBinding
```

### `Input.bindType`

Binds a UserInputType such as mouse or touch input.

```luau
Reactily.Input.bindType( inputType: Enum.UserInputType, callback: (input: InputObject) -> (), options: InputOptions? ): InputBinding
```

## Notes and common mistakes

- **Use:** Refer to the available method signatures above for inputs and output types; methods are ordinary Lua functions exported by this namespace.
- **Careful:** Framework method names and option keys must match their documented casing. Do not apply Roblox Instance naming rules to custom Reactily methods.

