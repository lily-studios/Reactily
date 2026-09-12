--!strict

-- exposes the public Reactily API

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

local version = "1.0.0"

--————————————————————————————————————————————————————————————————————--

local core = script:WaitForChild("core")
local diagnosticsFolder = script:WaitForChild("diagnostics")
local interfaceFolder = script:WaitForChild("interface")
local runtime = script:WaitForChild("runtime")
local state = script:WaitForChild("state")
local virtual = script:WaitForChild("virtual")

local animationModule = require(runtime:WaitForChild("animation"))
local atomModule = require(state:WaitForChild("atom"))
local bindingModule = require(runtime:WaitForChild("binding"))
local diagnosticsModule = require(diagnosticsFolder:WaitForChild("diagnostics"))
local elementModule = require(virtual:WaitForChild("element"))
local focusModule = require(interfaceFolder:WaitForChild("focus"))
local hooksModule = require(state:WaitForChild("hooks"))
local lifecycleModule = require(core:WaitForChild("lifecycle"))
local objectPoolModule = require(core:WaitForChild("objectPool"))
local rootModule = require(runtime:WaitForChild("root"))
local schedulerModule = require(core:WaitForChild("scheduler"))
local signalModule = require(core:WaitForChild("signal"))
local storeModule = require(state:WaitForChild("store"))
local styleModule = require(interfaceFolder:WaitForChild("style"))
local themeModule = require(interfaceFolder:WaitForChild("theme"))
local virtualListModule = require(interfaceFolder:WaitForChild("virtualList"))

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

function module.applyStyle<T>(properties: T, styleValue: style): T
	return styleModule.apply(properties, styleValue)
end

--————————————————————————————————————————————————————————————————————--

function module.clampBinding(
	source: binding<number>,
	minimum: number,
	maximum: number
): binding<number>
	return bindingModule.clamp(source, minimum, maximum)
end

--————————————————————————————————————————————————————————————————————--

function module.clearFocus()
	focusModule.clearSelection()
end

--————————————————————————————————————————————————————————————————————--

function module.combineBindings<A, B, R>(
	first: binding<A>,
	second: binding<B>,
	mapper: (firstValue: A, secondValue: B) -> R
): binding<R>
	return bindingModule.combine(first, second, mapper)
end

--————————————————————————————————————————————————————————————————————--

function module.createAttributeAtom<T>(
	instance: Instance,
	attributeName: string,
	defaultValue: T
): atom<T>
	return atomModule.fromAttribute(instance, attributeName, defaultValue)
end

--————————————————————————————————————————————————————————————————————--

function module.createAtom<T>(initialValue: T): atom<T>
	return atomModule.new(initialValue)
end

--————————————————————————————————————————————————————————————————————--

function module.createBillboardGui(props: billboardGuiProps?, children: {element}?): element
	return elementModule.createBillboardGui(props, children)
end

--————————————————————————————————————————————————————————————————————--

function module.createBinding<T>(initialValue: T): binding<T>
	return bindingModule.new(initialValue)
end

--————————————————————————————————————————————————————————————————————--

function module.createCanvasGroup(props: canvasGroupProps?, children: {element}?): element
	return elementModule.createCanvasGroup(props, children)
end

--————————————————————————————————————————————————————————————————————--

function module.createComponent<P>(
	componentValue: component<P>,
	props: P,
	children: {element}?,
	key: string?
): element
	return elementModule.createComponent(componentValue, props, children, key)
end

--————————————————————————————————————————————————————————————————————--

function module.createComputed<A, B>(
	source: atom<A>,
	selectorFunction: (value: A) -> B
): computed<B>
	return atomModule.computed(source, selectorFunction)
end

--————————————————————————————————————————————————————————————————————--

function module.createDiagnostics(): diagnostics
	return diagnosticsModule.new()
end

--————————————————————————————————————————————————————————————————————--

function module.createElement(
	className: string,
	props: elementModule.genericProps?,
	children: {element}?
): element
	return elementModule.createElement(className, props, children)
end

--————————————————————————————————————————————————————————————————————--

function module.createFocusGroup(): focusGroup
	return focusModule.new()
end

--————————————————————————————————————————————————————————————————————--

function module.createFragment(children: {element}, key: string?): element
	return elementModule.createFragment(children, key)
end

--————————————————————————————————————————————————————————————————————--

function module.createFrame(props: frameProps?, children: {element}?): element
	return elementModule.createFrame(props, children)
end

--————————————————————————————————————————————————————————————————————--

function module.createHistoryAtom<T>(initialValue: T, limit: number): historyAtom<T>
	return atomModule.history(initialValue, limit)
end

--————————————————————————————————————————————————————————————————————--

function module.createImageButton(props: imageButtonProps?, children: {element}?): element
	return elementModule.createImageButton(props, children)
end

--————————————————————————————————————————————————————————————————————--

function module.createImageLabel(props: imageLabelProps?, children: {element}?): element
	return elementModule.createImageLabel(props, children)
end

--————————————————————————————————————————————————————————————————————--

function module.createInstancePool(className: string, maximumSize: number): objectPool<Instance>
	return objectPoolModule.instance(className, maximumSize)
