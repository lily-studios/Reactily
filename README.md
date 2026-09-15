<p align="center">
  <img width="124" height="124" src="./assets/logo.svg" alt="Reactily Logo">
</p>

<h1 align="center">
  <b>Reactily</b>
</h1>

<p align="center">
  A typed, React-inspired interface framework for Roblox Luau.
</p>

<div align="center">

[![Documentation](https://img.shields.io/badge/docs-Reactily-7c5cff)](https://lily-studios.github.io/Reactily/)
[![Latest Release](https://img.shields.io/github/v/release/lily-studios/Reactily)](https://github.com/lily-studios/Reactily/releases/latest)
[![License](https://img.shields.io/github/license/lily-studios/Reactily)](./LICENSE)

</div>

Reactily is a declarative UI framework for building structured, reactive, and reusable Roblox interfaces with Luau.

It provides component-driven rendering while keeping Roblox ownership, lifecycle, and performance behavior explicit.

* **Typed:** Reactily is designed around strict Luau contracts, typed creators, typed state, and editor autocomplete.
* **Component-Based:** Build small reusable components and compose them into larger interfaces.
* **Reactive:** Use hooks, atoms, stores, signals, bindings, and other reactive primitives to update UI when data changes.
* **Roblox-Focused:** Reactily is designed specifically around Roblox Instances, events, Attributes, and UI behavior.
* **Explicit Lifecycle:** Reactily-owned resources use `delete()` and `isDeleted()` so ownership and cleanup remain clear.
* **Idle-Safe:** Runtime systems avoid unnecessary background work when nothing needs updating.

[Read the Reactily documentation](https://lily-studios.github.io/Reactily/).

## Example

```typescript
local replicatedStorage = game:GetService("ReplicatedStorage")

local Reactily = require(replicatedStorage.Reactily)

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local root = Reactily.createRoot(playerGui)

local interface = Reactily.createFrame({
	size = UDim2.fromScale(1, 1),
	backgroundTransparency = 1,
}, {
	Reactily.createTextLabel({
		size = UDim2.fromOffset(300, 60),
		position = UDim2.fromScale(.5, .5),
		anchorPoint = Vector2.new(.5, .5),

		text = "Hello from Reactily!",
		textScaled = true,
		backgroundTransparency = 1,
	}),
})

root.render(interface)
```

This creates a Reactily root and renders a simple text label into the player's interface.

## Core Systems

Reactily includes systems for:

* Virtual elements and rendering
* Function components
* Hooks
* State and stores
* Signals and bindings
* Context
* Themes and styles
* Tweens and springs
* Transitions
* Virtualization
* Object and Instance pools
* Diagnostics and profiling
* Portals
* Lazy components and resources

See the [API documentation](https://lily-studios.github.io/Reactily/docs/api) for the complete public API.

## Lifecycle

Reactily-owned resources use dot-call lifecycle APIs:

```typescript
root.render(interface)
root.delete()
```

Roblox-owned objects keep normal Roblox APIs:

```typescript
connection:Disconnect()
instance:Destroy()
```

## Documentation

* [Introduction](https://lily-studios.github.io/Reactily/docs/intro)
* [Getting Started](https://lily-studios.github.io/Reactily/docs/getting-started)
* [API Reference](https://lily-studios.github.io/Reactily/docs/api)
* [Examples](https://lily-studios.github.io/Reactily/docs/guides/examples)

## Releases

View the latest Reactily release and changelog on GitHub:

[Latest Reactily Release](https://github.com/lily-studios/Reactily/releases/latest)

## License

Reactily is [MIT licensed](./LICENSE).
