# Reactily · [![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/lily-studios/Reactily?tab=MIT-1-ov-file) [![Release](https://img.shields.io/github/v/release/lily-studios/Reactily?style=flat)](https://github.com/lily-studios/Reactily/releases/latest) [![Documentation](https://img.shields.io/badge/docs-documentation-blue.svg)](https://lily-studios.github.io/Reactily/) [![Luau](https://img.shields.io/badge/Luau-2C2D72?logo=lua\&logoColor=white)](https://luau.org/)

Reactily is a React-inspired, Roblox-native UI framework for building user interfaces with Luau.

* **Declarative:** Build interfaces from components and let Reactily handle reconciliation and updates.
* **Component-Based:** Create reusable function components with props, state, hooks, refs, and contexts.
* **Roblox-Native:** Reactily works directly with Roblox `Instance`s and uses Roblox's native property names and types.
* **Typed:** Designed for `--!strict` Luau with typed Roblox host elements and autocomplete.

## Installation

Add the Reactily ModuleScript to ReplicatedStorage in your Roblox project. Reactily should remain in a shared location so
it can be required wherever your interface code needs it.

Require Reactily from ReplicatedStorage, create a Reactily root using a Roblox GUI container such as PlayerGui,
 and render your application through that root.

If you use Rojo, map the Reactily source folder to ReplicatedStorage.Reactily so the library is
automatically synchronized into the correct location when your project is served or built.

## Documentation

Reactily provides React-inspired APIs including components, hooks, state, refs, contexts, fragments, portals, effects, memoization, and reconciliation.

It also includes Roblox-specific functionality for layout, interaction, animation, responsive UI, virtualization, diagnostics, and lifecycle management.

## Typed components

Reactily exports Luau types that work with `--!strict`. The PascalCase aliases
are familiar to TypeScript users, and the original lowercase type names remain
available for existing projects. Prefer the typed host creators such as
`createFrame` and `createTextLabel` when you want Roblox property autocomplete
and checking.

```lua
local Reactily = require(path.Reactily)

type HelloMessageProps = {
	Name: string,
}

local function HelloMessage(props: HelloMessageProps): Reactily.Element
	local labelProps: Reactily.TextLabelProps = {
		Text = `Hello {props.Name}`,
		TextWrapped = true,
	}

	return Reactily.createTextLabel(labelProps)
end

local root = Reactily.createRoot(playerGui)

local greeting: Reactily.Element = Reactily.createElement(HelloMessage, {
	Name = "Lily",
})

root.render(greeting)
```

## Contributing

Contributions, bug fixes, and improvements are welcome.

## License

Reactily is [MIT licensed](./LICENSE).
