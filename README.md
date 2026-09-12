# Reactily API & Usage

> **Version:** `1.0.0`  
> **Language:** Roblox Luau  
> **Type mode:** `--!strict`

Reactily is a typed, React-inspired UI framework for Roblox Luau.

Reactily-owned APIs use dot calls:

```lua
root.render(element)
store.set(nextState)
signal.fire(value)
```

Roblox-owned APIs continue to use Roblox method syntax:

```lua
instance:Destroy()
connection:Disconnect()
```

Generic types are inferred at function call sites. When Luau needs help, annotate the variable:

```lua
local selected: Reactily.signal<number> = Reactily.createSignal()
```

---

# Package

## `Reactily.getVersion()`

Returns the current Reactily version.

```lua
local version = Reactily.getVersion()
print(version)
```

## `Reactily.new(parent)`

Creates a Reactily root. Alias of `Reactily.createRoot()`.

```lua
local root = Reactily.new(playerGui)
```

## `Reactily.createRoot(parent)`

Creates a rendering root under a Roblox Instance.

```lua
local root = Reactily.createRoot(playerGui)

root.render(element)
root.delete()
```

---

# Elements

## `Reactily.createElement(className, props?, children?)`

Creates a generic Roblox host element.

Use the class-specific creators when one is available for better autocomplete.

```lua
local frame = Reactily.createElement("Frame", {
	size = UDim2.fromOffset(300, 200),
	backgroundTransparency = .2,
})
```

## `Reactily.createComponent(component, props, children?, key?)`

Creates a function-component element.

```lua
type panelProps = {
	title: string,
}

local function panel(props: panelProps): Reactily.element
	return Reactily.createTextLabel({
		text = props.title,
	})
end

local element = Reactily.createComponent(panel, {
	title = "Effects",
})
```

## `Reactily.createFragment(children, key?)`

Groups multiple children without adding another Roblox Instance.

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

## `Reactily.createPortal(target, children, key?)`

Renders children into another Roblox Instance.

```lua
local modal = Reactily.createPortal(overlayGui, {
	Reactily.createFrame({
		size = UDim2.fromScale(1, 1),
		backgroundTransparency = .3,
	}),
})
```

---

# Typed UI Creators

All typed creators return a Reactily element and provide class-specific prop autocomplete.

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

### Example

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

# Root API

A root is returned by `Reactily.createRoot()` or `Reactily.new()`.

## `root.render(element?)`

Renders or updates the current interface.

```lua
root.render(element)
```

Unmount the current tree without deleting the root:

```lua
root.render(nil)
```

## `root.batch(callback)`

Groups multiple root updates.

```lua
root.batch(function()
	root.render(firstElement)
	root.render(finalElement)
end)
```

## `root.suspend()`

Pauses rendering updates.

```lua
root.suspend()
```

## `root.resume()`

Resumes a suspended root.

```lua
root.resume()
```

## `root.flush()`

Immediately flushes pending root work.

```lua
root.flush()
```

## `root.getElement()`

Returns the current root element.

```lua
local element = root.getElement()
```

## `root.getParent()`

Returns the Roblox parent owned by the root.

```lua
local parent = root.getParent()
```

## `root.isSuspended()`

Returns whether the root is suspended.

```lua
if root.isSuspended() then
	print("Suspended")
end
```

## `root.isDeleted()`

Returns whether the root was deleted.

```lua
if root.isDeleted() then
	return
end
```

## `root.delete()`

Deletes the root and its owned runtime resources.

```lua
root.delete()
```

---

# Hooks

Hooks are used inside Reactily function components.

## `Reactily.useState(initialValue)`

Creates component state.

```lua
local count, setCount = Reactily.useState(0)

setCount(10)

setCount(function(previous: number): number
	return previous + 1
end)
```

## `Reactily.useReducer(reducer, initialState)`

Creates reducer-based component state.

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

## `Reactily.useRef(initialValue)`

Creates a mutable value that does not request a render when changed.

```lua
local dragging = Reactily.useRef(false)

dragging.current = true
```

## `Reactily.useMemo(factory, dependencies?)`

Memoizes a calculated value.

