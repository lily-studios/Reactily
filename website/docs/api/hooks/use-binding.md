---
title: Reactily.useBinding
sidebar_label: useBinding
sidebar_position: 3
description: API reference for Reactily.useBinding.
---

# `Reactily.useBinding`

Creates and owns a Reactily binding for the component lifetime.

## Signature
```typescript
Reactily.useBinding<T>(initialValue: T): binding<T>
```
## Usage
```typescript
local binding = Reactily.useBinding(0)
```
## Works with

Pairs naturally with `bindProperty`, `bindAttribute`, binding transforms.