end

--————————————————————————————————————————————————————————————————————--

function module.createLifecycleOwner(): lifecycleOwner
	return lifecycleModule.new()
end

--————————————————————————————————————————————————————————————————————--

function module.createObjectPool<T>(
	createObject: () -> T,
	resetObject: (object: T) -> (),
	deleteObject: (object: T) -> (),
	maximumSize: number
): objectPool<T>
	return objectPoolModule.new(createObject, resetObject, deleteObject, maximumSize)
end

--————————————————————————————————————————————————————————————————————--

function module.createPortal(target: Instance, children: {element}, key: string?): element
	return elementModule.createPortal(target, children, key)
end

--————————————————————————————————————————————————————————————————————--

function module.createRoot(parent: Instance): root
	return rootModule.new(parent)
end

--————————————————————————————————————————————————————————————————————--

function module.createScheduler(): scheduler
	return schedulerModule.new()
end

--————————————————————————————————————————————————————————————————————--

function module.createScreenGui(props: screenGuiProps?, children: {element}?): element
	return elementModule.createScreenGui(props, children)
end

--————————————————————————————————————————————————————————————————————--

function module.createScrollingFrame(props: scrollingFrameProps?, children: {element}?): element
	return elementModule.createScrollingFrame(props, children)
end

--————————————————————————————————————————————————————————————————————--

function module.createSignal<T>(): signal<T>
	return signalModule.new()
end

--————————————————————————————————————————————————————————————————————--

function module.createStore<T>(initialState: T): store<T>
	return storeModule.new(initialState)
end

--————————————————————————————————————————————————————————————————————--

function module.createStyle(styles: {style}): style
	return styleModule.merge(styles)
end

--————————————————————————————————————————————————————————————————————--

function module.createSurfaceGui(props: surfaceGuiProps?, children: {element}?): element
	return elementModule.createSurfaceGui(props, children)
end

--————————————————————————————————————————————————————————————————————--

function module.createTextBox(props: textBoxProps?, children: {element}?): element
	return elementModule.createTextBox(props, children)
end

--————————————————————————————————————————————————————————————————————--

function module.createTextButton(props: textButtonProps?, children: {element}?): element
	return elementModule.createTextButton(props, children)
end

--————————————————————————————————————————————————————————————————————--

function module.createTextLabel(props: textLabelProps?, children: {element}?): element
	return elementModule.createTextLabel(props, children)
end

--————————————————————————————————————————————————————————————————————--

function module.createTheme<T>(initialValue: T): theme<T>
	return themeModule.new(initialValue)
end

--————————————————————————————————————————————————————————————————————--

function module.createTween(
	instance: Instance,
	goals: {[string]: any},
	options: tweenOptions
): animation
	return animationModule.tween(instance, goals, options)
end

--————————————————————————————————————————————————————————————————————--

function module.createUIAspectRatioConstraint(props: uiAspectRatioConstraintProps?): element
	return elementModule.createUIAspectRatioConstraint(props)
end

--————————————————————————————————————————————————————————————————————--

function module.createUICorner(props: uiCornerProps?): element
	return elementModule.createUICorner(props)
end

--————————————————————————————————————————————————————————————————————--

function module.createUIGradient(props: uiGradientProps?): element
	return elementModule.createUIGradient(props)
end

--————————————————————————————————————————————————————————————————————--

function module.createUIGridLayout(props: uiGridLayoutProps?): element
	return elementModule.createUIGridLayout(props)
end

--————————————————————————————————————————————————————————————————————--

function module.createUIListLayout(props: uiListLayoutProps?): element
	return elementModule.createUIListLayout(props)
end

--————————————————————————————————————————————————————————————————————--

function module.createUIPadding(props: uiPaddingProps?): element
	return elementModule.createUIPadding(props)
end

--————————————————————————————————————————————————————————————————————--

function module.createUIPageLayout(props: uiPageLayoutProps?): element
	return elementModule.createUIPageLayout(props)
end

--————————————————————————————————————————————————————————————————————--

function module.createUIScale(props: uiScaleProps?): element
	return elementModule.createUIScale(props)
end

--————————————————————————————————————————————————————————————————————--

function module.createUISizeConstraint(props: uiSizeConstraintProps?): element
	return elementModule.createUISizeConstraint(props)
end

--————————————————————————————————————————————————————————————————————--

function module.createUIStroke(props: uiStrokeProps?): element
	return elementModule.createUIStroke(props)
end

--————————————————————————————————————————————————————————————————————--

function module.createUITextSizeConstraint(props: uiTextSizeConstraintProps?): element
	return elementModule.createUITextSizeConstraint(props)
end

--————————————————————————————————————————————————————————————————————--

function module.createVideoFrame(props: videoFrameProps?, children: {element}?): element
	return elementModule.createVideoFrame(props, children)
end

--————————————————————————————————————————————————————————————————————--

function module.createViewportFrame(props: viewportFrameProps?, children: {element}?): element
	return elementModule.createViewportFrame(props, children)
end

--————————————————————————————————————————————————————————————————————--

