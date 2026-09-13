--!strict

-- exposes the public Reactily API

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

local version = "1.0.0"

--————————————————————————————————————————————————————————————————————--

local animationModule = require(script.runtime.animation)
local atomModule = require(script.state.atom)
local bindingModule = require(script.runtime.binding)
local diagnosticsModule = require(script.diagnostics.diagnostics)
local elementModule = require(script.virtual.element)
local focusModule = require(script.interface.focus)
local hooksModule = require(script.state.hooks)
local lifecycleModule = require(script.core.lifecycle)
local objectPoolModule = require(script.core.objectPool)
local rootModule = require(script.runtime.root)
local schedulerModule = require(script.core.scheduler)
local signalModule = require(script.core.signal)
local storeModule = require(script.state.store)
local styleModule = require(script.interface.style)
local themeModule = require(script.interface.theme)
local virtualListModule = require(script.interface.virtualList)

--————————————————————————————————————————————————————————————————————--

export type animation = animationModule.animation
export type atom<T> = atomModule.atom<T>
export type atomChange<T> = atomModule.atomChange<T>
export type attributeMap = elementModule.attributeMap
export type attributeValue = elementModule.attributeValue
export type billboardGuiProps = elementModule.billboardGuiProps
export type binding<T> = bindingModule.binding<T>
export type bindingChange<T> = bindingModule.bindingChange<T>
export type buttonEvents = elementModule.buttonEvents
export type canvasGroupProps = elementModule.canvasGroupProps
export type commonGuiProps<T> = elementModule.commonGuiProps<T>
export type component<P> = elementModule.component<P>
export type computed<T> = atomModule.computed<T>
export type connection = signalModule.connection
export type counterControls = hooksModule.counterControls
export type diagnostics = diagnosticsModule.diagnostics
export type element = elementModule.element
export type focusGroup = focusModule.focusGroup
export type frameProps = elementModule.frameProps
export type historyAtom<T> = atomModule.historyAtom<T>
export type hostMetadataProps<T> = elementModule.hostMetadataProps<T>
export type imageButtonProps = elementModule.imageButtonProps
export type imageLabelProps = elementModule.imageLabelProps
export type imageProps = elementModule.imageProps
export type lifecycleOwner = lifecycleModule.owner
export type objectPool<T> = objectPoolModule.objectPool<T>
export type reducerDispatch<A> = hooksModule.reducerDispatch<A>
export type ref<T> = hooksModule.ref<T>
export type root = rootModule.root
export type scheduler = schedulerModule.scheduler
export type screenGuiProps = elementModule.screenGuiProps
export type scrollingFrameProps = elementModule.scrollingFrameProps
export type selector<T> = storeModule.selector<T>
export type signal<T> = signalModule.signal<T>
export type stateSetter<T> = hooksModule.stateSetter<T>
export type store<T> = storeModule.store<T>
export type storeChange<T> = storeModule.storeChange<T>
export type style = styleModule.style
export type surfaceGuiProps = elementModule.surfaceGuiProps
export type textBoxProps = elementModule.textBoxProps
export type textButtonProps = elementModule.textButtonProps
export type textLabelProps = elementModule.textLabelProps
export type textProps = elementModule.textProps
export type theme<T> = themeModule.theme<T>
export type tweenOptions = animationModule.tweenOptions
export type uiAspectRatioConstraintProps = elementModule.uiAspectRatioConstraintProps
export type uiCornerProps = elementModule.uiCornerProps
export type uiGradientProps = elementModule.uiGradientProps
export type uiGridLayoutProps = elementModule.uiGridLayoutProps
export type uiListLayoutProps = elementModule.uiListLayoutProps
export type uiPaddingProps = elementModule.uiPaddingProps
export type uiPageLayoutProps = elementModule.uiPageLayoutProps
export type uiScaleProps = elementModule.uiScaleProps
export type uiSizeConstraintProps = elementModule.uiSizeConstraintProps
export type uiStrokeProps = elementModule.uiStrokeProps
export type uiTextSizeConstraintProps = elementModule.uiTextSizeConstraintProps
export type videoFrameProps = elementModule.videoFrameProps
export type viewportFrameProps = elementModule.viewportFrameProps
export type virtualRange = virtualListModule.range

