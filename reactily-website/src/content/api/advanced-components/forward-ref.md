---
title: Reactily.forwardRef
sidebar_label: forwardRef
sidebar_position: 6
description: API reference for Reactily.forwardRef.
---

# `Reactily.forwardRef`

Creates a component wrapper that forwards props.ref to the render callback.

## Signature
```luau
Reactily.forwardRef(render: (props: any, Ref: RefTarget<any>?) -> any): any
```
## Usage
```luau
local input = Reactily.forwardRef(function(props, Ref)
	return Reactily.createTextBox({
		Ref = Ref,
		Text = props.text,
	})
end)
```
## Works with

Pairs naturally with `useImperativeHandle`, `useRef`, typed host refs.
