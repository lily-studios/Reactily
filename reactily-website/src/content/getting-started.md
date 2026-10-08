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
For this example, expose the package ModuleScript as `ReplicatedStorage.Reactily` and run the code from a `LocalScript`:
```luau
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Reactily = require(ReplicatedStorage:WaitForChild("Reactily"))
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
```
## Create a root

A root owns one rendered Reactily tree.
```luau
local Root = Reactily.createRoot(playerGui)
```
## Create a component
```luau
type CounterProps = {
	InitialValue: number,
}

local function Counter(props: CounterProps): Reactily.Element
	local count, setCount = Reactily.useState(props.InitialValue)

	return Reactily.createTextButton({
		Size = UDim2.fromOffset(240, 64),
		Text = `Count: {count}`,

		OnActivated = function()
			setCount(function(previous: number): number
				return previous + 1
			end)
		end,
	})
end
```
## Render it
```luau
Root.render(
	Reactily.createComponent(Counter, {
		InitialValue = 0,
	})
)
```
## Update by rendering again
```luau
Root.render(nextElement)
```
Reactily reconciles the next tree with the current tree rather than rebuilding everything blindly.

## Clean up
```luau
Root.Delete()
```
`Delete()` releases Reactily-owned work and rendered resources owned by the root.

## Next steps

- [Rendering](./concepts/rendering.md)
- [State & Reactivity](./concepts/state.md)
- [Lifecycle](./concepts/lifecycle.md)
- [Performance](./guides/performance.md)
- [API reference](/api)
