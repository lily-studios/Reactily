---
title: Reactily.Component
sidebar_label: Component
sidebar_position: 3
description: Public Reactily Component module.
---

# `Reactily.Component`

`Reactily.Component` is a public namespace exported by the runtime. Its methods are listed below.

## Methods

### `Component.create`

Creates a reusable function component with optional default props.

```luau
Reactily.Component.create<P>( render: (props: P) -> elementModule.element?, options: componentOptions<P>? ): elementModule.component<P>
```

### `Component.withDefaults`

Wraps a component with default props while preserving function-component behavior.

```luau
Reactily.Component.withDefaults<P>(componentValue: elementModule.component<P>, defaults: P): elementModule.component<P>
```
