---
title: Reactily.combineBindingsMany
sidebar_label: combineBindingsMany
sidebar_position: 6
description: API reference for Reactily.combineBindingsMany.
---

# `Reactily.combineBindingsMany`

Combines any number of bindings using an ordered value array.

## Signature
```luau
Reactily.combineBindingsMany<R>(sources: {Binding<any>}, mapper: (values: {any}) -> R): Binding<R>
```
## Usage
```luau
local combined = Reactily.combineBindingsMany(
	{firstBinding, secondBinding},
	function(values)
		return {
			first = values[1],
			second = values[2],
		}
	end
)
```
## Works with

Pairs naturally with `createBinding`, `mapBinding`, `bindProperty`, `bindAttribute`.
