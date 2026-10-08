---
title: Reactily.Component
sidebar_label: component
sidebar_position: 3
description: Public Reactily component module.
---

# `Reactily.Component`

`Reactily.Component` is a public namespace exported by the runtime. Its methods are listed below.

## Methods

### `Component.create`

Creates a reusable function component with optional default props.

```luau
Reactily.Component.create<P>( render: (props: P) -> elementModule.Element?, options: ComponentOptions<P>? ): elementModule.Component<P>
```

### `Component.withDefaults`

Wraps a component with default props while preserving function-component behavior.

```luau
Reactily.Component.withDefaults<P>(componentValue: elementModule.Component<P>, defaults: P): elementModule.Component<P>
```
