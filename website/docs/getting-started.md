---
sidebar_position: 2
title: Getting Started
description: Install Reactily, create a root, render a component, and clean it up.
---

# Getting Started

## Install Reactily

Mount the Reactily package where your client code can require it. The supported package entry point is:
```text
src/init.luau
```
Require the package:
```typescript
local Reactily = require(path.Reactily)
```
## Create a root

A root owns one rendered Reactily tree.
```typescript
local root = Reactily.createRoot(playerGui)
```
## Create a component
```typescript
type counterProps = {
	initialValue: number,
}

local function counter(props: counterProps): Reactily.element
	local count, setCount = Reactily.useState(props.initialValue)

	return Reactily.createTextButton({
		size = UDim2.fromOffset(240, 64),
		text = `Count: {count}`,

		onActivated = function()
			setCount(function(previous: number): number
				return previous + 1
			end)
		end,
	})
end
```
## Render it
```typescript
root.render(
	Reactily.createComponent(counter, {
		initialValue = 0,
	})
)
```
## Update by rendering again
```typescript
root.render(nextElement)
```
Reactily reconciles the next tree with the current tree rather than rebuilding everything blindly.

## Clean up
```typescript
root.delete()
```
`delete()` releases Reactily-owned work and rendered resources owned by the root.

## Next steps

- [Rendering](./concepts/rendering.md)
- [State & Reactivity](./concepts/state.md)
- [Lifecycle](./concepts/lifecycle.md)
- [Performance](./guides/performance.md)
- [API reference](/api)
