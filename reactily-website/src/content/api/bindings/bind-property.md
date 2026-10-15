---
title: Reactily.bindProperty
sidebar_label: bindProperty
sidebar_position: 3
description: API reference for Reactily.bindProperty.
---

# `Reactily.bindProperty`

Binds a reactive value to a Roblox property with optional two-way synchronization.

## Signature
```luau
Reactily.bindProperty<T>(source: Binding<T>, instance: Instance, propertyName: string, twoWay: boolean?): () -> ()
```
## Usage
```luau
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

## Understanding this API

This connects a binding to a named property of an existing Roblox Instance. Changes propagate to that property without constructing a new virtual element.

### Practical guidance

The property name is a Roblox property string, such as `"BackgroundTransparency"`; use official casing and clean up the binding when the target is no longer needed.

## Additional usage notes

### When to use it

Use when an existing Roblox Instance property should follow a binding value.

### Behavior and ownership

The binding manages future property updates after it is attached.

### Pitfalls to avoid

> **Note:** The target must support the named property. Preserve exact native Roblox property casing.
