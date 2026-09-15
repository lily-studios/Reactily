---
title: Reactily.bindAttribute
sidebar_label: bindAttribute
sidebar_position: 2
description: API reference for Reactily.bindAttribute.
---

# `Reactily.bindAttribute`

Binds a reactive value to a Roblox Attribute with optional two-way synchronization.

## Signature
```typescript
Reactily.bindAttribute<T>(source: binding<T>, instance: Instance, attributeName: string, twoWay: boolean?): () -> ()
```
## Usage
```typescript
local cleanup = Reactily.bindAttribute(
	enabledBinding,
	instance,
	"Enabled",
	true
)

cleanup()
```
## Works with

Pairs naturally with `createBinding`, `mapBinding`, `combineBindings`, `combineBindingsMany`.