function module.distinctSignal<T>(source: signal<T>): signal<T>
	return signalModule.distinct(source)
end

--————————————————————————————————————————————————————————————————————--

function module.filterSignal<T>(source: signal<T>, predicate: (value: T) -> boolean): signal<T>
	return signalModule.filter(source, predicate)
end

--————————————————————————————————————————————————————————————————————--

function module.formatBinding<T>(source: binding<T>, formatter: (value: T) -> string): binding<string>
	return bindingModule.format(source, formatter)
end

--————————————————————————————————————————————————————————————————————--

function module.getVersion(): string
	return version
end

--————————————————————————————————————————————————————————————————————--

function module.mapBinding<A, B>(source: binding<A>, mapper: (value: A) -> B): binding<B>
	return bindingModule.map(source, mapper)
end

--————————————————————————————————————————————————————————————————————--

function module.mapSignal<A, B>(source: signal<A>, mapper: (value: A) -> B): signal<B>
	return signalModule.map(source, mapper)
end

--————————————————————————————————————————————————————————————————————--

function module.mergeSignals<T>(sources: {signal<T>}): signal<T>
	return signalModule.merge(sources)
end

--————————————————————————————————————————————————————————————————————--

function module.new(parent: Instance): root
	return rootModule.new(parent)
end

--————————————————————————————————————————————————————————————————————--

function module.playTween(
	instance: Instance,
	goals: {[string]: any},
	options: tweenOptions
): animation
	return animationModule.play(instance, goals, options)
end

--————————————————————————————————————————————————————————————————————--

function module.resolveTheme<T, R>(themeValue: theme<T>, selectorFunction: (tokens: T) -> R): R
	return themeModule.resolve(themeValue, selectorFunction)
end

--————————————————————————————————————————————————————————————————————--

function module.resolveVirtualList(
	itemCount: number,
	itemSize: number,
	scrollOffset: number,
	viewportSize: number,
	overscan: number?
): virtualRange
	return virtualListModule.resolve(itemCount, itemSize, scrollOffset, viewportSize, overscan)
end

--————————————————————————————————————————————————————————————————————--

function module.roundBinding(source: binding<number>, precision: number): binding<number>
	return bindingModule.round(source, precision)
end

--————————————————————————————————————————————————————————————————————--

function module.skipSignal<T>(source: signal<T>, amount: number): signal<T>
	return signalModule.skip(source, amount)
end

--————————————————————————————————————————————————————————————————————--

function module.sliceVirtualList<T>(items: {T}, rangeValue: virtualRange): {T}
	return virtualListModule.slice(items, rangeValue)
end

--————————————————————————————————————————————————————————————————————--

function module.takeSignal<T>(source: signal<T>, maximum: number): signal<T>
	return signalModule.take(source, maximum)
end

--————————————————————————————————————————————————————————————————————--

function module.useAttribute<T>(
	instance: Instance,
	attributeName: string,
	defaultValue: T
): (T, (value: T) -> ())
	return hooksModule.useAttribute(instance, attributeName, defaultValue)
end

--————————————————————————————————————————————————————————————————————--

function module.useBoolean(initialValue: boolean?): (boolean, () -> (), () -> (), () -> ())
	return hooksModule.useBoolean(initialValue)
end

--————————————————————————————————————————————————————————————————————--

function module.useCallback<T>(callback: T, dependencies: {any}?): T
	return hooksModule.useCallback(callback, dependencies)
end

--————————————————————————————————————————————————————————————————————--

function module.useCounter(initialValue: number?): (number, counterControls)
	return hooksModule.useCounter(initialValue)
end

--————————————————————————————————————————————————————————————————————--

function module.useDebouncedValue<T>(value: T, delaySeconds: number): T
	return hooksModule.useDebouncedValue(value, delaySeconds)
end

--————————————————————————————————————————————————————————————————————--

function module.useEffect(callback: () -> (() -> ())?, dependencies: {any}?)
	hooksModule.useEffect(callback, dependencies)
end

--————————————————————————————————————————————————————————————————————--

function module.useMemo<T>(factory: () -> T, dependencies: {any}?): T
	return hooksModule.useMemo(factory, dependencies)
end

--————————————————————————————————————————————————————————————————————--

function module.usePrevious<T>(value: T): T?
	return hooksModule.usePrevious(value)
end

--————————————————————————————————————————————————————————————————————--

function module.useReducer<S, A>(
	reducer: (stateValue: S, action: A) -> S,
	initialState: S
): (S, reducerDispatch<A>)
	return hooksModule.useReducer(reducer, initialState)
end

--————————————————————————————————————————————————————————————————————--

function module.useRef<T>(initialValue: T): ref<T>
	return hooksModule.useRef(initialValue)
end

--————————————————————————————————————————————————————————————————————--

function module.useState<T>(initialValue: T): (T, stateSetter<T>)
	return hooksModule.useState(initialValue)
end

--————————————————————————————————————————————————————————————————————--

function module.useToggle(initialValue: boolean?): (boolean, () -> (), (value: boolean) -> ())
	return hooksModule.useToggle(initialValue)
end

--————————————————————————————————————————————————————————————————————--

return module
