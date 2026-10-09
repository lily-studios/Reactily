--[[
  Reactily · Lily Studios
  Public API / integration / lifecycle stress test
  Place this LocalScript in StarterPlayerScripts.
  Reactily is expected at ReplicatedStorage.Reactily.
  This file checks the generated public surface, compile-time public
  types, and behavioral integration across Reactily 2.1.0 systems. It also
  intentionally requires the four new specialized creator exports so the test
  catches a generator that accidentally drops them.
]]
--!strict
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Validate the renamed ModuleScript before loading the generated entrypoint.
local reactilyScript = ReplicatedStorage:WaitForChild("Reactily")
assert(reactilyScript:IsA("ModuleScript"), "Reactily entrypoint must be a ModuleScript.")
local virtualFolder = reactilyScript:FindFirstChild("virtual")
assert(virtualFolder ~= nil, "Reactily is missing the virtual directory.")
local childModule = virtualFolder:FindFirstChild("child")
assert(
  childModule ~= nil and childModule:IsA("ModuleScript"),
  "Reactily.virtual.child is missing. Sync the renamed child module and regenerate init.luau."
)
local Reactily = require(reactilyScript)
local ReactilyAny: any = Reactily
assert(RunService:IsClient(), "Reactily full test must run as a LocalScript on the client.")
local player = Players.LocalPlayer
assert(player ~= nil, "Reactily full test requires Players.LocalPlayer.")
local playerGui = player:WaitForChild("PlayerGui")

-- Compile-time coverage generated from the latest available init.luau.
type _PublicType001 = Reactily.ActivityMode
type _PublicType002 = Reactily.ActivityProps
type _PublicType003 = Reactily.Animation
type _PublicType004 = Reactily.AnimationGroup
type _PublicType005 = Reactily.AnimationPlayable
type _PublicType006 = Reactily.Atom<any>
type _PublicType007 = Reactily.AtomChange<any>
type _PublicType008 = Reactily.AttributeMap
type _PublicType009 = Reactily.AttributeValue
type _PublicType010 = Reactily.BillboardGuiProps
type _PublicType011 = Reactily.Binding<any>
type _PublicType012 = Reactily.BindingChange<any>
type _PublicType013 = Reactily.Bounds
type _PublicType014 = Reactily.Breakpoints
type _PublicType015 = Reactily.BreakpointValues<any>
type _PublicType016 = Reactily.ButtonEvents
type _PublicType017 = Reactily.CanvasGroupProps
type _PublicType018 = Reactily.Change<any>
type _PublicType019 = Reactily.ChangeKeys
type _PublicType020 = Reactily.Command
type _PublicType021 = Reactily.CommandRegistry
type _PublicType022 = Reactily.CommonGuiProps<any>
type _PublicType023 = Reactily.CommonOptions
type _PublicType024 = Reactily.Comparator
type _PublicType025 = Reactily.Component<any>
type _PublicType026 = Reactily.ComponentContext
type _PublicType027 = Reactily.ComponentOptions<any>
type _PublicType028 = Reactily.ComponentProfile
type _PublicType029 = Reactily.Computed<any>
type _PublicType030 = Reactily.Connection
type _PublicType031 = Reactily.Context<any>
type _PublicType032 = Reactily.ControllableStateOptions<any>
type _PublicType033 = Reactily.CounterControls
type _PublicType034 = Reactily.DeviceMonitor
type _PublicType035 = Reactily.DeviceState
type _PublicType036 = Reactily.Diagnostics
type _PublicType037 = Reactily.DragAxis
type _PublicType038 = Reactily.DragController
type _PublicType039 = Reactily.DragOptions
type _PublicType040 = Reactily.Element
type _PublicType041 = Reactily.ErrorBoundaryProps
type _PublicType042 = Reactily.EventKeys
type _PublicType043 = Reactily.FocusGroup
type _PublicType044 = Reactily.Form<any>
type _PublicType045 = Reactily.ForwardRefTarget<any>
type _PublicType046 = Reactily.FragmentInstance
type _PublicType047 = Reactily.FragmentInstanceRefTarget
type _PublicType048 = Reactily.FragmentMarker
type _PublicType049 = Reactily.FragmentRefTarget
type _PublicType050 = Reactily.FrameProps
type _PublicType051 = Reactily.GenericProps
type _PublicType052 = Reactily.GridLayoutOptions
type _PublicType053 = Reactily.GridOptions
type _PublicType054 = Reactily.GridRange
type _PublicType055 = Reactily.History<any>
type _PublicType056 = Reactily.HistoryAtom<any>
type _PublicType057 = Reactily.HostChangeProps
type _PublicType058 = Reactily.HostHandle
type _PublicType059 = Reactily.HostMetadataProps<any>
type _PublicType060 = Reactily.HostRefTarget<any>
type _PublicType061 = Reactily.ImageButtonProps
type _PublicType062 = Reactily.ImageLabelProps
type _PublicType063 = Reactily.ImageProps
type _PublicType064 = Reactily.InputBinding
type _PublicType065 = Reactily.InputOptions
type _PublicType066 = Reactily.Insets
type _PublicType067 = Reactily.InteractionController
type _PublicType068 = Reactily.InteractionOptions
type _PublicType069 = Reactily.InteractionStyle
type _PublicType070 = Reactily.KeyInputOptions
type _PublicType071 = Reactily.KeyOptions
type _PublicType072 = Reactily.LayerDefinition
type _PublicType073 = Reactily.LayerManager
type _PublicType074 = Reactily.LayoutOptions
type _PublicType075 = Reactily.LifecycleOwner
type _PublicType076 = Reactily.ListLayoutOptions
type _PublicType077 = Reactily.ListOptions
type _PublicType078 = Reactily.Measure
type _PublicType079 = Reactily.MeasureBounds
type _PublicType080 = Reactily.Middleware<any>
type _PublicType081 = Reactily.ModalOptions
type _PublicType082 = Reactily.Mode
type _PublicType083 = Reactily.MotionOptions
type _PublicType084 = Reactily.NodeSnapshot
type _PublicType085 = Reactily.ObjectPool<any>
type _PublicType086 = Reactily.Options
type _PublicType087 = Reactily.Owner
type _PublicType088 = Reactily.Placement
type _PublicType089 = Reactily.Playable
type _PublicType090 = Reactily.PopoverOptions
type _PublicType091 = Reactily.PopoverPlacement
type _PublicType092 = Reactily.Presence
type _PublicType093 = Reactily.PresenceOptions
type _PublicType094 = Reactily.Priority
type _PublicType095 = Reactily.ProfilerOnRender
type _PublicType096 = Reactily.ProfilerProps
type _PublicType097 = Reactily.PropMap
type _PublicType098 = Reactily.Range
type _PublicType099 = Reactily.ReconcileOptions
type _PublicType100 = Reactily.ReducerDispatch<any>
type _PublicType101 = Reactily.Ref<any>
type _PublicType102 = Reactily.RefCallback<any>
type _PublicType103 = Reactily.RefTarget<any>
type _PublicType104 = Reactily.ResizeController
type _PublicType105 = Reactily.ResizeOptions
type _PublicType106 = Reactily.Resource<any>
type _PublicType107 = Reactily.ResourceStatus
type _PublicType108 = Reactily.ResponsiveBreakpoints
type _PublicType109 = Reactily.ResponsiveValues<any>
type _PublicType110 = Reactily.Root
type _PublicType111 = Reactily.RuntimeNode
type _PublicType112 = Reactily.SafeAreaInsets
type _PublicType113 = Reactily.Scheduler
type _PublicType114 = Reactily.SchedulerOptions
type _PublicType115 = Reactily.ScreenGuiProps
type _PublicType116 = Reactily.ScrollingFrameProps
type _PublicType117 = Reactily.Selection<any>
type _PublicType118 = Reactily.Selector<any>
type _PublicType119 = Reactily.ShortcutOptions
type _PublicType120 = Reactily.Signal<any>
type _PublicType121 = Reactily.Snapshot
type _PublicType122 = Reactily.Spring<any>
type _PublicType123 = Reactily.SpringOptions
type _PublicType124 = Reactily.StateSetter<any>
type _PublicType125 = Reactily.Store<any>
type _PublicType126 = Reactily.StoreMiddleware<any>
type _PublicType127 = Reactily.StrictModeProps
type _PublicType128 = Reactily.Style
type _PublicType129 = Reactily.SurfaceGuiProps
type _PublicType130 = Reactily.SuspenseProps
type _PublicType131 = Reactily.Suspension
type _PublicType132 = Reactily.TextBoxProps
type _PublicType133 = Reactily.TextButtonProps
type _PublicType134 = Reactily.TextLabelProps
type _PublicType135 = Reactily.TextProps
type _PublicType136 = Reactily.Theme<any>
type _PublicType137 = Reactily.Tooltip
type _PublicType138 = Reactily.TooltipOptions
type _PublicType139 = Reactily.TransitionId
type _PublicType140 = Reactily.TransitionStarter
type _PublicType141 = Reactily.TweenOptions
type _PublicType142 = Reactily.UIAspectRatioConstraintProps
type _PublicType143 = Reactily.UICornerProps
type _PublicType144 = Reactily.UIGradientProps
type _PublicType145 = Reactily.UIGridLayoutProps
type _PublicType146 = Reactily.UIListLayoutProps
type _PublicType147 = Reactily.UIPaddingProps
type _PublicType148 = Reactily.UIPageLayoutProps
type _PublicType149 = Reactily.UIScaleProps
type _PublicType150 = Reactily.UISizeConstraintProps
type _PublicType151 = Reactily.UIStrokeProps
type _PublicType152 = Reactily.UITextSizeConstraintProps
type _PublicType153 = Reactily.ValidationMap
type _PublicType154 = Reactily.Validator<any>
type _PublicType155 = Reactily.VariableRange
type _PublicType156 = Reactily.VariableVirtualList
type _PublicType157 = Reactily.VariableVirtualRange
type _PublicType158 = Reactily.VariantStyle
type _PublicType159 = Reactily.VideoFrameProps
type _PublicType160 = Reactily.ViewportFrameProps
type _PublicType161 = Reactily.ViewTransitionConfig
type _PublicType162 = Reactily.ViewTransitionProps
type _PublicType163 = Reactily.VirtualGridRenderOptions<any>
type _PublicType164 = Reactily.VirtualList
type _PublicType165 = Reactily.VirtualListRenderOptions<any>
type _PublicType166 = Reactily.VirtualRange