```lua
local visibleItems = Reactily.useMemo(function()
	return calculateVisibleItems(items)
end, {
	items,
})
```

## `Reactily.useCallback(callback, dependencies?)`

Memoizes a callback.

```lua
local onActivated = Reactily.useCallback(function()
	print(selection)
end, {
	selection,
})
```

## `Reactily.useEffect(callback, dependencies?)`

Runs an effect and optionally returns cleanup.

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

## `Reactily.usePrevious(value)`

Returns the previous rendered value.

```lua
local previousValue = Reactily.usePrevious(currentValue)
```

## `Reactily.useToggle(initialValue?)`

Provides boolean toggle state.

```lua
local open, toggle, setOpen = Reactily.useToggle(false)

toggle()
setOpen(true)
```

## `Reactily.useBoolean(initialValue?)`

Provides boolean state with dedicated controls.

```lua
local enabled, enable, disable, toggle = Reactily.useBoolean(false)

enable()
disable()
toggle()
```

## `Reactily.useCounter(initialValue?)`

Provides number state with counter controls.

```lua
local count, controls = Reactily.useCounter(0)

controls.increment()
controls.increment(5)
controls.decrement()
controls.set(20)
controls.reset()
```

## `Reactily.useDebouncedValue(value, delaySeconds)`

Returns a delayed version of a changing value.

```lua
local query, setQuery = Reactily.useState("")
local debouncedQuery = Reactily.useDebouncedValue(query, .2)
```

## `Reactily.useAttribute(instance, attributeName, defaultValue)`

Synchronizes component state with a Roblox Attribute.

```lua
local enabled, setEnabled = Reactily.useAttribute(
	fixture,
	"enabled",
	true
)

setEnabled(false)
```

---

# Atoms

## `Reactily.createAtom(initialValue)`

Creates standalone state.

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

Delete:

```lua
intensity.delete()
```

## `Reactily.createComputed(source, selector)`

Creates read-only derived atom state.

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

## `Reactily.createHistoryAtom(initialValue, limit)`

Creates atom state with undo and redo history.

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

## `Reactily.createAttributeAtom(instance, attributeName, defaultValue)`

Creates standalone state synchronized with a Roblox Attribute.

```lua
local enabled = Reactily.createAttributeAtom(
	fixture,
	"enabled",
	true
)

enabled.set(false)
enabled.delete()
```

---

# Stores

## `Reactily.createStore(initialState)`

Creates structured application state.

```lua
type panelState = {
	page: string,
	bpm: number,
}

local store: Reactily.store<panelState> = Reactily.createStore({
	page = "Home",
	bpm = .7,
})
```

Read:

```lua
local state = store.get()
```

Set:

```lua
store.set({
	page = "Effects",
	bpm = .7,
})
```

Update:

```lua
store.update(function(previous: panelState): panelState
	return {
		page = "Effects",
		bpm = previous.bpm,
	}
end)
```

Subscribe:

```lua
store.subscribe(function(change)
	print(change.previous, change.current)
end)
```

Reset:

```lua
store.reset()
```

Batch updates:

```lua
store.batch(function()
	store.update(firstUpdate)
	store.update(secondUpdate)
end)
```

Delete:

```lua
store.delete()
```

## `store.select(selector)`

Creates derived store state.

```lua
local page = store.select(function(state: panelState): string
	return state.page
end)

print(page.get())

page.subscribe(function(change)
	print(change.previous, change.current)
end)

page.delete()
```

---

# Bindings

## `Reactily.createBinding(initialValue)`

Creates a mutable binding.

```lua
local intensity = Reactily.createBinding(.5)

intensity.set(.8)

print(intensity.get())
```

Subscribe:

```lua
intensity.subscribe(function(change)
	print(change.previous, change.current)
end)
```

Delete:

```lua
intensity.delete()
```

## `Reactily.mapBinding(source, mapper)`

Creates a derived binding.

```lua
local percentage = Reactily.mapBinding(
	intensity,
	function(value: number): number
		return value * 100
	end
)
```

## `Reactily.combineBindings(first, second, mapper)`

Combines two bindings.

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

## `Reactily.clampBinding(source, minimum, maximum)`

Clamps a numeric binding.

