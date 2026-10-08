---
title: Reactily.Component
sidebar_label: component
sidebar_position: 3
description: Public Reactily component module.
---

# `Reactily.Component`

`Reactily.Component` is a public namespace exported by the runtime. Its methods are listed below.

## Methods

### `Component.Create`

Creates a reusable function component with optional default props.

```luau
Reactily.Component.Create<P>( render: (props: P) -> Reactily.Element?, options: ComponentOptions<P>? ): Reactily.Component<P>
```

### `Component.WithDefaults`

Wraps a component with default props while preserving function-component behavior.

```luau
Reactily.Component.WithDefaults<P>(componentValue: Reactily.Component<P>, defaults: P): Reactily.Component<P>
```
