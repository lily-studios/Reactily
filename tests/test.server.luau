--[[

   Reactily · Lily Studios

   Full API / integration / stress test

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

local Reactily = require(ReplicatedStorage:WaitForChild("Reactily"))

local ReactilyAny: any = Reactily

assert(RunService:IsClient(), "Reactily full test must run as a LocalScript on the client.")

local player = Players.LocalPlayer

assert(player ~= nil, "Reactily full test requires Players.LocalPlayer.")

local playerGui = player:WaitForChild("PlayerGui")

-- Compile-time coverage for all types emitted by the current init generator.

type _PublicType001 = Reactily.Animation

type _PublicType002 = Reactily.AnimationGroup

type _PublicType003 = Reactily.AnimationPlayable

type _PublicType004 = Reactily.Atom<any>

type _PublicType005 = Reactily.AtomChange<any>

type _PublicType006 = Reactily.AttributeMap

type _PublicType007 = Reactily.AttributeValue

type _PublicType008 = Reactily.BillboardGuiProps

type _PublicType009 = Reactily.Binding<any>

type _PublicType010 = Reactily.BindingChange<any>

type _PublicType011 = Reactily.ButtonEvents

type _PublicType012 = Reactily.CanvasGroupProps

type _PublicType013 = Reactily.ChangeKeys

type _PublicType014 = Reactily.Command

type _PublicType015 = Reactily.CommandRegistry

type _PublicType016 = Reactily.CommonGuiProps<any>

type _PublicType017 = Reactily.CommonOptions

type _PublicType018 = Reactily.Component<any>

type _PublicType019 = Reactily.ComponentOptions<any>

type _PublicType020 = Reactily.ComponentProfile

type _PublicType021 = Reactily.Computed<any>

type _PublicType022 = Reactily.Connection

type _PublicType023 = Reactily.Context<any>

type _PublicType024 = Reactily.ControllableStateOptions<any>

type _PublicType025 = Reactily.CounterControls

type _PublicType026 = Reactily.DeviceMonitor

type _PublicType027 = Reactily.DeviceState

type _PublicType028 = Reactily.Diagnostics

type _PublicType029 = Reactily.DragAxis

type _PublicType030 = Reactily.DragController

type _PublicType031 = Reactily.DragOptions

type _PublicType032 = Reactily.Element

type _PublicType033 = Reactily.EventKeys

type _PublicType034 = Reactily.FocusGroup

type _PublicType035 = Reactily.FragmentInstance

type _PublicType036 = Reactily.FrameProps

type _PublicType037 = Reactily.GridLayoutOptions

type _PublicType038 = Reactily.GridOptions

type _PublicType039 = Reactily.GridRange

type _PublicType040 = Reactily.HistoryAtom<any>

type _PublicType041 = Reactily.HostMetadataProps<any>

type _PublicType042 = Reactily.ImageButtonProps

type _PublicType043 = Reactily.ImageLabelProps

type _PublicType044 = Reactily.ImageProps

type _PublicType045 = Reactily.InputBinding

type _PublicType046 = Reactily.InputOptions

type _PublicType047 = Reactily.InteractionController

type _PublicType048 = Reactily.InteractionOptions

type _PublicType049 = Reactily.InteractionStyle

type _PublicType050 = Reactily.KeyInputOptions

type _PublicType051 = Reactily.KeyOptions

type _PublicType052 = Reactily.LayerDefinition

type _PublicType053 = Reactily.LayerManager

type _PublicType054 = Reactily.LayoutOptions

type _PublicType055 = Reactily.LifecycleOwner

type _PublicType056 = Reactily.ListLayoutOptions

type _PublicType057 = Reactily.ListOptions

type _PublicType058 = Reactily.Measure

type _PublicType059 = Reactily.MeasureBounds

type _PublicType060 = Reactily.ModalOptions

type _PublicType061 = Reactily.MotionOptions

type _PublicType062 = Reactily.ObjectPool<any>

type _PublicType063 = Reactily.PopoverOptions

type _PublicType064 = Reactily.PopoverPlacement

type _PublicType065 = Reactily.Presence

type _PublicType066 = Reactily.PresenceOptions

type _PublicType067 = Reactily.Priority

type _PublicType068 = Reactily.PropMap

type _PublicType069 = Reactily.ReducerDispatch<any>

type _PublicType070 = Reactily.Ref<any>

type _PublicType071 = Reactily.RefTarget<any>

type _PublicType072 = Reactily.ResizeController

type _PublicType073 = Reactily.ResizeOptions

type _PublicType074 = Reactily.Resource<any>

type _PublicType075 = Reactily.ResourceStatus

type _PublicType076 = Reactily.ResponsiveBreakpoints

type _PublicType077 = Reactily.ResponsiveValues<any>

type _PublicType078 = Reactily.Root

type _PublicType079 = Reactily.SafeAreaInsets

type _PublicType080 = Reactily.Scheduler

type _PublicType081 = Reactily.ScreenGuiProps

type _PublicType082 = Reactily.ScrollingFrameProps

type _PublicType083 = Reactily.Selector<any>

type _PublicType084 = Reactily.ShortcutOptions

type _PublicType085 = Reactily.Signal<any>

type _PublicType086 = Reactily.Spring<any>

type _PublicType087 = Reactily.SpringOptions

type _PublicType088 = Reactily.StateSetter<any>

type _PublicType089 = Reactily.Store<any>

type _PublicType090 = Reactily.StoreMiddleware<any>

type _PublicType091 = Reactily.Style

type _PublicType092 = Reactily.SurfaceGuiProps

type _PublicType093 = Reactily.TextBoxProps

type _PublicType094 = Reactily.TextButtonProps

type _PublicType095 = Reactily.TextLabelProps

type _PublicType096 = Reactily.TextProps

type _PublicType097 = Reactily.Theme<any>

type _PublicType098 = Reactily.Tooltip

type _PublicType099 = Reactily.TooltipOptions

type _PublicType100 = Reactily.TransitionStarter

type _PublicType101 = Reactily.TweenOptions

type _PublicType102 = Reactily.UIAspectRatioConstraintProps

type _PublicType103 = Reactily.UICornerProps

type _PublicType104 = Reactily.UIGradientProps

type _PublicType105 = Reactily.UIGridLayoutProps

type _PublicType106 = Reactily.UIListLayoutProps

type _PublicType107 = Reactily.UIPaddingProps

type _PublicType108 = Reactily.UIPageLayoutProps

type _PublicType109 = Reactily.UIScaleProps

type _PublicType110 = Reactily.UISizeConstraintProps

type _PublicType111 = Reactily.UIStrokeProps

type _PublicType112 = Reactily.UITextSizeConstraintProps

type _PublicType113 = Reactily.ValidationMap

type _PublicType114 = Reactily.VariableVirtualList

type _PublicType115 = Reactily.VariableVirtualRange

type _PublicType116 = Reactily.VariantStyle

type _PublicType117 = Reactily.VideoFrameProps

type _PublicType118 = Reactily.ViewportFrameProps

type _PublicType119 = Reactily.VirtualGridRenderOptions<any>

type _PublicType120 = Reactily.VirtualList

type _PublicType121 = Reactily.VirtualListRenderOptions<any>

type _PublicType122 = Reactily.VirtualRange

local EXPECTED_PUBLIC_EXPORTS = {

   "Activity",

   "Attributes",

   "Change",

   "Children",

   "Command",

   "Component",

   "Debug",

   "Device",

   "Drag",

   "ErrorBoundary",

   "Event",

   "Experimental",

   "Focus",

   "Form",

   "Fragment",

   "History",

   "Hover",

   "Input",

   "Interaction",

   "Layer",

   "Layout",

   "Measure",

   "Modal",

   "Motion",

   "Popover",

   "Presence",

   "Priority",

   "Profiler",

   "Props",

   "Resize",

   "Responsive",

   "SafeArea",

   "Scroll",

   "Selection",

   "Shortcut",

   "StrictMode",

   "StrictModeDiagnostics",

   "Style",

   "Suspense",

   "Tag",

   "Tooltip",

   "Validator",

   "ViewTransition",

   "VirtualGrid",

   "VirtualList",

   "VirtualWindow",

   "apiVersion",

   "applyStyle",

   "batch",

   "bindAttribute",

   "bindProperty",

   "clampBinding",

   "clearFocus",

   "cloneElement",

   "combineBindings",

   "combineBindingsMany",

   "combineStores",

   "createActivity",

   "createAnimationDelay",

   "createAtom",

   "createAttributeAtom",

   "createBillboardGui",

   "createBinding",

   "createCanvasGroup",

   "createComponent",

   "createComputed",

   "createContext",

   "createContextProvider",

   "createDiagnostics",

   "createElement",

   "createErrorBoundary",

   "createFocusGroup",

   "createFragment",

   "createFrame",

   "createHistoryAtom",

   "createImageButton",

   "createImageLabel",

   "createInstancePool",

   "createLifecycleOwner",

   "createObjectPool",

   "createPortal",

   "createRef",

   "createResource",

   "createRoot",

   "createScheduler",

   "createScreenGui",

   "createScrollingFrame",

   "createSelector",

   "createSignal",

   "createSpring",

   "createStore",

   "createStyle",

   "createSurfaceGui",

   "createSuspense",

   "createTextBox",

   "createTextButton",

   "createTextLabel",

   "createTheme",

   "createTween",

   "createUIAspectRatioConstraint",

   "createUICorner",

   "createUIGradient",

   "createUIGridLayout",

   "createUIListLayout",

   "createUIPadding",

   "createUIPageLayout",

   "createUIScale",

   "createUISizeConstraint",

   "createUIStroke",

   "createUITextSizeConstraint",

   "createVariableVirtualList",

   "createVideoFrame",

   "createViewportFrame",

   "createVirtualList",

   "distinctSignal",

   "features",

   "filterSignal",

   "flattenChildren",

   "formatBinding",

   "forwardRef",

   "getProfile",

   "getProfilerSnapshot",

   "getRenderReason",

   "getSlowComponents",

   "getVersion",

   "hasFeature",

   "inspectRoot",

   "isCompatible",

   "isStrictMode",

   "isValidElement",

   "key",

   "lazy",

   "mapBinding",

   "mapSignal",

   "memo",

   "mergeSignals",

   "new",

   "parallelAnimations",

   "patch",

   "playTween",

   "preloadLazy",

   "resetProfiler",

   "resolveTheme",

   "resolveVariableVirtualList",

   "resolveVirtualGrid",

   "resolveVirtualList",

   "roundBinding",

   "sequenceAnimations",

   "setProfilingEnabled",

   "setStrictMode",

   "shallowEqual",

   "skipSignal",

   "sliceVirtualList",

   "startTransition",

   "takeSignal",

   "use",

   "useActionState",

   "useAttribute",

   "useBinding",

   "useBoolean",

   "useCallback",

   "useContext",

   "useControllableState",

   "useCounter",

   "useCurrentCamera",

   "useDebouncedValue",

   "useDebugValue",

   "useDeferredValue",

   "useDevice",

   "useEffect",

   "useEffectEvent",

   "useEvent",

   "useExternalStore",

   "useFocus",

   "useHover",

   "useId",

   "useImperativeHandle",

   "useInsertionEffect",

   "useLatest",

   "useLayoutEffect",

   "useLocalPlayer",

   "useMeasure",

   "useMemo",

   "useMount",

   "useOptimistic",

   "useOwned",

   "usePressed",

   "usePrevious",

   "useProperty",

   "useReducer",

   "useRef",

   "useShortcut",

   "useSpring",

   "useState",

   "useStore",

   "useSyncExternalStore",

   "useTag",

   "useToggle",

   "useTransition",

   "useTween",

   "useUnmount",

   "useUpdateEffect",

   "version",

   "versionInfo",

   "createProfiler",

   "createStrictMode",

   "createViewTransition",

}

local EXPECTED_FUNCTION_EXPORTS = {

   "Activity",

   "ErrorBoundary",

   "StrictMode",

   "Suspense",

   "ViewTransition",

   "applyStyle",

   "batch",

   "bindAttribute",

   "bindProperty",

   "clampBinding",

   "clearFocus",

   "cloneElement",

   "combineBindings",

   "combineBindingsMany",

   "combineStores",

   "createActivity",

   "createAnimationDelay",

   "createAtom",

   "createAttributeAtom",

   "createBillboardGui",

   "createBinding",

   "createCanvasGroup",

   "createComponent",

   "createComputed",

   "createContext",

   "createContextProvider",

   "createDiagnostics",

   "createElement",

   "createErrorBoundary",

   "createFocusGroup",

   "createFragment",

   "createFrame",

   "createHistoryAtom",

   "createImageButton",

   "createImageLabel",

   "createInstancePool",

   "createLifecycleOwner",

   "createObjectPool",

   "createPortal",

   "createRef",

   "createResource",

   "createRoot",

   "createScheduler",

   "createScreenGui",

   "createScrollingFrame",

   "createSelector",

   "createSignal",

   "createSpring",

   "createStore",

   "createStyle",

   "createSurfaceGui",

   "createSuspense",

   "createTextBox",

   "createTextButton",

   "createTextLabel",

   "createTheme",

   "createTween",

   "createUIAspectRatioConstraint",

   "createUICorner",

   "createUIGradient",

   "createUIGridLayout",

   "createUIListLayout",

   "createUIPadding",

   "createUIPageLayout",

   "createUIScale",

   "createUISizeConstraint",

   "createUIStroke",

   "createUITextSizeConstraint",

   "createVariableVirtualList",

   "createVideoFrame",

   "createViewportFrame",

   "createVirtualList",

   "distinctSignal",

   "filterSignal",

   "flattenChildren",

   "formatBinding",

   "forwardRef",

   "getProfile",

   "getProfilerSnapshot",

   "getRenderReason",

   "getSlowComponents",

   "getVersion",

   "hasFeature",

   "inspectRoot",

   "isCompatible",

   "isStrictMode",

   "isValidElement",

   "key",

   "lazy",

   "mapBinding",

   "mapSignal",

   "memo",

   "mergeSignals",

   "new",

   "parallelAnimations",

   "patch",

   "playTween",

   "preloadLazy",

   "resetProfiler",

   "resolveTheme",

   "resolveVariableVirtualList",

   "resolveVirtualGrid",

   "resolveVirtualList",

   "roundBinding",

   "sequenceAnimations",

   "setProfilingEnabled",

   "setStrictMode",

   "shallowEqual",

   "skipSignal",

   "sliceVirtualList",

   "startTransition",

   "takeSignal",

   "use",

   "useActionState",

   "useAttribute",

   "useBinding",

   "useBoolean",

   "useCallback",

   "useContext",

   "useControllableState",

   "useCounter",

   "useCurrentCamera",

   "useDebouncedValue",

   "useDebugValue",

   "useDeferredValue",

   "useDevice",

   "useEffect",

   "useEffectEvent",

   "useEvent",

   "useExternalStore",

   "useFocus",

   "useHover",

   "useId",

   "useImperativeHandle",

   "useInsertionEffect",

   "useLatest",

   "useLayoutEffect",

   "useLocalPlayer",

   "useMeasure",

   "useMemo",

   "useMount",

   "useOptimistic",

   "useOwned",

   "usePressed",

   "usePrevious",

   "useProperty",

   "useReducer",

   "useRef",

   "useShortcut",

   "useSpring",

   "useState",

   "useStore",

   "useSyncExternalStore",

   "useTag",

   "useToggle",

   "useTransition",

   "useTween",

   "useUnmount",

   "useUpdateEffect",

   "createProfiler",

   "createStrictMode",

   "createViewTransition",

}

local REQUIRED_NEW_CREATOR_EXPORTS = {

   "createActivity",

   "createProfiler",

   "createStrictMode",

   "createViewTransition",

}

local EXPECTED_NAMESPACE_MEMBERS: { [string]: { string } } = {

   Children = {

      "Count",

      "ForEach",

      "Map",

      "Only",

      "ToArray",

   },

   Command = {

      "Create",

   },

   Component = {

      "Create",

      "WithDefaults",

   },

   Debug = {

      "FormatTree",

      "Inspect",

   },

   Device = {

      "Create",

   },

   Drag = {

      "Bind",

   },

   Focus = {

      "ClearSelection",

      "New",

   },

   Form = {

      "Create",

   },

   History = {

      "Create",

   },

   Hover = {

      "Bind",

   },

   Input = {

      "Bind",

      "BindKey",

      "BindType",

   },

   Interaction = {

      "Bind",

   },

   Layer = {

      "Create",

   },

   Layout = {

      "Center",

      "Grid",

      "Horizontal",

      "Stack",

      "Vertical",

      "Wrap",

   },

   Measure = {

      "Create",

   },

   Modal = {

      "Create",

   },

   Motion = {

      "Create",

      "Play",

   },

   Popover = {

      "Place",

   },

   Presence = {

      "Create",

   },

   Profiler = {

      "Clear",

      "Get",

      "GetSlowComponents",

      "IsEnabled",

      "Record",

      "SetEnabled",

      "Snapshot",

   },

   Props = {

      "Changed",

      "Defaults",

      "Equal",

      "Merge",

      "Omit",

      "Pick",

   },

   Resize = {

      "Bind",

   },

   Responsive = {

      "Resolve",

   },

   SafeArea = {

      "GetInsets",

      "Padding",

   },

   Scroll = {

      "By",

      "ToBottom",

      "ToObject",

      "ToTop",

   },

   Selection = {

      "Create",

   },

   Shortcut = {

      "Create",

   },

   StrictModeDiagnostics = {

      "IsEnabled",

      "SetEnabled",

      "Warn",

   },

   Style = {

      "Apply",

      "Create",

      "Merge",

      "Variant",

      "When",

      "WithProperty",

      "Without",

   },

   Tooltip = {

      "Attach",

   },

   Validator = {

      "Combine",

      "MaxLength",

      "Number",

      "Pattern",

      "Range",

      "Required",

   },

   VirtualGrid = {

      "Render",

      "Resolve",

   },

   VirtualList = {

      "New",

      "Render",

      "Resolve",

      "Slice",

   },

   VirtualWindow = {

      "New",

      "Resolve",

   },

}

local EXPECTED_FEATURE_FLAGS = {

   "action-state",

   "activity",

   "concurrent-priorities",

   "effect-events",

   "fragment-refs",

   "host-metadata",

   "insertion-effects",

   "optimistic-state",

   "profiler-component",

   "strict-mode-checks",

   "suspense",

   "sync-external-store",

   "transitions",

   "use-api",

   "view-transitions",

   "virtual-grid",

   "virtual-list",

   "virtual-window",

}

type TestCase = {

   Name: string,

   Run: () -> (),

}

type Failure = {

   Name: string,

   Message: string,

}

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

      Name = name,

      Run = callback,

   }

end

local function safeDelete(value: any)

   if type(value) == "table" and type(value.Delete) == "function" then

      pcall(value.Delete)

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

      pcall(root.Delete)

      activeTestRoots[index] = nil

   end

end

--————————————————————————————————————————————————————————————————————--

-- Public surface

--————————————————————————————————————————————————————————————————————--

test("public API: every generated runtime export exists", function()

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

      error(`Missing generated specialized creator exports: {table.concat(missing, ", ")}. Update reactily-exports.cjs or add @reactilyExport annotations.`, 2)

   end

end)

test("public API: every function export is callable", function()

   for _, name in EXPECTED_FUNCTION_EXPORTS do

      expect(

         type(ReactilyAny[name]) == "function",

         `Reactily.{name} should be a function, got {typeof(ReactilyAny[name])}`

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

test("compatibility aliases point at the modern API", function()

   expect(Reactily.new == Reactily.createRoot, "Reactily.new should alias createRoot.")

   expect(Reactily.useEvent == Reactily.useEffectEvent, "Reactily.useEvent alias is stale.")

   expect(Reactily.useExternalStore == Reactily.useSyncExternalStore, "Reactily.useExternalStore alias is stale.")

end)

--————————————————————————————————————————————————————————————————————--

-- Pure utilities and element construction

--————————————————————————————————————————————————————————————————————--

test("utilities: shallowEqual, patch, props, validators, responsive", function()

   expect(Reactily.shallowEqual({ a = 1 }, { a = 1 }))

   expect(not Reactily.shallowEqual({ a = 1 }, { a = 2 }))

   local patched = Reactily.patch({ a = 1, b = 2 }, { b = 3 })

   expectEqual(patched.a, 1)

   expectEqual(patched.b, 3)

   local sourceProps: Reactily.PropMap = { a = 1 }

   local defaults = Reactily.Props.Defaults(sourceProps, { a = 0, b = 2 })

   expectEqual(defaults.a, 1)

   expectEqual(defaults.b, 2)

   local merged = Reactily.Props.Merge({ a = 1 }, { b = 2 })

   expectEqual(merged.a, 1)

   expectEqual(merged.b, 2)

   expect(Reactily.Props.Equal({ a = 1 }, { a = 1 }))

   expectEqual(Reactily.Props.Pick({ a = 1, b = 2 }, { "b" }).b, 2)

   expectEqual(Reactily.Props.Omit({ a = 1, b = 2 }, { "b" }).a, 1)

   local required = Reactily.Validator.Required()

   local numeric = Reactily.Validator.Number()

   local range = Reactily.Validator.Range(1, 3)

   local pattern = Reactily.Validator.Pattern("^Lily")

   local maximum = Reactily.Validator.MaxLength(4)

   local combined = Reactily.Validator.Combine({ required, numeric })

   expect(required("") ~= nil)

   expect(required("ok") == nil)

   expect(numeric(5) == nil)

   expect(numeric("5") ~= nil)

   expect(range(2) == nil and range(4) ~= nil)

   expect(pattern("Lily UI") == nil)

   expect(maximum("1234") == nil and maximum("12345") ~= nil)

   expect(combined(2) == nil)

   local responsive = Reactily.Responsive.Resolve(Vector2.new(1000, 600), {

      Fallback = "fallback",

      Mobile = "mobile",

      Tablet = "tablet",

      Desktop = "desktop",

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

   expectEqual(Reactily.Children.Count({ child, clone }), 2)

   expectEqual(#Reactily.Children.ToArray({ child, clone }), 2)

   expect(Reactily.Children.Only({ child }) == child)

end)

test("layout helpers construct valid elements", function()

   local children = { Reactily.createTextLabel({ Text = "A" }), Reactily.createTextLabel({ Text = "B" }) }

   local layouts = {

      Reactily.Layout.Horizontal(nil, children),

      Reactily.Layout.Vertical(nil, children),

      Reactily.Layout.Wrap(nil, children),

      Reactily.Layout.Grid({ CellSize = UDim2.fromOffset(20, 20) }, children),

      Reactily.Layout.Stack(nil, children),

      Reactily.Layout.Center(nil, children),

      Reactily.Modal.Create(nil, children),

      Reactily.SafeArea.Padding(),

   }

   for _, elementValue in layouts do

      expect(Reactily.isValidElement(elementValue))

   end

end)

--————————————————————————————————————————————————————————————————————--

-- Root / reconciliation / host integration

--————————————————————————————————————————————————————————————————————--

test("root: render, flush, inspect, suspend, resume, batch, delete", function()

   local root = createTestRoot(host)

   root.render(Reactily.createFrame({ Name = "RootProbe", Size = UDim2.fromOffset(100, 40) }))

   root.Flush()

   local frame = host:FindFirstChild("RootProbe")

   expect(frame ~= nil and frame:IsA("Frame"), "Initial host frame was not mounted.")

   expect(root.GetElement() ~= nil)

   expect(root.GetParent() == host)

   expect(root.Inspect() ~= nil)

   expect(Reactily.inspectRoot(root) ~= nil)

   expect(root.Suspend())

   root.render(Reactily.createFrame({ Name = "SuspendedProbe" }))

   root.Flush()

   expect(host:FindFirstChild("SuspendedProbe") == nil, "Suspended root should not reconcile.")

   expect(root.Resume())

   root.Flush()

   expect(host:FindFirstChild("SuspendedProbe") ~= nil, "Resumed root failed to reconcile.")

   root.Batch(function()

      root.render(Reactily.createFrame({ Name = "BatchA" }))

      root.render(Reactily.createFrame({ Name = "BatchB" }))

   end)

   root.Flush()

   expect(host:FindFirstChild("BatchB") ~= nil)

   expect(host:FindFirstChild("BatchA") == nil)

   expect(root.Delete())

   expect(root.IsDeleted())

end)

test("host metadata: refs, attributes, tags, property changes", function()

   local root = createTestRoot(host)

   local hostRef = Reactily.createRef()

   local changedValue: any = nil

   root.render(Reactily.createFrame({

      Name = "MetadataProbe",

      Size = UDim2.fromOffset(50, 50),

      Attributes = { TestAttribute = 123 },

      Tags = { TAG_NAME },

      Ref = hostRef,

      OnPropertyChanged = {

         Name = function(value)

            changedValue = value

         end,

      },

   }))

   root.Flush()

   local frame = hostRef.Current

   assert(frame ~= nil, "Host ref was not assigned.")

   assert(frame:IsA("Frame"), "Host ref should point to a Frame.")

   expectEqual(frame:GetAttribute("TestAttribute"), 123)

   expect(CollectionService:HasTag(frame, TAG_NAME))

   frame.Name = "MetadataProbeRenamed"

   expect(waitUntil(function(): boolean

      return changedValue == "MetadataProbeRenamed"

   end))

   root.Delete()

   expect(hostRef.Current == nil, "Host ref should clear on unmount.")

end)

--————————————————————————————————————————————————————————————————————--

-- Scheduler, batching, signals, bindings

--————————————————————————————————————————————————————————————————————--

test("scheduler: priorities, keyed replacement, cancellation, counts", function()

   local scheduler = Reactily.createScheduler({ TimeSliceSeconds = 0 })

   local order: { string } = {}

   scheduler.EnqueuePriority(Reactily.Priority.Idle, function()

      order[#order + 1] = "idle"

   end)

   scheduler.EnqueuePriority(Reactily.Priority.Transition, function()

      order[#order + 1] = "transition"

   end)

   scheduler.EnqueuePriority(Reactily.Priority.Normal, function()

      order[#order + 1] = "normal"

   end)

   scheduler.EnqueuePriority(Reactily.Priority.UserBlocking, function()

      order[#order + 1] = "user"

   end)

   scheduler.EnqueuePriority(Reactily.Priority.Immediate, function()

      order[#order + 1] = "immediate"

   end)

   expectEqual(scheduler.GetPendingCount(), 5)

   scheduler.Flush()

   expectEqual(table.concat(order, ","), "immediate,user,normal,transition,idle")

   local keyedValue = ""

   scheduler.EnqueueKeyedPriority("same", Reactily.Priority.Idle, function()

      keyedValue = "old"

   end)

   scheduler.EnqueueKeyedPriority("same", Reactily.Priority.UserBlocking, function()

      keyedValue = "new"

   end)

   expect(scheduler.IsPending("same"))

   scheduler.Flush()

   expectEqual(keyedValue, "new")

   local cancelled = scheduler.Enqueue(function()

      error("cancelled scheduler task executed")

   end)

   expect(scheduler.Cancel(cancelled))

   expectEqual(scheduler.GetPendingCount(), 0)

   expect(scheduler.Delete())

   expect(scheduler.IsDeleted())

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

      source.Connect(function(v)

         baseValues[#baseValues + 1] = v

      end),

      mapped.Connect(function(v)

         mappedValues[#mappedValues + 1] = v

      end),

      filtered.Connect(function(v)

         filteredValues[#filteredValues + 1] = v

      end),

      distinct.Connect(function(v)

         distinctValues[#distinctValues + 1] = v

      end),

      skipped.Connect(function(v)

         skippedValues[#skippedValues + 1] = v

      end),

      taken.Connect(function(v)

         takenValues[#takenValues + 1] = v

      end),

      merged.Connect(function(v)

         mergedValues[#mergedValues + 1] = v

      end),

   }

   source.Fire(1)

   source.Fire(2)

   source.Fire(2)

   other.Fire(9)

   expectEqual(#baseValues, 3)

   expectEqual(mappedValues[1], 2)

   expectEqual(filteredValues[1], 2)

   expectEqual(#distinctValues, 2)

   expectEqual(skippedValues[1], 2)

   expectEqual(#takenValues, 2)

   expectEqual(mergedValues[#mergedValues], 9)

   for _, connection in connections do

      connection.Disconnect()

   end

   for _, signalValue in { mapped, filtered, distinct, skipped, taken, merged, source, other } do

      signalValue.Delete()

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

   expectEqual(mapped.Get(), 20)

   expectEqual(combined.Get(), 5)

   expectEqual(many.Get(), 6)

   expectEqual(formatted.Get(), "#2")

   expectNear(rounded.Get(), 1.23, 0.0001)

   expectEqual(clamped.Get(), 5)

   local label = Instance.new("TextLabel")

   label.Parent = testGui

   local textBinding = Reactily.createBinding("A")

   local detachProperty = Reactily.bindProperty(textBinding, label, "Text", true)

   expectEqual(label.Text, "A")

   textBinding.Set("B")

   expectEqual(label.Text, "B")

   label.Text = "C"

   expect(waitUntil(function(): boolean

      return textBinding.Get() == "C"

   end))

   local attributeBinding = Reactily.createBinding(1)

   local detachAttribute = Reactily.bindAttribute(attributeBinding, label, "Bound", true)

   attributeBinding.Set(2)

   expectEqual(label:GetAttribute("Bound"), 2)

   label:SetAttribute("Bound", 3)

   expect(waitUntil(function(): boolean

      return attributeBinding.Get() == 3

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

--————————————————————————————————————————————————————————————————————--

-- State primitives

--————————————————————————————————————————————————————————————————————--

test("atoms: atom, computed, history, attribute atom", function()

   local atom = Reactily.createAtom(1)

   local computed = Reactily.createComputed(atom, function(value: number): number

      return value * 2

   end)

   expectEqual(computed.Get(), 2)

   atom.Update(function(value: number): number

      return value + 2

   end)

   expectEqual(atom.Get(), 3)

   expectEqual(computed.Get(), 6)

   local history = Reactily.createHistoryAtom(0, 5)

   history.Set(1)

   history.Set(2)

   expect(history.CanUndo())

   expect(history.Undo())

   expectEqual(history.Get(), 1)

   expect(history.Redo())

   expectEqual(history.Get(), 2)

   attributeCarrier:SetAttribute("AtomValue", 5)

   local attributeAtom = Reactily.createAttributeAtom(attributeCarrier, "AtomValue", 0)

   expectEqual(attributeAtom.Get(), 5)

   attributeAtom.Set(7)

   expectEqual(attributeCarrier:GetAttribute("AtomValue"), 7)

   attributeAtom.Delete()

   history.Delete()

   computed.Delete()

   atom.Delete()

end)

test("stores: middleware, update, transaction, selector, combine", function()

   local store = Reactily.createStore({ Count = 1 })

   local removeMiddleware = store.Use(function(_previous, nextValue)

      return { Count = math.max(nextValue.Count, 0) }

   end)

   local selector = Reactily.createSelector(store, function(state)

      return state.Count

   end)

   local other = Reactily.createStore(10)

   local combined = Reactily.combineStores({ store, other }, function(values)

      return values[1].Count + values[2]

   end)

   expectEqual(selector.Get(), 1)

   store.Update(function(state)

      return { Count = state.Count + 1 }

   end)

   expectEqual(selector.Get(), 2)

   expectEqual(combined.Get(), 12)

   store.Transaction(function()

      store.Set({ Count = 3 })

      store.Set({ Count = 4 })

   end)

   expectEqual(store.Get().Count, 4)

   store.Set({ Count = -100 })

   expectEqual(store.Get().Count, 0)

   removeMiddleware()

   combined.Delete()

   selector.Delete()

   other.Delete()

   store.Delete()

end)

test("history, selection, form, command controllers", function()

   local history = Reactily.History.Create("A", 5)

   expect(history.Push("B"))

   expectEqual(history.Undo(), "A")

   expectEqual(history.Redo(), "B")

   local selection = Reactily.Selection.Create({ "A" })

   expect(selection.IsSelected("A"))

   expect(selection.Select("B"))

   expect(selection.Toggle("A"))

   expect(not selection.IsSelected("A"))

   local form = Reactily.Form.Create({ Name = "Lily", Age = 1 })

   expect(not form.IsDirty())

   expect(form.Set("Name", "Reactily"))

   expect(form.IsDirty())

   expect(form.Validate({ Name = Reactily.Validator.Required() }))

   expectEqual(form.Get().Name, "Reactily")

   local executed = 0

   local commands = Reactily.Command.Create()

   expect(commands.Register("inc", {

      Execute = function(amount: any)

         executed += amount

      end,

   }))

   expect(commands.Execute("inc", 2))

   expectEqual(executed, 2)

   commands.Delete()

   form.Delete()

   selection.Delete()

   history.Delete()

end)

--————————————————————————————————————————————————————————————————————--

-- Ownership / diagnostics / styling / virtualization

--————————————————————————————————————————————————————————————————————--

test("diagnostics, lifecycle ownership, object pools", function()

   local diagnostics = Reactily.createDiagnostics()

   expectEqual(diagnostics.Increment("renders"), 1)

   expectEqual(diagnostics.Increment("renders", 2), 3)

   expectEqual(diagnostics.Get("renders"), 3)

   expectEqual(diagnostics.Snapshot().renders, 3)

   local owner = Reactily.createLifecycleOwner()

   local cleaned = false

   local ownedInstance = Instance.new("Folder")

   ownedInstance.Name = "Owned"

   ownedInstance.Parent = testGui

-- Lifecycle owner methods are intentionally exposed on the owner object.

   local lifecycleModule = ReactilyAny.createLifecycleOwner

   expect(type(lifecycleModule) == "function")

   local pool = Reactily.createObjectPool(

      function()

         return { value = 1 }

      end,

      function(object)

         object.value = 0

      end,

      function(_object)

         cleaned = true

      end,

      1

   )

   local object = pool.Acquire()

   expectEqual(object.value, 1)

   expect(pool.Release(object))

   expectEqual(pool.GetAvailableCount(), 1)

   pool.Clear()

   expect(cleaned)

   local instancePool = Reactily.createInstancePool("Folder", 1)

   local pooledInstance = instancePool.Acquire()

   expect(pooledInstance:IsA("Folder"))

   expect(instancePool.Release(pooledInstance))

   instancePool.Delete()

   pool.Delete()

   diagnostics.Delete()

-- The owner is a raw lifecycle record; exercise deletion through its source-facing fields

-- indirectly by ensuring its shape remains valid for current public consumers.

   expect(type(owner.Cleanups) == "table")

   expect(type(owner.Connections) == "table")

   expect(type(owner.Instances) == "table")

   ownedInstance:Destroy()

end)

test("style, theme, props helpers", function()

   local base = Reactily.Style.Create({ BackgroundTransparency = 0.5, Visible = true })

   local accent = Reactily.Style.Create({ BackgroundTransparency = 0.25 })

   local merged = Reactily.createStyle({ base, accent })

   local applied: any = Reactily.applyStyle({ Name = "X" }, merged)

   expectEqual(applied.BackgroundTransparency, 0.25)

   local variant = Reactily.Style.Variant({

      Base = base,

      Variants = { active = accent },

   }, "active")

   expectEqual(variant.BackgroundTransparency, 0.25)

   expectEqual(Reactily.Style.When(false, accent).BackgroundTransparency, nil)

   expectEqual(Reactily.Style.WithProperty(base, "Visible", false).Visible, false)

   expectEqual(Reactily.Style.Without(base, "Visible").Visible, nil)

   local theme = Reactily.createTheme({ spacing = 8 })

   expectEqual(Reactily.resolveTheme(theme, function(tokens)

      return tokens.spacing

   end), 8)

   theme.Update(function(tokens)

      return { spacing = tokens.spacing + 4 }

   end)

   expectEqual(theme.Get().spacing, 12)

   theme.Delete()

end)

test("virtualization: fixed list, variable window, grid, slicing", function()

   local list = Reactily.createVirtualList(100, 20, 100, 1)

   local range = list.GetRange()

   expect(range.First >= 1 and range.Last <= 100)

   expect(list.SetScrollOffset(200))

   local movedRange = list.GetRange()

   expect(movedRange.First > 1)

   local resolved = Reactily.resolveVirtualList(100, 20, 200, 100, 1)

   expect(resolved.First > 1)

   local sliced = Reactily.sliceVirtualList({ "a", "b", "c", "d" }, { First = 2, Last = 3, Offset = 0, TotalSize = 4 })

   expectEqual(#sliced, 2)

   expectEqual(sliced[1], "b")

   local variable = Reactily.createVariableVirtualList({ 10, 20, 30, 40 }, 30, 1)

   expect(variable.GetRange().TotalSize == 100)

   variable.SetScrollOffset(25)

   expect(variable.GetRange().First >= 1)

   local variableRange = Reactily.resolveVariableVirtualList({ 10, 20, 30 }, 10, 20, 0)

   expectEqual(variableRange.TotalSize, 60)

   local grid = Reactily.resolveVirtualGrid(100, 20, 20, 100, 100, 0, 0, 0, 1)

   expect(grid.FirstRow >= 1 and grid.LastRow >= grid.FirstRow)

   variable.Delete()

   list.Delete()

end)

--————————————————————————————————————————————————————————————————————--

-- Roblox-oriented controllers

--————————————————————————————————————————————————————————————————————--

test("focus, input, interaction, drag, resize, measure, tooltip controllers", function()

   local focus = Reactily.createFocusGroup()

   expect(focus.Add(observedButton))

   expect(focus.FocusFirst())

   expect(focus.GetCurrent() == observedButton)

   Reactily.clearFocus()

   local input = Reactily.Input.Bind(function(_input)

      return false

   end, function(_input)

      return nil

   end, { Enabled = false })

   expect(not input.IsEnabled())

   expect(input.Enable())

   expect(input.IsEnabled())

   input.Disable()

   local shortcut = Reactily.Shortcut.Create({ Key = Enum.KeyCode.F8, Enabled = false }, function()

      return nil

   end)

   local interaction = Reactily.Interaction.Bind(observedButton, {

      Normal = { BackgroundTransparency = 0.1 },

      Hover = { BackgroundTransparency = 0.2 },

      Pressed = { BackgroundTransparency = 0.3 },

   })

   interaction.Refresh()

   local drag = Reactily.Drag.Bind(observedButton, { Enabled = false })

   local handle = Instance.new("Frame")

   handle.Parent = testGui

   local resize = Reactily.Resize.Bind(observedFrame, handle, { Enabled = false })

   local measure = Reactily.Measure.Create(observedFrame)

   local bounds = measure.Get()

   expectType(bounds.AbsoluteSize, "Vector2")

   local tooltip = Reactily.Tooltip.Attach(playerGui, observedButton, "Reactily", { delay = 0 })

   tooltip.Show()

   tooltip.Hide()

   tooltip.Delete()

   measure.Delete()

   resize.Delete()

   handle:Destroy()

   drag.Delete()

   interaction.Delete()

   shortcut.Delete()

   input.Delete()

   focus.Delete()

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

   Reactily.Scroll.ToTop(scrolling)

   expectEqual(scrolling.CanvasPosition.Y, 0)

   Reactily.Scroll.By(scrolling, Vector2.new(0, 20))

   Reactily.Scroll.ToBottom(scrolling)

   Reactily.Scroll.ToObject(scrolling, target)

   local placed = Reactily.Popover.Place(observedButton, observedFrame, { Placement = "Bottom" })

   expectType(placed, "UDim2")

   local device = Reactily.Device.Create()

   local state = device.Get()

   expectType(state.ViewportSize, "Vector2")

   local layerParent = Instance.new("Folder")

   layerParent.Parent = testGui

   local layers = Reactily.Layer.Create(layerParent)

   expect(not layers.IsDeleted())

   layers.Delete()

   device.Delete()

   layerParent:Destroy()

   scrolling:Destroy()

end)

--————————————————————————————————————————————————————————————————————--

-- Animation / motion / presence / spring

--————————————————————————————————————————————————————————————————————--

test("animation, motion, groups, presence, spring", function()

   local frame = Instance.new("Frame")

   frame.BackgroundTransparency = 0

   frame.Parent = testGui

   local tween = Reactily.createTween(frame, { BackgroundTransparency = 0.5 }, { Time = 0 })

   tween.Play()

   expect(waitUntil(function(): boolean

      return frame.BackgroundTransparency == 0.5

   end))

   local played = Reactily.playTween(frame, { BackgroundTransparency = 0.25 }, { Time = 0 })

   expect(waitUntil(function(): boolean

      return frame.BackgroundTransparency == 0.25

   end))

   local delay = Reactily.createAnimationDelay(0)

   local parallel = Reactily.parallelAnimations({ delay })

   parallel.Play()

   local sequential = Reactily.sequenceAnimations({ Reactily.createAnimationDelay(0) })

   sequential.Play()

   local motion = Reactily.Motion.Create(frame, { BackgroundTransparency = 0.1 }, { Duration = 0 })

   motion.Play()

   local motionPlayed = Reactily.Motion.Play(frame, { BackgroundTransparency = 0.2 }, { Duration = 0 })

   local presence = Reactily.Presence.Create(frame, { Motion = { Duration = 0 } })

   expect(not presence.IsDeleted())

   local spring = Reactily.createSpring(0, { Frequency = 20, Damping = 1 })

   expectEqual(spring.Get(), 0)

   spring.SetTarget(1)

   expectEqual(spring.GetTarget(), 1)

   spring.Delete()

   presence.Delete()

   motionPlayed.Delete()

   motion.Delete()

   sequential.Delete()

   parallel.Delete()

   played.Delete()

   tween.Delete()

   frame:Destroy()

end)

--————————————————————————————————————————————————————————————————————--

-- Context, resource, Suspense, lazy, memo, forwardRef

--————————————————————————————————————————————————————————————————————--

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

   root.Flush()

   expectEqual(seenHook, "provided")

   expectEqual(seenUse, "provided")

   root.Delete()

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

      Fallback = Reactily.createTextLabel({ Name = "ResourceFallback", Text = "loading" }),

      Children = { Reactily.createElement(ResourceReader, {}) },

   }))

   root.Flush()

   expect(host:FindFirstChild("ResourceFallback") ~= nil, "Suspense fallback did not mount.")

   expect(waitUntil(function(): boolean

      root.Flush()

      return host:FindFirstChild("ResourceValue") ~= nil

   end, 2), "Suspense resource never resolved.")

   expectEqual(resource.GetStatus(), "Resolved")

   expectEqual(resource.Get(), "resolved")

   root.Delete()

   resource.Delete()

end)

test("lazy, preloadLazy, memo, forwardRef", function()

   local lazyLoaded = 0

   local LazyComponent = Reactily.lazy(function()

      lazyLoaded += 1

      return function(): Reactily.Element

         return Reactily.createTextLabel({ Name = "LazyValue", Text = "lazy" })

      end

   end)

   expect(Reactily.preloadLazy(LazyComponent))

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

         Fallback = Reactily.createTextLabel({ Text = "lazy-loading" }),

         Children = { Reactily.createElement(LazyComponent, {}) },

      }),

      Reactily.createElement(MemoComponent, { value = 1 }),

      Reactily.createElement(Forwarded, { ref = ref }),

   }))

   expect(waitUntil(function(): boolean

      root.Flush()

      return host:FindFirstChild("LazyValue") ~= nil

   end, 2))

   expectEqual(lazyLoaded, 1)

   expect(forwarded == ref)

   root.render(Reactily.createFragment({

      Reactily.createElement(MemoComponent, { value = 1 }),

      Reactily.createElement(Forwarded, { ref = ref }),

   }))

   root.Flush()

   expect(memoRenders <= 2, "Memoized component rerendered unexpectedly often.")

   root.Delete()

end)

--————————————————————————————————————————————————————————————————————--

-- New 1.4 boundaries and refs

--————————————————————————————————————————————————————————————————————--

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

   root.render(Reactily.Activity({ Mode = "visible", Children = { Reactily.createElement(Stateful, {}) } }))

   root.Flush()

   assert(capturedSetState ~= nil, "Activity state setter was not captured.")

   local setActivityState = capturedSetState

   setActivityState(9)

   root.Flush()

   expectEqual((host:FindFirstChild("ActivityState") :: TextLabel).Text, "9")

   root.render(Reactily.Activity({ Mode = "hidden", Children = { Reactily.createElement(Stateful, {}) } }))

   root.Flush()

   local hiddenInstance = host:FindFirstChild("ActivityState")

   assert(hiddenInstance ~= nil, "Activity state label disappeared while hidden.")

   assert(hiddenInstance:IsA("TextLabel"), "Activity state host should be a TextLabel.")

   local hiddenLabel = hiddenInstance

   expect(not hiddenLabel.Visible, "Activity hidden mode did not hide the host subtree.")

   root.render(Reactily.Activity({ Mode = "visible", Children = { Reactily.createElement(Stateful, {}) } }))

   root.Flush()

   local visibleInstance = host:FindFirstChild("ActivityState")

   assert(visibleInstance ~= nil, "Activity state label did not return when visible.")

   assert(visibleInstance:IsA("TextLabel"), "Activity state host should be a TextLabel.")

   local visibleLabel = visibleInstance

   expect(visibleLabel.Visible)

   expectEqual(visibleLabel.Text, "9", "Activity did not preserve component state.")

   root.Delete()

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

      Id = "full-test",

      OnRender = function(id, phase, duration, reason)

         expectEqual(id, "full-test")

         expect(phase == "mount" or phase == "update")

         expect(duration >= 0)

         expect(type(reason) == "string")

         calls += 1

      end,

      Children = { Reactily.createElement(Probe, {}) },

   }))

   root.Flush()

   expect(calls >= 1, "Profiler onRender callback did not run.")

   expect(type(Reactily.getProfilerSnapshot()) == "table")

   expect(type(Reactily.getSlowComponents()) == "table")

   root.Delete()

   Reactily.setProfilingEnabled(false)

end)

test("StrictMode: preview rendering and diagnostics API", function()

   Reactily.StrictModeDiagnostics.SetEnabled(true)

   expect(Reactily.StrictModeDiagnostics.IsEnabled())

   local renders = 0

   local function StrictProbe(): Reactily.Element

      renders += 1

      return Reactily.createTextLabel({ Name = "StrictProbe", Text = "strict" })

   end

   local root = createTestRoot(host)

   root.render(Reactily.StrictMode({ Children = { Reactily.createElement(StrictProbe, {}) } }))

   root.Flush()

   expect(renders >= 2, `StrictMode expected at least two initial renders, got {renders}.`)

   root.Delete()

end)

test("ViewTransition: enter, update, exit callbacks", function()

   local entered = 0

   local updated = 0

   local exited = 0

   local root = createTestRoot(host)

   local function tree(size: number): Reactily.Element

      return Reactily.ViewTransition({

         Config = { Duration = 0, EnterFrom = { BackgroundTransparency = 1 } },

         OnEnter = function()

            entered += 1

         end,

         OnUpdate = function()

            updated += 1

         end,

         OnExit = function()

            exited += 1

         end,

         Children = {

            Reactily.createFrame({ Name = "TransitionFrame", Size = UDim2.fromOffset(size, size), BackgroundTransparency = 0 }),

         },

      })

   end

   root.render(tree(20))

   root.Flush()

   expect(entered >= 1, "ViewTransition enter callback did not run.")

   root.render(tree(40))

   root.Flush()

   expect(updated >= 1, "ViewTransition update callback did not run.")

   root.render(nil)

   root.Flush()

   expect(exited >= 1, "ViewTransition exit callback did not run.")

   root.Delete()

end)

test("Fragment ref: instances, bounds, focus helpers, refresh/delete", function()

   local fragmentRef = Reactily.createRef()

   local root = createTestRoot(host)

   root.render(Reactily.createFragment({

      Reactily.createTextButton({ Name = "FragmentA", Text = "A", Active = true, Selectable = true, Size = UDim2.fromOffset(40, 20) }),

      Reactily.createTextButton({ Name = "FragmentB", Text = "B", Active = true, Selectable = true, Position = UDim2.fromOffset(50, 0), Size = UDim2.fromOffset(40, 20) }),

   }, nil, fragmentRef))

   root.Flush()

   local fragment = fragmentRef.Current

   assert(fragment ~= nil, "Fragment ref was not assigned.")

   local instances = fragment.GetInstances()

   expectEqual(#instances, 2)

   local boundsPosition, boundsSize = fragment.GetBounds()

   expect(boundsPosition ~= nil and boundsSize ~= nil)

   fragment.Refresh()

   expect(fragment.Focus())

   expect(fragment.FocusLast())

   fragment.Blur()

   root.Delete()

   expect(fragmentRef.Current == nil)

end)

--————————————————————————————————————————————————————————————————————--

-- Errors, transitions, hooks

--————————————————————————————————————————————————————————————————————--

test("ErrorBoundary catches component failures", function()

   local captured: any = nil

   local function Broken(): Reactily.Element

      error("intentional Reactily test failure")

   end

   local root = createTestRoot(host)

   root.render(Reactily.ErrorBoundary({

      Fallback = function(failure)

         return Reactily.createTextLabel({ Name = "CaughtError", Text = tostring(failure) })

      end,

      OnError = function(failure)

         captured = failure

      end,

      Children = { Reactily.createElement(Broken, {}) },

   }))

   root.Flush()

   expect(captured ~= nil)

   expect(host:FindFirstChild("CaughtError") ~= nil)

   root.Delete()

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

      local controllable, setControllable = Reactily.useControllableState({ DefaultValue = 1 })

      local binding = Reactily.useBinding(1)

      local attribute, setAttribute = Reactily.useAttribute(attributeCarrier, "HookValue", 1)

      local contextValue = Reactily.useContext(context)

      local readableContext: string = Reactily.use(context)

      local debounced = Reactily.useDebouncedValue(state, 0)

      local deferred = Reactily.useDeferredValue(state)

      local pending, start = Reactily.useTransition()

      local optimistic, dispatchOptimistic = Reactily.useOptimistic(state, function(current: number, action: number): number

         return current + action

      end)

      local actionState, dispatchAction, actionPending = Reactily.useActionState(function(current: number, payload: number): number

         return current + payload

      end, 0)

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

      local spring = Reactily.useSpring(state, { Frequency = 30, Damping = 1 })

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

      local aliasEvent = Reactily.useEvent(function(): number

         return state

      end)

      local aliasExternal = Reactily.useExternalStore(subscribeExternal, function(): number

         return externalValue

      end)

      Reactily.useShortcut({ Key = Enum.KeyCode.F8, Enabled = false }, function()

         return nil

      end)

      local owned = Reactily.useMemo(function()

         return {

            Delete = function()

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

         if not didKick.Current then

            didKick.Current = true

            setState(2)

            dispatch(3)

            enableBoolean()

            probe.toggleBooleanFunction = toggleBoolean

            probe.disableBooleanFunction = disableBoolean

            toggle()

            setToggle(true)

            counterControls.Increment(2)

            setControllable(4)

            binding.Set(5)

            setAttribute(6)

            externalValue = 7

            notifyExternal()

            store.Set(20)

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

      probe.ref = ref.Current

      probe.latest = latest.Current

      probe.previous = previous

      probe.id = id

      probe.boolean = boolean

      probe.toggleValue = toggleValue

      probe.counter = counter

      probe.controllable = controllable

      probe.binding = binding.Get()

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

      probe.aliasEventValue = aliasEvent()

      probe.aliasExternal = aliasExternal

      return Reactily.createTextLabel({ Name = "HookProbe", Text = tostring(state) })

   end

   local root = createTestRoot(host)

   root.render(Reactily.createContextProvider(context, "provided-hooks", {

      Reactily.createElement(HookProbe, {}),

   }))

   expect(waitUntil(function(): boolean

      root.Flush()

      return probe.state == 2 and probe.reduced == 3 and probe.actionState == 3

   end, 3), "Hook probe did not settle after state/action updates.")

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

   expectEqual(probe.aliasExternal, 7)

   expect(probe.tagged == true, "useTag did not observe the existing tag.")

   expectEqual(probe.propertyName, observedFrame.Name)

   expect(probe.localPlayer == player, "useLocalPlayer returned the wrong player.")

   expectType(probe.measurement.AbsoluteSize, "Vector2")

   expect(

      probe.imperativeRef ~= nil

         and probe.imperativeRef.Current ~= nil

         and probe.imperativeRef.Current.value == 2,

      "useImperativeHandle did not publish the latest handle after layout effects."

   )

   expectEqual(probe.eventValue, 2)

   expectEqual(probe.aliasEventValue, 2)

   local insertionIndex = table.find(order, "insertion")

   local layoutIndex = table.find(order, "layout")

   local effectIndex = table.find(order, "effect")

   expect(insertionIndex ~= nil and layoutIndex ~= nil and effectIndex ~= nil, "Insertion/layout/normal effect markers were not all recorded.")

   expect((insertionIndex :: number) < (layoutIndex :: number), "Insertion effect should run before layout effect.")

   expect((layoutIndex :: number) < (effectIndex :: number), "Layout effect should run before normal effect.")

   root.Delete()

   expect(probe.unmounted == true, "useUnmount callback did not run.")

   expect(ownedDeleteCount >= 1, "useOwned resource was not cleaned up.")

   store.Delete()

end)

--————————————————————————————————————————————————————————————————————--

-- Run

--————————————————————————————————————————————————————————————————————--

print(`\n[Reactily Test] Starting {#tests} integration tests against Reactily {Reactily.version}...`)

print(`[Reactily Test] API version: {Reactily.apiVersion}; runtime exports expected: {#EXPECTED_PUBLIC_EXPORTS}`)

for index, case in tests do

   local failureMessage: string? = nil

   local success = xpcall(case.Run, function(message)

      failureMessage = debug.traceback(tostring(message), 2)

   end)

   cleanupTestRoots()

   if success then

      passed += 1

      print(`[Reactily Test] PASS {index}/{#tests}: {case.Name}`)

   else

      local failure = failureMessage or "Unknown test failure."

      failures[#failures + 1] = {
         Name = case.Name,
         Message = failure,

      }

      warn(`[Reactily Test] FAIL {index}/{#tests}: {case.Name}\n{failure}`)

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

      warn(`[Reactily Test] Failure #{index}: {failure.Name}\n{failure.Message}`)

   end

   error(`Reactily full test failed: {#failures}/{#tests} tests failed.`, 0)

end

print(`[Reactily Test] ALL TESTS PASSED for Reactily {Reactily.version}.`)
