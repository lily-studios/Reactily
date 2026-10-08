---
title: Reactily.useImperativeHandle
sidebar_label: useImperativeHandle
sidebar_position: 17
description: API reference for Reactily.useImperativeHandle.
---

# `Reactily.useImperativeHandle`

Creates or updates an imperative handle exposed through a Reactily ref.

## Signature
```luau
Reactily.useImperativeHandle<T>(target: RefTarget<T>?, factory: () -> T, dependencies: {any}?): ()
```
## Usage
```luau
Reactily.useImperativeHandle(
	Ref,
	function()
		return {
			focus = function()
				textBox:CaptureFocus()
			end,
		}
	end,
	{}
)
```
## Works with

Pairs naturally with `forwardRef`, `useRef`, typed refs.
