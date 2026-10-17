---
title: Reactily.bindAttribute
sidebar_label: bindAttribute
sidebar_position: 2
description: API reference for Reactily.bindAttribute.
---

# `Reactily.bindAttribute`

Binds a reactive value to a Roblox Attribute with optional two-way synchronization.

## Signature
```luau
Reactily.bindAttribute<T>(source: Binding<T>, instance: Instance, attributeName: string, twoWay: boolean?): () -> ()
```
## Usage
```luau
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

## Understanding this API

This connects a binding with a Roblox Attribute stored on an Instance. Attributes can be read or observed by other scripts.

### Practical guidance

Use a real Attribute name, not a property name. The optional two-way setting changes whether external attribute updates can flow back into the binding.

## Additional usage notes

### When to use it

Use when an Instance attribute should track a binding value.

### Behavior and ownership

The binding writes the named Roblox attribute as values change.

### Pitfalls to avoid

> **Note:** Attribute values must be valid Roblox attribute types; unsupported values cannot be stored on Instances.
