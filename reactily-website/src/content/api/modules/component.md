---
title: Reactily.Component
sidebar_label: component
sidebar_position: 3
description: Public Reactily component module.
---

# `Reactily.Component`

`Reactily.Component` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

Component helpers create function components and apply default props, allowing the same component to be reused with different inputs.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

## Methods

### `Component.create`

Creates a reusable function component with optional default props.

```luau
Reactily.Component.create<P>( render: (props: P) -> Reactily.Element?, options: ComponentOptions<P>? ): Reactily.Component<P>
```

### `Component.withDefaults`

Wraps a component with default props while preserving function-component behavior.

```luau
Reactily.Component.withDefaults<P>(componentValue: Reactily.Component<P>, defaults: P): Reactily.Component<P>
```

## Notes and common mistakes

- **Use:** Refer to the available method signatures above for inputs and output types; methods are ordinary Lua functions exported by this namespace.
- **Careful:** Framework method names and option keys must match their documented casing. Do not apply Roblox Instance naming rules to custom Reactily methods.