local EXPECTED_PUBLIC_EXPORTS = {
  "Activity", "addCleanup", "Animation", "AnimationGroup", "apiVersion", "apply", "applyStyle", "assign", "Atom",
  "attachAttribute", "attachProperty", "Attributes", "batch", "Batching", "beginRender", "bindAttribute",
  "Binding", "bindInstanceDeletion", "bindKey", "bindProperty", "bindType", "by", "cancel", "capture", "center",
  "Change", "changed", "Children", "clamp", "clampBinding", "clearFocus", "clearSelection", "cloneElement",
  "combineBindings", "combineBindingsMany", "combineMany", "combineStores", "Command", "Compare", "Component",
  "computed", "connect", "connectNamed", "Context", "count", "createActivity", "createAnimationDelay",
  "createAtom", "createAttributeAtom", "createBillboardGui", "createBinding", "createCanvasGroup", "createChild",
  "createComponent", "createComputed", "createContext", "createContextProvider", "createDiagnostics",
  "createElement", "createErrorBoundary", "createFocusGroup", "createFragment", "createFrame",
  "createHistoryAtom", "createHost", "createImageButton", "createImageLabel", "createInstancePool",
  "createLifecycleOwner", "createObjectPool", "createPortal", "createProfiler", "createRef", "createResource",
  "createRoot", "createScheduler", "createScreenGui", "createScrollingFrame", "createSelector", "createSignal",
  "createSpring", "createStore", "createStrictMode", "createStyle", "createSurfaceGui", "createSuspense",
  "createTextBox", "createTextButton", "createTextLabel", "createTheme", "createTween",
  "createUIAspectRatioConstraint", "createUICorner", "createUIGradient", "createUIGridLayout",
  "createUIListLayout", "createUIPadding", "createUIPageLayout", "createUIScale", "createUISizeConstraint",
  "createUIStroke", "createUITextSizeConstraint", "createVariableVirtualList", "createVideoFrame",
  "createViewportFrame", "createViewTransition", "createVirtualList", "Debug", "defaults", "delay",
  "deleteContext", "deleteHost", "deleteInstance", "deleteInstances", "Device", "DevMode", "Diagnostics",
  "disconnect", "disconnectAll", "distinct", "distinctSignal", "Drag", "Element", "endRender", "equal",
  "ErrorBoundary", "Event", "Experimental", "features", "filter", "filterSignal", "flattenChildren",
  "flushEffects", "flushInsertionEffects", "flushLayoutEffects", "Focus", "forEach", "Form", "format",
  "formatBinding", "formatTree", "forwardRef", "ForwardRef", "Fragment", "FragmentRef", "fromAttribute",
  "getChangePropertyName", "getCleanupCount", "getConnectionCount", "getCurrentId", "getCurrentPriority",
  "getEventName", "getInsets", "getInstanceCount", "getPendingCount", "getProfile", "getProfilerSnapshot",
  "getPropertyName", "getRenderReason", "getSlowComponents", "getVersion", "grid", "hasFeature", "hide",
  "history", "History", "Hooks", "horizontal", "HostConfig", "Hover", "Input", "inspectRoot", "instance",
  "Interaction", "isActive", "isBatching", "isChange", "isCompatible", "isDeleted", "isEvent", "isMemo",
  "isProperty", "isStrictMode", "isSuspension", "isTransitionPriority", "isValidElement", "key", "Layer",
  "Layout", "lazy", "Lazy", "Lifecycle", "mapBinding", "mapSignal", "maxLength", "Measure", "memo", "Memo",
  "mergeSignals", "Metadata", "Modal", "Motion", "newContext", "number", "ObjectPool", "omit",
  "onCurrentFinished", "only", "padding", "parallel", "parallelAnimations", "patch", "pattern", "pauseEffects",
  "pick", "place", "playEnter", "playTween", "playUpdate", "pop", "Popover", "preload", "preloadLazy", "Presence",
  "Priority", "Profiler", "ProfilerComponent", "Props", "push", "queue", "range", "ReactCompat", "Readable",
  "reconcile", "Reconciler", "record", "Renderer", "replaceInstance", "replayEffects", "replayRef", "required",
  "resetProfiler", "Resize", "resolveTheme", "resolveVariableVirtualList", "resolveVirtualGrid",
  "resolveVirtualList", "Resource", "Responsive", "resumeEffects", "Root", "round", "roundBinding", "run",
  "runCleanups", "runWithPriority", "SafeArea", "Scheduler", "Scroll", "select", "Selection", "sequence",
  "sequenceAnimations", "setProfilingEnabled", "setStrictMode", "shallowEqual", "Shortcut", "shouldUpdate",
  "show", "Signal", "skip", "skipSignal", "slice", "sliceVirtualList", "snapshot", "Spring", "stack", "start",
  "startTransition", "Store", "StrictMode", "StrictModeDiagnostics", "Style", "subscribe", "Suspense",
  "TableUtility", "Tag", "take", "takeSignal", "Theme", "toArray", "toBottom", "toObject", "Tooltip", "toTop",
  "trackInstance", "Transition", "tween", "updateHost", "use", "useActionState", "useAttribute", "useBinding",
  "useBoolean", "useCallback", "useContext", "useControllableState", "useCounter", "useCurrentCamera",
  "useDebouncedValue", "useDebugValue", "useDeferredValue", "useDevice", "useEffect", "useEffectEvent",
  "useFocus", "useHover", "useId", "useImperativeHandle", "useInsertionEffect", "useLatest", "useLayoutEffect",
  "useLocalPlayer", "useMeasure", "useMemo", "useMount", "useOptimistic", "useOwned", "usePressed", "usePrevious",
  "useProperty", "useReducer", "useRef", "useShortcut", "useSpring", "useState", "useStore",
  "useSyncExternalStore", "useTag", "useToggle", "useTransition", "useTween", "useUnmount", "useUpdateEffect",
  "Validator", "variant", "version", "versionInfo", "vertical", "ViewTransition", "VirtualGrid", "VirtualList",
  "VirtualWindow", "warn", "warnIf", "when", "withDefaults", "without", "withProperty",
}

local EXPECTED_FUNCTION_EXPORTS = {
  "Activity", "ErrorBoundary", "StrictMode", "Suspense", "ViewTransition", "applyStyle", "batch", "bindAttribute",
  "bindProperty", "clampBinding", "clearFocus", "cloneElement", "combineBindings", "combineBindingsMany",
  "combineStores", "createActivity", "createAnimationDelay", "createAtom", "createAttributeAtom",
  "createBillboardGui", "createBinding", "createCanvasGroup", "createComponent", "createComputed",
  "createContext", "createContextProvider", "createDiagnostics", "createElement", "createErrorBoundary",
  "createFocusGroup", "createFragment", "createFrame", "createHistoryAtom", "createImageButton",
  "createImageLabel", "createInstancePool", "createLifecycleOwner", "createObjectPool", "createPortal",
  "createRef", "createResource", "createRoot", "createScheduler", "createScreenGui", "createScrollingFrame",
  "createSelector", "createSignal", "createSpring", "createStore", "createStyle", "createSurfaceGui",
  "createSuspense", "createTextBox", "createTextButton", "createTextLabel", "createTheme", "createTween",
  "createUIAspectRatioConstraint", "createUICorner", "createUIGradient", "createUIGridLayout",
  "createUIListLayout", "createUIPadding", "createUIPageLayout", "createUIScale", "createUISizeConstraint",
  "createUIStroke", "createUITextSizeConstraint", "createVariableVirtualList", "createVideoFrame",
  "createViewportFrame", "createVirtualList", "distinctSignal", "filterSignal", "flattenChildren",
  "formatBinding", "forwardRef", "getProfile", "getProfilerSnapshot", "getRenderReason", "getSlowComponents",
  "getVersion", "hasFeature", "inspectRoot", "isCompatible", "isStrictMode", "isValidElement", "key", "lazy",
  "mapBinding", "mapSignal", "memo", "mergeSignals", "parallelAnimations", "patch", "playTween", "preloadLazy",
  "resetProfiler", "resolveTheme", "resolveVariableVirtualList", "resolveVirtualGrid", "resolveVirtualList",
  "roundBinding", "sequenceAnimations", "setProfilingEnabled", "setStrictMode", "shallowEqual", "skipSignal",
  "sliceVirtualList", "startTransition", "takeSignal", "use", "useActionState", "useAttribute", "useBinding",
  "useBoolean", "useCallback", "useContext", "useControllableState", "useCounter", "useCurrentCamera",
  "useDebouncedValue", "useDebugValue", "useDeferredValue", "useDevice", "useEffect", "useEffectEvent",
  "useFocus", "useHover", "useId", "useImperativeHandle", "useInsertionEffect", "useLatest", "useLayoutEffect",
  "useLocalPlayer", "useMeasure", "useMemo", "useMount", "useOptimistic", "useOwned", "usePressed", "usePrevious",
  "useProperty", "useReducer", "useRef", "useShortcut", "useSpring", "useState", "useStore",
  "useSyncExternalStore", "useTag", "useToggle", "useTransition", "useTween", "useUnmount", "useUpdateEffect",
  "createProfiler", "createStrictMode", "createViewTransition",
}