```lua
local normalized = Reactily.clampBinding(intensity, 0, 1)
```

## `Reactily.roundBinding(source, precision)`

Rounds a numeric binding.

```lua
local rounded = Reactily.roundBinding(intensity, 2)
```

## `Reactily.formatBinding(source, formatter)`

Maps a binding to text.

```lua
local label = Reactily.formatBinding(
	intensity,
	function(value: number): string
		return `{math.round(value * 100)}%`
	end
)
```

---

# Signals

## `Reactily.createSignal()`

Creates a typed signal.

```lua
local selected: Reactily.signal<number> = Reactily.createSignal()
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

Connect once:

```lua
selected.once(function(fixtureId: number)
	print(fixtureId)
end)
```

Listener count:

```lua
print(selected.getListenerCount())
```

Delete:

```lua
selected.delete()
```

## `Reactily.mapSignal(source, mapper)`

Maps emitted values.

```lua
local names = Reactily.mapSignal(
	selected,
	function(fixtureId: number): string
		return `Fixture {fixtureId}`
	end
)
```

## `Reactily.filterSignal(source, predicate)`

Emits only values accepted by a predicate.

```lua
local even = Reactily.filterSignal(
	selected,
	function(fixtureId: number): boolean
		return fixtureId % 2 == 0
	end
)
```

## `Reactily.distinctSignal(source)`

Skips consecutive duplicate values.

```lua
local distinct = Reactily.distinctSignal(selected)
```

## `Reactily.mergeSignals(sources)`

Combines multiple signals into one signal.

```lua
local merged = Reactily.mergeSignals({
	firstSignal,
	secondSignal,
})
```

## `Reactily.skipSignal(source, amount)`

Skips the first number of emissions.

```lua
local skipped = Reactily.skipSignal(selected, 2)
```

## `Reactily.takeSignal(source, maximum)`

Emits up to a maximum number of values.

```lua
local firstFive = Reactily.takeSignal(selected, 5)
```

---

# Themes

## `Reactily.createTheme(initialValue)`

Creates theme state.

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

Read and update:

```lua
local tokens = theme.get()

theme.update(function(previous: themeTokens): themeTokens
	return {
		accent = Color3.fromRGB(255, 100, 120),
		background = previous.background,
	}
end)
```

Subscribe:

```lua
theme.subscribe(function(tokens: themeTokens)
	print(tokens.accent)
end)
```

Delete:

```lua
theme.delete()
```

## `Reactily.resolveTheme(theme, selector)`

Immediately selects a value from theme tokens.

```lua
local accent = Reactily.resolveTheme(
	theme,
	function(tokens: themeTokens): Color3
		return tokens.accent
	end
)
```

---

# Styles

## `Reactily.createStyle(styles)`

Merges multiple Reactily style tables.

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

## `Reactily.applyStyle(properties, style)`

Applies a style table to an existing props table.

```lua
local props = Reactily.applyStyle({
	size = UDim2.fromOffset(200, 80),
}, styleValue)

local button = Reactily.createTextButton(props)
```

---

# Animation

## `Reactily.createTween(instance, goals, options)`

Creates an animation without automatically playing it.

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

## `Reactily.playTween(instance, goals, options)`

Creates and immediately plays an animation.

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

## Animation methods

Play:

```lua
animation.play()
```

Cancel:

```lua
animation.cancel()
```

Completion:

```lua
local connection = animation.onCompleted(function(playbackState)
	print(playbackState)
end)
```

Delete:

```lua
animation.delete()
```

Access the Roblox Tween:

```lua
local tween = animation.tween
```

---

# Focus

## `Reactily.createFocusGroup()`

Creates a selectable GUI focus group.

```lua
local focusGroup = Reactily.createFocusGroup()

focusGroup.add(playButton)
focusGroup.add(settingsButton)

