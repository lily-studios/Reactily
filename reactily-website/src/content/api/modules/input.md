---
title: Reactily.Input
sidebar_label: Input
sidebar_position: 11
description: Public Reactily Input module.
---

# `Reactily.Input`

`Reactily.Input` is a public namespace exported by the runtime. Its methods are listed below.

## Methods

### `Input.Bind`

Binds a filtered UserInputService InputBegan callback.

```luau
Reactily.Input.Bind( predicate: (input: InputObject) -> boolean, callback: (input: InputObject) -> (), options: InputOptions? ): InputBinding
```

### `Input.BindKey`

Binds a keyboard key with optional required modifiers.

```luau
Reactily.Input.BindKey(keyCode: Enum.KeyCode, callback: (input: InputObject) -> (), options: KeyOptions?): InputBinding
```

### `Input.BindType`

Binds a UserInputType such as mouse or touch input.

```luau
Reactily.Input.BindType( inputType: Enum.UserInputType, callback: (input: InputObject) -> (), options: InputOptions? ): InputBinding
```