--————————————————————————————————————————————————————————————————————--

--- Applies a style to a cloned property table.
--- Style values override matching property values.
--- @param properties T Source properties to clone.
--- @param styleValue style Style values to apply.
--- @return T Styled property table.
function module.applyStyle<T>(properties: T, styleValue: style): T
	return styleModule.apply(properties, styleValue)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a numeric binding clamped between a minimum and maximum.
--- @param source binding<number> Source numeric binding.
--- @param minimum number Minimum allowed value.
--- @param maximum number Maximum allowed value.
--- @return binding<number> Derived clamped binding.
function module.clampBinding(
	source: binding<number>,
	minimum: number,
	maximum: number
): binding<number>
	return bindingModule.clamp(source, minimum, maximum)
end

--————————————————————————————————————————————————————————————————————--

--- Clears the current Reactily GUI selection.
function module.clearFocus()
	focusModule.clearSelection()
end

--————————————————————————————————————————————————————————————————————--

--- Combines two bindings into one derived binding.
--- @param first binding<A> First source binding.
--- @param second binding<B> Second source binding.
--- @param mapper (firstValue: A, secondValue: B) -> R Function that derives the output value.
--- @return binding<R> Derived binding updated when either source changes.
function module.combineBindings<A, B, R>(
	first: binding<A>,
	second: binding<B>,
	mapper: (firstValue: A, secondValue: B) -> R
): binding<R>
	return bindingModule.combine(first, second, mapper)
end

--————————————————————————————————————————————————————————————————————--

--- Creates an atom synchronized with a Roblox Attribute.
--- @param instance Instance Instance containing the Attribute.
--- @param attributeName string Attribute name to synchronize.
--- @param defaultValue T Value used when the Attribute does not exist.
--- @return atom<T> Attribute-backed atom.
function module.createAttributeAtom<T>(
	instance: Instance,
	attributeName: string,
	defaultValue: T
): atom<T>
	return atomModule.fromAttribute(instance, attributeName, defaultValue)
end

--————————————————————————————————————————————————————————————————————--

--- Creates reactive standalone state.
--- @param initialValue T Initial atom value.
--- @return atom<T> A new atom.
function module.createAtom<T>(initialValue: T): atom<T>
	return atomModule.new(initialValue)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed BillboardGui element.