focusGroup.focusFirst()
focusGroup.focusLast()
```

Remove:

```lua
focusGroup.remove(settingsButton)
```

Read current items:

```lua
local items = focusGroup.getItems()
```

Clear:

```lua
focusGroup.clear()
```

Delete:

```lua
focusGroup.delete()
```

## `Reactily.clearFocus()`

Clears Roblox GUI selection.

```lua
Reactily.clearFocus()
```

---

# Virtual Lists

## `Reactily.resolveVirtualList(itemCount, itemSize, scrollOffset, viewportSize, overscan?)`

Calculates the visible range for a fixed-height virtualized list.

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

## `Reactily.sliceVirtualList(items, range)`

Returns only the items inside a resolved virtual range.

```lua
local visibleItems = Reactily.sliceVirtualList(items, range)
```

---

# Object Pools

## `Reactily.createObjectPool(createObject, resetObject, deleteObject, maximumSize)`

Creates a reusable object pool.

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

Acquire:

```lua
local object = pool.acquire()
```

Release:

```lua
pool.release(object)
```

Counts:

```lua
print(pool.getAvailableCount())
print(pool.getCreatedCount())
```

Clear:

```lua
pool.clear()
```

Delete:

```lua
pool.delete()
```

## `Reactily.createInstancePool(className, maximumSize)`

Creates a pool of Roblox Instances.

```lua
local pool = Reactily.createInstancePool("Frame", 64)

local frame = pool.acquire()
frame.Parent = playerGui

pool.release(frame)
```

---

# Scheduler

## `Reactily.createScheduler()`

Creates a Reactily scheduler.

```lua
local scheduler = Reactily.createScheduler()
```

## `scheduler.enqueue(callback)`

Queues work and returns its task ID.

```lua
local taskId = scheduler.enqueue(function()
	print("scheduled")
end)
```

## `scheduler.enqueueKeyed(key, callback)`

Queues keyed work.

```lua
scheduler.enqueueKeyed("layout", function()
	rebuildLayout()
end)
```

## `scheduler.cancel(taskId)`

Cancels queued work by task ID.

```lua
scheduler.cancel(taskId)
```

## `scheduler.cancelKey(key)`

Cancels keyed work.

```lua
scheduler.cancelKey("layout")
```

## `scheduler.isPending(key)`

Checks whether a key is queued.

```lua
if scheduler.isPending("layout") then
	print("Layout pending")
end
```

## `scheduler.getPendingCount()`

Returns the number of queued tasks.

```lua
print(scheduler.getPendingCount())
```

## `scheduler.flush()`

Runs pending scheduler work.

```lua
scheduler.flush()
```

## `scheduler.clear()`

Clears pending scheduler work.

```lua
scheduler.clear()
```

## `scheduler.delete()`

Deletes the scheduler.

```lua
scheduler.delete()
```

---

# Diagnostics

## `Reactily.createDiagnostics()`

Creates explicit named counters.

```lua
local diagnostics = Reactily.createDiagnostics()
```

Increment:

```lua
diagnostics.increment("renders")
diagnostics.increment("hostCreates", 5)
```

Read:

```lua
print(diagnostics.get("renders"))
```

Snapshot:

```lua
local values = diagnostics.snapshot()
```

Reset one:

```lua
diagnostics.reset("renders")
```

Reset all:

```lua
diagnostics.resetAll()
```

Delete:

```lua
diagnostics.delete()
```

---

# Lifecycle

## `Reactily.createLifecycleOwner()`

Creates a lifecycle owner for manually owned resources.

```lua
local owner = Reactily.createLifecycleOwner()
```

For normal application code, prefer higher-level Reactily objects that already own their resources.

---

# Common Props Usage

## Keys

Use stable keys for children whose order can change.

```lua
Reactily.createTextButton({
	key = tostring(fixtureId),
	text = fixtureName,
})
```

## Refs

Receive the mounted Roblox Instance.

```lua
local buttonInstance: TextButton? = nil

Reactily.createTextButton({
	ref = function(instance: TextButton?)
		buttonInstance = instance
	end,
})
```

## Attributes

Set Roblox Attributes from props.

```lua
Reactily.createFrame({
	attributes = {
		panelType = "effects",
		fixtureId = 12,
	},
})
```

## Tags

Apply CollectionService tags.

```lua
Reactily.createFrame({
	tags = {
		"[Lily] Interface",
		"[Lily] Panel",
	},
})
```

## Events

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

# Cleanup

Long-lived Reactily-owned objects expose `.delete()`.

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