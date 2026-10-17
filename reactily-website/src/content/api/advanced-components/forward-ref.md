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

## Understanding this API

Ref forwarding allows a component wrapper to expose a child ref instead of preventing callers from reaching the target.

### Practical guidance

Use this for reusable wrappers around focusable controls or GUI elements when consumers genuinely need access to the inner host Instance.

## Additional usage notes

### When to use it

Use a forwarded ref when a reusable component must expose a host instance or imperative handle to its caller.

### Behavior and ownership

The ref is forwarded through the wrapper instead of being treated as an ordinary prop.

### Pitfalls to avoid

> **Note:** Keep ref ownership explicit and expect a cleared ref after the component unmounts.
