# Reactily Documentation & API Reference

> **Version:** `1.0.0`  
> **Language:** Roblox Luau  
> **Type mode:** `--!strict`  
> **Lifecycle convention:** Reactily-owned resources use `.delete()` / `.isDeleted()`  
> **Package entry point:** `src/init.luau`

Reactily is a Lily-owned, React-inspired interface framework for Roblox Luau. It combines typed Roblox UI creators, virtual elements, function components, hooks, keyed reconciliation, portals, standalone state, stores, signals, bindings, themes, styles, focus management, virtualized lists, TweenService helpers, bounded object pools, diagnostics, and an idle-safe scheduler.

This document describes the supported public API exported from `src/init.luau`, then documents the advanced modules used to implement the framework.

---

## Table of Contents

- [Overview](#overview)
- [Installation and Source Layout](#installation-and-source-layout)
- [Quick Start](#quick-start)
- [Core Conventions](#core-conventions)
- [Elements and Typed Creators](#elements-and-typed-creators)
- [Components](#components)
- [Roots and Rendering](#roots-and-rendering)
- [Fragments, Keys, and Portals](#fragments-keys-and-portals)
- [Refs, Attributes, Tags, and Events](#refs-attributes-tags-and-events)
- [Hooks](#hooks)
- [Atoms and Computed State](#atoms-and-computed-state)
- [History State](#history-state)
- [Stores and Selectors](#stores-and-selectors)
- [Bindings](#bindings)
- [Signals](#signals)
- [Themes and Styles](#themes-and-styles)
- [Animation](#animation)
- [Focus Groups](#focus-groups)
- [Virtual Lists](#virtual-lists)
- [Object Pools](#object-pools)
- [Scheduler](#scheduler)
- [Diagnostics](#diagnostics)
- [Lifecycle Ownership](#lifecycle-ownership)
- [Performance Model](#performance-model)
- [Public API Reference](#public-api-reference)
- [Returned Object APIs](#returned-object-apis)
- [Typed Creator Reference](#typed-creator-reference)
- [Typed Prop Reference](#typed-prop-reference)
- [Advanced Module Reference](#advanced-module-reference)
- [Complete Examples](#complete-examples)

---

## Overview

Reactily's public surface is dot-based:

```lua
local Reactily = require(path.Reactily)

local root = Reactily.createRoot(playerGui)
root.render(element)
root.delete()
```

Reactily-owned APIs do **not** use colon calls:

```lua
-- Correct
root.render(element)
store.set(nextState)
signal.fire(value)
animation.delete()

-- Incorrect for Reactily-owned APIs
root:render(element)
store:set(nextState)
signal:fire(value)
```

Roblox-owned APIs retain Roblox's required method syntax:

```lua
instance:Destroy()
connection:Disconnect()
instance:SetAttribute("enabled", true)
signal:Connect(callback)
```

---

## Installation and Source Layout

Reactily's source tree is:

```text
Reactily/
├── DOCUMENTATION.md
├── README.md
├── PRODUCTION_AUDIT.md
├── manifest.json
└── src/
    ├── init.luau
    ├── core/
    │   ├── lifecycle.luau
    │   ├── objectPool.luau
    │   ├── scheduler.luau
    │   └── signal.luau
    ├── diagnostics/
    │   └── diagnostics.luau
    ├── interface/
    │   ├── focus.luau
    │   ├── style.luau
    │   ├── theme.luau
    │   └── virtualList.luau
    ├── runtime/
    │   ├── animation.luau
    │   ├── binding.luau
    │   ├── hostConfig.luau
    │   ├── renderer.luau
    │   └── root.luau
    ├── state/
    │   ├── atom.luau
    │   ├── hooks.luau
    │   └── store.luau
    └── virtual/
        ├── element.luau
        └── reconciler.luau
```

Mount the package into Roblox with `src/init.luau` as the package entry point, then require the mounted package:

```lua
local Reactily = require(path.To.Reactily)
```

Check the runtime version:

```lua
print(Reactily.getVersion()) -- "1.0.0"
```

---

## Quick Start

```lua
local Reactily = require(path.Reactily)

local function counter(): Reactily.element
	local count, setCount = Reactily.useState(0)

	return Reactily.createTextButton({
		size = UDim2.fromOffset(240, 64),
		text = `Count: {count}`,
		textSize = 28,

		onActivated = function()
			setCount(function(previous: number): number
				return previous + 1
			end)
		end,
	})
end

local root = Reactily.createRoot(playerGui)

root.render(
	Reactily.createComponent(counter, {})
)
```

Delete the root when the interface is permanently removed:

```lua
root.delete()
```

---

## Core Conventions

### Dot-only Reactily APIs

Reactily objects are closure-backed records. Call their functions with `.`:

```lua
atom.set(1)
binding.delete()
root.suspend()
selector.get()
```

### `delete()` means Reactily lifecycle cleanup

Reactily uses `delete()` for framework-owned resource cleanup:

```lua
root.delete()
signal.delete()
store.delete()
theme.delete()
animation.delete()
```

Deletion functions generally return `true` when they perform deletion and `false` if the object was already deleted.

### Change-only updates

Atoms, stores, bindings, themes, hook state, reducer state, selectors, and host updates skip downstream work when the relevant value is unchanged.

```lua
local value = Reactily.createAtom(10)

print(value.set(10)) -- false
print(value.set(20)) -- true
```

> **Table state:** Luau table equality is reference equality. For state tables, represent a changed state with a new table instead of mutating the existing table and setting the same reference.

### Strict types and autocomplete

Typed creators use class-relevant props:

```lua
Reactily.createFrame({
	size = UDim2.fromScale(1, 1),
	backgroundTransparency = .2,
})
```

`createFrame()` receives `frameProps?`. `createTextButton()` receives `textButtonProps?`. This provides class-specific editor completion.

---

## Elements and Typed Creators

A Reactily element is virtual data. Creating an element does not immediately create a Roblox Instance. The root's renderer creates and updates Instances during reconciliation.

```lua
local element = Reactily.createFrame({
	name = "Panel",
	size = UDim2.fromOffset(400, 300),
	backgroundColor3 = Color3.fromRGB(28, 28, 32),
}, {
	Reactily.createTextLabel({
		size = UDim2.fromScale(1, 0),
		automaticSize = Enum.AutomaticSize.Y,
		text = "Reactily",
		textSize = 30,
	}),
})
```

Prefer a typed creator when Reactily exposes one:

```lua
-- Preferred
Reactily.createFrame({
	size = UDim2.fromOffset(200, 100),
})

-- Generic escape hatch
Reactily.createElement("Frame", {
	size = UDim2.fromOffset(200, 100),
})
```

`createElement()` accepts generic props and therefore does not provide the same class-specific autocomplete.

---

## Components

Define props with ordinary Luau types:

```lua
type panelProps = {
	title: string,
	visible: boolean,
}

local function panel(props: panelProps): Reactily.element
	return Reactily.createFrame({
		visible = props.visible,
	}, {
		Reactily.createTextLabel({
			text = props.title,
		}),
	})
end
```

Create the component element:

```lua
local element = Reactily.createComponent<panelProps>(
	panel,
	{
		title = "Effects",
		visible = true,
	}
)
```

Full signature:

```lua
Reactily.createComponent<P>(
	componentValue: Reactily.component<P>,
	props: P,
	children: {Reactily.element}?,
	key: string?
): Reactily.element
```

### Hook rules

Hooks must run only during component render and must retain the same order and completed-render count. Reactily checks hook kind, hook order, and completed-render hook count.

---

## Roots and Rendering

Create a root:

```lua
local root = Reactily.createRoot(playerGui)
```

Render:

```lua
root.render(element)
```

Unmount while keeping the root:

```lua
root.render(nil)
```

Delete the entire root runtime:

```lua
root.delete()
```

### Batching

```lua
root.batch(function()
	root.render(firstTree)
	root.render(finalTree)
end)
```

Nested batches are supported. The render occurs after the outermost batch completes.

### Suspension

```lua
root.suspend()
root.render(nextTree)
```

The new tree remains pending while suspended.

```lua
root.resume()
```

`resume()` renders pending work if needed.

### Manual flush

```lua
root.flush()
```

Flushes queued scheduler work owned by the root.

---

## Fragments, Keys, and Portals

### Fragments

```lua
local items = Reactily.createFragment({
	Reactily.createTextLabel({ text = "A" }),
	Reactily.createTextLabel({ text = "B" }),
})
```

Optional key:

```lua
Reactily.createFragment(children, "section")
```

### Keys

Host props expose `key`:

```lua
Reactily.createTextButton({
	key = `fixture-{fixtureId}`,
	text = tostring(fixtureId),
})
```

Use stable identity-based keys when children can move, be inserted, or be removed.

### Portals

```lua
local modal = Reactily.createPortal(overlayGui, {
	Reactily.createFrame({
		size = UDim2.fromScale(1, 1),
		backgroundTransparency = .35,
	}),
}, "modal")
```

Signature:

```lua
Reactily.createPortal(
	target: Instance,
	children: {Reactily.element},
	key: string?
): Reactily.element
```

---

## Refs, Attributes, Tags, and Events

### Refs

```lua
local buttonInstance: TextButton? = nil

Reactily.createTextButton({
	ref = function(instance: TextButton?)
		buttonInstance = instance
	end,
})
```

The ref receives the mounted host and later receives `nil` when the ref changes or the host is removed.

### Attributes

```lua
Reactily.createFrame({
	attributes = {
		panelType = "effects",
		fixtureId = 12,
		enabled = true,
	},
})
```

Supported values are documented under [`attributeValue`](#attributevalue).

### CollectionService tags

```lua
Reactily.createFrame({
	tags = {
		"[Lily] Interface",
		"[Lily] Panel",
	},
})
```

Reactily diffs the tags it manages for the host while preserving unrelated external tags.

### Events

```lua
Reactily.createTextButton({
	onActivated = function(input: InputObject, clickCount: number)
		print(input, clickCount)
	end,

	onMouseEnter = function()
		print("hover")
	end,
})
```

Changing an event callback disconnects the previous Reactily-owned event connection.

---

## Hooks

### `useState`

```lua
local value, setValue = Reactily.useState(initialValue)
```

```lua
Reactily.useState<T>(
	initialValue: T
): (
	T,
	(value: T | ((previous: T) -> T)) -> ()
)
```

The setter is stable across renders.

### `useReducer`

```lua
type state = {
	count: number,
}

type action =
	{type: "increment"}
	| {type: "reset"}

local current, dispatch = Reactily.useReducer<state, action>(
	function(previous: state, actionValue: action): state
		if actionValue.type == "increment" then
			return {
				count = previous.count + 1,
			}
		end

		return {
			count = 0,
		}
	end,
	{
		count = 0,
	}
)
```

### `useRef`

```lua
local dragging = Reactily.useRef(false)
dragging.current = true
```

Changing `.current` does not request a render.

### `useMemo`

```lua
local visibleFixtures = Reactily.useMemo(function()
	return calculateVisibleFixtures(fixtures, selection)
end, {fixtures, selection})
```

If dependencies are omitted, Reactily treats them as changed each render.

### `useCallback`

```lua
local onActivated = Reactily.useCallback(function()
	print(selection)
end, {selection})
```

### `useEffect`

```lua
Reactily.useEffect(function()
	local connection = instance.Changed:Connect(function()
		print("changed")
	end)

	return function()
		connection:Disconnect()
	end
end, {instance})
```

Effect cleanup runs before a changed effect and when the component context is deleted. If dependencies are omitted, the effect is treated as changed each render.

### `usePrevious`

```lua
local previous = Reactily.usePrevious(currentValue)
```

Returns `nil` on the first render.

### `useBoolean`

```lua
local enabled, enable, disable, toggle = Reactily.useBoolean(false)

enable()
disable()
toggle()
```

Return order:

```text
value, enable, disable, toggle
```

### `useToggle`

```lua
local open, toggle, setOpen = Reactily.useToggle(false)

toggle()
setOpen(true)
```

### `useCounter`

```lua
local count, controls = Reactily.useCounter(0)

controls.increment()
controls.increment(5)
controls.decrement()
controls.set(100)
controls.reset()
```

### `useDebouncedValue`

```lua
local query, setQuery = Reactily.useState("")
local debouncedQuery = Reactily.useDebouncedValue(query, .2)
```

The delayed task is cancelled when dependencies change or the owning effect is deleted.

### `useAttribute`

```lua
local enabled, setEnabled = Reactily.useAttribute(
	fixture,
	"enabled",
	true
)

setEnabled(false)
```

Synchronizes hook state with the Roblox Attribute.

---

## Atoms and Computed State

```lua
local bpm = Reactily.createAtom(.7)
```

Read:

```lua
local current = bpm.get()
```

Set:

```lua
local didChange = bpm.set(.8)
```

Update:

```lua
bpm.update(function(previous: number): number
	return previous + .1
end)
```

Subscribe:

```lua
local connection = bpm.subscribe(function(change)
	print(change.previous, change.current)
end)
```

Delete:

```lua
bpm.delete()
```

### Computed atoms

```lua
local percentage = Reactily.createComputed(
	intensity,
	function(value: number): string
		return `{math.round(value * 100)}%`
	end
)
```

The computed value owns its source subscription. `percentage.delete()` disconnects it.

### Attribute-backed atoms

```lua
local enabled = Reactily.createAttributeAtom(
	fixture,
	"enabled",
	true
)
```

State and Attribute changes synchronize both ways. Delete the atom when that synchronization scope ends.

---

## History State

```lua
local position = Reactily.createHistoryAtom(Vector2.zero, 100)
```

```lua
position.set(Vector2.new(100, 50))
position.undo()
position.redo()
```

Inspect history:

```lua
print(position.canUndo())
print(position.canRedo())
print(position.getPastCount())
print(position.getFutureCount())
```

Clear history without changing the current value:

```lua
position.clearHistory()
```

The `limit` applies to retained past entries.

---

## Stores and Selectors

```lua
type panelState = {
	page: string,
	selectedFixture: number?,
	bpm: number,
}

local store = Reactily.createStore<panelState>({
	page = "Home",
	selectedFixture = nil,
	bpm = .7,
})
```

Update:

```lua
store.update(function(previous: panelState): panelState
	return {
		page = "Effects",
		selectedFixture = previous.selectedFixture,
		bpm = previous.bpm,
	}
end)
```

### Selectors

```lua
local page = store.select(function(state: panelState): string
	return state.page
end)
```

```lua
page.subscribe(function(change)
	print(change.previous, change.current)
end)
```

Selectors emit only when the selected result changes.

Delete a selector manually:

```lua
page.delete()
```

Deleting the store also deletes its active selectors.

### Batching

```lua
store.batch(function()
	store.update(firstUpdate)
	store.update(secondUpdate)
end)
```

Nested batches are supported.

---

## Bindings

```lua
local intensity = Reactily.createBinding(.5)
```

Map:

```lua
local percent = Reactily.mapBinding(
	intensity,
	function(value: number): number
		return value * 100
	end
)
```

Combine:

```lua
local pan = Reactily.createBinding(0)
local tilt = Reactily.createBinding(0)

local position = Reactily.combineBindings(
	pan,
	tilt,
	function(panValue: number, tiltValue: number): Vector2
		return Vector2.new(panValue, tiltValue)
	end
)
```

Clamp:

```lua
local normalized = Reactily.clampBinding(intensity, 0, 1)
```

Round:

```lua
local rounded = Reactily.roundBinding(intensity, 2)
```

Format:

```lua
local label = Reactily.formatBinding(
	intensity,
	function(value: number): string
		return `{math.round(value * 100)}%`
	end
)
```

Derived bindings own their upstream subscriptions and disconnect them on `.delete()`.

---

## Signals

```lua
local selected = Reactily.createSignal<number>()
```

Connect:

```lua
local connection = selected.connect(function(fixtureId: number)
	print(fixtureId)
end)
```

Fire:

```lua
selected.fire(5)
```

Once:

```lua
selected.once(function(fixtureId: number)
	print("first:", fixtureId)
end)
```

Disconnect:

```lua
connection.disconnect()
```

Delete:

```lua
selected.delete()
```

### Operators

```lua
local mapped = Reactily.mapSignal(source, mapper)
local filtered = Reactily.filterSignal(source, predicate)
local distinct = Reactily.distinctSignal(source)
local merged = Reactily.mergeSignals({first, second})
local skipped = Reactily.skipSignal(source, 2)
local firstFive = Reactily.takeSignal(source, 5)
```

Derived signals own and release their upstream connections.

---

## Themes and Styles

### Themes

```lua
type themeTokens = {
	accent: Color3,
	background: Color3,
	text: Color3,
}

local theme = Reactily.createTheme<themeTokens>({
	accent = Color3.fromRGB(80, 120, 255),
	background = Color3.fromRGB(24, 24, 28),
	text = Color3.new(1, 1, 1),
})
```

```lua
theme.update(function(previous: themeTokens): themeTokens
	return {
		accent = Color3.fromRGB(255, 100, 120),
		background = previous.background,
		text = previous.text,
	}
end)
```

Resolve immediately:

```lua
local accent = Reactily.resolveTheme(
	theme,
	function(tokens: themeTokens): Color3
		return tokens.accent
	end
)
```

### Styles

```lua
local baseStyle: Reactily.style = {
	backgroundColor3 = Color3.fromRGB(30, 30, 35),
	borderSizePixel = 0,
}

local selectedStyle: Reactily.style = {
	backgroundColor3 = Color3.fromRGB(60, 90, 180),
}
```

Merge:

```lua
local styleValue = Reactily.createStyle({
	baseStyle,
	selectedStyle,
})
```

Apply:

```lua
local props = Reactily.applyStyle({
	size = UDim2.fromOffset(200, 80),
}, styleValue)

local button = Reactily.createTextButton(props)
```

---

## Animation

Create without playing:

```lua
local animation = Reactily.createTween(
	frame,
	{
		BackgroundTransparency = 0,
		Position = UDim2.fromScale(.5, .5),
	},
	{
		time = .2,
		easingStyle = Enum.EasingStyle.Quad,
		easingDirection = Enum.EasingDirection.Out,
	}
)
```

```lua
animation.play()
```

Create and play:

```lua
local animation = Reactily.playTween(frame, goals, {
	time = .2,
})
```

Completion:

```lua
animation.onCompleted(function(playbackState)
	print(playbackState)
end)
```

Delete:

```lua
animation.delete()
```

Deletion disconnects Reactily-owned completion listeners, cancels the Tween, and destroys the Roblox Tween internally.

---

## Focus Groups

```lua
local focusGroup = Reactily.createFocusGroup()

focusGroup.add(playButton)
focusGroup.add(settingsButton)

focusGroup.focusFirst()
focusGroup.focusLast()
```

```lua
focusGroup.remove(settingsButton)
focusGroup.clear()
focusGroup.delete()
```

Clear the current Roblox GUI selection:

```lua
Reactily.clearFocus()
```

A focus target must have a parent, be visible, and be selectable.

---

## Virtual Lists

```lua
local range = Reactily.resolveVirtualList(
	5000,
	44,
	scrollingFrame.CanvasPosition.Y,
	scrollingFrame.AbsoluteWindowSize.Y,
	3
)
```

Returned values:

```lua
print(range.first)
print(range.last)
print(range.offset)
print(range.totalSize)
```

Slice an array:

```lua
local visibleFixtures = Reactily.sliceVirtualList(fixtures, range)
```

When `itemCount == 0`, `first` and `last` are both `0`.

---

## Object Pools

### Instance pool

```lua
local pool = Reactily.createInstancePool("Frame", 64)

local frame = pool.acquire()
frame.Parent = playerGui

pool.release(frame)
```

When the retained pool is full, released Instances are destroyed instead of retained.

### Generic pool

```lua
type temporaryData = {
	value: number,
}

local pool = Reactily.createObjectPool<temporaryData>(
	function(): temporaryData
		return {
			value = 0,
		}
	end,
	function(object: temporaryData)
		object.value = 0
	end,
	function(_object: temporaryData)
		-- custom final deletion
	end,
	128
)
```

```lua
print(pool.getAvailableCount())
print(pool.getCreatedCount())
pool.delete()
```

---

## Scheduler

Reactily's scheduler uses a temporary `RunService.Heartbeat` connection only while queued work exists.

```lua
local scheduler = Reactily.createScheduler()
```

Queue:

```lua
local taskId = scheduler.enqueue(function()
	print("scheduled")
end)
```

Keyed queue:

```lua
scheduler.enqueueKeyed("layout", function()
	rebuildLayout()
end)
```

A second pending task with the same key updates the existing pending callback rather than stacking another keyed task.

Cancel:

```lua
scheduler.cancel(taskId)
scheduler.cancelKey("layout")
```

Flush:

```lua
scheduler.flush()
```

Clear:

```lua
scheduler.clear()
```

Delete:

```lua
scheduler.delete()
```

---

## Diagnostics

Diagnostics are explicit counters and do not poll.

```lua
local diagnostics = Reactily.createDiagnostics()

diagnostics.increment("renders")
diagnostics.increment("hostCreates", 5)

print(diagnostics.get("renders"))
print(diagnostics.snapshot())
```

```lua
diagnostics.reset("renders")
diagnostics.resetAll()
diagnostics.delete()
```

---

## Lifecycle Ownership

```lua
local owner = Reactily.createLifecycleOwner()
```

Public type:

```lua
type lifecycleOwner = {
	cleanups: {() -> ()},
	connections: {RBXScriptConnection},
	instances: {Instance},
	isDeleted: boolean,
}
```

Most application code should prefer higher-level Reactily objects that already own their resources.

### Deletion guide

| Object | Delete when |
| --- | --- |
| `root` | The rendered interface/root is permanently removed |
| `atom` | Standalone state is no longer used |
| `computed` | The derived state is no longer needed |
| `historyAtom` | The history state owner ends |
| `store` | The store/application scope ends |
| `selector` | The selector is no longer needed before its store ends |
| `binding` | The binding/derived binding scope ends |
| `signal` | The signal owner ends |
| `scheduler` | The scheduler owner ends |
| `objectPool` | The pool owner ends |
| `theme` | The theme owner ends |
| `focusGroup` | The focus scope ends |
| `animation` | The animation owner is no longer needed |
| `diagnostics` | The diagnostics scope ends |

---

## Performance Model

Reactily is event-driven and change-oriented.

### Scheduler dormancy

The scheduler:

1. Connects Heartbeat only when queued work exists.
2. Disconnects before flushing.
3. Reconnects only if callbacks queue more work.
4. Stops immediately when cancellation empties the queue.
5. Does not keep a permanent per-frame callback alive.

### Change-only state

Atoms, stores, bindings, themes, hook state, reducers, selectors, and host property updates avoid downstream work when values are unchanged.

### Derived ownership

Mapped/filtered/distinct/merged/take/skip signals and mapped/combined bindings disconnect upstream subscriptions on `.delete()`.

### Keyed reconciliation

Stable keys preserve child identity when list ordering changes.

```lua
for _, fixture in fixtures do
	children[#children + 1] = Reactily.createTextButton({
		key = tostring(fixture.id),
		text = fixture.name,
	})
end
```

### Virtualization

For large fixed-height lists, render only `range.first` through `range.last`.

---

# Public API Reference

All signatures below are exported from `src/init.luau`.

## Package

### `Reactily.getVersion`

```lua
Reactily.getVersion(): string
```

Returns `"1.0.0"`.

### `Reactily.new`

```lua
Reactily.new(parent: Instance): Reactily.root
```

Alias of `createRoot`.

### `Reactily.createRoot`

```lua
Reactily.createRoot(parent: Instance): Reactily.root
```

---

## Virtual Tree

### `Reactily.createElement`

```lua
Reactily.createElement(
	className: string,
	props: {[string]: any}?,
	children: {Reactily.element}?
): Reactily.element
```

### `Reactily.createComponent`

```lua
Reactily.createComponent<P>(
	componentValue: Reactily.component<P>,
	props: P,
	children: {Reactily.element}?,
	key: string?
): Reactily.element
```

### `Reactily.createFragment`

```lua
Reactily.createFragment(
	children: {Reactily.element},
	key: string?
): Reactily.element
```

### `Reactily.createPortal`

```lua
Reactily.createPortal(
	target: Instance,
	children: {Reactily.element},
	key: string?
): Reactily.element
```

---

## State Constructors

```lua
Reactily.createAtom<T>(initialValue: T): Reactily.atom<T>
```

```lua
Reactily.createComputed<A, B>(
	source: Reactily.atom<A>,
	selectorFunction: (value: A) -> B
): Reactily.computed<B>
```

```lua
Reactily.createHistoryAtom<T>(
	initialValue: T,
	limit: number
): Reactily.historyAtom<T>
```

```lua
Reactily.createAttributeAtom<T>(
	instance: Instance,
	attributeName: string,
	defaultValue: T
): Reactily.atom<T>
```

```lua
Reactily.createStore<T>(
	initialState: T
): Reactily.store<T>
```

---

## Binding API

```lua
Reactily.createBinding<T>(initialValue: T): Reactily.binding<T>
```

```lua
Reactily.mapBinding<A, B>(
	source: Reactily.binding<A>,
	mapper: (value: A) -> B
): Reactily.binding<B>
```

```lua
Reactily.combineBindings<A, B, R>(
	first: Reactily.binding<A>,
	second: Reactily.binding<B>,
	mapper: (firstValue: A, secondValue: B) -> R
): Reactily.binding<R>
```

```lua
Reactily.clampBinding(
	source: Reactily.binding<number>,
	minimum: number,
	maximum: number
): Reactily.binding<number>
```

```lua
Reactily.roundBinding(
	source: Reactily.binding<number>,
	precision: number
): Reactily.binding<number>
```

```lua
Reactily.formatBinding<T>(
	source: Reactily.binding<T>,
	formatter: (value: T) -> string
): Reactily.binding<string>
```

---

## Signal API

```lua
Reactily.createSignal<T>(): Reactily.signal<T>
```

```lua
Reactily.mapSignal<A, B>(
	source: Reactily.signal<A>,
	mapper: (value: A) -> B
): Reactily.signal<B>
```

```lua
Reactily.filterSignal<T>(
	source: Reactily.signal<T>,
	predicate: (value: T) -> boolean
): Reactily.signal<T>
```

```lua
Reactily.distinctSignal<T>(
	source: Reactily.signal<T>
): Reactily.signal<T>
```

```lua
Reactily.mergeSignals<T>(
	sources: {Reactily.signal<T>}
): Reactily.signal<T>
```

```lua
Reactily.skipSignal<T>(
	source: Reactily.signal<T>,
	amount: number
): Reactily.signal<T>
```

```lua
Reactily.takeSignal<T>(
	source: Reactily.signal<T>,
	maximum: number
): Reactily.signal<T>
```

---

## Hooks API

```lua
Reactily.useState<T>(
	initialValue: T
): (T, Reactily.stateSetter<T>)
```

```lua
Reactily.useReducer<S, A>(
	reducer: (stateValue: S, action: A) -> S,
	initialState: S
): (S, Reactily.reducerDispatch<A>)
```

```lua
Reactily.useRef<T>(
	initialValue: T
): Reactily.ref<T>
```

```lua
Reactily.useMemo<T>(
	factory: () -> T,
	dependencies: {any}?
): T
```

```lua
Reactily.useCallback<T>(
	callback: T,
	dependencies: {any}?
): T
```

```lua
Reactily.useEffect(
	callback: () -> (() -> ())?,
	dependencies: {any}?
)
```

```lua
Reactily.usePrevious<T>(
	value: T
): T?
```

```lua
Reactily.useToggle(
	initialValue: boolean?
): (
	boolean,
	() -> (),
	(value: boolean) -> ()
)
```

```lua
Reactily.useBoolean(
	initialValue: boolean?
): (
	boolean,
	() -> (),
	() -> (),
	() -> ()
)
```

```lua
Reactily.useCounter(
	initialValue: number?
): (
	number,
	Reactily.counterControls
)
```

```lua
Reactily.useDebouncedValue<T>(
	value: T,
	delaySeconds: number
): T
```

```lua
Reactily.useAttribute<T>(
	instance: Instance,
	attributeName: string,
	defaultValue: T
): (
	T,
	(value: T) -> ()
)
```

---

## Style and Theme API

```lua
Reactily.createStyle(styles: {Reactily.style}): Reactily.style
```

```lua
Reactily.applyStyle<T>(
	properties: T,
	styleValue: Reactily.style
): T
```

```lua
Reactily.createTheme<T>(
	initialValue: T
): Reactily.theme<T>
```

```lua
Reactily.resolveTheme<T, R>(
	themeValue: Reactily.theme<T>,
	selectorFunction: (tokens: T) -> R
): R
```

---

## Animation API

```lua
Reactily.createTween(
	instance: Instance,
	goals: {[string]: any},
	options: Reactily.tweenOptions
): Reactily.animation
```

```lua
Reactily.playTween(
	instance: Instance,
	goals: {[string]: any},
	options: Reactily.tweenOptions
): Reactily.animation
```

---

## Focus API

```lua
Reactily.createFocusGroup(): Reactily.focusGroup
```

```lua
Reactily.clearFocus()
```

---

## Virtual List API

```lua
Reactily.resolveVirtualList(
	itemCount: number,
	itemSize: number,
	scrollOffset: number,
	viewportSize: number,
	overscan: number?
): Reactily.virtualRange
```

```lua
Reactily.sliceVirtualList<T>(
	items: {T},
	rangeValue: Reactily.virtualRange
): {T}
```

---

## Pool API

```lua
Reactily.createObjectPool<T>(
	createObject: () -> T,
	resetObject: (object: T) -> (),
	deleteObject: (object: T) -> (),
	maximumSize: number
): Reactily.objectPool<T>
```

```lua
Reactily.createInstancePool(
	className: string,
	maximumSize: number
): Reactily.objectPool<Instance>
```

---

## Scheduler, Diagnostics, and Lifecycle

```lua
Reactily.createScheduler(): Reactily.scheduler
```

```lua
Reactily.createDiagnostics(): Reactily.diagnostics
```

```lua
Reactily.createLifecycleOwner(): Reactily.lifecycleOwner
```

---

# Returned Object APIs

## `root`

```lua
type root = {
	batch: (callback: () -> ()) -> (),
	delete: () -> boolean,
	flush: () -> (),
	getElement: () -> Reactily.element?,
	getParent: () -> Instance,
	isDeleted: () -> boolean,
	isSuspended: () -> boolean,
	render: (elementValue: Reactily.element?) -> (),
	resume: () -> boolean,
	suspend: () -> boolean,
}
```

## `atom<T>`

```lua
type atom<T> = {
	delete: () -> boolean,
	get: () -> T,
	isDeleted: () -> boolean,
	set: (value: T) -> boolean,
	subscribe: (callback: (change: Reactily.atomChange<T>) -> ()) -> Reactily.connection,
	update: (updater: (previous: T) -> T) -> boolean,
}
```

## `computed<T>`

```lua
type computed<T> = {
	delete: () -> boolean,
	get: () -> T,
	isDeleted: () -> boolean,
	subscribe: (callback: (change: Reactily.atomChange<T>) -> ()) -> Reactily.connection,
}
```

## `historyAtom<T>`

```lua
type historyAtom<T> = Reactily.atom<T> & {
	canRedo: () -> boolean,
	canUndo: () -> boolean,
	clearHistory: () -> (),
	getFutureCount: () -> number,
	getPastCount: () -> number,
	redo: () -> boolean,
	undo: () -> boolean,
}
```

## `store<T>`

```lua
type store<T> = {
	batch: (callback: () -> ()) -> (),
	delete: () -> boolean,
	get: () -> T,
	isDeleted: () -> boolean,
	reset: () -> boolean,
	select: <R>((state: T) -> R) -> Reactily.selector<R>,
	set: (state: T) -> boolean,
	subscribe: (callback: (change: {
		current: T,
		previous: T,
	}) -> ()) -> Reactily.connection,
	update: (updater: (state: T) -> T) -> boolean,
}
```

## `selector<T>`

```lua
type selector<T> = {
	delete: () -> boolean,
	get: () -> T,
	isDeleted: () -> boolean,
	subscribe: (callback: (change: {
		current: T,
		previous: T,
	}) -> ()) -> Reactily.connection,
}
```

## `binding<T>`

```lua
type binding<T> = {
	delete: () -> boolean,
	get: () -> T,
	isDeleted: () -> boolean,
	set: (value: T) -> boolean,
	subscribe: (callback: (change: Reactily.bindingChange<T>) -> ()) -> Reactily.connection,
}
```

## `signal<T>`

```lua
type signal<T> = {
	connect: (callback: (value: T) -> ()) -> Reactily.connection,
	delete: () -> boolean,
	fire: (value: T) -> (),
	getListenerCount: () -> number,
	isDeleted: () -> boolean,
	once: (callback: (value: T) -> ()) -> Reactily.connection,
}
```

## `connection`

```lua
type connection = {
	connected: boolean,
	disconnect: () -> boolean,
}
```

## `scheduler`

```lua
type scheduler = {
	cancel: (taskId: number) -> boolean,
	cancelKey: (key: string) -> boolean,
	clear: () -> (),
	delete: () -> boolean,
	enqueue: (callback: () -> ()) -> number,
	enqueueKeyed: (key: string, callback: () -> ()) -> number,
	flush: () -> (),
	getPendingCount: () -> number,
	isDeleted: () -> boolean,
	isPending: (key: string) -> boolean,
}
```

## `objectPool<T>`

```lua
type objectPool<T> = {
	acquire: () -> T,
	clear: () -> (),
	delete: () -> boolean,
	getAvailableCount: () -> number,
	getCreatedCount: () -> number,
	isDeleted: () -> boolean,
	release: (object: T) -> boolean,
}
```

## `animation`

```lua
type animation = {
	cancel: () -> boolean,
	delete: () -> boolean,
	isDeleted: () -> boolean,
	onCompleted: (callback: (playbackState: Enum.PlaybackState) -> ()) -> RBXScriptConnection,
	play: () -> (),
	tween: Tween,
}
```

## `tweenOptions`

```lua
type tweenOptions = {
	delayTime: number?,
	easingDirection: Enum.EasingDirection?,
	easingStyle: Enum.EasingStyle?,
	repeatCount: number?,
	reverses: boolean?,
	time: number,
}
```

| Option | Default |
| --- | --- |
| `delayTime` | `0` |
| `easingDirection` | `Enum.EasingDirection.Out` |
| `easingStyle` | `Enum.EasingStyle.Quad` |
| `repeatCount` | `0` |
| `reverses` | `false` |
| `time` | Required |

## `theme<T>`

```lua
type theme<T> = {
	delete: () -> boolean,
	get: () -> T,
	isDeleted: () -> boolean,
	set: (value: T) -> boolean,
	subscribe: (callback: (value: T) -> ()) -> Reactily.connection,
	update: (updater: (value: T) -> T) -> boolean,
}
```

## `focusGroup`

```lua
type focusGroup = {
	add: (object: GuiObject) -> boolean,
	clear: () -> (),
	delete: () -> boolean,
	focusFirst: () -> boolean,
	focusLast: () -> boolean,
	getItems: () -> {GuiObject},
	isDeleted: () -> boolean,
	remove: (object: GuiObject) -> boolean,
}
```

## `diagnostics`

```lua
type diagnostics = {
	delete: () -> boolean,
	get: (name: string) -> number,
	increment: (name: string, amount: number?) -> number,
	isDeleted: () -> boolean,
	reset: (name: string) -> boolean,
	resetAll: () -> (),
	snapshot: () -> {[string]: number},
}
```

## `counterControls`

```lua
type counterControls = {
	decrement: (amount: number?) -> (),
	increment: (amount: number?) -> (),
	reset: () -> (),
	set: (value: number) -> (),
}
```

## `ref<T>`

```lua
type ref<T> = {
	current: T,
}
```

## `virtualRange`

```lua
type virtualRange = {
	first: number,
	last: number,
	offset: number,
	totalSize: number,
}
```

---

# Typed Creator Reference

All class-specific creators return `Reactily.element`.

| Creator | Props | Children | Roblox host |
| --- | --- | --- | --- |
| `createBillboardGui` | `billboardGuiProps?` | Yes | `BillboardGui` |
| `createCanvasGroup` | `canvasGroupProps?` | Yes | `CanvasGroup` |
| `createFrame` | `frameProps?` | Yes | `Frame` |
| `createImageButton` | `imageButtonProps?` | Yes | `ImageButton` |
| `createImageLabel` | `imageLabelProps?` | Yes | `ImageLabel` |
| `createScreenGui` | `screenGuiProps?` | Yes | `ScreenGui` |
| `createScrollingFrame` | `scrollingFrameProps?` | Yes | `ScrollingFrame` |
| `createSurfaceGui` | `surfaceGuiProps?` | Yes | `SurfaceGui` |
| `createTextBox` | `textBoxProps?` | Yes | `TextBox` |
| `createTextButton` | `textButtonProps?` | Yes | `TextButton` |
| `createTextLabel` | `textLabelProps?` | Yes | `TextLabel` |
| `createUIAspectRatioConstraint` | `uiAspectRatioConstraintProps?` | No | `UIAspectRatioConstraint` |
| `createUICorner` | `uiCornerProps?` | No | `UICorner` |
| `createUIGradient` | `uiGradientProps?` | No | `UIGradient` |
| `createUIGridLayout` | `uiGridLayoutProps?` | No | `UIGridLayout` |
| `createUIListLayout` | `uiListLayoutProps?` | No | `UIListLayout` |
| `createUIPadding` | `uiPaddingProps?` | No | `UIPadding` |
| `createUIPageLayout` | `uiPageLayoutProps?` | No | `UIPageLayout` |
| `createUIScale` | `uiScaleProps?` | No | `UIScale` |
| `createUISizeConstraint` | `uiSizeConstraintProps?` | No | `UISizeConstraint` |
| `createUIStroke` | `uiStrokeProps?` | No | `UIStroke` |
| `createUITextSizeConstraint` | `uiTextSizeConstraintProps?` | No | `UITextSizeConstraint` |
| `createVideoFrame` | `videoFrameProps?` | Yes | `VideoFrame` |
| `createViewportFrame` | `viewportFrameProps?` | Yes | `ViewportFrame` |

Virtual-tree helpers:

| Function | Purpose |
| --- | --- |
| `createComponent` | Function component |
| `createElement` | Generic Roblox host |
| `createFragment` | Group children without a host |
| `createPortal` | Render children into another target |

---

# Typed Prop Reference

Reactily host prop names use camelCase and are mapped to the corresponding Roblox property/event names by the host configuration.

The sections below reproduce the public prop contracts from `src/virtual/element.luau`.

### `attributeValue`

```lua
export type attributeValue =
	boolean
	| BrickColor
	| CFrame
	| Color3
	| ColorSequence
	| NumberRange
	| NumberSequence
	| number
	| Rect
	| string
	| UDim
	| UDim2
	| Vector2
	| Vector3
```

### `hostMetadataProps`

```lua
export type hostMetadataProps<T> = {
	attributes: attributeMap?,
	key: string?,
	name: string?,
	ref: refCallback<T>?,
	tags: {string}?,
	onAncestryChanged: ((child: Instance, parent: Instance?) -> ())?,
	onChanged: ((property: string) -> ())?,
}
```

### `commonGuiProps`

```lua
export type commonGuiProps<T> = hostMetadataProps<T> & {
	active: boolean?,
	anchorPoint: Vector2?,
	automaticSize: Enum.AutomaticSize?,
	backgroundColor3: Color3?,
	backgroundTransparency: number?,
	borderColor3: Color3?,
	borderMode: Enum.BorderMode?,
	borderSizePixel: number?,
	clipsDescendants: boolean?,
	layoutOrder: number?,
	nextSelectionDown: GuiObject?,
	nextSelectionLeft: GuiObject?,
	nextSelectionRight: GuiObject?,
	nextSelectionUp: GuiObject?,
	position: UDim2?,
	rotation: number?,
	selectable: boolean?,
	selectionOrder: number?,
	size: UDim2?,
	sizeConstraint: Enum.SizeConstraint?,
	visible: boolean?,
	zIndex: number?,
	onInputBegan: ((input: InputObject) -> ())?,
	onInputChanged: ((input: InputObject) -> ())?,
	onInputEnded: ((input: InputObject) -> ())?,
	onMouseEnter: (() -> ())?,
	onMouseLeave: (() -> ())?,
	onSelectionGained: (() -> ())?,
	onSelectionLost: (() -> ())?,
}
```

### `textProps`

```lua
export type textProps = {
	font: Enum.Font?,
	fontFace: Font?,
	lineHeight: number?,
	maxVisibleGraphemes: number?,
	richText: boolean?,
	text: string?,
	textColor3: Color3?,
	textDirection: Enum.TextDirection?,
	textScaled: boolean?,
	textSize: number?,
	textStrokeColor3: Color3?,
	textStrokeTransparency: number?,
	textTransparency: number?,
	textTruncate: Enum.TextTruncate?,
	textWrapped: boolean?,
	textXAlignment: Enum.TextXAlignment?,
	textYAlignment: Enum.TextYAlignment?,
}
```

### `imageProps`

```lua
export type imageProps = {
	image: string?,
	imageColor3: Color3?,
	imageRectOffset: Vector2?,
	imageRectSize: Vector2?,
	imageTransparency: number?,
	resampleMode: Enum.ResamplerMode?,
	scaleType: Enum.ScaleType?,
	sliceCenter: Rect?,
	sliceScale: number?,
	tileSize: UDim2?,
}
```

### `buttonEvents`

```lua
export type buttonEvents = {
	onActivated: ((input: InputObject, clickCount: number) -> ())?,
	onMouseButton1Click: (() -> ())?,
	onMouseButton1Down: ((x: number, y: number) -> ())?,
	onMouseButton1Up: ((x: number, y: number) -> ())?,
	onMouseButton2Click: (() -> ())?,
	onMouseButton2Down: ((x: number, y: number) -> ())?,
	onMouseButton2Up: ((x: number, y: number) -> ())?,
}
```

### `billboardGuiProps`

```lua
export type billboardGuiProps = hostMetadataProps<BillboardGui> & {
	active: boolean?,
	adornee: Instance?,
	alwaysOnTop: boolean?,
	brightness: number?,
	clipsDescendants: boolean?,
	enabled: boolean?,
	extentsOffset: Vector3?,
	extentsOffsetWorldSpace: Vector3?,
	lightInfluence: number?,
	maxDistance: number?,
	playerToHideFrom: Player?,
	size: UDim2?,
	sizeOffset: Vector2?,
	studsOffset: Vector3?,
	studsOffsetWorldSpace: Vector3?,
	zIndexBehavior: Enum.ZIndexBehavior?,
}
```

### `canvasGroupProps`

```lua
export type canvasGroupProps = commonGuiProps<CanvasGroup> & {
	groupColor3: Color3?,
	groupTransparency: number?,
}
```

### `frameProps`

```lua
export type frameProps = commonGuiProps<Frame> & {
	style: Enum.FrameStyle?,
}
```

### `imageButtonProps`

```lua
export type imageButtonProps = commonGuiProps<ImageButton> & imageProps & buttonEvents & {
	autoButtonColor: boolean?,
	hoverImage: string?,
	modal: boolean?,
	pressedImage: string?,
	selected: boolean?,
}
```

### `imageLabelProps`

```lua
export type imageLabelProps = commonGuiProps<ImageLabel> & imageProps
```

### `screenGuiProps`

```lua
export type screenGuiProps = hostMetadataProps<ScreenGui> & {
	clipToDeviceSafeArea: boolean?,
	displayOrder: number?,
	enabled: boolean?,
	ignoreGuiInset: boolean?,
	resetOnSpawn: boolean?,
	safeAreaCompatibility: Enum.SafeAreaCompatibility?,
	screenInsets: Enum.ScreenInsets?,
	zIndexBehavior: Enum.ZIndexBehavior?,
}
```

### `scrollingFrameProps`

```lua
export type scrollingFrameProps = commonGuiProps<ScrollingFrame> & {
	automaticCanvasSize: Enum.AutomaticSize?,
	bottomImage: string?,
	canvasPosition: Vector2?,
	canvasSize: UDim2?,
	elasticBehavior: Enum.ElasticBehavior?,
	midImage: string?,
	scrollBarImageColor3: Color3?,
	scrollBarImageTransparency: number?,
	scrollBarThickness: number?,
	scrollingDirection: Enum.ScrollingDirection?,
	scrollingEnabled: boolean?,
	topImage: string?,
	verticalScrollBarInset: Enum.ScrollBarInset?,
	verticalScrollBarPosition: Enum.VerticalScrollBarPosition?,
}
```

### `surfaceGuiProps`

```lua
export type surfaceGuiProps = hostMetadataProps<SurfaceGui> & {
	active: boolean?,
	adornee: BasePart?,
	alwaysOnTop: boolean?,
	brightness: number?,
	canvasSize: Vector2?,
	clipsDescendants: boolean?,
	enabled: boolean?,
	face: Enum.NormalId?,
	lightInfluence: number?,
	maxDistance: number?,
	pixelsPerStud: number?,
	sizingMode: Enum.SurfaceGuiSizingMode?,
	toolPunchThroughDistance: number?,
	zIndexBehavior: Enum.ZIndexBehavior?,
	zOffset: number?,
}
```

### `textBoxProps`

```lua
export type textBoxProps = commonGuiProps<TextBox> & textProps & {
	clearTextOnFocus: boolean?,
	cursorPosition: number?,
	multiLine: boolean?,
	placeholderColor3: Color3?,
	placeholderText: string?,
	selectionStart: number?,
	showNativeInput: boolean?,
	textEditable: boolean?,
	onFocused: (() -> ())?,
	onFocusLost: ((enterPressed: boolean, input: InputObject?) -> ())?,
}
```

### `textButtonProps`

```lua
export type textButtonProps = commonGuiProps<TextButton> & textProps & buttonEvents & {
	autoButtonColor: boolean?,
	modal: boolean?,
	selected: boolean?,
	style: Enum.ButtonStyle?,
}
```

### `textLabelProps`

```lua
export type textLabelProps = commonGuiProps<TextLabel> & textProps
```

### `videoFrameProps`

```lua
export type videoFrameProps = commonGuiProps<VideoFrame> & {
	looped: boolean?,
	playing: boolean?,
	timePosition: number?,
	video: string?,
	volume: number?,
}
```

### `viewportFrameProps`

```lua
export type viewportFrameProps = commonGuiProps<ViewportFrame> & {
	ambient: Color3?,
	currentCamera: Camera?,
	imageColor3: Color3?,
	imageTransparency: number?,
	lightColor: Color3?,
	lightDirection: Vector3?,
}
```

### `uiAspectRatioConstraintProps`

```lua
export type uiAspectRatioConstraintProps = hostMetadataProps<UIAspectRatioConstraint> & {
	aspectRatio: number?,
	aspectType: Enum.AspectType?,
	dominantAxis: Enum.DominantAxis?,
}
```

### `uiCornerProps`

```lua
export type uiCornerProps = hostMetadataProps<UICorner> & {
	cornerRadius: UDim?,
}
```

### `uiGradientProps`

```lua
export type uiGradientProps = hostMetadataProps<UIGradient> & {
	color: ColorSequence?,
	enabled: boolean?,
	offset: Vector2?,
	rotation: number?,
	transparency: NumberSequence?,
}
```

### `uiGridLayoutProps`

```lua
export type uiGridLayoutProps = hostMetadataProps<UIGridLayout> & {
	cellPadding: UDim2?,
	cellSize: UDim2?,
	fillDirection: Enum.FillDirection?,
	fillDirectionMaxCells: number?,
	horizontalAlignment: Enum.HorizontalAlignment?,
	sortOrder: Enum.SortOrder?,
	startCorner: Enum.StartCorner?,
	verticalAlignment: Enum.VerticalAlignment?,
}
```

### `uiListLayoutProps`

```lua
export type uiListLayoutProps = hostMetadataProps<UIListLayout> & {
	fillDirection: Enum.FillDirection?,
	horizontalAlignment: Enum.HorizontalAlignment?,
	horizontalFlex: Enum.UIFlexAlignment?,
	itemLineAlignment: Enum.ItemLineAlignment?,
	padding: UDim?,
	sortOrder: Enum.SortOrder?,
	verticalAlignment: Enum.VerticalAlignment?,
	verticalFlex: Enum.UIFlexAlignment?,
	wraps: boolean?,
}
```

### `uiPaddingProps`

```lua
export type uiPaddingProps = hostMetadataProps<UIPadding> & {
	paddingBottom: UDim?,
	paddingLeft: UDim?,
	paddingRight: UDim?,
	paddingTop: UDim?,
}
```

### `uiPageLayoutProps`

```lua
export type uiPageLayoutProps = hostMetadataProps<UIPageLayout> & {
	animated: boolean?,
	circular: boolean?,
	easingDirection: Enum.EasingDirection?,
	easingStyle: Enum.EasingStyle?,
	gamepadInputEnabled: boolean?,
	padding: UDim?,
	scrollWheelInputEnabled: boolean?,
	touchInputEnabled: boolean?,
	tweenTime: number?,
}
```

### `uiScaleProps`

```lua
export type uiScaleProps = hostMetadataProps<UIScale> & {
	scale: number?,
}
```

### `uiSizeConstraintProps`

```lua
export type uiSizeConstraintProps = hostMetadataProps<UISizeConstraint> & {
	maximumSize: Vector2?,
	minimumSize: Vector2?,
}
```

### `uiStrokeProps`

```lua
export type uiStrokeProps = hostMetadataProps<UIStroke> & {
	applyStrokeMode: Enum.ApplyStrokeMode?,
	color: Color3?,
	enabled: boolean?,
	lineJoinMode: Enum.LineJoinMode?,
	thickness: number?,
	transparency: number?,
}
```

### `uiTextSizeConstraintProps`

```lua
export type uiTextSizeConstraintProps = hostMetadataProps<UITextSizeConstraint> & {
	maximumTextSize: number?,
	minimumTextSize: number?,
}
```


---

# Advanced Module Reference

Application code should normally require only the Reactily package root. These modules are intended for framework development or advanced integration.

## `src/core/lifecycle.luau`

```lua
lifecycle.addCleanup(owner, callback)
lifecycle.bindInstanceDeletion(owner, instance)
lifecycle.connect(owner, signal, callback)
lifecycle.connectNamed(owner, connections, name, signal, callback)
lifecycle.createChild(parent)
lifecycle.delete(owner)
lifecycle.deleteInstance(owner, instance)
lifecycle.deleteInstances(owner)
lifecycle.disconnect(owner, connection)
lifecycle.disconnectAll(owner)
lifecycle.getCleanupCount(owner)
lifecycle.getConnectionCount(owner)
lifecycle.getInstanceCount(owner)
lifecycle.isDeleted(owner)
lifecycle.new()
lifecycle.replaceInstance(owner, current, nextValue)
lifecycle.runCleanups(owner)
lifecycle.trackInstance(owner, instance)
```

`bindInstanceDeletion()` observes Roblox `Instance.Destroying` and deletes the Reactily owner when the Instance is externally destroyed.

## `src/core/objectPool.luau`

```lua
objectPool.instance(className, maximumSize)
objectPool.new(createObject, resetObject, deleteObject, maximumSize)
```

## `src/core/scheduler.luau`

```lua
scheduler.new()
```

## `src/core/signal.luau`

```lua
signal.distinct(source)
signal.filter(source, predicate)
signal.map(source, mapper)
signal.merge(sources)
signal.new()
signal.skip(source, amount)
signal.take(source, maximum)
```

## `src/diagnostics/diagnostics.luau`

```lua
diagnostics.new()
```

## `src/interface/focus.luau`

```lua
focus.clearSelection()
focus.new()
```

## `src/interface/style.luau`

```lua
style.apply(properties, styleValue)
style.merge(styles)
style.when(condition, styleValue)
style.without(styleValue, property)
style.withProperty(styleValue, property, value)
```

## `src/interface/theme.luau`

```lua
theme.new(initialValue)
theme.resolve(themeValue, selector)
```

## `src/interface/virtualList.luau`

```lua
virtualList.resolve(itemCount, itemSize, scrollOffset, viewportSize, overscan)
virtualList.slice(items, rangeValue)
```

## `src/runtime/animation.luau`

```lua
animation.play(instance, goals, options)
animation.tween(instance, goals, options)
```

## `src/runtime/binding.luau`

```lua
binding.attach(source, instance, propertyName)
binding.clamp(source, minimum, maximum)
binding.combine(first, second, mapper)
binding.format(source, formatter)
binding.map(source, mapper)
binding.new(initialValue)
binding.round(source, precision)
```

`binding.attach()` returns a cleanup callback that disconnects the property subscription.

## `src/runtime/hostConfig.luau`

```lua
hostConfig.getEventName(propName)
hostConfig.getPropertyName(propName)
hostConfig.isEvent(propName)
hostConfig.isProperty(propName)
```

## `src/runtime/renderer.luau`

```lua
renderer.createHost(parent, elementValue)
renderer.deleteHost(handle)
renderer.updateHost(handle, previousProps, nextProps)
```

## `src/runtime/root.luau`

```lua
root.new(parent)
```

## `src/state/atom.luau`

```lua
atom.computed(source, selector)
atom.fromAttribute(instance, attributeName, defaultValue)
atom.history(initialValue, limit)
atom.new(initialValue)
```

## `src/state/hooks.luau`

Public hook implementations plus framework render-context functions:

```lua
hooks.beginRender(context)
hooks.deleteContext(context)
hooks.endRender(context, didComplete)
hooks.flushEffects(context)
hooks.newContext(requestRender)
```

Application code should use the hooks re-exported by `Reactily`.

## `src/state/store.luau`

```lua
store.new(initialState)
```

## `src/virtual/element.luau`

Contains the virtual element union, prop contracts, and typed element constructors documented above.

## `src/virtual/reconciler.luau`

```lua
reconciler.delete(node)
reconciler.reconcile(parent, currentNode, nextElement, options)
```

---

# Complete Examples

## Typed counter

```lua
local Reactily = require(path.Reactily)

local function counter(): Reactily.element
	local count, controls = Reactily.useCounter(0)

	return Reactily.createFrame({
		size = UDim2.fromOffset(300, 140),
		backgroundColor3 = Color3.fromRGB(27, 27, 31),
		borderSizePixel = 0,
	}, {
		Reactily.createUICorner({
			cornerRadius = UDim.new(0, 10),
		}),

		Reactily.createTextButton({
			size = UDim2.fromScale(1, 1),
			backgroundTransparency = 1,
			text = `Count: {count}`,
			textColor3 = Color3.new(1, 1, 1),
			textSize = 28,

			onActivated = function()
				controls.increment()
			end,
		}),
	})
end

local root = Reactily.createRoot(playerGui)

root.render(
	Reactily.createComponent(counter, {})
)
```

## Store-driven page state

```lua
local Reactily = require(path.Reactily)

type appState = {
	page: "Home" | "Effects" | "Position",
	selectedFixture: number?,
}

local app = Reactily.createStore<appState>({
	page = "Home",
	selectedFixture = nil,
})

local page = app.select(function(state: appState)
	return state.page
end)

page.subscribe(function(change)
	print(`Page: {change.previous} -> {change.current}`)
end)

app.update(function(previous: appState): appState
	return {
		page = "Effects",
		selectedFixture = previous.selectedFixture,
	}
end)
```

## Position editor history

```lua
local Reactily = require(path.Reactily)

type position = {
	pan: number,
	tilt: number,
}

local currentPosition = Reactily.createHistoryAtom<position>(
	{
		pan = 0,
		tilt = 0,
	},
	100
)

currentPosition.set({
	pan = 30,
	tilt = -15,
})

currentPosition.undo()
currentPosition.redo()
```

## Modal portal

```lua
local overlay = Reactily.createPortal(screenGui, {
	Reactily.createFrame({
		key = "overlay",
		size = UDim2.fromScale(1, 1),
		backgroundColor3 = Color3.new(0, 0, 0),
		backgroundTransparency = .4,
	}, {
		Reactily.createFrame({
			anchorPoint = Vector2.new(.5, .5),
			position = UDim2.fromScale(.5, .5),
			size = UDim2.fromOffset(500, 320),
		}),
	}),
}, "settings-modal")
```

## Virtualized fixture list

```lua
local range = Reactily.resolveVirtualList(
	#fixtures,
	36,
	scrollingFrame.CanvasPosition.Y,
	scrollingFrame.AbsoluteWindowSize.Y,
	4
)

local children: {Reactily.element} = {}

for index = range.first, range.last do
	local fixture = fixtures[index]

	children[#children + 1] = Reactily.createTextButton({
		key = tostring(fixture.id),
		position = UDim2.fromOffset(0, (index - 1) * 36),
		size = UDim2.new(1, 0, 0, 36),
		text = fixture.name,
	})
end
```

## Attribute-backed component state

```lua
type fixtureToggleProps = {
	fixture: Model,
}

local function fixtureToggle(props: fixtureToggleProps): Reactily.element
	local enabled, setEnabled = Reactily.useAttribute(
		props.fixture,
		"enabled",
		true
	)

	return Reactily.createTextButton({
		text = if enabled then "Enabled" else "Disabled",

		onActivated = function()
			setEnabled(not enabled)
		end,
	})
end
```

## Owned Tween

```lua
local animation = Reactily.playTween(
	panel,
	{
		Position = UDim2.fromScale(.5, .5),
		BackgroundTransparency = 0,
	},
	{
		time = .25,
		easingStyle = Enum.EasingStyle.Quad,
		easingDirection = Enum.EasingDirection.Out,
	}
)

animation.onCompleted(function(playbackState)
	if playbackState ~= Enum.PlaybackState.Completed then return end

	animation.delete()
end)
```

---

## Versioning

Current version:

```text
1.0.0
```

Runtime access:

```lua
local version = Reactily.getVersion()
```

---

## Final Notes

The supported package contract is `src/init.luau`. Prefer that API unless you are extending Reactily itself.

Reactily's core runtime contract is built around typed class-specific creators, stable hook order, keyed reconciliation, explicit `.delete()` ownership, change-only updates, and no permanent self-generated frame loop while the framework is idle.

---

# All References

This final section is the consolidated Reactily reference index. It is intentionally placed at the end of the documentation so the full guide can be read normally while every callable API remains available in one lookup section.

## Public Package Reference

### Package

```lua
Reactily.getVersion(): string
Reactily.new(parent: Instance): Reactily.root
Reactily.createRoot(parent: Instance): Reactily.root
```

### Virtual Tree

```lua
Reactily.createElement(
	className: string,
	props: {[string]: any}?,
	children: {Reactily.element}?
): Reactily.element

Reactily.createComponent<P>(
	componentValue: Reactily.component<P>,
	props: P,
	children: {Reactily.element}?,
	key: string?
): Reactily.element

Reactily.createFragment(
	children: {Reactily.element},
	key: string?
): Reactily.element

Reactily.createPortal(
	target: Instance,
	children: {Reactily.element},
	key: string?
): Reactily.element
```

### Typed Roblox Creators

```lua
Reactily.createBillboardGui(props: Reactily.billboardGuiProps?, children: {Reactily.element}?): Reactily.element
Reactily.createCanvasGroup(props: Reactily.canvasGroupProps?, children: {Reactily.element}?): Reactily.element
Reactily.createFrame(props: Reactily.frameProps?, children: {Reactily.element}?): Reactily.element
Reactily.createImageButton(props: Reactily.imageButtonProps?, children: {Reactily.element}?): Reactily.element
Reactily.createImageLabel(props: Reactily.imageLabelProps?, children: {Reactily.element}?): Reactily.element
Reactily.createScreenGui(props: Reactily.screenGuiProps?, children: {Reactily.element}?): Reactily.element
Reactily.createScrollingFrame(props: Reactily.scrollingFrameProps?, children: {Reactily.element}?): Reactily.element
Reactily.createSurfaceGui(props: Reactily.surfaceGuiProps?, children: {Reactily.element}?): Reactily.element
Reactily.createTextBox(props: Reactily.textBoxProps?, children: {Reactily.element}?): Reactily.element
Reactily.createTextButton(props: Reactily.textButtonProps?, children: {Reactily.element}?): Reactily.element
Reactily.createTextLabel(props: Reactily.textLabelProps?, children: {Reactily.element}?): Reactily.element
Reactily.createVideoFrame(props: Reactily.videoFrameProps?, children: {Reactily.element}?): Reactily.element
Reactily.createViewportFrame(props: Reactily.viewportFrameProps?, children: {Reactily.element}?): Reactily.element

Reactily.createUIAspectRatioConstraint(props: Reactily.uiAspectRatioConstraintProps?): Reactily.element
Reactily.createUICorner(props: Reactily.uiCornerProps?): Reactily.element
Reactily.createUIGradient(props: Reactily.uiGradientProps?): Reactily.element
Reactily.createUIGridLayout(props: Reactily.uiGridLayoutProps?): Reactily.element
Reactily.createUIListLayout(props: Reactily.uiListLayoutProps?): Reactily.element
Reactily.createUIPadding(props: Reactily.uiPaddingProps?): Reactily.element
Reactily.createUIPageLayout(props: Reactily.uiPageLayoutProps?): Reactily.element
Reactily.createUIScale(props: Reactily.uiScaleProps?): Reactily.element
Reactily.createUISizeConstraint(props: Reactily.uiSizeConstraintProps?): Reactily.element
Reactily.createUIStroke(props: Reactily.uiStrokeProps?): Reactily.element
Reactily.createUITextSizeConstraint(props: Reactily.uiTextSizeConstraintProps?): Reactily.element
```

## Hooks Reference

```lua
Reactily.useState<T>(
	initialValue: T
): (T, Reactily.stateSetter<T>)

Reactily.useReducer<S, A>(
	reducer: (stateValue: S, action: A) -> S,
	initialState: S
): (S, Reactily.reducerDispatch<A>)

Reactily.useRef<T>(
	initialValue: T
): Reactily.ref<T>

Reactily.useMemo<T>(
	factory: () -> T,
	dependencies: {any}?
): T

Reactily.useCallback<T>(
	callback: T,
	dependencies: {any}?
): T

Reactily.useEffect(
	callback: () -> (() -> ())?,
	dependencies: {any}?
)

Reactily.usePrevious<T>(
	value: T
): T?

Reactily.useToggle(
	initialValue: boolean?
): (
	boolean,
	() -> (),
	(value: boolean) -> ()
)

Reactily.useBoolean(
	initialValue: boolean?
): (
	boolean,
	() -> (),
	() -> (),
	() -> ()
)

Reactily.useCounter(
	initialValue: number?
): (
	number,
	Reactily.counterControls
)

Reactily.useDebouncedValue<T>(
	value: T,
	delaySeconds: number
): T

Reactily.useAttribute<T>(
	instance: Instance,
	attributeName: string,
	defaultValue: T
): (
	T,
	(value: T) -> ()
)
```

## Atom Reference

```lua
Reactily.createAtom<T>(
	initialValue: T
): Reactily.atom<T>

Reactily.createComputed<A, B>(
	source: Reactily.atom<A>,
	selectorFunction: (value: A) -> B
): Reactily.computed<B>

Reactily.createHistoryAtom<T>(
	initialValue: T,
	limit: number
): Reactily.historyAtom<T>

Reactily.createAttributeAtom<T>(
	instance: Instance,
	attributeName: string,
	defaultValue: T
): Reactily.atom<T>
```

### `atom<T>`

```lua
atom.get(): T
atom.set(value: T): boolean
atom.update(updater: (previous: T) -> T): boolean
atom.subscribe(callback: (change: Reactily.atomChange<T>) -> ()): Reactily.connection
atom.isDeleted(): boolean
atom.delete(): boolean
```

### `computed<T>`

```lua
computed.get(): T
computed.subscribe(callback: (change: Reactily.atomChange<T>) -> ()): Reactily.connection
computed.isDeleted(): boolean
computed.delete(): boolean
```

### `historyAtom<T>`

```lua
historyAtom.get(): T
historyAtom.set(value: T): boolean
historyAtom.update(updater: (previous: T) -> T): boolean
historyAtom.subscribe(callback: (change: Reactily.atomChange<T>) -> ()): Reactily.connection

historyAtom.canUndo(): boolean
historyAtom.canRedo(): boolean
historyAtom.undo(): boolean
historyAtom.redo(): boolean
historyAtom.clearHistory()
historyAtom.getPastCount(): number
historyAtom.getFutureCount(): number

historyAtom.isDeleted(): boolean
historyAtom.delete(): boolean
```

## Store Reference

```lua
Reactily.createStore<T>(
	initialState: T
): Reactily.store<T>
```

### `store<T>`

```lua
store.get(): T
store.set(state: T): boolean
store.update(updater: (state: T) -> T): boolean
store.reset(): boolean

store.subscribe(
	callback: (change: {
		current: T,
		previous: T,
	}) -> ()
): Reactily.connection

store.select<R>(
	selectorFunction: (state: T) -> R
): Reactily.selector<R>

store.batch(callback: () -> ())

store.isDeleted(): boolean
store.delete(): boolean
```

### `selector<T>`

```lua
selector.get(): T

selector.subscribe(
	callback: (change: {
		current: T,
		previous: T,
	}) -> ()
): Reactily.connection

selector.isDeleted(): boolean
selector.delete(): boolean
```

## Binding Reference

```lua
Reactily.createBinding<T>(
	initialValue: T
): Reactily.binding<T>

Reactily.mapBinding<A, B>(
	source: Reactily.binding<A>,
	mapper: (value: A) -> B
): Reactily.binding<B>

Reactily.combineBindings<A, B, R>(
	first: Reactily.binding<A>,
	second: Reactily.binding<B>,
	mapper: (firstValue: A, secondValue: B) -> R
): Reactily.binding<R>

Reactily.clampBinding(
	source: Reactily.binding<number>,
	minimum: number,
	maximum: number
): Reactily.binding<number>

Reactily.roundBinding(
	source: Reactily.binding<number>,
	precision: number
): Reactily.binding<number>

Reactily.formatBinding<T>(
	source: Reactily.binding<T>,
	formatter: (value: T) -> string
): Reactily.binding<string>
```

### `binding<T>`

```lua
binding.get(): T
binding.set(value: T): boolean
binding.subscribe(callback: (change: Reactily.bindingChange<T>) -> ()): Reactily.connection
binding.isDeleted(): boolean
binding.delete(): boolean
```

## Signal Reference

```lua
Reactily.createSignal<T>(): Reactily.signal<T>

Reactily.mapSignal<A, B>(
	source: Reactily.signal<A>,
	mapper: (value: A) -> B
): Reactily.signal<B>

Reactily.filterSignal<T>(
	source: Reactily.signal<T>,
	predicate: (value: T) -> boolean
): Reactily.signal<T>

Reactily.distinctSignal<T>(
	source: Reactily.signal<T>
): Reactily.signal<T>

Reactily.mergeSignals<T>(
	sources: {Reactily.signal<T>}
): Reactily.signal<T>

Reactily.skipSignal<T>(
	source: Reactily.signal<T>,
	amount: number
): Reactily.signal<T>

Reactily.takeSignal<T>(
	source: Reactily.signal<T>,
	maximum: number
): Reactily.signal<T>
```

### `signal<T>`

```lua
signal.connect(callback: (value: T) -> ()): Reactily.connection
signal.once(callback: (value: T) -> ()): Reactily.connection
signal.fire(value: T)
signal.getListenerCount(): number
signal.isDeleted(): boolean
signal.delete(): boolean
```

### `connection`

```lua
connection.connected: boolean
connection.disconnect(): boolean
```

## Root Reference

### `root`

```lua
root.render(elementValue: Reactily.element?)
root.flush()

root.batch(callback: () -> ())

root.suspend(): boolean
root.resume(): boolean
root.isSuspended(): boolean

root.getElement(): Reactily.element?
root.getParent(): Instance

root.isDeleted(): boolean
root.delete(): boolean
```

## Theme Reference

```lua
Reactily.createTheme<T>(
	initialValue: T
): Reactily.theme<T>

Reactily.resolveTheme<T, R>(
	themeValue: Reactily.theme<T>,
	selectorFunction: (tokens: T) -> R
): R
```

### `theme<T>`

```lua
theme.get(): T
theme.set(value: T): boolean
theme.update(updater: (value: T) -> T): boolean
theme.subscribe(callback: (value: T) -> ()): Reactily.connection
theme.isDeleted(): boolean
theme.delete(): boolean
```

## Style Reference

```lua
Reactily.createStyle(
	styles: {Reactily.style}
): Reactily.style

Reactily.applyStyle<T>(
	properties: T,
	styleValue: Reactily.style
): T
```

Advanced style helpers:

```lua
style.merge(styles)
style.when(condition, styleValue)
style.withProperty(styleValue, property, value)
style.without(styleValue, property)
style.apply(properties, styleValue)
```

## Animation Reference

```lua
Reactily.createTween(
	instance: Instance,
	goals: {[string]: any},
	options: Reactily.tweenOptions
): Reactily.animation

Reactily.playTween(
	instance: Instance,
	goals: {[string]: any},
	options: Reactily.tweenOptions
): Reactily.animation
```

### `animation`

```lua
animation.tween: Tween
animation.play()
animation.cancel(): boolean

animation.onCompleted(
	callback: (playbackState: Enum.PlaybackState) -> ()
): RBXScriptConnection

animation.isDeleted(): boolean
animation.delete(): boolean
```

### `tweenOptions`

```lua
type tweenOptions = {
	delayTime: number?,
	easingDirection: Enum.EasingDirection?,
	easingStyle: Enum.EasingStyle?,
	repeatCount: number?,
	reverses: boolean?,
	time: number,
}
```

## Focus Reference

```lua
Reactily.createFocusGroup(): Reactily.focusGroup
Reactily.clearFocus()
```

### `focusGroup`

```lua
focusGroup.add(object: GuiObject): boolean
focusGroup.remove(object: GuiObject): boolean
focusGroup.clear()
focusGroup.focusFirst(): boolean
focusGroup.focusLast(): boolean
focusGroup.getItems(): {GuiObject}
focusGroup.isDeleted(): boolean
focusGroup.delete(): boolean
```

## Virtual List Reference

```lua
Reactily.resolveVirtualList(
	itemCount: number,
	itemSize: number,
	scrollOffset: number,
	viewportSize: number,
	overscan: number?
): Reactily.virtualRange

Reactily.sliceVirtualList<T>(
	items: {T},
	rangeValue: Reactily.virtualRange
): {T}
```

### `virtualRange`

```lua
type virtualRange = {
	first: number,
	last: number,
	offset: number,
	totalSize: number,
}
```

## Object Pool Reference

```lua
Reactily.createObjectPool<T>(
	createObject: () -> T,
	resetObject: (object: T) -> (),
	deleteObject: (object: T) -> (),
	maximumSize: number
): Reactily.objectPool<T>

Reactily.createInstancePool(
	className: string,
	maximumSize: number
): Reactily.objectPool<Instance>
```

### `objectPool<T>`

```lua
objectPool.acquire(): T
objectPool.release(object: T): boolean
objectPool.clear()
objectPool.getAvailableCount(): number
objectPool.getCreatedCount(): number
objectPool.isDeleted(): boolean
objectPool.delete(): boolean
```

## Scheduler Reference

```lua
Reactily.createScheduler(): Reactily.scheduler
```

### `scheduler`

```lua
scheduler.enqueue(callback: () -> ()): number
scheduler.enqueueKeyed(key: string, callback: () -> ()): number

scheduler.cancel(taskId: number): boolean
scheduler.cancelKey(key: string): boolean

scheduler.isPending(key: string): boolean
scheduler.getPendingCount(): number

scheduler.flush()
scheduler.clear()

scheduler.isDeleted(): boolean
scheduler.delete(): boolean
```

## Diagnostics Reference

```lua
Reactily.createDiagnostics(): Reactily.diagnostics
```

### `diagnostics`

```lua
diagnostics.increment(name: string, amount: number?): number
diagnostics.get(name: string): number
diagnostics.reset(name: string): boolean
diagnostics.resetAll()
diagnostics.snapshot(): {[string]: number}
diagnostics.isDeleted(): boolean
diagnostics.delete(): boolean
```

## Lifecycle Reference

```lua
Reactily.createLifecycleOwner(): Reactily.lifecycleOwner
```

Advanced lifecycle module API:

```lua
lifecycle.new(): lifecycleOwner

lifecycle.connect(
	ownerValue,
	signal,
	callback
): RBXScriptConnection

lifecycle.connectNamed(
	ownerValue,
	connections,
	name,
	signal,
	callback
): RBXScriptConnection

lifecycle.disconnect(
	ownerValue,
	connection
): boolean

lifecycle.disconnectAll(ownerValue)

lifecycle.trackInstance(ownerValue, instance)
lifecycle.replaceInstance(ownerValue, current, nextValue)
lifecycle.deleteInstance(ownerValue, instance): boolean
lifecycle.deleteInstances(ownerValue)

lifecycle.addCleanup(ownerValue, callback)
lifecycle.runCleanups(ownerValue)

lifecycle.createChild(parent)
lifecycle.bindInstanceDeletion(ownerValue, instance)

lifecycle.getConnectionCount(ownerValue): number
lifecycle.getInstanceCount(ownerValue): number
lifecycle.getCleanupCount(ownerValue): number

lifecycle.isDeleted(ownerValue): boolean
lifecycle.delete(ownerValue): boolean
```

## Host Metadata Reference

All supported host creators inherit Reactily metadata where applicable:

```lua
key: string?
ref: ((instance: T?) -> ())?
attributes: {[string]: Reactily.attributeValue}?
tags: {string}?
```

### `attributeValue`

```lua
type attributeValue =
	boolean
	| BrickColor
	| CFrame
	| Color3
	| ColorSequence
	| Font
	| NumberRange
	| NumberSequence
	| Rect
	| string
	| number
	| UDim
	| UDim2
	| Vector2
	| Vector3
```

## Common GUI Event Reference

```lua
onAncestryChanged: ((child: Instance, parent: Instance?) -> ())?
onChanged: ((property: string) -> ())?
onInputBegan: ((input: InputObject) -> ())?
onInputChanged: ((input: InputObject) -> ())?
onInputEnded: ((input: InputObject) -> ())?
onMouseEnter: (() -> ())?
onMouseLeave: (() -> ())?
```

Button creators additionally support button-specific events such as:

```lua
onActivated: ((input: InputObject, clickCount: number) -> ())?
onMouseButton1Click: (() -> ())?
onMouseButton1Down: ((x: number, y: number) -> ())?
onMouseButton1Up: ((x: number, y: number) -> ())?
onMouseButton2Click: (() -> ())?
onMouseButton2Down: ((x: number, y: number) -> ())?
onMouseButton2Up: ((x: number, y: number) -> ())?
```

## Module Path Reference

| Module | Responsibility |
| --- | --- |
| `src/init.luau` | Public Reactily API |
| `src/core/lifecycle.luau` | Resource ownership and deletion |
| `src/core/objectPool.luau` | Bounded object and Instance reuse |
| `src/core/scheduler.luau` | Idle-safe queued rendering/work |
| `src/core/signal.luau` | Typed signals and derived signal operators |
| `src/diagnostics/diagnostics.luau` | Explicit runtime counters |
| `src/interface/focus.luau` | GUI focus groups |
| `src/interface/style.luau` | Style table composition |
| `src/interface/theme.luau` | Typed theme state |
| `src/interface/virtualList.luau` | Fixed-size list virtualization |
| `src/runtime/animation.luau` | Owned TweenService animations |
| `src/runtime/binding.luau` | Reactive bindings and transforms |
| `src/runtime/hostConfig.luau` | Reactily prop/event → Roblox mapping |
| `src/runtime/renderer.luau` | Roblox Instance creation/update/deletion |
| `src/runtime/root.luau` | Render root lifecycle |
| `src/state/atom.luau` | Atoms, computed state, history, Attributes |
| `src/state/hooks.luau` | Component hooks and hook runtime |
| `src/state/store.luau` | Stores, selectors, batches |
| `src/virtual/element.luau` | Element types and typed creators |
| `src/virtual/reconciler.luau` | Reconciliation, keys, portals, deletion |

## Lifecycle Naming Reference

Reactily-owned lifecycle terminology:

```lua
delete
isDeleted
deleteInstance
deleteInstances
deleteObject
deleteContext
deleteHost
```

Roblox-owned lifecycle names remain Roblox-owned:

```lua
instance:Destroy()
tween:Destroy()
instance.Destroying
connection:Disconnect()
```

Reactily never renames external Roblox contracts.

## Final Reference Rule

For normal application code, treat `src/init.luau` as the supported package contract.

Use the advanced module APIs only when extending Reactily itself or when a framework-level integration genuinely requires lower-level ownership, scheduling, rendering, or host configuration access.

---

# Literal Full API Index

This is the literal dot-call reference for Reactily. Use this section when you only need to see **what can be typed after `Reactily.`** or after a returned Reactily object.

## Everything after `Reactily.`

```lua
Reactily.applyStyle
Reactily.clampBinding
Reactily.clearFocus
Reactily.combineBindings
Reactily.createAttributeAtom
Reactily.createAtom
Reactily.createBillboardGui
Reactily.createBinding
Reactily.createCanvasGroup
Reactily.createComponent
Reactily.createComputed
Reactily.createDiagnostics
Reactily.createElement
Reactily.createFocusGroup
Reactily.createFragment
Reactily.createFrame
Reactily.createHistoryAtom
Reactily.createImageButton
Reactily.createImageLabel
Reactily.createInstancePool
Reactily.createLifecycleOwner
Reactily.createObjectPool
Reactily.createPortal
Reactily.createRoot
Reactily.createScheduler
Reactily.createScreenGui
Reactily.createScrollingFrame
Reactily.createSignal
Reactily.createStore
Reactily.createStyle
Reactily.createSurfaceGui
Reactily.createTextBox
Reactily.createTextButton
Reactily.createTextLabel
Reactily.createTheme
Reactily.createTween
Reactily.createUIAspectRatioConstraint
Reactily.createUICorner
Reactily.createUIGradient
Reactily.createUIGridLayout
Reactily.createUIListLayout
Reactily.createUIPadding
Reactily.createUIPageLayout
Reactily.createUIScale
Reactily.createUISizeConstraint
Reactily.createUIStroke
Reactily.createUITextSizeConstraint
Reactily.createVideoFrame
Reactily.createViewportFrame
Reactily.distinctSignal
Reactily.filterSignal
Reactily.formatBinding
Reactily.getVersion
Reactily.mapBinding
Reactily.mapSignal
Reactily.mergeSignals
Reactily.new
Reactily.playTween
Reactily.resolveTheme
Reactily.resolveVirtualList
Reactily.roundBinding
Reactily.skipSignal
Reactily.sliceVirtualList
Reactily.takeSignal
Reactily.useAttribute
Reactily.useBoolean
Reactily.useCallback
Reactily.useCounter
Reactily.useDebouncedValue
Reactily.useEffect
Reactily.useMemo
Reactily.usePrevious
Reactily.useReducer
Reactily.useRef
Reactily.useState
Reactily.useToggle
```

## Returned Object Dot APIs

### `root.*`

```lua
root.batch(callback)
root.delete()
root.flush()
root.getElement()
root.getParent()
root.isDeleted()
root.isSuspended()
root.render(element)
root.resume()
root.suspend()
```

### `atom.*`

```lua
atom.delete()
atom.get()
atom.isDeleted()
atom.set(value)
atom.subscribe(callback)
atom.update(updater)
```

### `computed.*`

```lua
computed.delete()
computed.get()
computed.isDeleted()
computed.subscribe(callback)
```

### `historyAtom.*`

```lua
historyAtom.canRedo()
historyAtom.canUndo()
historyAtom.clearHistory()
historyAtom.delete()
historyAtom.get()
historyAtom.getFutureCount()
historyAtom.getPastCount()
historyAtom.isDeleted()
historyAtom.redo()
historyAtom.set(value)
historyAtom.subscribe(callback)
historyAtom.undo()
historyAtom.update(updater)
```

### `store.*`

```lua
store.batch(callback)
store.delete()
store.get()
store.isDeleted()
store.reset()
store.select(selector)
store.set(state)
store.subscribe(callback)
store.update(updater)
```

### `selector.*`

```lua
selector.delete()
selector.get()
selector.isDeleted()
selector.subscribe(callback)
```

### `binding.*`

```lua
binding.delete()
binding.get()
binding.isDeleted()
binding.set(value)
binding.subscribe(callback)
```

### `signal.*`

```lua
signal.connect(callback)
signal.delete()
signal.fire(value)
signal.getListenerCount()
signal.isDeleted()
signal.once(callback)
```

### `connection.*`

```lua
connection.disconnect()
```

### `scheduler.*`

```lua
scheduler.cancel(taskId)
scheduler.cancelKey(key)
scheduler.clear()
scheduler.delete()
scheduler.enqueue(callback)
scheduler.enqueueKeyed(key, callback)
scheduler.flush()
scheduler.getPendingCount()
scheduler.isDeleted()
scheduler.isPending(key)
```

### `objectPool.*`

```lua
objectPool.acquire()
objectPool.clear()
objectPool.delete()
objectPool.getAvailableCount()
objectPool.getCreatedCount()
objectPool.isDeleted()
objectPool.release(object)
```

### `theme.*`

```lua
theme.delete()
theme.get()
theme.isDeleted()
theme.set(value)
theme.subscribe(callback)
theme.update(updater)
```

### `focusGroup.*`

```lua
focusGroup.add(object)
focusGroup.clear()
focusGroup.delete()
focusGroup.focusFirst()
focusGroup.focusLast()
focusGroup.getItems()
focusGroup.isDeleted()
focusGroup.remove(object)
```

### `animation.*`

```lua
animation.cancel()
animation.delete()
animation.isDeleted()
animation.onCompleted(callback)
animation.play()
```

### `diagnostics.*`

```lua
diagnostics.delete()
diagnostics.get(name)
diagnostics.increment(name, amount)
diagnostics.isDeleted()
diagnostics.reset(name)
diagnostics.resetAll()
diagnostics.snapshot()
```

## Creator-Only Quick Reference

```lua
Reactily.createAttributeAtom
Reactily.createAtom
Reactily.createBillboardGui
Reactily.createBinding
Reactily.createCanvasGroup
Reactily.createComponent
Reactily.createComputed
Reactily.createDiagnostics
Reactily.createElement
Reactily.createFocusGroup
Reactily.createFragment
Reactily.createFrame
Reactily.createHistoryAtom
Reactily.createImageButton
Reactily.createImageLabel
Reactily.createInstancePool
Reactily.createLifecycleOwner
Reactily.createObjectPool
Reactily.createPortal
Reactily.createRoot
Reactily.createScheduler
Reactily.createScreenGui
Reactily.createScrollingFrame
Reactily.createSignal
Reactily.createStore
Reactily.createStyle
Reactily.createSurfaceGui
Reactily.createTextBox
Reactily.createTextButton
Reactily.createTextLabel
Reactily.createTheme
Reactily.createTween
Reactily.createUIAspectRatioConstraint
Reactily.createUICorner
Reactily.createUIGradient
Reactily.createUIGridLayout
Reactily.createUIListLayout
Reactily.createUIPadding
Reactily.createUIPageLayout
Reactily.createUIScale
Reactily.createUISizeConstraint
Reactily.createUIStroke
Reactily.createUITextSizeConstraint
Reactily.createVideoFrame
Reactily.createViewportFrame
```

## Hook-Only Quick Reference

```lua
Reactily.useAttribute
Reactily.useBoolean
Reactily.useCallback
Reactily.useCounter
Reactily.useDebouncedValue
Reactily.useEffect
Reactily.useMemo
Reactily.usePrevious
Reactily.useReducer
Reactily.useRef
Reactily.useState
Reactily.useToggle
```

## Signal / Binding / State Quick Reference

```lua
Reactily.clampBinding
Reactily.combineBindings
Reactily.createAttributeAtom
Reactily.createAtom
Reactily.createBinding
Reactily.createComputed
Reactily.createHistoryAtom
Reactily.createSignal
Reactily.createStore
Reactily.distinctSignal
Reactily.filterSignal
Reactily.formatBinding
Reactily.mapBinding
Reactily.mapSignal
Reactily.mergeSignals
Reactily.roundBinding
Reactily.skipSignal
Reactily.takeSignal
```