--- @param props billboardGuiProps? BillboardGui props.
--- @param children {element}? Child Reactily elements.
--- @return element A BillboardGui host element.
function module.createBillboardGui(
	props: billboardGuiProps?,
	children: {element}?
): element
	return elementModule.createBillboardGui(props, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a reactive binding.
--- @param initialValue T Initial binding value.
--- @return binding<T> A new binding.
function module.createBinding<T>(initialValue: T): binding<T>
	return bindingModule.new(initialValue)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed CanvasGroup element.
--- @param props canvasGroupProps? CanvasGroup props.
--- @param children {element}? Child Reactily elements.
--- @return element A CanvasGroup host element.
function module.createCanvasGroup(
	props: canvasGroupProps?,
	children: {element}?
): element
	return elementModule.createCanvasGroup(props, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a function component element.
--- @param componentValue component<P> Component function to render.
--- @param props P Props passed to the component.
--- @param children {element}? Child elements associated with the component.
--- @param key string? Stable reconciliation key.
--- @return element A component element.
function module.createComponent<P>(
	componentValue: component<P>,
	props: P,
	children: {element}?,
	key: string?
): element
	return elementModule.createComponent(
		componentValue,
		props,
		children,
		key
	)
end

--————————————————————————————————————————————————————————————————————--

--- Creates read-only derived state from an atom.
--- @param source atom<A> Source atom to observe.
--- @param selectorFunction (value: A) -> B Function that derives the output value.
--- @return computed<B> Derived computed atom.
function module.createComputed<A, B>(
	source: atom<A>,
	selectorFunction: (value: A) -> B
): computed<B>
	return atomModule.computed(source, selectorFunction)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a diagnostic counter collection.
--- @return diagnostics A new diagnostics object.
function module.createDiagnostics(): diagnostics
	return diagnosticsModule.new()
end

--————————————————————————————————————————————————————————————————————--

--- Creates a generic Roblox host element.
--- Prefer class-specific creators when available for stronger prop autocomplete.
--- @param className string Roblox class name.
--- @param props elementModule.genericProps? Generic host props.
--- @param children {element}? Child Reactily elements.
--- @return element A generic host element.
function module.createElement(
	className: string,
	props: elementModule.genericProps?,
	children: {element}?
): element
	return elementModule.createElement(className, props, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a grouped GUI focus controller.
--- @return focusGroup A new focus group.
function module.createFocusGroup(): focusGroup
	return focusModule.new()
end

--————————————————————————————————————————————————————————————————————--

--- Creates a fragment without adding a Roblox Instance.
--- @param children {element} Child Reactily elements.
--- @param key string? Stable reconciliation key.
--- @return element A fragment element.
function module.createFragment(
	children: {element},
	key: string?
): element
	return elementModule.createFragment(children, key)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed Frame element.
--- @param props frameProps? Frame props.
--- @param children {element}? Child Reactily elements.
--- @return element A Frame host element.
function module.createFrame(
	props: frameProps?,
	children: {element}?
): element
	return elementModule.createFrame(props, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates an atom with bounded undo and redo history.
--- @param initialValue T Initial atom value.
--- @param limit number Maximum number of past values retained.
--- @return historyAtom<T> History-enabled atom.
function module.createHistoryAtom<T>(
	initialValue: T,
	limit: number
): historyAtom<T>
	return atomModule.history(initialValue, limit)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed ImageButton element.
--- @param props imageButtonProps? ImageButton props.
--- @param children {element}? Child Reactily elements.
--- @return element An ImageButton host element.
function module.createImageButton(
	props: imageButtonProps?,
	children: {element}?
): element
	return elementModule.createImageButton(props, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed ImageLabel element.
--- @param props imageLabelProps? ImageLabel props.
--- @param children {element}? Child Reactily elements.
--- @return element An ImageLabel host element.
function module.createImageLabel(
	props: imageLabelProps?,
	children: {element}?
): element
	return elementModule.createImageLabel(props, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a bounded reusable pool for Roblox Instances.
--- @param className string Roblox class name used by Instance.new().
--- @param maximumSize number Maximum number of inactive Instances retained.
--- @return objectPool<Instance> A new Instance object pool.
function module.createInstancePool(
	className: string,
	maximumSize: number
): objectPool<Instance>
	return objectPoolModule.instance(className, maximumSize)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a lifecycle owner for cleanup-managed resources.
--- @return lifecycleOwner A new lifecycle owner.
function module.createLifecycleOwner(): lifecycleOwner
	return lifecycleModule.new()
end

--————————————————————————————————————————————————————————————————————--

--- Creates a bounded reusable object pool.
--- @param createObject () -> T Creates a new object when none is retained.
--- @param resetObject (object: T) -> () Resets an object before retention.
--- @param deleteObject (object: T) -> () Permanently deletes an object.
--- @param maximumSize number Maximum number of inactive objects retained.
--- @return objectPool<T> A new object pool.
function module.createObjectPool<T>(
	createObject: () -> T,
	resetObject: (object: T) -> (),
	deleteObject: (object: T) -> (),
	maximumSize: number
): objectPool<T>
	return objectPoolModule.new(
		createObject,
		resetObject,
		deleteObject,
		maximumSize
	)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a portal that renders children under another Roblox Instance.
--- @param target Instance Parent that receives the portal children.
--- @param children {element} Child Reactily elements.
--- @param key string? Stable reconciliation key.
--- @return element A portal element.
function module.createPortal(
	target: Instance,
	children: {element},
	key: string?
): element
	return elementModule.createPortal(target, children, key)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a Reactily rendering root.
--- @param parent Instance Roblox parent that receives rendered hosts.
--- @return root A new rendering root.
function module.createRoot(parent: Instance): root
	return rootModule.new(parent)
end

--————————————————————————————————————————————————————————————————————--

--- Creates an idle-safe one-shot scheduler.
--- @return scheduler A new scheduler.
function module.createScheduler(): scheduler
	return schedulerModule.new()
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed ScreenGui element.
--- @param props screenGuiProps? ScreenGui props.
--- @param children {element}? Child Reactily elements.
--- @return element A ScreenGui host element.
function module.createScreenGui(
	props: screenGuiProps?,
	children: {element}?
): element
	return elementModule.createScreenGui(props, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed ScrollingFrame element.
--- @param props scrollingFrameProps? ScrollingFrame props.
--- @param children {element}? Child Reactily elements.
--- @return element A ScrollingFrame host element.
function module.createScrollingFrame(
	props: scrollingFrameProps?,
	children: {element}?
): element
	return elementModule.createScrollingFrame(props, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed Reactily signal.
--- @return signal<T> A new signal.
function module.createSignal<T>(): signal<T>
	return signalModule.new()
end

--————————————————————————————————————————————————————————————————————--

--- Creates a reactive store.
--- @param initialState T Initial store state.
--- @return store<T> A new store.
function module.createStore<T>(initialState: T): store<T>
	return storeModule.new(initialState)
end

--————————————————————————————————————————————————————————————————————--

--- Merges styles into one style value.
--- Later styles override earlier values.
--- @param styles {style} Styles to merge in order.
--- @return style Merged style.
function module.createStyle(styles: {style}): style
	return styleModule.merge(styles)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed SurfaceGui element.
--- @param props surfaceGuiProps? SurfaceGui props.
--- @param children {element}? Child Reactily elements.
--- @return element A SurfaceGui host element.
function module.createSurfaceGui(
	props: surfaceGuiProps?,
	children: {element}?
): element
	return elementModule.createSurfaceGui(props, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed TextBox element.
--- @param props textBoxProps? TextBox props.
--- @param children {element}? Child Reactily elements.
--- @return element A TextBox host element.
function module.createTextBox(
	props: textBoxProps?,
	children: {element}?
): element
	return elementModule.createTextBox(props, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed TextButton element.
--- @param props textButtonProps? TextButton props.
--- @param children {element}? Child Reactily elements.
--- @return element A TextButton host element.
function module.createTextButton(
	props: textButtonProps?,
	children: {element}?
): element
	return elementModule.createTextButton(props, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed TextLabel element.
--- @param props textLabelProps? TextLabel props.
--- @param children {element}? Child Reactily elements.
--- @return element A TextLabel host element.
function module.createTextLabel(
	props: textLabelProps?,
	children: {element}?
): element
	return elementModule.createTextLabel(props, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates reactive theme state.
--- @param initialValue T Initial theme value or token table.
--- @return theme<T> A new theme object.
function module.createTheme<T>(initialValue: T): theme<T>
	return themeModule.new(initialValue)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a TweenService-backed animation without playing it automatically.
--- @param instance Instance Instance whose properties will be animated.
--- @param goals {[string]: any} Target property values.
--- @param options tweenOptions Tween duration and playback options.
--- @return animation A new Reactily animation.
function module.createTween(
	instance: Instance,
	goals: {[string]: any},
	options: tweenOptions
): animation
	return animationModule.tween(instance, goals, options)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed UIAspectRatioConstraint element.
--- @param props uiAspectRatioConstraintProps? Constraint props.
--- @return element A UIAspectRatioConstraint host element.
function module.createUIAspectRatioConstraint(
	props: uiAspectRatioConstraintProps?
): element
	return elementModule.createUIAspectRatioConstraint(props)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed UICorner element.
--- @param props uiCornerProps? UICorner props.
--- @return element A UICorner host element.
function module.createUICorner(
	props: uiCornerProps?
): element
	return elementModule.createUICorner(props)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed UIGradient element.
--- @param props uiGradientProps? UIGradient props.
--- @return element A UIGradient host element.
function module.createUIGradient(
	props: uiGradientProps?
): element
	return elementModule.createUIGradient(props)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed UIGridLayout element.
--- @param props uiGridLayoutProps? UIGridLayout props.
--- @return element A UIGridLayout host element.
function module.createUIGridLayout(
	props: uiGridLayoutProps?
): element
	return elementModule.createUIGridLayout(props)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed UIListLayout element.
--- @param props uiListLayoutProps? UIListLayout props.
--- @return element A UIListLayout host element.
function module.createUIListLayout(
	props: uiListLayoutProps?
): element
	return elementModule.createUIListLayout(props)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed UIPadding element.
--- @param props uiPaddingProps? UIPadding props.
--- @return element A UIPadding host element.
function module.createUIPadding(
	props: uiPaddingProps?
): element
	return elementModule.createUIPadding(props)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed UIPageLayout element.
--- @param props uiPageLayoutProps? UIPageLayout props.
--- @return element A UIPageLayout host element.
function module.createUIPageLayout(
	props: uiPageLayoutProps?
): element
	return elementModule.createUIPageLayout(props)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed UIScale element.
--- @param props uiScaleProps? UIScale props.
--- @return element A UIScale host element.
function module.createUIScale(
	props: uiScaleProps?
): element
	return elementModule.createUIScale(props)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed UISizeConstraint element.
--- @param props uiSizeConstraintProps? Constraint props.
--- @return element A UISizeConstraint host element.
function module.createUISizeConstraint(
	props: uiSizeConstraintProps?
): element
	return elementModule.createUISizeConstraint(props)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed UIStroke element.
--- @param props uiStrokeProps? UIStroke props.
--- @return element A UIStroke host element.
function module.createUIStroke(
	props: uiStrokeProps?
): element
	return elementModule.createUIStroke(props)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed UITextSizeConstraint element.
--- @param props uiTextSizeConstraintProps? Constraint props.
--- @return element A UITextSizeConstraint host element.
function module.createUITextSizeConstraint(
	props: uiTextSizeConstraintProps?
): element
	return elementModule.createUITextSizeConstraint(props)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed VideoFrame element.
--- @param props videoFrameProps? VideoFrame props.
--- @param children {element}? Child Reactily elements.
--- @return element A VideoFrame host element.
function module.createVideoFrame(
	props: videoFrameProps?,
	children: {element}?
): element
	return elementModule.createVideoFrame(props, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed ViewportFrame element.
--- @param props viewportFrameProps? ViewportFrame props.
--- @param children {element}? Child Reactily elements.
--- @return element A ViewportFrame host element.
function module.createViewportFrame(
	props: viewportFrameProps?,
	children: {element}?
): element
	return elementModule.createViewportFrame(props, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a signal that suppresses consecutive duplicate values.
--- @param source signal<T> Source signal.
--- @return signal<T> Derived distinct signal.
function module.distinctSignal<T>(
	source: signal<T>
): signal<T>
	return signalModule.distinct(source)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a signal that forwards values accepted by a predicate.
--- @param source signal<T> Source signal.
--- @param predicate (value: T) -> boolean Function deciding whether each value is forwarded.
--- @return signal<T> Derived filtered signal.
function module.filterSignal<T>(
	source: signal<T>,
	predicate: (value: T) -> boolean
): signal<T>
	return signalModule.filter(source, predicate)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a string binding from another binding.
--- @param source binding<T> Source binding.
--- @param formatter (value: T) -> string Function that formats each value.
--- @return binding<string> Derived formatted binding.
function module.formatBinding<T>(
	source: binding<T>,
	formatter: (value: T) -> string
): binding<string>
	return bindingModule.format(source, formatter)
end

--————————————————————————————————————————————————————————————————————--

--- Returns the current Reactily package version.
--- @return string Semantic version string.
function module.getVersion(): string
	return version
end

--————————————————————————————————————————————————————————————————————--

--- Creates a binding by mapping values from another binding.
--- @param source binding<A> Source binding.
--- @param mapper (value: A) -> B Function that transforms source values.
--- @return binding<B> Derived mapped binding.
function module.mapBinding<A, B>(
	source: binding<A>,
	mapper: (value: A) -> B
): binding<B>
	return bindingModule.map(source, mapper)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a signal by mapping values from another signal.
--- @param source signal<A> Source signal.
--- @param mapper (value: A) -> B Function that transforms source values.
--- @return signal<B> Derived mapped signal.
function module.mapSignal<A, B>(
	source: signal<A>,
	mapper: (value: A) -> B
): signal<B>
	return signalModule.map(source, mapper)
end

--————————————————————————————————————————————————————————————————————--

--- Merges multiple signals into one output signal.
--- @param sources {signal<T>} Source signals to merge.
--- @return signal<T> Signal forwarding values from every source.
function module.mergeSignals<T>(
	sources: {signal<T>}
): signal<T>
	return signalModule.merge(sources)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a Reactily rendering root.
--- @param parent Instance Roblox parent that receives rendered hosts.
--- @return root A new rendering root.
function module.new(parent: Instance): root
	return rootModule.new(parent)
end

--————————————————————————————————————————————————————————————————————--

--- Creates and immediately plays a TweenService-backed animation.
--- @param instance Instance Instance whose properties will be animated.
--- @param goals {[string]: any} Target property values.
--- @param options tweenOptions Tween duration and playback options.
--- @return animation The active Reactily animation.
function module.playTween(
	instance: Instance,
	goals: {[string]: any},
	options: tweenOptions
): animation
	return animationModule.play(instance, goals, options)
end

--————————————————————————————————————————————————————————————————————--

--- Resolves a value from the current theme without creating a subscription.
--- @param themeValue theme<T> Theme containing the source tokens.
--- @param selectorFunction (tokens: T) -> R Function that selects or derives a value.
--- @return R Resolved value.
function module.resolveTheme<T, R>(
	themeValue: theme<T>,
	selectorFunction: (tokens: T) -> R
): R
	return themeModule.resolve(themeValue, selectorFunction)
end

--————————————————————————————————————————————————————————————————————--

--- Resolves the visible range for a fixed-size virtual list.
--- @param itemCount number Total number of items.
--- @param itemSize number Size of each item along the scrolling axis.
--- @param scrollOffset number Current scroll position.
--- @param viewportSize number Visible viewport size.
--- @param overscan number? Additional items rendered before and after the visible range.
--- @return virtualRange Calculated virtual range and total list size.
function module.resolveVirtualList(
	itemCount: number,
	itemSize: number,
	scrollOffset: number,
	viewportSize: number,
	overscan: number?
): virtualRange
	return virtualListModule.resolve(
		itemCount,
		itemSize,
		scrollOffset,
		viewportSize,
		overscan
	)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a numeric binding rounded to the requested precision.
--- @param source binding<number> Source numeric binding.
--- @param precision number Number of decimal places to preserve.
--- @return binding<number> Derived rounded binding.
function module.roundBinding(
	source: binding<number>,
	precision: number
): binding<number>
	return bindingModule.round(source, precision)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a signal that ignores the first number of source emissions.
--- @param source signal<T> Source signal.
--- @param amount number Number of initial emissions to skip.
--- @return signal<T> Derived signal.
function module.skipSignal<T>(
	source: signal<T>,
	amount: number
): signal<T>
	return signalModule.skip(source, amount)
end

--————————————————————————————————————————————————————————————————————--

--- Returns the items contained within a resolved virtual range.
--- @param items {T} Complete ordered item collection.
--- @param rangeValue virtualRange Range returned by resolveVirtualList().
--- @return {T} New array containing items inside the range.
function module.sliceVirtualList<T>(
	items: {T},
	rangeValue: virtualRange
): {T}
	return virtualListModule.slice(items, rangeValue)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a signal that forwards at most a maximum number of emissions.
--- @param source signal<T> Source signal.
--- @param maximum number Maximum number of values to forward.
--- @return signal<T> Derived limited signal.
function module.takeSignal<T>(
	source: signal<T>,
	maximum: number
): signal<T>
	return signalModule.take(source, maximum)
end

--————————————————————————————————————————————————————————————————————--

--- Creates component state synchronized with a Roblox Attribute.
--- @param instance Instance Instance containing the Attribute.
--- @param attributeName string Attribute name to synchronize.
--- @param defaultValue T Value used when the Attribute does not exist.
--- @return T Current Attribute-backed value.
--- @return (value: T) -> () Setter that updates the Attribute and hook state.
function module.useAttribute<T>(
	instance: Instance,
	attributeName: string,
	defaultValue: T
): (T, (value: T) -> ())
	return hooksModule.useAttribute(
		instance,
		attributeName,
		defaultValue
	)
end

--————————————————————————————————————————————————————————————————————--

--- Creates boolean component state with enable, disable, and toggle controls.
--- @param initialValue boolean? Initial value. Defaults to false.
--- @return boolean Current boolean value.
--- @return () -> () Function that enables the value.
--- @return () -> () Function that disables the value.
--- @return () -> () Function that toggles the value.
function module.useBoolean(
	initialValue: boolean?
): (boolean, () -> (), () -> (), () -> ())
	return hooksModule.useBoolean(initialValue)
end

--————————————————————————————————————————————————————————————————————--

--- Memoizes a callback until its dependencies change.
--- @param callback T Callback value to memoize.
--- @param dependencies {any}? Values controlling when the callback is replaced.
--- @return T Memoized callback.
function module.useCallback<T>(
	callback: T,
	dependencies: {any}?
): T
	return hooksModule.useCallback(callback, dependencies)
end

--————————————————————————————————————————————————————————————————————--

--- Creates numeric component state with counter controls.
--- @param initialValue number? Initial counter value. Defaults to zero.
--- @return number Current counter value.
--- @return counterControls Counter controls.
function module.useCounter(
	initialValue: number?
): (number, counterControls)
	return hooksModule.useCounter(initialValue)
end

--————————————————————————————————————————————————————————————————————--

--- Returns a delayed version of a changing value.
--- @param value T Current source value.
--- @param delaySeconds number Delay before the returned value updates.
--- @return T Current debounced value.
function module.useDebouncedValue<T>(
	value: T,
	delaySeconds: number
): T
	return hooksModule.useDebouncedValue(value, delaySeconds)
end

--————————————————————————————————————————————————————————————————————--

--- Queues an effect after the component render completes.
--- Returning a cleanup function disposes the previous effect before rerunning and on deletion.
--- @param callback () -> (() -> ())? Effect callback with optional cleanup.
--- @param dependencies {any}? Values controlling when the effect reruns.
function module.useEffect(
	callback: () -> (() -> ())?,
	dependencies: {any}?
)
	hooksModule.useEffect(callback, dependencies)
end

--————————————————————————————————————————————————————————————————————--

--- Memoizes a calculated value until its dependencies change.
--- @param factory () -> T Function that produces the memoized value.
--- @param dependencies {any}? Values controlling when the value is recalculated.
--- @return T Current memoized value.
function module.useMemo<T>(
	factory: () -> T,
	dependencies: {any}?
): T
	return hooksModule.useMemo(factory, dependencies)
end

--————————————————————————————————————————————————————————————————————--

--- Returns the value from the previous completed render.
--- @param value T Current value.
--- @return T? Previous rendered value, or nil on the first render.
function module.usePrevious<T>(value: T): T?
	return hooksModule.usePrevious(value)
end

--————————————————————————————————————————————————————————————————————--

--- Creates reducer-managed component state.
--- @param reducer (stateValue: S, action: A) -> S Function that derives the next state.
--- @param initialState S Initial reducer state.
--- @return S Current reducer state.
--- @return reducerDispatch<A> Stable dispatch function.
function module.useReducer<S, A>(
	reducer: (stateValue: S, action: A) -> S,
	initialState: S
): (S, reducerDispatch<A>)
	return hooksModule.useReducer(reducer, initialState)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a stable mutable reference that persists across renders.
--- @param initialValue T Initial reference value.
--- @return ref<T> Stable mutable reference.
function module.useRef<T>(initialValue: T): ref<T>
	return hooksModule.useRef(initialValue)
end

--————————————————————————————————————————————————————————————————————--

--- Creates component state and a stable setter.
--- @param initialValue T Initial state value.
--- @return T Current state value.
--- @return stateSetter<T> Setter accepting a value or updater function.
function module.useState<T>(
	initialValue: T
): (T, stateSetter<T>)
	return hooksModule.useState(initialValue)
end

--————————————————————————————————————————————————————————————————————--

--- Creates boolean component state with toggle and direct-set controls.
--- @param initialValue boolean? Initial value. Defaults to false.
--- @return boolean Current boolean value.
--- @return () -> () Function that toggles the value.
--- @return (value: boolean) -> () Function that directly sets the value.
function module.useToggle(
	initialValue: boolean?
): (boolean, () -> (), (value: boolean) -> ())
	return hooksModule.useToggle(initialValue)
end

--————————————————————————————————————————————————————————————————————--

return module