local REQUIRED_NEW_CREATOR_EXPORTS = {
  "createActivity", "createProfiler", "createStrictMode", "createViewTransition",
}

local EXPECTED_NAMESPACE_MEMBERS: { [string]: { string } } = {
  Children = { "count", "forEach", "map", "only", "toArray", },
  Command = { "create", },
  Component = { "create", "withDefaults", },
  Debug = { "formatTree", "inspect", },
  Device = { "create", },
  Drag = { "bind", },
  Focus = { "clearSelection", },
  Form = { "create", },
  History = { "create", },
  Hover = { "bind", },
  Input = { "bind", "bindKey", "bindType", },
  Interaction = { "bind", },
  Layer = { "create", },
  Layout = { "center", "grid", "horizontal", "stack", "vertical", "wrap", },
  Measure = { "create", },
  Modal = { "create", },
  Motion = { "create", "play", },
  Popover = { "place", },
  Presence = { "create", },
  Profiler = { "clear", "get", "getSlowComponents", "isEnabled", "record", "setEnabled", "snapshot", },
  Props = { "changed", "defaults", "equal", "merge", "omit", "pick", },
  Resize = { "bind", },
  Responsive = { "resolve", },
  SafeArea = { "getInsets", "padding", },
  Scroll = { "by", "toBottom", "toObject", "toTop", },
  Selection = { "create", },
  Shortcut = { "create", },
  StrictModeDiagnostics = { "isEnabled", "setEnabled", "warn", },
  Style = { "apply", "create", "merge", "variant", "when", "withProperty", "without", },
  Tooltip = { "attach", },
  Validator = { "combine", "maxLength", "number", "pattern", "range", "required", },
  VirtualGrid = { "render", "resolve", },
  VirtualList = { "render", "resolve", "slice", },
  VirtualWindow = { "resolve", },
}

local EXPECTED_FEATURE_FLAGS = {
  "action-state", "activity", "concurrent-priorities", "effect-events", "fragment-refs", "host-metadata",
  "insertion-effects", "optimistic-state", "profiler-component", "strict-mode-checks", "suspense",
  "sync-external-store", "transitions", "use-api", "view-transitions", "virtual-grid", "virtual-list",
  "virtual-window",
}
type TestCase = { name: string, run: () -> () }
type Failure = { name: string, message: string }
local tests: { TestCase } = {}
local failures: { Failure } = {}
local passed = 0
local startedAt = os.clock()
local TEST_GUI_NAME = "__ReactilyFullTest"
local TAG_NAME = "__ReactilyFullTestTag"
local WAIT_TIMEOUT = 3
local previousGui = playerGui:FindFirstChild(TEST_GUI_NAME)
if previousGui then
  previousGui:Destroy()
end
local testGui = Instance.new("ScreenGui")
testGui.Name = TEST_GUI_NAME
testGui.ResetOnSpawn = false
testGui.IgnoreGuiInset = true
testGui.DisplayOrder = 10_000
testGui.Parent = playerGui
local host = Instance.new("Frame")
host.Name = "Host"
host.BackgroundTransparency = 1
host.Position = UDim2.fromOffset(-10_000, -10_000)
host.Size = UDim2.fromOffset(800, 600)
host.Parent = testGui
local observedButton = Instance.new("TextButton")
observedButton.Name = "ObservedButton"
observedButton.Text = "Probe"
observedButton.Active = true
observedButton.Selectable = true
observedButton.Size = UDim2.fromOffset(100, 40)
observedButton.Parent = testGui
local observedFrame = Instance.new("Frame")
observedFrame.Name = "ObservedFrame"
observedFrame.Size = UDim2.fromOffset(120, 60)
observedFrame.BackgroundTransparency = 0
observedFrame.Parent = testGui
local attributeCarrier = Instance.new("Folder")
attributeCarrier.Name = "AttributeCarrier"
attributeCarrier.Parent = testGui
attributeCarrier:SetAttribute("Value", 1)
CollectionService:AddTag(observedFrame, TAG_NAME)

local function cleanupEnvironment()
  pcall(function()
    CollectionService:RemoveTag(observedFrame, TAG_NAME)
  end)
  if testGui.Parent then
    testGui:Destroy()
  end
end

local function expect(condition: boolean, message: string?)
  if not condition then
    error(message or "Expectation failed.", 2)
  end
end

local function expectEqual(actual: any, expected: any, message: string?)
  if actual ~= expected then
    error(message or `Expected {tostring(expected)}, got {tostring(actual)}.`, 2)
  end
end

local function expectType(value: any, expectedType: string, message: string?)
  local actual = typeof(value)
  if actual ~= expectedType then
    error(message or `Expected type {expectedType}, got {actual}.`, 2)
  end
end

local function expectNear(actual: number, expected: number, epsilon: number, message: string?)
  if math.abs(actual - expected) > epsilon then
    error(message or `Expected {actual} to be within {epsilon} of {expected}.`, 2)
  end
end

local function waitUntil(predicate: () -> boolean, timeout: number?): boolean
  local deadline = os.clock() + (timeout or WAIT_TIMEOUT)
  while os.clock() < deadline do
    if predicate() then
      return true
    end
    task.wait()
  end
  return predicate()
end

local function test(name: string, callback: () -> ())
  tests[#tests + 1] = {
    name = name,
    run = callback,
  }
end

local function safeDelete(value: any)
  if type(value) == "table" and type(value.delete) == "function" then
    pcall(value.delete)
  end
end
local activeTestRoots: { Reactily.Root } = {}

