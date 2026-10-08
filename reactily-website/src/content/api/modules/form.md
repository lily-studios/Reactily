---
title: Reactily.Form
sidebar_label: Form
sidebar_position: 8
description: Public Reactily Form module.
---

# `Reactily.Form`

`Reactily.Form` is a public namespace exported by the runtime. Its methods are listed below.

## Methods

### `Form.Create`

Creates a reactive form with per-field bindings, reset, dirty state, and validation.

```luau
Reactily.Form.Create<T>(initial: T): form<T>
```

The returned owned controller (the internal Luau type is `form<T>`) exposes `Get()`, `Set()`, `Field()`, `GetErrors()`, `IsDirty()`, `Reset()`, `Subscribe()`, `Validate()`, `Delete()`, and `IsDeleted()`.
