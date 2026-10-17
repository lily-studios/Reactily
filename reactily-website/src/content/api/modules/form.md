---
title: Reactily.Form
sidebar_label: Form
sidebar_position: 8
description: Public Reactily Form module.
---

# `Reactily.Form`

`Reactily.Form` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

Form utilities centralize field data and validation so multiple inputs can be managed as one form.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

## Methods

### `Form.create`

Creates a reactive form with per-field bindings, reset, dirty state, and validation.

```luau
Reactily.Form.create<T>(initial: T): form<T>
```

The returned owned controller (the internal Luau type is `form<T>`) exposes `Get()`, `Set()`, `Field()`, `GetErrors()`, `IsDirty()`, `Reset()`, `Subscribe()`, `Validate()`, `Delete()`, and `IsDeleted()`.

## Notes and common mistakes

- **Input:** Form helpers centralize validation and state management for controlled input.
- **Common mistake:** Mixing independent text-input mutation with form-managed state without synchronization.