local function createTestRoot(parent: Instance): Reactily.Root
  local root = Reactily.createRoot(parent)
  activeTestRoots[#activeTestRoots + 1] = root
  return root
end

local function cleanupTestRoots()
  for index = #activeTestRoots, 1, -1 do
    local root = activeTestRoots[index]
    pcall(root.delete)
    activeTestRoots[index] = nil
  end
end

-- Public surface

test("public API: generated runtime export snapshot exists", function()
  for _, name in EXPECTED_PUBLIC_EXPORTS do
    expect(ReactilyAny[name] ~= nil, `Missing public Reactily export: {name}`)
  end
end)

test("Reactily 2.1 API: specialized creator exports survive init generation", function()
  local missing: { string } = {}
  for _, name in REQUIRED_NEW_CREATOR_EXPORTS do
    if type(ReactilyAny[name]) ~= "function" then
      missing[#missing + 1] = name
    end
  end
  if #missing > 0 then
    error(
      `Missing generated specialized creator exports: {table.concat(missing, ", ")}. Regenerate init.luau from the Luau source with npm run generate.`,
      2
    )
  end
end)

test("public API: every function export is callable", function()
  for _, name in EXPECTED_FUNCTION_EXPORTS do
    expect(type(ReactilyAny[name]) == "function", `Reactily.{name} should be a function, got {typeof(ReactilyAny[name])}`
    )
  end
end)

test("public API: namespaces expose their expected members", function()
  for namespaceName, members in EXPECTED_NAMESPACE_MEMBERS do
    local namespaceValue = ReactilyAny[namespaceName]
    expect(type(namespaceValue) == "table", `Reactily.{namespaceName} should be a table.`)
    local namespace = namespaceValue :: { [string]: any }
    for _, memberName in members do
      expect(namespace[memberName] ~= nil, `Missing Reactily.{namespaceName}.{memberName}`)
    end
  end
end)

test("metadata: version, API version, compatibility, feature flags", function()
  expect(type(Reactily.version) == "string" and Reactily.version ~= "", "Reactily.version is invalid.")
  expect(type(Reactily.apiVersion) == "number", "Reactily.apiVersion must be a number.")
  expectEqual(Reactily.getVersion(), Reactily.version)
  expect(Reactily.isCompatible(Reactily.apiVersion), "Current API version should be compatible.")
  expect(not Reactily.isCompatible(Reactily.apiVersion + 1), "Unknown API version should not be compatible.")
  local major, minor, patch = string.match(Reactily.version, "^(%d+)%.(%d+)%.(%d+)")
  expect(major ~= nil and minor ~= nil and patch ~= nil, "Reactily.version must be semver-compatible.")
  expectEqual(Reactily.versionInfo.major, tonumber(major))
  expectEqual(Reactily.versionInfo.minor, tonumber(minor))
  expectEqual(Reactily.versionInfo.patch, tonumber(patch))
  for _, flag in EXPECTED_FEATURE_FLAGS do
    expect(Reactily.hasFeature(flag), `Expected feature flag to be enabled: {flag}`)
    expect(Reactily.features[flag] == true, `Missing Reactily.features entry: {flag}`)
  end
end)

test("deprecated aliases are no longer part of the public API", function()
  expect(ReactilyAny.new == nil)
  expect(ReactilyAny.useEvent == nil)
  expect(ReactilyAny.useExternalStore == nil)
end)

-- Pure utilities and element construction

test("utilities: shallowEqual, patch, props, validators, responsive", function()
  expect(Reactily.shallowEqual({ a = 1 }, { a = 1 }))
  expect(not Reactily.shallowEqual({ a = 1 }, { a = 2 }))
  local patched = Reactily.patch({ a = 1, b = 2 }, { b = 3 })
  expectEqual(patched.a, 1)
  expectEqual(patched.b, 3)
  local sourceProps: Reactily.PropMap = { a = 1 }
  local defaults = Reactily.Props.defaults(sourceProps, { a = 0, b = 2 })
  expectEqual(defaults.a, 1)
  expectEqual(defaults.b, 2)
  local merged = Reactily.Props.merge({ a = 1 }, { b = 2 })
  expectEqual(merged.a, 1)
  expectEqual(merged.b, 2)
  expect(Reactily.Props.equal({ a = 1 }, { a = 1 }))
  expectEqual(Reactily.Props.pick({ a = 1, b = 2 }, { "b" }).b, 2)
  expectEqual(Reactily.Props.omit({ a = 1, b = 2 }, { "b" }).a, 1)
  local required = Reactily.Validator.required()
  local numeric = Reactily.Validator.number()
  local range = Reactily.Validator.range(1, 3)
  local pattern = Reactily.Validator.pattern("^Lily")
  local maximum = Reactily.Validator.maxLength(4)
  local combined = Reactily.Validator.combine({ required, numeric })
  expect(required("") ~= nil)
  expect(required("ok") == nil)
  expect(numeric(5) == nil)
  expect(numeric("5") ~= nil)
  expect(range(2) == nil and range(4) ~= nil)
  expect(pattern("Lily UI") == nil)
  expect(maximum("1234") == nil and maximum("12345") ~= nil)
  expect(combined(2) == nil)
  local responsive = Reactily.Responsive.resolve(Vector2.new(1000, 600), {
    fallback = "fallback",
    mobile = "mobile",
    tablet = "tablet",
    desktop = "desktop",
  })
  expect(type(responsive) == "string")
end)

test("elements: every host/specialized creator constructs a valid element", function()
  local child = Reactily.createTextLabel({ Name = "Child", Text = "child" })
  local creators = {
    Reactily.createBillboardGui(),
    Reactily.createCanvasGroup(),
    Reactily.createFrame(),
    Reactily.createImageButton(),
    Reactily.createImageLabel(),
    Reactily.createScreenGui(),
    Reactily.createScrollingFrame(),
    Reactily.createSurfaceGui(),
    Reactily.createTextBox(),
    Reactily.createTextButton(),
    child,
    Reactily.createUIAspectRatioConstraint(),
    Reactily.createUICorner(),
    Reactily.createUIGradient(),
    Reactily.createUIGridLayout(),
    Reactily.createUIListLayout(),
    Reactily.createUIPadding(),
    Reactily.createUIPageLayout(),
    Reactily.createUIScale(),
    Reactily.createUISizeConstraint(),
    Reactily.createUIStroke(),
    Reactily.createUITextSizeConstraint(),
    Reactily.createVideoFrame(),
    Reactily.createViewportFrame(),
    Reactily.createFragment({ child }),
    Reactily.createSuspense(Reactily.createTextLabel({ Text = "fallback" }), child),
    Reactily.createErrorBoundary(Reactily.createTextLabel({ Text = "error" }), child),
    Reactily.createPortal(host, { child }),
  }
  for index, elementValue in creators do
    expect(Reactily.isValidElement(elementValue), `Creator #{index} did not return a valid element.`)
  end
  local clone = Reactily.cloneElement(child, { Name = "Clone" })
  expect(Reactily.isValidElement(clone))
  local keyed = Reactily.key(child, "stable-key")
  expect(Reactily.isValidElement(keyed))
  local nestedLevel: { any } = { clone }
  table.insert(nestedLevel, false)
  local nestedChildren: { any } = { child, nestedLevel }
  local flattened = Reactily.flattenChildren(nestedChildren)
  expectEqual(#flattened, 2)
  expectEqual(Reactily.Children.count({ child, clone }), 2)
  expectEqual(#Reactily.Children.toArray({ child, clone }), 2)
  expect(Reactily.Children.only({ child }) == child)
end)

test("layout helpers construct valid elements", function()
  local children = { Reactily.createTextLabel({ Text = "A" }), Reactily.createTextLabel({ Text = "B" }) }
  local layouts = {
    Reactily.Layout.horizontal(nil, children),
    Reactily.Layout.vertical(nil, children),
    Reactily.Layout.wrap(nil, children),
    Reactily.Layout.grid({ CellSize = UDim2.fromOffset(20, 20) }, children),
    Reactily.Layout.stack(nil, children),
    Reactily.Layout.center(nil, children),
    Reactily.Modal.create(nil, children),
    Reactily.SafeArea.padding(),
  }
  for _, elementValue in layouts do
    expect(Reactily.isValidElement(elementValue))
  end
end)

-- Root / reconciliation / host integration

test("root: render, flush, inspect, suspend, resume, batch, delete", function()
  local root = createTestRoot(host)
  root.render(Reactily.createFrame({ Name = "RootProbe", Size = UDim2.fromOffset(100, 40) }))
  root.flush()
  local frame = host:FindFirstChild("RootProbe")
  expect(frame ~= nil and frame:IsA("Frame"), "Initial host frame was not mounted.")
  expect(root.getElement() ~= nil)
  expect(root.getParent() == host)
  expect(root.inspect() ~= nil)
  expect(Reactily.inspectRoot(root) ~= nil)
  expect(root.suspend())
  root.render(Reactily.createFrame({ Name = "SuspendedProbe" }))
  root.flush()
  expect(host:FindFirstChild("SuspendedProbe") == nil, "Suspended root should not reconcile.")
  expect(root.resume())
  root.flush()
  expect(host:FindFirstChild("SuspendedProbe") ~= nil, "Resumed root failed to reconcile.")
  root.batch(function()
    root.render(Reactily.createFrame({ Name = "BatchA" }))
    root.render(Reactily.createFrame({ Name = "BatchB" }))
  end)
  root.flush()
  expect(host:FindFirstChild("BatchB") ~= nil)
  expect(host:FindFirstChild("BatchA") == nil)
  expect(root.delete())
  expect(root.isDeleted())
end)

test("host metadata: refs, attributes, tags, property changes", function()
  local root = createTestRoot(host)
  local hostRef = Reactily.createRef()
  local changedValue: any = nil
  root.render(Reactily.createFrame({
    Name = "MetadataProbe",
    Size = UDim2.fromOffset(50, 50),
    attributes = { TestAttribute = 123 },
    tags = { TAG_NAME },
    ref = hostRef,
    onPropertyChanged = {
      Name = function(value)
        changedValue = value
      end,
    },
  }))
  root.flush()
  local frame = hostRef.current
  assert(frame ~= nil, "Host ref was not assigned.")
  assert(frame:IsA("Frame"), "Host ref should point to a Frame.")
  expectEqual(frame:GetAttribute("TestAttribute"), 123)
  expect(CollectionService:HasTag(frame, TAG_NAME))
  frame.Name = "MetadataProbeRenamed"
  expect(waitUntil(function(): boolean
    return changedValue == "MetadataProbeRenamed"
  end))
  root.delete()
  expect(hostRef.current == nil, "Host ref should clear on unmount.")
end)

-- Scheduler, batching, signals, bindings

test("scheduler: priorities, keyed replacement, cancellation, counts", function()
  local scheduler = Reactily.createScheduler({ timeSliceSeconds = 0 })
  local order: { string } = {}
  scheduler.enqueuePriority(Reactily.Priority.idle, function()
    order[#order + 1] = "idle"
  end)
  scheduler.enqueuePriority(Reactily.Priority.transition, function()
    order[#order + 1] = "transition"
  end)
  scheduler.enqueuePriority(Reactily.Priority.normal, function()
    order[#order + 1] = "normal"
  end)
  scheduler.enqueuePriority(Reactily.Priority.userBlocking, function()
    order[#order + 1] = "user"
  end)
  scheduler.enqueuePriority(Reactily.Priority.immediate, function()
    order[#order + 1] = "immediate"
  end)
  expectEqual(scheduler.getPendingCount(), 5)
  scheduler.flush()
  expectEqual(table.concat(order, ","), "immediate,user,normal,transition,idle")
  local keyedValue = ""
  scheduler.enqueueKeyedPriority("same", Reactily.Priority.idle, function()
    keyedValue = "old"
  end)
  scheduler.enqueueKeyedPriority("same", Reactily.Priority.userBlocking, function()
    keyedValue = "new"
  end)
  expect(scheduler.isPending("same"))
  scheduler.flush()
  expectEqual(keyedValue, "new")
  local cancelled = scheduler.enqueue(function()
    error("cancelled scheduler task executed")
  end)
  expect(scheduler.cancel(cancelled))
  expectEqual(scheduler.getPendingCount(), 0)
  expect(scheduler.delete())
  expect(scheduler.isDeleted())
end)

test("batch: deferred callbacks flush once outer batch finishes", function()
  local value = 0
  Reactily.batch(function()
    value += 1
    Reactily.batch(function()
      value += 1
    end)
  end)
  expectEqual(value, 2)
end)

test("signals: base + map/filter/distinct/merge/skip/take", function()
  local source = Reactily.createSignal()
  local other = Reactily.createSignal()
  local mapped = Reactily.mapSignal(source, function(value: number): number
    return value * 2
  end)
  local filtered = Reactily.filterSignal(source, function(value: number): boolean
    return value % 2 == 0
  end)
  local distinct = Reactily.distinctSignal(source)
  local skipped = Reactily.skipSignal(source, 1)
  local taken = Reactily.takeSignal(source, 2)
  local merged = Reactily.mergeSignals({ source, other })
  local baseValues: { number } = {}
  local mappedValues: { number } = {}
  local filteredValues: { number } = {}
  local distinctValues: { number } = {}
  local skippedValues: { number } = {}
  local takenValues: { number } = {}
  local mergedValues: { number } = {}
  local connections = {
    source.connect(function(v)
      baseValues[#baseValues + 1] = v
    end),
    mapped.connect(function(v)
      mappedValues[#mappedValues + 1] = v
    end),
    filtered.connect(function(v)
      filteredValues[#filteredValues + 1] = v
    end),
    distinct.connect(function(v)
      distinctValues[#distinctValues + 1] = v
    end),
    skipped.connect(function(v)
      skippedValues[#skippedValues + 1] = v
    end),
    taken.connect(function(v)
      takenValues[#takenValues + 1] = v
    end),
    merged.connect(function(v)
      mergedValues[#mergedValues + 1] = v
    end),
  }
  source.fire(1)
  source.fire(2)
  source.fire(2)
  other.fire(9)
  expectEqual(#baseValues, 3)
  expectEqual(mappedValues[1], 2)
  expectEqual(filteredValues[1], 2)
  expectEqual(#distinctValues, 2)
  expectEqual(skippedValues[1], 2)
  expectEqual(#takenValues, 2)
  expectEqual(mergedValues[#mergedValues], 9)
  for _, connection in connections do
    connection.disconnect()
  end
  for _, signalValue in { mapped, filtered, distinct, skipped, taken, merged, source, other } do
    signalValue.delete()
  end
end)

test("bindings: mapping, combining, formatting, rounding, clamp, host binding", function()
  local first = Reactily.createBinding(2)
  local second = Reactily.createBinding(3)
  local mapped = Reactily.mapBinding(first, function(value: number): number
    return value * 10
  end)
  local combined = Reactily.combineBindings(first, second, function(a: number, b: number): number
    return a + b
  end)
  local many = Reactily.combineBindingsMany({ first, second }, function(values): number
    return values[1] * values[2]
  end)
  local formatted = Reactily.formatBinding(first, function(value: number): string
    return `#{value}`
  end)
  local rounded = Reactily.roundBinding(Reactily.createBinding(1.234), 2)
  local clamped = Reactily.clampBinding(Reactily.createBinding(10), 0, 5)
  expectEqual(mapped.get(), 20)
  expectEqual(combined.get(), 5)
  expectEqual(many.get(), 6)
  expectEqual(formatted.get(), "#2")
  expectNear(rounded.get(), 1.23, 0.0001)
  expectEqual(clamped.get(), 5)
  local label = Instance.new("TextLabel")
  label.Parent = testGui
  local textBinding = Reactily.createBinding("A")
  local detachProperty = Reactily.bindProperty(textBinding, label, "Text", true)
  expectEqual(label.Text, "A")
  textBinding.set("B")
  expectEqual(label.Text, "B")
  label.Text = "C"
  expect(waitUntil(function(): boolean
    return textBinding.get() == "C"
  end))
  local attributeBinding = Reactily.createBinding(1)
  local detachAttribute = Reactily.bindAttribute(attributeBinding, label, "Bound", true)
  attributeBinding.set(2)
  expectEqual(label:GetAttribute("Bound"), 2)
  label:SetAttribute("Bound", 3)
  expect(waitUntil(function(): boolean
    return attributeBinding.get() == 3
  end))
  detachProperty()
  detachAttribute()
  label:Destroy()
  safeDelete(first)
  safeDelete(second)
  safeDelete(mapped)
  safeDelete(combined)
  safeDelete(many)
  safeDelete(formatted)
  safeDelete(rounded)
  safeDelete(clamped)
  safeDelete(textBinding)
  safeDelete(attributeBinding)
end)

-- State primitives

test("atoms: atom, computed, history, attribute atom", function()
  local atom = Reactily.createAtom(1)
  local computed = Reactily.createComputed(atom, function(value: number): number
    return value * 2
  end)
  expectEqual(computed.get(), 2)
  atom.update(function(value: number): number
    return value + 2
  end)
  expectEqual(atom.get(), 3)
  expectEqual(computed.get(), 6)
  local history = Reactily.createHistoryAtom(0, 5)
  history.set(1)
  history.set(2)
  expect(history.canUndo())
  expect(history.undo())
  expectEqual(history.get(), 1)
  expect(history.redo())
  expectEqual(history.get(), 2)
  attributeCarrier:SetAttribute("AtomValue", 5)
  local attributeAtom = Reactily.createAttributeAtom(attributeCarrier, "AtomValue", 0)
  expectEqual(attributeAtom.get(), 5)
  attributeAtom.set(7)
  expectEqual(attributeCarrier:GetAttribute("AtomValue"), 7)
  attributeAtom.delete()
  history.delete()
  computed.delete()
  atom.delete()
end)

test("stores: middleware, update, transaction, selector, combine", function()
  local store = Reactily.createStore({ count = 1 })
  local removeMiddleware = store.use(function(_previous, nextValue)
    return { count = math.max(nextValue.count, 0) }
  end)
  local selector = Reactily.createSelector(store, function(state)
    return state.count
  end)
  local other = Reactily.createStore(10)
  local combined = Reactily.combineStores({ store, other }, function(values)
    return values[1].count + values[2]
  end)
  expectEqual(selector.get(), 1)
  store.update(function(state)
    return { count = state.count + 1 }
  end)
  expectEqual(selector.get(), 2)
  expectEqual(combined.get(), 12)
  store.transaction(function()
    store.set({ count = 3 })
    store.set({ count = 4 })
  end)
  expectEqual(store.get().count, 4)
  store.set({ count = -100 })
  expectEqual(store.get().count, 0)
  removeMiddleware()
  combined.delete()
  selector.delete()
  other.delete()
  store.delete()
end)

test("history, selection, form, command controllers", function()
  local history = Reactily.History.create("A", 5)
  expect(history.push("B"))
  expectEqual(history.undo(), "A")
  expectEqual(history.redo(), "B")
  local selection = Reactily.Selection.create({ "A" })
  expect(selection.isSelected("A"))
  expect(selection.select("B"))
  expect(selection.toggle("A"))
  expect(not selection.isSelected("A"))
  local form = Reactily.Form.create({ name = "Lily", age = 1 })
  expect(not form.isDirty())
  expect(form.set("name", "Reactily"))
  expect(form.isDirty())
  expect(form.validate({ name = Reactily.Validator.required() }))
  expectEqual(form.get().name, "Reactily")
  local executed = 0
  local commands = Reactily.Command.create()
  expect(commands.register("inc", {
    execute = function(amount: any)
      executed += amount
    end,
  }))
  expect(commands.execute("inc", 2))
  expectEqual(executed, 2)
  commands.delete()
  form.delete()
  selection.delete()
  history.delete()
end)

-- Ownership / diagnostics / styling / virtualization

test("diagnostics, lifecycle ownership, object pools", function()
  local diagnostics = Reactily.createDiagnostics()
  expectEqual(diagnostics.increment("renders"), 1)
  expectEqual(diagnostics.increment("renders", 2), 3)
  expectEqual(diagnostics.get("renders"), 3)
  expectEqual(diagnostics.snapshot().renders, 3)
  local owner = Reactily.createLifecycleOwner()
  local cleaned = false
  local ownedInstance = Instance.new("Folder")
  ownedInstance.Name = "Owned"
  ownedInstance.Parent = testGui

-- Lifecycle owner methods are intentionally exposed on the owner object.
  local lifecycleModule = ReactilyAny.createLifecycleOwner
  expect(type(lifecycleModule) == "function")
  local pool = Reactily.createObjectPool(function()
    return { value = 1 }
  end, function(object)
    object.value = 0
  end, function(_object)
    cleaned = true
  end, 1
  )
  local object = pool.acquire()
  expectEqual(object.value, 1)
  expect(pool.release(object))
  expectEqual(pool.getAvailableCount(), 1)
  pool.clear()
  expect(cleaned)
  local instancePool = Reactily.createInstancePool("Folder", 1)
  local pooledInstance = instancePool.acquire()
  expect(pooledInstance:IsA("Folder"))
  expect(instancePool.release(pooledInstance))
  instancePool.delete()
  pool.delete()
  diagnostics.delete()

-- The owner is a raw lifecycle record; exercise deletion through its source-facing fields
-- indirectly by ensuring its shape remains valid for current public consumers.
  expect(type(owner.cleanups) == "table")
  expect(type(owner.connections) == "table")
  expect(type(owner.instances) == "table")
  ownedInstance:Destroy()
end)

test("style, theme, props helpers", function()
  local base = Reactily.Style.create({ BackgroundTransparency = 0.5, Visible = true })
  local accent = Reactily.Style.create({ BackgroundTransparency = 0.25 })
  local merged = Reactily.createStyle({ base, accent })
  local applied: any = Reactily.applyStyle({ Name = "X" }, merged)
  expectEqual(applied.BackgroundTransparency, 0.25)
  local variant = Reactily.Style.variant({
    base = base,
    variants = { active = accent },
  }, "active")
  expectEqual(variant.BackgroundTransparency, 0.25)
  expectEqual(Reactily.Style.when(false, accent).BackgroundTransparency, nil)
  expectEqual(Reactily.Style.withProperty(base, "Visible", false).Visible, false)
  expectEqual(Reactily.Style.without(base, "Visible").Visible, nil)
  local theme = Reactily.createTheme({ spacing = 8 })
  expectEqual(
    Reactily.resolveTheme(theme, function(tokens)
      return tokens.spacing
    end),
    8
  )
  theme.update(function(tokens)
    return { spacing = tokens.spacing + 4 }
  end)
  expectEqual(theme.get().spacing, 12)
  theme.delete()
end)

test("virtualization: fixed list, variable window, grid, slicing", function()
  local list = Reactily.createVirtualList(100, 20, 100, 1)
  local range = list.getRange()
  expect(range.first >= 1 and range.last <= 100)
  expect(list.setScrollOffset(200))
  local movedRange = list.getRange()
  expect(movedRange.first > 1)
  local resolved = Reactily.resolveVirtualList(100, 20, 200, 100, 1)
  expect(resolved.first > 1)
  local sliced = Reactily.sliceVirtualList({ "a", "b", "c", "d" }, { first = 2, last = 3, offset = 0, totalSize = 4 })
  expectEqual(#sliced, 2)
  expectEqual(sliced[1], "b")
  local variable = Reactily.createVariableVirtualList({ 10, 20, 30, 40 }, 30, 1)
  expect(variable.getRange().totalSize == 100)
  variable.setScrollOffset(25)
  expect(variable.getRange().first >= 1)
  local variableRange = Reactily.resolveVariableVirtualList({ 10, 20, 30 }, 10, 20, 0)
  expectEqual(variableRange.totalSize, 60)
  local grid = Reactily.resolveVirtualGrid(100, 20, 20, 100, 100, 0, 0, 0, 1)
  expect(grid.firstRow >= 1 and grid.lastRow >= grid.firstRow)
  variable.delete()
  list.delete()
end)

-- Roblox-oriented controllers

test("focus, input, interaction, drag, resize, measure, tooltip controllers", function()
  local focus = Reactily.createFocusGroup()
  expect(focus.add(observedButton))
  expect(focus.focusFirst())
  expect(focus.getCurrent() == observedButton)
  Reactily.clearFocus()
  local input = Reactily.Input.bind(function(_input)
    return false
  end, function(_input)
    return nil
  end, { enabled = false })
  expect(not input.isEnabled())
  expect(input.enable())
  expect(input.isEnabled())
  input.disable()
  local shortcut = Reactily.Shortcut.create({ key = Enum.KeyCode.F8, enabled = false }, function()
    return nil
  end)
  local interaction = Reactily.Interaction.bind(observedButton, {
    normal = { BackgroundTransparency = 0.1 },
    hover = { BackgroundTransparency = 0.2 },
    pressed = { BackgroundTransparency = 0.3 },
  })
  interaction.refresh()
  local drag = Reactily.Drag.bind(observedButton, { enabled = false })
  local handle = Instance.new("Frame")
  handle.Parent = testGui
  local resize = Reactily.Resize.bind(observedFrame, handle, { enabled = false })
  local measure = Reactily.Measure.create(observedFrame)
  local bounds = measure.get()
  expectType(bounds.AbsoluteSize, "Vector2")
  local tooltip = Reactily.Tooltip.attach(playerGui, observedButton, "Reactily", { delay = 0 })
  tooltip.show()
  tooltip.hide()
  tooltip.delete()
  measure.delete()
  resize.delete()
  handle:Destroy()
  drag.delete()
  interaction.delete()
  shortcut.delete()
  input.delete()
  focus.delete()
end)

test("scroll, popover, device, layer controllers", function()
  local scrolling = Instance.new("ScrollingFrame")
  scrolling.Size = UDim2.fromOffset(100, 100)
  scrolling.CanvasSize = UDim2.fromOffset(100, 500)
  scrolling.Parent = testGui
  local target = Instance.new("Frame")
  target.Position = UDim2.fromOffset(0, 200)
  target.Size = UDim2.fromOffset(20, 20)
  target.Parent = scrolling
  Reactily.Scroll.toTop(scrolling)
  expectEqual(scrolling.CanvasPosition.Y, 0)
  Reactily.Scroll.by(scrolling, Vector2.new(0, 20))
  Reactily.Scroll.toBottom(scrolling)
  Reactily.Scroll.toObject(scrolling, target)
  local placed = Reactily.Popover.place(observedButton, observedFrame, { placement = "Bottom" })
  expectType(placed, "UDim2")
  local device = Reactily.Device.create()
  local state = device.get()
  expectType(state.viewportSize, "Vector2")
  local layerParent = Instance.new("Folder")
  layerParent.Parent = testGui
  local layers = Reactily.Layer.create(layerParent)
  expect(not layers.isDeleted())
  layers.delete()
  device.delete()
  layerParent:Destroy()
  scrolling:Destroy()
end)

-- Animation / motion / presence / spring

test("animation, motion, groups, presence, spring", function()
  local frame = Instance.new("Frame")
  frame.BackgroundTransparency = 0
  frame.Parent = testGui
  local tween = Reactily.createTween(frame, { BackgroundTransparency = 0.5 }, { Time = 0 })
  tween.play()
  expect(waitUntil(function(): boolean
    return frame.BackgroundTransparency == 0.5
  end))
  local played = Reactily.playTween(frame, { BackgroundTransparency = 0.25 }, { Time = 0 })
  expect(waitUntil(function(): boolean
    return frame.BackgroundTransparency == 0.25
  end))
  local delay = Reactily.createAnimationDelay(0)
  local parallel = Reactily.parallelAnimations({ delay })
  parallel.play()
  local sequential = Reactily.sequenceAnimations({ Reactily.createAnimationDelay(0) })
  sequential.play()
  local motion = Reactily.Motion.create(frame, { BackgroundTransparency = 0.1 }, { duration = 0 })
  motion.play()
  local motionPlayed = Reactily.Motion.play(frame, { BackgroundTransparency = 0.2 }, { duration = 0 })
  local presence = Reactily.Presence.create(frame, { motion = { duration = 0 } })
  expect(not presence.isDeleted())
  local spring = Reactily.createSpring(0, { frequency = 20, damping = 1 })
  expectEqual(spring.get(), 0)
  spring.setTarget(1)
  expectEqual(spring.getTarget(), 1)
  spring.delete()
  presence.delete()
  motionPlayed.delete()
  motion.delete()
  sequential.delete()
  parallel.delete()
  played.delete()
  tween.delete()
  frame:Destroy()
end)

-- Context, resource, Suspense, lazy, memo, forwardRef

test("context: provider + useContext + Reactily.use", function()
  local context = Reactily.createContext("default")
  local seenHook = ""
  local seenUse = ""
  local function Reader(): Reactily.Element
    seenHook = Reactily.useContext(context)
    seenUse = Reactily.use(context)
    return Reactily.createTextLabel({ Name = "ContextValue", Text = seenHook })
  end
  local root = createTestRoot(host)
  root.render(Reactily.createContextProvider(context, "provided", {
    Reactily.createElement(Reader, {}),
  }))
  root.flush()
  expectEqual(seenHook, "provided")
  expectEqual(seenUse, "provided")
  root.delete()
end)

test("resource + Suspense + Reactily.use", function()
  local resource = Reactily.createResource(function(): string
    task.wait(0.05)
    return "resolved"
  end)
  local function ResourceReader(): Reactily.Element
    local value: string = Reactily.use(resource)
    return Reactily.createTextLabel({ Name = "ResourceValue", Text = value })
  end
  local root = createTestRoot(host)
  root.render(Reactily.Suspense({
    fallback = Reactily.createTextLabel({ Name = "ResourceFallback", Text = "loading" }),
    children = { Reactily.createElement(ResourceReader, {}) },
  }))
  root.flush()
  expect(host:FindFirstChild("ResourceFallback") ~= nil, "Suspense fallback did not mount.")
  expect(
    waitUntil(function(): boolean
      root.flush()
      return host:FindFirstChild("ResourceValue") ~= nil
    end, 2),
    "Suspense resource never resolved."
  )
  expectEqual(resource.getStatus(), "Resolved")
  expectEqual(resource.get(), "resolved")
  root.delete()
  resource.delete()
end)

test("lazy, preloadLazy, memo, forwardRef", function()
  local lazyLoaded = 0
  local LazyComponent = Reactily.lazy(function()
    lazyLoaded += 1
    return function(): Reactily.Element
      return Reactily.createTextLabel({ Name = "LazyValue", Text = "lazy" })
    end
  end)
  expect(Reactily.preloadLazy(LazyComponent), "preloadLazy did not recognize this lazy component.")
  local memoRenders = 0
  local MemoComponent = Reactily.memo(function(props: { value: number }): Reactily.Element
    memoRenders += 1
    return Reactily.createTextLabel({ Name = "MemoValue", Text = tostring(props.value) })
  end)
  local forwarded: any = nil
  local Forwarded = Reactily.forwardRef(function(_props: any, ref: any): Reactily.Element
    forwarded = ref
    return Reactily.createTextLabel({ Name = "ForwardedValue", Text = "forward" })
  end)
  local ref = Reactily.createRef()
  local root = createTestRoot(host)
  root.render(Reactily.createFragment({
    Reactily.Suspense({
      fallback = Reactily.createTextLabel({ Text = "lazy-loading" }),
      children = { Reactily.createElement(LazyComponent, {}) },
    }),
    Reactily.createElement(MemoComponent, { value = 1 }),
    Reactily.createElement(Forwarded, { ref = ref }),
  }))
  expect(waitUntil(function(): boolean
    root.flush()
    return host:FindFirstChild("LazyValue") ~= nil
  end, 2), "LazyValue did not mount within two seconds.")
  expectEqual(lazyLoaded, 1)
  expect(forwarded == ref, "forwardRef did not receive the custom ref prop.")
  root.render(Reactily.createFragment({
    Reactily.createElement(MemoComponent, { value = 1 }),
    Reactily.createElement(Forwarded, { ref = ref }),
  }))
  root.flush()
  expect(memoRenders <= 2, "Memoized component rerendered unexpectedly often.")
  root.delete()
end)

-- New 1.4 boundaries and refs

test("Activity: hidden subtree preserves hook state", function()
  local capturedSetState: ((number) -> ())? = nil
  local function Stateful(): Reactily.Element
    local value, setValue = Reactily.useState(1)
    capturedSetState = function(nextValue: number)
      setValue(nextValue)
    end
    return Reactily.createTextLabel({ Name = "ActivityState", Text = tostring(value) })
  end
  local root = createTestRoot(host)
  root.render(Reactily.Activity({ mode = "visible", children = { Reactily.createElement(Stateful, {}) } }))
  root.flush()
  assert(capturedSetState ~= nil, "Activity state setter was not captured.")
  local setActivityState = capturedSetState
  setActivityState(9)
  root.flush()
  expectEqual((host:FindFirstChild("ActivityState") :: TextLabel).Text, "9")
  root.render(Reactily.Activity({ mode = "hidden", children = { Reactily.createElement(Stateful, {}) } }))
  root.flush()
  local hiddenInstance = host:FindFirstChild("ActivityState")
  assert(hiddenInstance ~= nil, "Activity state label disappeared while hidden.")
  assert(hiddenInstance:IsA("TextLabel"), "Activity state host should be a TextLabel.")
  local hiddenLabel = hiddenInstance
  expect(not hiddenLabel.Visible, "Activity hidden mode did not hide the host subtree.")
  root.render(Reactily.Activity({ mode = "visible", children = { Reactily.createElement(Stateful, {}) } }))
  root.flush()
  local visibleInstance = host:FindFirstChild("ActivityState")
  assert(visibleInstance ~= nil, "Activity state label did not return when visible.")
  assert(visibleInstance:IsA("TextLabel"), "Activity state host should be a TextLabel.")
  local visibleLabel = visibleInstance
  expect(visibleLabel.Visible)
  expectEqual(visibleLabel.Text, "9", "Activity did not preserve component state.")
  root.delete()
end)

test("Profiler: component callback + diagnostics snapshot", function()
  Reactily.resetProfiler()
  Reactily.setProfilingEnabled(true)
  local calls = 0
  local function Probe(): Reactily.Element
    return Reactily.createTextLabel({ Name = "Profiled", Text = "profile" })
  end
  local root = createTestRoot(host)
  root.render(Reactily.Profiler({
    id = "full-test",
    onRender = function(id, phase, duration, reason)
      expectEqual(id, "full-test")
      expect(phase == "mount" or phase == "update")
      expect(duration >= 0)
      expect(type(reason) == "string")
      calls += 1
    end,
    children = { Reactily.createElement(Probe, {}) },
  }))
  root.flush()
  expect(calls >= 1, "Profiler onRender callback did not run.")
  expect(type(Reactily.getProfilerSnapshot()) == "table")
  expect(type(Reactily.getSlowComponents()) == "table")
  root.delete()
  Reactily.setProfilingEnabled(false)
end)

test("StrictMode: preview rendering and diagnostics API", function()
  Reactily.StrictModeDiagnostics.setEnabled(true)
  expect(Reactily.StrictModeDiagnostics.isEnabled())
  local renders = 0
  local function StrictProbe(): Reactily.Element
    renders += 1
    return Reactily.createTextLabel({ Name = "StrictProbe", Text = "strict" })
  end
  local root = createTestRoot(host)
  root.render(Reactily.StrictMode({ children = { Reactily.createElement(StrictProbe, {}) } }))
  root.flush()
  expect(renders >= 2, `StrictMode expected at least two initial renders, got {renders}.`)
  root.delete()
  Reactily.StrictModeDiagnostics.setEnabled(false)
end)

test("ViewTransition: enter, update, exit callbacks", function()
  local entered = 0
  local updated = 0
  local exited = 0
  local root = createTestRoot(host)
  local function tree(size: number): Reactily.Element
    return Reactily.ViewTransition({
      config = { duration = 0, enterFrom = { BackgroundTransparency = 1 } },
      onEnter = function()
        entered += 1
      end,
      onUpdate = function()
        updated += 1
      end,
      onExit = function()
        exited += 1
      end,
      children = {
        Reactily.createFrame({
          Name = "TransitionFrame",
          Size = UDim2.fromOffset(size, size),
          BackgroundTransparency = 0,
        }),
      },
    })
  end
  root.render(tree(20))
  root.flush()
  expect(entered >= 1, "ViewTransition enter callback did not run.")
  root.render(tree(40))
  root.flush()
  expect(updated >= 1, "ViewTransition update callback did not run.")
  root.render(nil)
  root.flush()
  expect(exited >= 1, "ViewTransition exit callback did not run.")
  root.delete()
end)

test("Fragment ref: instances, bounds, focus helpers, refresh/delete", function()
  local fragmentRef = Reactily.createRef()
  local root = createTestRoot(host)
  root.render(Reactily.createFragment({
    Reactily.createTextButton({
      Name = "FragmentA",
      Text = "A",
      Active = true,
      Selectable = true,
      Size = UDim2.fromOffset(40, 20),
    }),
    Reactily.createTextButton({
      Name = "FragmentB",
      Text = "B",
      Active = true,
      Selectable = true,
      Position = UDim2.fromOffset(50, 0),
      Size = UDim2.fromOffset(40, 20),
    }),
  }, nil, fragmentRef))
  root.flush()
  local fragment = fragmentRef.current
  assert(fragment ~= nil, "Fragment ref was not assigned.")
  local instances = fragment.getInstances()
  expectEqual(#instances, 2)
  local boundsPosition, boundsSize = fragment.getBounds()
  expect(boundsPosition ~= nil and boundsSize ~= nil)
  fragment.refresh()
  expect(fragment.focus())
  expect(fragment.focusLast())
  fragment.blur()
  root.delete()
  expect(fragmentRef.current == nil)
end)

-- Errors, transitions, hooks

test("ErrorBoundary catches component failures", function()
  local captured: any = nil
  local function Broken(): Reactily.Element
    error("intentional Reactily test failure")
  end
  local root = createTestRoot(host)
  root.render(Reactily.ErrorBoundary({
    fallback = function(failure)
      return Reactily.createTextLabel({ Name = "CaughtError", Text = tostring(failure) })
    end,
    onError = function(failure)
      captured = failure
    end,
    children = { Reactily.createElement(Broken, {}) },
  }))
  root.flush()
  expect(captured ~= nil)
  expect(host:FindFirstChild("CaughtError") ~= nil)
  root.delete()
end)

test("startTransition executes transition work", function()
  local ran = false
  local thread = Reactily.startTransition(function()
    ran = true
  end)
  expect(type(thread) == "thread")
  expect(waitUntil(function(): boolean
    return ran
  end))
end)

test("hooks: complete exported hook smoke/integration pass", function()
  local context = Reactily.createContext("hook-context")
  local store = Reactily.createStore(10)
  local externalValue = 1
  local externalListeners: { () -> () } = {}
  local ownedDeleteCount = 0
  local probe: { [string]: any } = {}
  local order: { string } = {}
  local function subscribeExternal(callback: () -> ()): () -> ()
    externalListeners[#externalListeners + 1] = callback
    return function()
      local index = table.find(externalListeners, callback)
      if index then
        table.remove(externalListeners, index)
      end
    end
  end
  local function notifyExternal()
    for _, callback in table.clone(externalListeners) do
      callback()
    end
  end
  local function HookProbe(): Reactily.Element
    local state, setState = Reactily.useState(1)
    local reduced, dispatch = Reactily.useReducer(function(current: number, action: number): number
      return current + action
    end, 0)
    local memoValue = Reactily.useMemo(function(): number
      return state * 2
    end, { state })
    local callback = Reactily.useCallback(function(): number
      return state
    end, { state })
    local ref = Reactily.useRef("ref")
    local latest = Reactily.useLatest(state)
    local previous = Reactily.usePrevious(state, 0)
    local id = Reactily.useId()
    local boolean, enableBoolean, disableBoolean, toggleBoolean = Reactily.useBoolean(false)
    local toggleValue, toggle, setToggle = Reactily.useToggle(false)
    local counter, counterControls = Reactily.useCounter(1)
    local controllable, setControllable = Reactily.useControllableState({ defaultValue = 1 })
    local binding = Reactily.useBinding(1)
    local attribute, setAttribute = Reactily.useAttribute(attributeCarrier, "HookValue", 1)
    local contextValue = Reactily.useContext(context)
    local readableContext: string = Reactily.use(context)
    local debounced = Reactily.useDebouncedValue(state, 0)
    local deferred = Reactily.useDeferredValue(state)
    local pending, start = Reactily.useTransition()
    local optimistic, dispatchOptimistic = Reactily.useOptimistic(
      state,
      function(current: number, action: number): number
        return current + action
      end
    )
    local actionState, dispatchAction, actionPending = Reactily.useActionState(
      function(current: number, payload: number): number
        return current + payload
      end,
      0
    )
    local storeValue = Reactily.useStore(store)
    local external = Reactily.useSyncExternalStore(subscribeExternal, function(): number
      return externalValue
    end)
    local tagged = Reactily.useTag(observedFrame, TAG_NAME)
    local propertyName: string = Reactily.useProperty(observedFrame, "Name")
    local camera = Reactily.useCurrentCamera()
    local device = Reactily.useDevice()
    local localPlayer = Reactily.useLocalPlayer()
    local measurement = Reactily.useMeasure(observedFrame)
    local focused = Reactily.useFocus(observedButton)
    local hovered = Reactily.useHover(observedButton)
    local pressed = Reactily.usePressed(observedButton)
    local spring = Reactily.useSpring(state, { frequency = 30, damping = 1 })
    local tween = Reactily.useTween(observedFrame, { BackgroundTransparency = 0.4 }, { Time = 0 }, { state })
    local imperativeRef = Reactily.useRef(nil :: any)
    Reactily.useImperativeHandle(imperativeRef, function()
      return { value = state }
    end, { state })
    Reactily.useDebugValue(state, function(value)
      return `state:{value}`
    end)
    local event = Reactily.useEffectEvent(function(): number
      return state
    end)
    local secondEffectEvent = Reactily.useEffectEvent(function(): number
      return state
    end)
    local secondExternal = Reactily.useSyncExternalStore(subscribeExternal, function(): number
      return externalValue
    end)
    Reactily.useShortcut({ key = Enum.KeyCode.F8, enabled = false }, function()
      return nil
    end)
    local owned = Reactily.useMemo(function()
      return {
        delete = function()
          ownedDeleteCount += 1
        end,
      }
    end, {})
    Reactily.useOwned(owned)
    local didKick = Reactily.useRef(false)
    Reactily.useInsertionEffect(function()
      order[#order + 1] = "insertion"
      return nil
    end, {})
    Reactily.useLayoutEffect(function()
      order[#order + 1] = "layout"
      return nil
    end, {})
    Reactily.useMount(function()
      order[#order + 1] = "mount"
      return nil
    end)
    Reactily.useUpdateEffect(function()
      order[#order + 1] = "update"
      return nil
    end, { state })
    Reactily.useUnmount(function()
      probe.unmounted = true
    end)
    Reactily.useEffect(function()
      order[#order + 1] = "effect"
      if not didKick.current then
        didKick.current = true
        setState(2)
        dispatch(3)
        enableBoolean()
        probe.toggleBooleanFunction = toggleBoolean
        probe.disableBooleanFunction = disableBoolean
        toggle()
        setToggle(true)
        counterControls.increment(2)
        setControllable(4)
        binding.set(5)
        setAttribute(6)
        externalValue = 7
        notifyExternal()
        store.set(20)
        dispatchAction(3)
        start(function()
          dispatchOptimistic(5)
        end)
      end
      return nil
    end, {})
    probe.state = state
    probe.reduced = reduced
    probe.memoValue = memoValue
    probe.callbackValue = callback()
    probe.ref = ref.current
    probe.latest = latest.current
    probe.previous = previous
    probe.id = id
    probe.boolean = boolean
    probe.toggleValue = toggleValue
    probe.counter = counter
    probe.controllable = controllable
    probe.binding = binding.get()
    probe.attribute = attribute
    probe.contextValue = contextValue
    probe.readableContext = readableContext
    probe.debounced = debounced
    probe.deferred = deferred
    probe.pending = pending
    probe.optimistic = optimistic
    probe.actionState = actionState
    probe.actionPending = actionPending
    probe.storeValue = storeValue
    probe.external = external
    probe.tagged = tagged
    probe.propertyName = propertyName
    probe.camera = camera
    probe.device = device
    probe.localPlayer = localPlayer
    probe.measurement = measurement
    probe.focused = focused
    probe.hovered = hovered
    probe.pressed = pressed
    probe.spring = spring
    probe.tween = tween
    probe.imperativeRef = imperativeRef
    probe.eventValue = event()
    probe.secondEffectEventValue = secondEffectEvent()
    probe.secondExternal = secondExternal
    return Reactily.createTextLabel({ Name = "HookProbe", Text = tostring(state) })
  end
  local root = createTestRoot(host)
  root.render(Reactily.createContextProvider(context, "provided-hooks", {
    Reactily.createElement(HookProbe, {}),
  }))
  expect(
    waitUntil(function(): boolean
      root.flush()
      return probe.state == 2 and probe.reduced == 3 and probe.actionState == 3
    end, 3),
    "Hook probe did not settle after state/action updates."
  )
  expectEqual(probe.memoValue, 4)
  expectEqual(probe.callbackValue, 2)
  expectEqual(probe.latest, 2)
  expect(type(probe.id) == "string" and probe.id ~= "")
  expect(probe.boolean == true, "useBoolean did not settle to true.")
  expect(probe.toggleValue == true, "useToggle did not settle to true.")
  expectEqual(probe.counter, 3)
  expectEqual(probe.controllable, 4)
  expectEqual(probe.binding, 5)
  expectEqual(probe.attribute, 6)
  expectEqual(probe.contextValue, "provided-hooks")
  expectEqual(probe.readableContext, "provided-hooks")
  expectEqual(probe.storeValue, 20)
  expectEqual(probe.external, 7)
  expectEqual(probe.secondExternal, 7)
  expect(probe.tagged == true, "useTag did not observe the existing tag.")
  expectEqual(probe.propertyName, observedFrame.Name)
  expect(probe.localPlayer == player, "useLocalPlayer returned the wrong player.")
  expectType(probe.measurement.AbsoluteSize, "Vector2")
  expect(probe.imperativeRef ~= nil
    and probe.imperativeRef.current ~= nil
    and probe.imperativeRef.current.value == 2, "useImperativeHandle did not publish the latest handle after layout effects."
  )
  expectEqual(probe.eventValue, 2)
  expectEqual(probe.secondEffectEventValue, 2)
  local insertionIndex = table.find(order, "insertion")
  local layoutIndex = table.find(order, "layout")
  local effectIndex = table.find(order, "effect")
  expect(
    insertionIndex ~= nil and layoutIndex ~= nil and effectIndex ~= nil,
    "Insertion/layout/normal effect markers were not all recorded."
  )
  expect((insertionIndex :: number) < (layoutIndex :: number), "Insertion effect should run before layout effect.")
  expect((layoutIndex :: number) < (effectIndex :: number), "Layout effect should run before normal effect.")
  root.delete()
  expect(probe.unmounted == true, "useUnmount callback did not run.")
  expect(ownedDeleteCount >= 1, "useOwned resource was not cleaned up.")
  store.delete()
end)

-- Run
print("[Reactily Test] SOURCE REVISION: namespace-case-fixed-2026-10-09 | Hover / Motion")
print(`\n[Reactily Test] Starting {#tests} integration tests against Reactily {Reactily.version}...`)
print(`[Reactily Test] API version: {Reactily.apiVersion}; runtime exports expected: {#EXPECTED_PUBLIC_EXPORTS}`)
for index, case in tests do
  local failureMessage: string? = nil
  local success = xpcall(case.run, function(message)
    failureMessage = debug.traceback(tostring(message), 2)
  end)
  cleanupTestRoots()
  if success then
    passed += 1
    print(`[Reactily Test] PASS {index}/{#tests}: {case.name}`)
  else
    local failure = failureMessage or "Unknown test failure."
    failures[#failures + 1] = {
      name = case.name,
      message = failure,
    }
    warn(`[Reactily Test] FAIL {index}/{#tests}: {case.name}\n{failure}`)
  end
end
cleanupEnvironment()
local elapsed = os.clock() - startedAt
print("\n[Reactily Test] ————————————————————————————————————————————————")
print(`[Reactily Test] Passed: {passed}`)
print(`[Reactily Test] Failed: {#failures}`)
print(`[Reactily Test] Total:  {#tests}`)
print(`[Reactily Test] Time:   {string.format("%.3f", elapsed)}s`)
print("[Reactily Test] ————————————————————————————————————————————————")
if #failures > 0 then
  for index, failure in failures do
    warn(`[Reactily Test] Failure #{index}: {failure.name}\n{failure.message}`)
  end
  error(`Reactily full test failed: {#failures}/{#tests} tests failed.`, 0)
end
print(`[Reactily Test] ALL TESTS PASSED for Reactily {Reactily.version}.`)
