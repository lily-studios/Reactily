---
title: Reactily.bindProperty
sidebar_label: bindProperty
sidebar_position: 3
description: API reference for Reactily.bindProperty.
---

# `Reactily.bindProperty`

Binds a reactive value to a Roblox property with optional two-way synchronization.

## Signature
```typescript
Reactily.bindProperty<T>(source: binding<T>, instance: Instance, propertyName: string, twoWay: boolean?): () -> ()
```
## Usage
```typescript
local cleanup = Reactily.bindProperty(
	positionBinding,
	frame,
	"Position",
	true
)

cleanup()
```
## Works with

Pairs naturally with `createBinding`, `mapBinding`, `combineBindings`, `combineBindingsMany`.
