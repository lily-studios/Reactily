---
title: Reactily.forwardRef
sidebar_label: forwardRef
sidebar_position: 6
description: API reference for Reactily.forwardRef.
---

# `Reactily.forwardRef`

Creates a component wrapper that forwards props.ref to the render callback.

## Signature
```typescript
Reactily.forwardRef(render: (props: any, ref: refTarget<any>?) -> any): any
```
## Usage
```typescript
local input = Reactily.forwardRef(function(props, ref)
	return Reactily.createTextBox({
		ref = ref,
		text = props.text,
	})
end)
```
## Works with

Pairs naturally with `useImperativeHandle`, `useRef`, typed host refs.
