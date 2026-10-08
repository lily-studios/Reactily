---
title: Reactily.Input
sidebar_label: Input
sidebar_position: 11
description: Public Reactily Input module.
---

# `Reactily.Input`

`Reactily.Input` is a public namespace exported by the runtime. Its methods are listed below.

## Methods

### `Input.bind`

Binds a filtered UserInputService InputBegan callback.

```luau
Reactily.Input.bind( predicate: (input: InputObject) -> boolean, callback: (input: InputObject) -> (), options: inputOptions? ): inputBinding
```

### `Input.bindKey`

Binds a keyboard key with optional required modifiers.

```luau
Reactily.Input.bindKey(keyCode: Enum.KeyCode, callback: (input: InputObject) -> (), options: keyOptions?): inputBinding
```

### `Input.bindType`

Binds a UserInputType such as mouse or touch input.

```luau
Reactily.Input.bindType( inputType: Enum.UserInputType, callback: (input: InputObject) -> (), options: inputOptions? ): inputBinding
```
