# Reactily

> Version `1.1.0`

Reactily is a Lily-owned, React-inspired Roblox Luau interface framework. The public package is `src/init.luau`; implementation is split into focused modules under `src/`.

## Lifecycle naming

All Reactily-owned lifecycle APIs use `delete` / `isDeleted`.

```lua
local root = Reactily.createRoot(playerGui)
root.render(element)
root.delete()
```

Roblox-owned API names are preserved exactly, including `instance:Destroy()`, `tween:Destroy()`, `instance.Destroying`, and `connection:Disconnect()`.

## Typed creators and autocomplete

Prefer class-specific creators because their first argument is a relevant typed props table.

```lua
local button = Reactily.createTextButton({
	text = "Continue",
	textSize = 28,
	size = UDim2.fromOffset(240, 64),
	backgroundColor3 = Color3.fromRGB(35, 35, 40),

	onActivated = function(input: InputObject, clickCount: number)
		print(input, clickCount)
	end,
})
```

Available typed creators include Frame, CanvasGroup, ScrollingFrame, TextLabel, TextButton, TextBox, ImageLabel, ImageButton, VideoFrame, ViewportFrame, ScreenGui, SurfaceGui, BillboardGui, UICorner, UIStroke, UIGradient, UIListLayout, UIGridLayout, UIPadding, UIPageLayout, UIAspectRatioConstraint, UIScale, UISizeConstraint, and UITextSizeConstraint.

## Components and hooks

```lua
local function counter(): Reactily.element
	local count, setCount = Reactily.useState(0)

	return Reactily.createTextButton({
		text = `Count: {count}`,

		onActivated = function()
			setCount(function(previous: number): number
				return previous + 1
			end)
		end,
	})
end

local root = Reactily.createRoot(playerGui)
root.render(Reactily.createComponent(counter, {}))
```

Hooks include the core state/effect hooks plus layout effects, external/store subscriptions, bindings, transitions, deferred values, stable IDs/events, lifecycle helpers, input state, controlled state, springs, and component-owned tweens.

## State systems

Reactily includes standalone atoms, computed atoms, Attribute-backed atoms, history atoms with undo/redo, stores with selectors and nested batching, bindings, and typed signals.

```lua
local position = Reactily.createHistoryAtom(Vector2.zero, 100)
position.set(Vector2.new(100, 50))
position.undo()
position.redo()
position.delete()
```

```lua
type panelState = {
	page: string,
	selectedItem: number?,
}

local store = Reactily.createStore<panelState>({
	page = "Home",
	selectedItem = nil,
})

local page = store.select(function(state: panelState): string
	return state.page
end)
```

## Framework features

Reactily 1.1 includes:

- Context providers, memoized components, error boundaries, Suspense, lazy components, and resources
- global batching, store middleware/transactions, selectors, combined stores, immutable patching, and shallow equality
- component hooks for layout effects, external stores, transitions, deferred values, IDs, stable events, lifecycle ownership, input state, springs, and tweens
- one-way or two-way Roblox property/Attribute bindings and property-change callbacks
- idle-safe springs plus sequential/parallel animation composition
- fixed-list, fixed-grid, and cached variable-size virtualization
- keyboard/controller focus navigation
- component profiling, render reasons, root inspection, strict development warnings, and explicit diagnostics counters
- Attributes and CollectionService tags in host props
- bounded object and Instance pools
- portals into any Roblox Instance
- change-only host property writes and keyed child reconciliation

See [`FEATURES.md`](FEATURES.md) for examples of the complete 1.1 feature surface.

## Portals

```lua
local overlay = Reactily.createPortal(screenGui, {
	Reactily.createFrame({
		size = UDim2.fromScale(1, 1),
		backgroundTransparency = .4,
	}),
})
```

## Root batching and suspension

```lua
root.batch(function()
	root.render(firstElement)
	root.render(finalElement)
end)

root.suspend()
root.render(nextElement)
root.resume()
```

## Testing

Reactily ships with dependency-free Studio smoke tests. Mount `test.project.json`, run the `ReactilyTests` server script, and require zero failures before release.

```bash
rojo serve test.project.json
```

## Runtime behavior

Reactily does not keep a permanent frame callback alive. The scheduler creates one `RunService.Heartbeat` connection only while queued work exists, disconnects it before processing, and returns to an idle state after the queue is empty. Unchanged atom/store/binding state does not emit signals, host properties are only written when changed, and every owned runtime resource has an explicit deletion path.
