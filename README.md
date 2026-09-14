# Reactily Reference Overview

Reactily is a typed, React-inspired UI framework for Roblox Luau. This reference documents the APIs you use to describe interfaces, render them into Roblox Instances, manage state, connect reactive values, and own runtime resources.

```lua
local Reactily = require(path.To.Reactily)
```

> **Version:** `1.0.0`

> **Language:** Roblox Luau

> **Type mode:** `--!strict`

> **Package entry:** `src/Reactily.luau`

## Installation

Choose the installation method that best matches your Roblox workflow.

### Git

Clone the repository when you want the full source, version history, and an easy way to pull future updates:

```bash
git clone https://github.com/lily-studios/Reactily.git
cd Reactily
```

To update an existing clone later:

```bash
git pull
```

Use the cloned `src` directory with your normal Roblox development workflow. If your project uses Rojo, map the Reactily source into the location where you keep shared packages, such as `ReplicatedStorage`.

### GitHub Releases

For a stable packaged version, use the latest GitHub release:

[Download the latest Reactily release](https://github.com/lily-studios/Reactily/releases/latest)

Open the release and download the appropriate file from **Assets**. If a Roblox model/package such as an `.rbxm` or `.rbxmx` file is provided, use that for the simplest Roblox Studio installation. If the release only provides a source archive, extract it and use the included Reactily source in your project.

### Download Source Without Git

If you do not want to install Git:

1. Open the [Reactily repository](https://github.com/lily-studios/Reactily).
2. Select **Code**.
3. Select **Download ZIP**.
4. Extract the archive.
5. Add the Reactily source to your Roblox project.

### Roblox Studio

For a downloaded Roblox model/package:

1. Open your experience in Roblox Studio.
2. In **Explorer**, choose where Reactily should live. `ReplicatedStorage` is a common location for a shared UI package.
3. Drag the downloaded `.rbxm` or `.rbxmx` file into Studio.
4. Rename the installed module to `Reactily` if the downloaded package uses a different name.
5. Require the module from your code.

```lua
local replicatedStorage = game:GetService("ReplicatedStorage")

local Reactily = require(replicatedStorage:WaitForChild("Reactily"))
```

If Reactily is installed somewhere else, require it from that location instead.

### Verify the Installation

After requiring Reactily, you can verify the package loaded correctly:

```lua
print(Reactily.getVersion())
```

## Reactily

The Reactily API is organized into functional areas:

- **[Elements and typed creators](#elements)** — Describe Roblox UI as Reactily elements and function components.

- **[Roots](#root-api)** — Render, update, suspend, flush, and delete an interface tree.

- **[Hooks](#hooks)** — Use component-local state, reducers, refs, memoization, effects, and convenience state helpers.

- **[Atoms and stores](#atoms)** — Manage standalone and structured reactive state.

- **[Bindings and signals](#bindings)** — Derive values and react to emitted events.

- **[Themes and styles](#themes)** — Share visual state and compose property tables.

- **[Animation and focus](#animation)** — Drive TweenService-backed animation and GUI selection.

- **[Virtual lists and object pools](#virtual-lists)** — Reduce work for large collections and reusable objects.

- **[Scheduler, diagnostics, and lifecycle](#scheduler)** — Own deferred work, counters, and cleanup explicitly.

- **[Common props and cleanup](#common-props-usage)** — Use keys, refs, Attributes, tags, events, and Reactily lifecycle conventions.

## Quick start

Create a Reactily root, render an element, and delete the root when the interface is permanently removed:

```lua
local root = Reactily.createRoot(playerGui)
root.render(
    Reactily.createTextLabel({
        text = "Hello from Reactily",
        size = UDim2.fromOffset(240, 48),
    })
)
root.delete()
```

## Conventions

### Reactily APIs use dot syntax

Reactily-owned objects expose closure-backed functions and are called with `.`:

```lua
root.render(element)
store.set(nextState)
signal.fire(value)
```

Roblox-owned objects keep Roblox method syntax:

```lua
instance:Destroy()
connection:Disconnect()
```

### Generic types are inferred

Luau usually infers generic types from the value you pass. Add an annotation when the type cannot be inferred clearly:

```lua
local changed: Reactily.signal<number> = Reactily.createSignal()
```

### Change-only updates

Treat unchanged values as unchanged state. Reactily state and reactive APIs are designed so callers can avoid unnecessary downstream work when the resolved value has not changed.
---
## Reference

### Package

#### `Reactily.getVersion()`

```lua
Reactily.getVersion()
```

Returns the current Reactily version.

##### Usage

```lua
local version = Reactily.getVersion()
print(version)
```

#### `Reactily.new(parent)`

```lua
Reactily.new(parent)
```

`Reactily.new` creates a Reactily root. It is an alias of `Reactily.createRoot()`.

##### Usage

```lua
local root = Reactily.new(playerGui)
```

#### `Reactily.createRoot(parent)`

```lua
Reactily.createRoot(parent)
```

`Reactily.createRoot` creates a rendering root under a Roblox `Instance`.

##### Usage

```lua
local root = Reactily.createRoot(playerGui)
root.render(element)
root.delete()
```
---
### Elements

#### `Reactily.createElement(className, props?, children?)`

```lua
Reactily.createElement(className, props?, children?)
```

`Reactily.createElement` creates a generic Roblox host element.

Use the class-specific creators when one is available for better autocomplete.

##### Usage

```lua
local frame = Reactily.createElement("Frame", {
   size = UDim2.fromOffset(300, 200),
   backgroundTransparency = .2,
})
```

#### `Reactily.createComponent(component, props, children?, key?)`

```lua
Reactily.createComponent(component, props, children?, key?)
```

`Reactily.createComponent` creates an element backed by a function component.

##### Usage

```lua
type cardProps = {
   title: string,
}
local function card(props: cardProps): Reactily.element
   return Reactily.createTextLabel({
      text = props.title,
   })
end
local element = Reactily.createComponent(card, {
   title = "Welcome",
})
```

#### `Reactily.createFragment(children, key?)`

```lua
Reactily.createFragment(children, key?)
```

`Reactily.createFragment` groups multiple children without creating another Roblox `Instance`.

##### Usage

```lua
local items = Reactily.createFragment({
   Reactily.createTextLabel({
      text = "One",
   }),
   Reactily.createTextLabel({
      text = "Two",
   }),
})
```

#### `Reactily.createPortal(target, children, key?)`

```lua
Reactily.createPortal(target, children, key?)
```

`Reactily.createPortal` renders children into another Roblox `Instance`.

##### Usage

```lua
local modal = Reactily.createPortal(overlayGui, {
   Reactily.createFrame({
      size = UDim2.fromScale(1, 1),
      backgroundTransparency = .3,
   }),
})
```
---
### Typed UI Creators

Reactily provides class-specific creators for common Roblox UI objects. Each creator returns a Reactily element and gives Luau more specific prop autocomplete than the generic `createElement` API.

| API | Roblox host |
| --- | --- |
| `Reactily.createBillboardGui()` | `BillboardGui` |
| `Reactily.createCanvasGroup()` | `CanvasGroup` |
| `Reactily.createFrame()` | `Frame` |
| `Reactily.createImageButton()` | `ImageButton` |
| `Reactily.createImageLabel()` | `ImageLabel` |
| `Reactily.createScreenGui()` | `ScreenGui` |
| `Reactily.createScrollingFrame()` | `ScrollingFrame` |
| `Reactily.createSurfaceGui()` | `SurfaceGui` |
| `Reactily.createTextBox()` | `TextBox` |
| `Reactily.createTextButton()` | `TextButton` |
| `Reactily.createTextLabel()` | `TextLabel` |
| `Reactily.createUIAspectRatioConstraint()` | `UIAspectRatioConstraint` |
| `Reactily.createUICorner()` | `UICorner` |
| `Reactily.createUIGradient()` | `UIGradient` |
| `Reactily.createUIGridLayout()` | `UIGridLayout` |
| `Reactily.createUIListLayout()` | `UIListLayout` |
| `Reactily.createUIPadding()` | `UIPadding` |
| `Reactily.createUIPageLayout()` | `UIPageLayout` |
| `Reactily.createUIScale()` | `UIScale` |
| `Reactily.createUISizeConstraint()` | `UISizeConstraint` |
| `Reactily.createUIStroke()` | `UIStroke` |
| `Reactily.createUITextSizeConstraint()` | `UITextSizeConstraint` |
| `Reactily.createVideoFrame()` | `VideoFrame` |
| `Reactily.createViewportFrame()` | `ViewportFrame` |

#### Example

```lua
local button = Reactily.createTextButton({
   size = UDim2.fromOffset(180, 50),
   text = "Select",
   textSize = 24,
   onActivated = function()
      print("Selected")
   end,
}, {
   Reactily.createUICorner({
      cornerRadius = UDim.new(0, 8),
   }),
})
```
---
### Root API

A root represents one rendered Reactily tree. Create one with `Reactily.createRoot()` or `Reactily.new()`.

#### `root.render(element?)`

```lua
root.render(element?)
```

Renders or updates the current interface.

##### Usage

```lua
root.render(element)
```

Unmount the current tree without deleting the root:

```lua
root.render(nil)
```

#### `root.batch(callback)`

```lua
root.batch(callback)
```

Groups multiple root updates.

##### Usage

```lua
root.batch(function()
   root.render(firstElement)
   root.render(finalElement)
end)
```

#### `root.suspend()`

```lua
root.suspend()
```

Pauses rendering updates.

##### Usage

```lua
root.suspend()
```

#### `root.resume()`

```lua
root.resume()
```

Resumes a suspended root.

##### Usage

```lua
root.resume()
```

#### `root.flush()`

```lua
root.flush()
```

Immediately flushes pending root work.

##### Usage

```lua
root.flush()
```

#### `root.getElement()`

```lua
root.getElement()
```

Returns the current root element.

##### Usage

```lua
local element = root.getElement()
```

#### `root.getParent()`

```lua
root.getParent()
```

Returns the Roblox parent owned by the root.

##### Usage

```lua
local parent = root.getParent()
```

#### `root.isSuspended()`

```lua
root.isSuspended()
```

Returns whether the root is suspended.

##### Usage

```lua
if root.isSuspended() then
   print("Suspended")
end
```

#### `root.isDeleted()`

```lua
root.isDeleted()
```

Returns whether the root was deleted.

##### Usage

```lua
if root.isDeleted() then
   return
end
```

#### `root.delete()`

```lua
root.delete()
```

Deletes the root and its owned runtime resources.

##### Usage

```lua
root.delete()
```
---
### Hooks

Hooks let function components use Reactily state and lifecycle features. Call Hooks from Reactily function components and keep their call order stable between completed renders.

#### `Reactily.useState(initialValue)`

```lua
Reactily.useState(initialValue)
```

`Reactily.useState` adds state to a Reactily function component.

##### Usage

```lua
local count, setCount = Reactily.useState(0)
setCount(10)
setCount(function(previous: number): number
   return previous + 1
end)
```

#### `Reactily.useReducer(reducer, initialState)`

```lua
Reactily.useReducer(reducer, initialState)
```

`Reactily.useReducer` manages component state with a reducer function.

##### Usage

```lua
type counterState = {
   count: number,
}
type counterAction = {
   type: string,
}
local state, dispatch = Reactily.useReducer(
   function(previous: counterState, action: counterAction): counterState
      if action.type == "increment" then
         return {
            count = previous.count + 1,
         }
      end
      return previous
   end,
   {
      count = 0,
   }
)
dispatch({
   type = "increment",
})
```

#### `Reactily.useRef(initialValue)`

```lua
Reactily.useRef(initialValue)
```

`Reactily.useRef` creates a mutable value that persists without requesting a render when it changes.

##### Usage

```lua
local dragging = Reactily.useRef(false)
dragging.current = true
```

#### `Reactily.useMemo(factory, dependencies?)`

```lua
Reactily.useMemo(factory, dependencies?)
```

`Reactily.useMemo` caches a calculated value until its dependencies change.

##### Usage

```lua
local visibleItems = Reactily.useMemo(function()
   return calculateVisibleItems(items)
end, {
   items,
})
```

#### `Reactily.useCallback(callback, dependencies?)`

```lua
Reactily.useCallback(callback, dependencies?)
```

`Reactily.useCallback` caches a callback until its dependencies change.

##### Usage

```lua
local onActivated = Reactily.useCallback(function()
   print(selection)
end, {
   selection,
})
```

#### `Reactily.useEffect(callback, dependencies?)`

```lua
Reactily.useEffect(callback, dependencies?)
```

`Reactily.useEffect` runs an effect after rendering and may return a cleanup function.

##### Usage

```lua
Reactily.useEffect(function()
   local connection = button.MouseEnter:Connect(function()
      print("hover")
   end)
   return function()
      connection:Disconnect()
   end
end, {
   button,
})
```

#### `Reactily.usePrevious(value)`

```lua
Reactily.usePrevious(value)
```

`Reactily.usePrevious` returns the value from the previous completed render.

##### Usage

```lua
local previousValue = Reactily.usePrevious(currentValue)
```

#### `Reactily.useToggle(initialValue?)`

```lua
Reactily.useToggle(initialValue?)
```

Provides boolean toggle state.

##### Usage

```lua
local open, toggle, setOpen = Reactily.useToggle(false)
toggle()
setOpen(true)
```

#### `Reactily.useBoolean(initialValue?)`

```lua
Reactily.useBoolean(initialValue?)
```

Provides boolean state with dedicated controls.

##### Usage

```lua
local enabled, enable, disable, toggle = Reactily.useBoolean(false)
enable()
disable()
toggle()
```

#### `Reactily.useCounter(initialValue?)`

```lua
Reactily.useCounter(initialValue?)
```

Provides number state with counter controls.

##### Usage

```lua
local count, controls = Reactily.useCounter(0)
controls.increment()
controls.increment(5)
controls.decrement()
controls.set(20)
controls.reset()
```

#### `Reactily.useDebouncedValue(value, delaySeconds)`

```lua
Reactily.useDebouncedValue(value, delaySeconds)
```

Returns a delayed version of a changing value.

##### Usage

```lua
local query, setQuery = Reactily.useState("")
local debouncedQuery = Reactily.useDebouncedValue(query, .2)
```

#### `Reactily.useAttribute(instance, attributeName, defaultValue)`

```lua
Reactily.useAttribute(instance, attributeName, defaultValue)
```

Synchronizes component state with a Roblox Attribute.

##### Usage

```lua
local active, setActive = Reactily.useAttribute(
   instance,
   "active",
   true
)
setActive(false)
```
---
### Atoms

#### `Reactily.createAtom(initialValue)`

```lua
Reactily.createAtom(initialValue)
```

`Reactily.createAtom` creates standalone reactive state.

##### Usage

```lua
local intensity = Reactily.createAtom(.5)
print(intensity.get())
intensity.set(.8)
intensity.update(function(previous: number): number
   return previous + .1
end)
```

Subscribe to changes:

```lua
local connection = intensity.subscribe(function(change)
   print(change.previous, change.current)
end)
```

##### Deleting

```lua
intensity.delete()
```

#### `Reactily.createComputed(source, selector)`

```lua
Reactily.createComputed(source, selector)
```

`Reactily.createComputed` creates read-only state derived from an atom.

##### Usage

```lua
local percentage = Reactily.createComputed(
   intensity,
   function(value: number): string
      return `{math.round(value * 100)}%`
   end
)
print(percentage.get())
percentage.delete()
```

#### `Reactily.createHistoryAtom(initialValue, limit)`

```lua
Reactily.createHistoryAtom(initialValue, limit)
```

Creates atom state with undo and redo history.

##### Usage

```lua
local position = Reactily.createHistoryAtom(Vector2.zero, 100)
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

Clear history:

```lua
position.clearHistory()
```

#### `Reactily.createAttributeAtom(instance, attributeName, defaultValue)`

```lua
Reactily.createAttributeAtom(instance, attributeName, defaultValue)
```

Creates standalone state synchronized with a Roblox Attribute.

##### Usage

```lua
local active = Reactily.createAttributeAtom(
   instance,
   "active",
   true
)
active.set(false)
active.delete()
```
---
### Stores

#### `Reactily.createStore(initialState)`

```lua
Reactily.createStore(initialState)
```

`Reactily.createStore` creates structured application state.

##### Usage

```lua
type appState = {
   page: string,
   count: number,
}
local store: Reactily.store<appState> = Reactily.createStore({
   page = "home",
   count = 0,
})
```

##### Reading the value

```lua
local state = store.get()
```

##### Setting the value

```lua
store.set({
   page = "settings",
   count = 0,
})
```

##### Updating the value

```lua
store.update(function(previous: appState): appState
   return {
      page = "settings",
      count = previous.count,
   }
end)
```

##### Subscribing to changes

```lua
store.subscribe(function(change)
   print(change.previous, change.current)
end)
```

##### Resetting

```lua
store.reset()
```

##### Batching updates

```lua
store.batch(function()
   store.update(firstUpdate)
   store.update(secondUpdate)
end)
```

##### Deleting

```lua
store.delete()
```

#### `store.select(selector)`

```lua
store.select(selector)
```

Creates derived store state.

##### Usage

```lua
local page = store.select(function(state: appState): string
   return state.page
end)
print(page.get())
page.subscribe(function(change)
   print(change.previous, change.current)
end)
page.delete()
```
---
### Bindings

#### `Reactily.createBinding(initialValue)`

```lua
Reactily.createBinding(initialValue)
```

`Reactily.createBinding` creates a mutable reactive binding.

##### Usage

```lua
local intensity = Reactily.createBinding(.5)
intensity.set(.8)
print(intensity.get())
```

##### Subscribing to changes

```lua
intensity.subscribe(function(change)
   print(change.previous, change.current)
end)
```

##### Deleting

```lua
intensity.delete()
```

#### `Reactily.mapBinding(source, mapper)`

```lua
Reactily.mapBinding(source, mapper)
```

Creates a derived binding.

##### Usage

```lua
local percentage = Reactily.mapBinding(
   intensity,
   function(value: number): number
      return value * 100
   end
)
```

#### `Reactily.combineBindings(first, second, mapper)`

```lua
Reactily.combineBindings(first, second, mapper)
```

Combines two bindings.

##### Usage

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

#### `Reactily.clampBinding(source, minimum, maximum)`

```lua
Reactily.clampBinding(source, minimum, maximum)
```

Clamps a numeric binding.

##### Usage

```lua
local normalized = Reactily.clampBinding(intensity, 0, 1)
```

#### `Reactily.roundBinding(source, precision)`

```lua
Reactily.roundBinding(source, precision)
```

Rounds a numeric binding.

##### Usage

```lua
local rounded = Reactily.roundBinding(intensity, 2)
```

#### `Reactily.formatBinding(source, formatter)`

```lua
Reactily.formatBinding(source, formatter)
```

Maps a binding to text.

##### Usage

```lua
local label = Reactily.formatBinding(
   intensity,
   function(value: number): string
      return `{math.round(value * 100)}%`
   end
)
```
---
### Signals

#### `Reactily.createSignal()`

```lua
Reactily.createSignal()
```

`Reactily.createSignal` creates a typed signal.

##### Usage

```lua
local changed: Reactily.signal<number> = Reactily.createSignal()
```

##### Connecting

```lua
local connection = changed.connect(function(value: number)
   print(value)
end)
```

##### Firing the signal

```lua
changed.fire(5)
```

##### Connecting once

```lua
changed.once(function(value: number)
   print(value)
end)
```

##### Reading the listener count

```lua
print(changed.getListenerCount())
```

##### Deleting

```lua
changed.delete()
```

#### `Reactily.mapSignal(source, mapper)`

```lua
Reactily.mapSignal(source, mapper)
```

Maps emitted values.

##### Usage

```lua
local names = Reactily.mapSignal(
   changed,
   function(value: number): string
      return `Value {value}`
   end
)
```

#### `Reactily.filterSignal(source, predicate)`

```lua
Reactily.filterSignal(source, predicate)
```

Emits only values accepted by a predicate.

##### Usage

```lua
local even = Reactily.filterSignal(
   changed,
   function(value: number): boolean
      return value % 2 == 0
   end
)
```

#### `Reactily.distinctSignal(source)`

```lua
Reactily.distinctSignal(source)
```

Skips consecutive duplicate values.

##### Usage

```lua
local distinct = Reactily.distinctSignal(changed)
```

#### `Reactily.mergeSignals(sources)`

```lua
Reactily.mergeSignals(sources)
```

Combines multiple signals into one signal.

##### Usage

```lua
local merged = Reactily.mergeSignals({
   firstSignal,
   secondSignal,
})
```

#### `Reactily.skipSignal(source, amount)`

```lua
Reactily.skipSignal(source, amount)
```

Skips the first number of emissions.

##### Usage

```lua
local skipped = Reactily.skipSignal(changed, 2)
```

#### `Reactily.takeSignal(source, maximum)`

```lua
Reactily.takeSignal(source, maximum)
```

Emits up to a maximum number of values.

##### Usage

```lua
local firstFive = Reactily.takeSignal(changed, 5)
```
---
### Themes

#### `Reactily.createTheme(initialValue)`

```lua
Reactily.createTheme(initialValue)
```

`Reactily.createTheme` creates reactive theme state.

##### Usage

```lua
type themeTokens = {
   accent: Color3,
   background: Color3,
}
local theme: Reactily.theme<themeTokens> = Reactily.createTheme({
   accent = Color3.fromRGB(80, 120, 255),
   background = Color3.fromRGB(24, 24, 28),
})
```

##### Reading and updating

```lua
local tokens = theme.get()
theme.update(function(previous: themeTokens): themeTokens
   return {
      accent = Color3.fromRGB(255, 100, 120),
      background = previous.background,
   }
end)
```

##### Subscribing to changes

```lua
theme.subscribe(function(tokens: themeTokens)
   print(tokens.accent)
end)
```

##### Deleting

```lua
theme.delete()
```

#### `Reactily.resolveTheme(theme, selector)`

```lua
Reactily.resolveTheme(theme, selector)
```

Immediately selects a value from theme tokens.

##### Usage

```lua
local accent = Reactily.resolveTheme(
   theme,
   function(tokens: themeTokens): Color3
      return tokens.accent
   end
)
```
---
### Styles

#### `Reactily.createStyle(styles)`

```lua
Reactily.createStyle(styles)
```

Merges multiple Reactily style tables.

##### Usage

```lua
local baseStyle: Reactily.style = {
   backgroundTransparency = .2,
   borderSizePixel = 0,
}
local selectedStyle: Reactily.style = {
   backgroundColor3 = Color3.fromRGB(60, 90, 180),
}
local styleValue = Reactily.createStyle({
   baseStyle,
   selectedStyle,
})
```

#### `Reactily.applyStyle(properties, style)`

```lua
Reactily.applyStyle(properties, style)
```

Applies a style table to an existing props table.

##### Usage

```lua
local props = Reactily.applyStyle({
   size = UDim2.fromOffset(200, 80),
}, styleValue)
local button = Reactily.createTextButton(props)
```
---
### Animation

#### `Reactily.createTween(instance, goals, options)`

```lua
Reactily.createTween(instance, goals, options)
```

Creates an animation without automatically playing it.

##### Usage

```lua
local animation = Reactily.createTween(
   frame,
   {
      BackgroundTransparency = 0,
   },
   {
      time = .2,
      easingStyle = Enum.EasingStyle.Quad,
      easingDirection = Enum.EasingDirection.Out,
   }
)
animation.play()
```

#### `Reactily.playTween(instance, goals, options)`

```lua
Reactily.playTween(instance, goals, options)
```

Creates and immediately plays an animation.

##### Usage

```lua
local animation = Reactily.playTween(
   frame,
   {
      Position = UDim2.fromScale(.5, .5),
   },
   {
      time = .25,
   }
)
```

#### Animation methods

##### Playing the animation

```lua
animation.play()
```

##### Cancelling the animation

```lua
animation.cancel()
```

##### Listening for completion

```lua
local connection = animation.onCompleted(function(playbackState)
   print(playbackState)
end)
```

##### Deleting

```lua
animation.delete()
```

##### Accessing the Roblox Tween

```lua
local tween = animation.tween
```
---
### Focus

#### `Reactily.createFocusGroup()`

```lua
Reactily.createFocusGroup()
```

Creates a selectable GUI focus group.

##### Usage

```lua
local focusGroup = Reactily.createFocusGroup()
focusGroup.add(playButton)
focusGroup.add(settingsButton)
focusGroup.focusFirst()
focusGroup.focusLast()
```

##### Removing an item

```lua
focusGroup.remove(settingsButton)
```

##### Reading current items

```lua
local items = focusGroup.getItems()
```

##### Clearing

```lua
focusGroup.clear()
```

##### Deleting

```lua
focusGroup.delete()
```

#### `Reactily.clearFocus()`

```lua
Reactily.clearFocus()
```

Clears Roblox GUI selection.

##### Usage

```lua
Reactily.clearFocus()
```
---
### Virtual Lists

#### `Reactily.resolveVirtualList(itemCount, itemSize, scrollOffset, viewportSize, overscan?)`

```lua
Reactily.resolveVirtualList(itemCount, itemSize, scrollOffset, viewportSize, overscan?)
```

Calculates the visible range for a fixed-height virtualized list.

##### Usage

```lua
local range = Reactily.resolveVirtualList(
   5000,
   44,
   scrollingFrame.CanvasPosition.Y,
   scrollingFrame.AbsoluteWindowSize.Y,
   3
)
print(range.first)
print(range.last)
print(range.offset)
print(range.totalSize)
```

#### `Reactily.sliceVirtualList(items, range)`

```lua
Reactily.sliceVirtualList(items, range)
```

Returns only the items inside a resolved virtual range.

##### Usage

```lua
local visibleItems = Reactily.sliceVirtualList(items, range)
```
---
### Object Pools

#### `Reactily.createObjectPool(createObject, resetObject, deleteObject, maximumSize)`

```lua
Reactily.createObjectPool(createObject, resetObject, deleteObject, maximumSize)
```

Creates a reusable object pool.

##### Usage

```lua
type temporaryData = {
   value: number,
}
local pool: Reactily.objectPool<temporaryData> = Reactily.createObjectPool(
   function(): temporaryData
      return {
         value = 0,
      }
   end,
   function(object: temporaryData)
      object.value = 0
   end,
   function(_object: temporaryData)
   end,
   128
)
```

##### Acquiring an object

```lua
local object = pool.acquire()
```

##### Releasing an object

```lua
pool.release(object)
```

##### Reading pool counts

```lua
print(pool.getAvailableCount())
print(pool.getCreatedCount())
```

##### Clearing

```lua
pool.clear()
```

##### Deleting

```lua
pool.delete()
```

#### `Reactily.createInstancePool(className, maximumSize)`

```lua
Reactily.createInstancePool(className, maximumSize)
```

Creates a pool of Roblox Instances.

##### Usage

```lua
local pool = Reactily.createInstancePool("Frame", 64)
local frame = pool.acquire()
frame.Parent = playerGui
pool.release(frame)
```
---
### Scheduler

#### `Reactily.createScheduler()`

```lua
Reactily.createScheduler()
```

`Reactily.createScheduler` creates a scheduler for queued Reactily work.

##### Usage

```lua
local scheduler = Reactily.createScheduler()
```

#### `scheduler.enqueue(callback)`

```lua
scheduler.enqueue(callback)
```

Queues work and returns its task ID.

##### Usage

```lua
local taskId = scheduler.enqueue(function()
   print("scheduled")
end)
```

#### `scheduler.enqueueKeyed(key, callback)`

```lua
scheduler.enqueueKeyed(key, callback)
```

Queues keyed work.

##### Usage

```lua
scheduler.enqueueKeyed("layout", function()
   rebuildLayout()
end)
```

#### `scheduler.cancel(taskId)`

```lua
scheduler.cancel(taskId)
```

Cancels queued work by task ID.

##### Usage

```lua
scheduler.cancel(taskId)
```

#### `scheduler.cancelKey(key)`

```lua
scheduler.cancelKey(key)
```

Cancels keyed work.

##### Usage

```lua
scheduler.cancelKey("layout")
```

#### `scheduler.isPending(key)`

```lua
scheduler.isPending(key)
```

Checks whether a key is queued.

##### Usage

```lua
if scheduler.isPending("layout") then
   print("Layout pending")
end
```

#### `scheduler.getPendingCount()`

```lua
scheduler.getPendingCount()
```

Returns the number of queued tasks.

##### Usage

```lua
print(scheduler.getPendingCount())
```

#### `scheduler.flush()`

```lua
scheduler.flush()
```

Runs pending scheduler work.

##### Usage

```lua
scheduler.flush()
```

#### `scheduler.clear()`

```lua
scheduler.clear()
```

Clears pending scheduler work.

##### Usage

```lua
scheduler.clear()
```

#### `scheduler.delete()`

```lua
scheduler.delete()
```

Deletes the scheduler.

##### Usage

```lua
scheduler.delete()
```
---
### Diagnostics

#### `Reactily.createDiagnostics()`

```lua
Reactily.createDiagnostics()
```

`Reactily.createDiagnostics` creates a collection of explicit named counters.

##### Usage

```lua
local diagnostics = Reactily.createDiagnostics()
```

##### Incrementing a counter

```lua
diagnostics.increment("renders")
diagnostics.increment("hostCreates", 5)
```

##### Reading the value

```lua
print(diagnostics.get("renders"))
```

##### Taking a snapshot

```lua
local values = diagnostics.snapshot()
```

##### Resetting one counter

```lua
diagnostics.reset("renders")
```

##### Resetting all counters

```lua
diagnostics.resetAll()
```

##### Deleting

```lua
diagnostics.delete()
```
---
### Lifecycle

#### `Reactily.createLifecycleOwner()`

```lua
Reactily.createLifecycleOwner()
```

`Reactily.createLifecycleOwner` creates a lifecycle owner for manually owned resources.

##### Usage

```lua
local owner = Reactily.createLifecycleOwner()
```

For normal application code, prefer higher-level Reactily objects that already own their resources.
---
### Common Props Usage

#### Keys

Use stable keys for children whose order can change.

```lua
Reactily.createTextButton({
   key = tostring(itemId),
   text = itemName,
})
```

#### Refs

Receive the mounted Roblox Instance.

```lua
local buttonInstance: TextButton? = nil
Reactily.createTextButton({
   ref = function(instance: TextButton?)
      buttonInstance = instance
   end,
})
```

#### Attributes

Set Roblox Attributes from props.

```lua
Reactily.createFrame({
   attributes = {
      role = "content",
      itemId = 12,
   },
})
```

#### Tags

Apply CollectionService tags.

```lua
Reactily.createFrame({
   tags = {
      "Interface",
      "Interactive",
   },
})
```

#### Events

Use `on...` props for supported Roblox events.

```lua
Reactily.createTextButton({
   onActivated = function()
      print("Activated")
   end,
   onMouseEnter = function()
      print("Hover")
   end,
})
```
---
### Cleanup

Reactily-owned runtime objects expose `.delete()` when they own resources that may outlive a single call. Delete them when their owning scope ends.

```lua
root.delete()
atom.delete()
store.delete()
binding.delete()
signal.delete()
theme.delete()
animation.delete()
focusGroup.delete()
scheduler.delete()
objectPool.delete()
diagnostics.delete()
```

Connections returned by Reactily signals use `.disconnect()`:

```lua
connection.disconnect()
```

Roblox connections continue to use `:Disconnect()`:

```lua
robloxConnection:Disconnect()
```
---
## All References

This index lists every public API documented in this reference.

### Package

- [`Reactily.getVersion()`](#reactilygetversion)

- [`Reactily.new(parent)`](#reactilynewparent)

- [`Reactily.createRoot(parent)`](#reactilycreaterootparent)

### Elements

- [`Reactily.createElement(className, props?, children?)`](#reactilycreateelementclassname-props-children)

- [`Reactily.createComponent(component, props, children?, key?)`](#reactilycreatecomponentcomponent-props-children-key)

- [`Reactily.createFragment(children, key?)`](#reactilycreatefragmentchildren-key)

- [`Reactily.createPortal(target, children, key?)`](#reactilycreateportaltarget-children-key)

### Typed UI Creators

- [`Reactily.createBillboardGui`](#typed-ui-creators)

- [`Reactily.createCanvasGroup`](#typed-ui-creators)

- [`Reactily.createFrame`](#typed-ui-creators)

- [`Reactily.createImageButton`](#typed-ui-creators)

- [`Reactily.createImageLabel`](#typed-ui-creators)

- [`Reactily.createScreenGui`](#typed-ui-creators)

- [`Reactily.createScrollingFrame`](#typed-ui-creators)

- [`Reactily.createSurfaceGui`](#typed-ui-creators)

- [`Reactily.createTextBox`](#typed-ui-creators)

- [`Reactily.createTextButton`](#typed-ui-creators)

- [`Reactily.createTextLabel`](#typed-ui-creators)

- [`Reactily.createUIAspectRatioConstraint`](#typed-ui-creators)

- [`Reactily.createUICorner`](#typed-ui-creators)

- [`Reactily.createUIGradient`](#typed-ui-creators)

- [`Reactily.createUIGridLayout`](#typed-ui-creators)

- [`Reactily.createUIListLayout`](#typed-ui-creators)

- [`Reactily.createUIPadding`](#typed-ui-creators)

- [`Reactily.createUIPageLayout`](#typed-ui-creators)

- [`Reactily.createUIScale`](#typed-ui-creators)

- [`Reactily.createUISizeConstraint`](#typed-ui-creators)

- [`Reactily.createUIStroke`](#typed-ui-creators)

- [`Reactily.createUITextSizeConstraint`](#typed-ui-creators)

- [`Reactily.createVideoFrame`](#typed-ui-creators)

- [`Reactily.createViewportFrame`](#typed-ui-creators)

### Root API

- [`root.render(element?)`](#rootrenderelement)

- [`root.batch(callback)`](#rootbatchcallback)

- [`root.suspend()`](#rootsuspend)

- [`root.resume()`](#rootresume)

- [`root.flush()`](#rootflush)

- [`root.getElement()`](#rootgetelement)

- [`root.getParent()`](#rootgetparent)

- [`root.isSuspended()`](#rootissuspended)

- [`root.isDeleted()`](#rootisdeleted)

- [`root.delete()`](#rootdelete)

### Hooks

- [`Reactily.useState(initialValue)`](#reactilyusestateinitialvalue)

- [`Reactily.useReducer(reducer, initialState)`](#reactilyusereducerreducer-initialstate)

- [`Reactily.useRef(initialValue)`](#reactilyuserefinitialvalue)

- [`Reactily.useMemo(factory, dependencies?)`](#reactilyusememofactory-dependencies)

- [`Reactily.useCallback(callback, dependencies?)`](#reactilyusecallbackcallback-dependencies)

- [`Reactily.useEffect(callback, dependencies?)`](#reactilyuseeffectcallback-dependencies)

- [`Reactily.usePrevious(value)`](#reactilyusepreviousvalue)

- [`Reactily.useToggle(initialValue?)`](#reactilyusetoggleinitialvalue)

- [`Reactily.useBoolean(initialValue?)`](#reactilyusebooleaninitialvalue)

- [`Reactily.useCounter(initialValue?)`](#reactilyusecounterinitialvalue)

- [`Reactily.useDebouncedValue(value, delaySeconds)`](#reactilyusedebouncedvaluevalue-delayseconds)

- [`Reactily.useAttribute(instance, attributeName, defaultValue)`](#reactilyuseattributeinstance-attributename-defaultvalue)

### Atoms

- [`Reactily.createAtom(initialValue)`](#reactilycreateatominitialvalue)

- [`Reactily.createComputed(source, selector)`](#reactilycreatecomputedsource-selector)

- [`Reactily.createHistoryAtom(initialValue, limit)`](#reactilycreatehistoryatominitialvalue-limit)

- [`Reactily.createAttributeAtom(instance, attributeName, defaultValue)`](#reactilycreateattributeatominstance-attributename-defaultvalue)

### Stores

- [`Reactily.createStore(initialState)`](#reactilycreatestoreinitialstate)

- [`store.select(selector)`](#storeselectselector)

### Bindings

- [`Reactily.createBinding(initialValue)`](#reactilycreatebindinginitialvalue)

- [`Reactily.mapBinding(source, mapper)`](#reactilymapbindingsource-mapper)

- [`Reactily.combineBindings(first, second, mapper)`](#reactilycombinebindingsfirst-second-mapper)

- [`Reactily.clampBinding(source, minimum, maximum)`](#reactilyclampbindingsource-minimum-maximum)

- [`Reactily.roundBinding(source, precision)`](#reactilyroundbindingsource-precision)

- [`Reactily.formatBinding(source, formatter)`](#reactilyformatbindingsource-formatter)

### Signals

- [`Reactily.createSignal()`](#reactilycreatesignal)

- [`Reactily.mapSignal(source, mapper)`](#reactilymapsignalsource-mapper)

- [`Reactily.filterSignal(source, predicate)`](#reactilyfiltersignalsource-predicate)

- [`Reactily.distinctSignal(source)`](#reactilydistinctsignalsource)

- [`Reactily.mergeSignals(sources)`](#reactilymergesignalssources)

- [`Reactily.skipSignal(source, amount)`](#reactilyskipsignalsource-amount)

- [`Reactily.takeSignal(source, maximum)`](#reactilytakesignalsource-maximum)

### Themes

- [`Reactily.createTheme(initialValue)`](#reactilycreatethemeinitialvalue)

- [`Reactily.resolveTheme(theme, selector)`](#reactilyresolvethemetheme-selector)

### Styles

- [`Reactily.createStyle(styles)`](#reactilycreatestylestyles)

- [`Reactily.applyStyle(properties, style)`](#reactilyapplystyleproperties-style)

### Animation

- [`Reactily.createTween(instance, goals, options)`](#reactilycreatetweeninstance-goals-options)

- [`Reactily.playTween(instance, goals, options)`](#reactilyplaytweeninstance-goals-options)

### Focus

- [`Reactily.createFocusGroup()`](#reactilycreatefocusgroup)

- [`Reactily.clearFocus()`](#reactilyclearfocus)

### Virtual Lists

- [`Reactily.resolveVirtualList(itemCount, itemSize, scrollOffset, viewportSize, overscan?)`](#reactilyresolvevirtuallistitemcount-itemsize-scrolloffset-viewportsize-overscan)

- [`Reactily.sliceVirtualList(items, range)`](#reactilyslicevirtuallistitems-range)

### Object Pools

- [`Reactily.createObjectPool(createObject, resetObject, deleteObject, maximumSize)`](#reactilycreateobjectpoolcreateobject-resetobject-deleteobject-maximumsize)

- [`Reactily.createInstancePool(className, maximumSize)`](#reactilycreateinstancepoolclassname-maximumsize)

### Scheduler

- [`Reactily.createScheduler()`](#reactilycreatescheduler)

- [`scheduler.enqueue(callback)`](#schedulerenqueuecallback)

- [`scheduler.enqueueKeyed(key, callback)`](#schedulerenqueuekeyedkey-callback)

- [`scheduler.cancel(taskId)`](#schedulercanceltaskid)

- [`scheduler.cancelKey(key)`](#schedulercancelkeykey)

- [`scheduler.isPending(key)`](#schedulerispendingkey)

- [`scheduler.getPendingCount()`](#schedulergetpendingcount)

- [`scheduler.flush()`](#schedulerflush)

- [`scheduler.clear()`](#schedulerclear)

- [`scheduler.delete()`](#schedulerdelete)

### Diagnostics

- [`Reactily.createDiagnostics()`](#reactilycreatediagnostics)

### Lifecycle

- [`Reactily.createLifecycleOwner()`](#reactilycreatelifecycleowner)

### Root methods

- `root.batch(callback)`

- `root.delete()`

- `root.flush()`

- `root.getElement()`

- `root.getParent()`

- `root.isDeleted()`

- `root.isSuspended()`

- `root.render(element?)`

- `root.resume()`

- `root.suspend()`

### Store and selector methods

- `store.select(selector)`

### Scheduler methods

- `scheduler.cancel(taskId)`

- `scheduler.cancelKey(key)`

- `scheduler.clear()`

- `scheduler.delete()`

- `scheduler.enqueue(callback)`

- `scheduler.enqueueKeyed(key, callback)`

- `scheduler.flush()`

- `scheduler.getPendingCount()`

- `scheduler.isPending(key)`
