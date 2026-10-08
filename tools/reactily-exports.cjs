"use strict";

/**
 * Reactily public API generation configuration.
 *
 * Source declaration keys are intentionally preserved; they identify the
 * original Luau functions and types in each module. Public type aliases in
 * typeExports use PascalCase (including Roblox's UI prefix).
 *
 * Modules may also opt in using:
 *   --- @reactilyExport [optionalPublicName]
 *   --- @reactilyType [optionalPublicName]
 *
 * Run: node tools/generate-init.cjs
 */

module.exports = {
  sourceDir: "scripts",
  outputFile: "init.luau",
  fallbackVersion: "2.0.0",
  apiVersion: 1,

  requiredRuntimeDirectories: ["core","runtime","state","virtual"],

  functionExports: {
    "core/batching": {
      "Run": ["batch"],
    },
    "core/compare": {
      "shallowEqual": ["shallowEqual"],
    },
    "core/devMode": {
      "isStrictMode": ["isStrictMode"],
      "setStrictMode": ["setStrictMode"],
    },
    "core/lifecycle": {
      "new": ["createLifecycleOwner"],
    },
    "core/objectPool": {
      "instance": ["createInstancePool"],
      "new": ["createObjectPool"],
    },
    "core/scheduler": {
      "new": ["createScheduler"],
    },
    "core/signal": {
      "distinct": ["distinctSignal"],
      "filter": ["filterSignal"],
      "map": ["mapSignal"],
      "merge": ["mergeSignals"],
      "new": ["createSignal"],
      "skip": ["skipSignal"],
      "take": ["takeSignal"],
    },
    "core/tableUtility": {
      "patch": ["patch"],
    },
    "diagnostics/diagnostics": {
      "new": ["createDiagnostics"],
    },
    "diagnostics/profiler": {
      "clear": ["resetProfiler"],
      "get": ["getProfile"],
      "getSlowComponents": ["getSlowComponents"],
      "setEnabled": ["setProfilingEnabled"],
      "snapshot": ["getProfilerSnapshot"],
    },
    "interface/focus": {
      "clearSelection": ["clearFocus"],
      "new": ["createFocusGroup"],
    },
    "interface/style": {
      "apply": ["applyStyle"],
      "merge": ["createStyle"],
    },
    "interface/theme": {
      "new": ["createTheme"],
      "resolve": ["resolveTheme"],
    },
    "interface/virtualGrid": {
      "resolve": ["resolveVirtualGrid"],
    },
    "interface/virtualList": {
      "new": ["createVirtualList"],
      "resolve": ["resolveVirtualList"],
      "slice": ["sliceVirtualList"],
    },
    "interface/virtualWindow": {
      "new": ["createVariableVirtualList"],
      "resolve": ["resolveVariableVirtualList"],
    },
    "runtime/animation": {
      "play": ["playTween"],
      "tween": ["createTween"],
    },
    "runtime/animationGroup": {
      "delay": ["createAnimationDelay"],
      "parallel": ["parallelAnimations"],
      "sequence": ["sequenceAnimations"],
    },
    "runtime/binding": {
      "attachAttribute": ["bindAttribute"],
      "attachProperty": ["bindProperty"],
      "clamp": ["clampBinding"],
      "combine": ["combineBindings"],
      "combineMany": ["combineBindingsMany"],
      "format": ["formatBinding"],
      "map": ["mapBinding"],
      "new": ["createBinding"],
      "round": ["roundBinding"],
    },
    "runtime/lazy": {
      "new": ["lazy"],
      "preload": ["preloadLazy"],
    },
    "runtime/resource": {
      "new": ["createResource"],
    },
    "runtime/root": {
      "new": ["createRoot"],
    },
    "runtime/spring": {
      "new": ["createSpring"],
    },
    "state/atom": {
      "computed": ["createComputed"],
      "fromAttribute": ["createAttributeAtom"],
      "history": ["createHistoryAtom"],
      "new": ["createAtom"],
    },
    "state/context": {
      "new": ["createContext"],
    },
    "state/hooks": {
      "createRef": ["createRef"],
      "useActionState": ["useActionState"],
      "useAttribute": ["useAttribute"],
      "useBinding": ["useBinding"],
      "useBoolean": ["useBoolean"],
      "useCallback": ["useCallback"],
      "useContext": ["useContext"],
      "useControllableState": ["useControllableState"],
      "useCounter": ["useCounter"],
      "useCurrentCamera": ["useCurrentCamera"],
      "useDebouncedValue": ["useDebouncedValue"],
      "useDebugValue": ["useDebugValue"],
      "useDeferredValue": ["useDeferredValue"],
      "useDevice": ["useDevice"],
      "useEffect": ["useEffect"],
      "useEffectEvent": ["useEffectEvent"],
      "useFocus": ["useFocus"],
      "useHover": ["useHover"],
      "useId": ["useId"],
      "useImperativeHandle": ["useImperativeHandle"],
      "useInsertionEffect": ["useInsertionEffect"],
      "useLatest": ["useLatest"],
      "useLayoutEffect": ["useLayoutEffect"],
      "useLocalPlayer": ["useLocalPlayer"],
      "useMeasure": ["useMeasure"],
      "useMemo": ["useMemo"],
      "useMount": ["useMount"],
      "useOptimistic": ["useOptimistic"],
      "useOwned": ["useOwned"],
      "usePressed": ["usePressed"],
      "usePrevious": ["usePrevious"],
      "useProperty": ["useProperty"],
      "useReducer": ["useReducer"],
      "useRef": ["useRef"],
      "useShortcut": ["useShortcut"],
      "useSpring": ["useSpring"],
      "useState": ["useState"],
      "useStore": ["useStore"],
      "useSyncExternalStore": ["useSyncExternalStore"],
      "useTag": ["useTag"],
      "useToggle": ["useToggle"],
      "useTransition": ["useTransition"],
      "useTween": ["useTween"],
      "useUnmount": ["useUnmount"],
      "useUpdateEffect": ["useUpdateEffect"],
    },
    "state/readable": {
      "use": ["use"],
    },
    "state/store": {
      "combine": ["combineStores"],
      "new": ["createStore"],
      "select": ["createSelector"],
    },
    "virtual/element": {
      "createActivity": ["createActivity"],
      "createProfiler": ["createProfiler"],
      "createStrictMode": ["createStrictMode"],
      "createViewTransition": ["createViewTransition"],
      "cloneElement": ["cloneElement"],
      "createBillboardGui": ["createBillboardGui"],
      "createCanvasGroup": ["createCanvasGroup"],
      "createComponent": ["createComponent"],
      "createElement": ["createElement"],
      "createErrorBoundary": ["createErrorBoundary"],
      "createFragment": ["createFragment"],
      "createFrame": ["createFrame"],
      "createImageButton": ["createImageButton"],
      "createImageLabel": ["createImageLabel"],
      "createPortal": ["createPortal"],
      "createScreenGui": ["createScreenGui"],
      "createScrollingFrame": ["createScrollingFrame"],
      "createSurfaceGui": ["createSurfaceGui"],
      "createSuspense": ["createSuspense"],
      "createTextBox": ["createTextBox"],
      "createTextButton": ["createTextButton"],
      "createTextLabel": ["createTextLabel"],
      "createUIAspectRatioConstraint": ["createUIAspectRatioConstraint"],
      "createUICorner": ["createUICorner"],
      "createUIGradient": ["createUIGradient"],
      "createUIGridLayout": ["createUIGridLayout"],
      "createUIListLayout": ["createUIListLayout"],
      "createUIPadding": ["createUIPadding"],
      "createUIPageLayout": ["createUIPageLayout"],
      "createUIScale": ["createUIScale"],
      "createUISizeConstraint": ["createUISizeConstraint"],
      "createUIStroke": ["createUIStroke"],
      "createUITextSizeConstraint": ["createUITextSizeConstraint"],
      "createVideoFrame": ["createVideoFrame"],
      "createViewportFrame": ["createViewportFrame"],
      "flattenChildren": ["flattenChildren"],
      "isValidElement": ["isValidElement"],
    },
    "virtual/forwardRef": {
      "new": ["forwardRef"],
    },
    "virtual/memo": {
      "wrap": ["memo"],
    },
    "virtual/reactCompat": {
      "Activity": ["Activity"],
      "ErrorBoundary": ["ErrorBoundary"],
      "StrictMode": ["StrictMode"],
      "Suspense": ["Suspense"],
      "ViewTransition": ["ViewTransition"],
    },
  },

  typeExports: {
    "core/lifecycle": {
      "owner": ["LifecycleOwner"],
    },
    "core/objectPool": {
      "objectPool": ["ObjectPool"],
    },
    "core/scheduler": {
      "priority": ["Priority"],
      "scheduler": ["Scheduler"],
    },
    "core/signal": {
      "connection": ["Connection"],
      "signal": ["Signal"],
    },
    "diagnostics/diagnostics": {
      "diagnostics": ["Diagnostics"],
    },
    "diagnostics/profiler": {
      "componentProfile": ["ComponentProfile"],
    },
    "interface/command": {
      "command": ["Command"],
      "commandRegistry": ["CommandRegistry"],
    },
    "interface/component": {
      "componentOptions": ["ComponentOptions"],
    },
    "interface/device": {
      "deviceMonitor": ["DeviceMonitor"],
      "deviceState": ["DeviceState"],
    },
    "interface/drag": {
      "dragAxis": ["DragAxis"],
      "dragController": ["DragController"],
      "dragOptions": ["DragOptions"],
    },
    "interface/focus": {
      "focusGroup": ["FocusGroup"],
    },
    "interface/form": {
      "validationMap": ["ValidationMap"],
    },
    "interface/input": {
      "inputBinding": ["InputBinding"],
      "inputOptions": ["InputOptions"],
      "keyOptions": ["KeyInputOptions"],
    },
    "interface/interaction": {
      "interactionController": ["InteractionController"],
      "interactionOptions": ["InteractionOptions"],
      "interactionStyle": ["InteractionStyle"],
    },
    "interface/layer": {
      "layerDefinition": ["LayerDefinition"],
      "layerManager": ["LayerManager"],
    },
    "interface/layout": {
      "commonOptions": ["LayoutOptions"],
      "gridOptions": ["GridLayoutOptions"],
      "listOptions": ["ListLayoutOptions"],
    },
    "interface/measure": {
      "bounds": ["MeasureBounds"],
      "measure": ["Measure"],
    },
    "interface/modal": {
      "modalOptions": ["ModalOptions"],
    },
    "interface/popover": {
      "placement": ["PopoverPlacement"],
      "popoverOptions": ["PopoverOptions"],
    },
    "interface/props": {
      "propMap": ["PropMap"],
    },
    "interface/resize": {
      "resizeController": ["ResizeController"],
      "resizeOptions": ["ResizeOptions"],
    },
    "interface/responsive": {
      "breakpointValues": ["ResponsiveValues"],
      "breakpoints": ["ResponsiveBreakpoints"],
    },
    "interface/safeArea": {
      "insets": ["SafeAreaInsets"],
    },
    "interface/shortcut": {
      "shortcutOptions": ["ShortcutOptions"],
    },
    "interface/style": {
      "style": ["Style"],
      "variantStyle": ["VariantStyle"],
    },
    "interface/theme": {
      "theme": ["Theme"],
    },
    "interface/tooltip": {
      "tooltip": ["Tooltip"],
      "tooltipOptions": ["TooltipOptions"],
    },
    "interface/virtualGrid": {
      "gridRange": ["GridRange"],
      "renderOptions": ["VirtualGridRenderOptions"],
    },
    "interface/virtualList": {
      "range": ["VirtualRange"],
      "renderOptions": ["VirtualListRenderOptions"],
      "virtualList": ["VirtualList"],
    },
    "interface/virtualWindow": {
      "variableRange": ["VariableVirtualRange"],
      "variableVirtualList": ["VariableVirtualList"],
    },
    "runtime/animation": {
      "animation": ["Animation"],
      "tweenOptions": ["TweenOptions"],
    },
    "runtime/animationGroup": {
      "animationGroup": ["AnimationGroup"],
      "playable": ["AnimationPlayable"],
    },
    "runtime/binding": {
      "binding": ["Binding"],
      "bindingChange": ["BindingChange"],
    },
    "runtime/fragmentRef": {
      "fragmentInstance": ["FragmentInstance"],
    },
    "runtime/hostConfig": {
      "changeKeys": ["ChangeKeys"],
      "eventKeys": ["EventKeys"],
    },
    "runtime/motion": {
      "motionOptions": ["MotionOptions"],
    },
    "runtime/presence": {
      "presence": ["Presence"],
      "presenceOptions": ["PresenceOptions"],
    },
    "runtime/resource": {
      "resource": ["Resource"],
      "resourceStatus": ["ResourceStatus"],
    },
    "runtime/root": {
      "root": ["Root"],
    },
    "runtime/spring": {
      "spring": ["Spring"],
      "springOptions": ["SpringOptions"],
    },
    "state/atom": {
      "atom": ["Atom"],
      "atomChange": ["AtomChange"],
      "computed": ["Computed"],
      "historyAtom": ["HistoryAtom"],
    },
    "state/context": {
      "context": ["Context"],
    },
    "state/hooks": {
      "controllableStateOptions": ["ControllableStateOptions"],
      "counterControls": ["CounterControls"],
      "reducerDispatch": ["ReducerDispatch"],
      "ref": ["Ref"],
      "refTarget": ["RefTarget"],
      "stateSetter": ["StateSetter"],
      "transitionStarter": ["TransitionStarter"],
    },
    "state/store": {
      "middleware": ["StoreMiddleware"],
      "selector": ["Selector"],
      "store": ["Store"],
    },
    "virtual/element": {
      "attributeMap": ["AttributeMap"],
      "attributeValue": ["AttributeValue"],
      "billboardGuiProps": ["BillboardGuiProps"],
      "buttonEvents": ["ButtonEvents"],
      "canvasGroupProps": ["CanvasGroupProps"],
      "commonGuiProps": ["CommonGuiProps"],
      "component": ["Component"],
      "element": ["Element"],
      "frameProps": ["FrameProps"],
      "hostMetadataProps": ["HostMetadataProps"],
      "imageButtonProps": ["ImageButtonProps"],
      "imageLabelProps": ["ImageLabelProps"],
      "imageProps": ["ImageProps"],
      "screenGuiProps": ["ScreenGuiProps"],
      "scrollingFrameProps": ["ScrollingFrameProps"],
      "surfaceGuiProps": ["SurfaceGuiProps"],
      "textBoxProps": ["TextBoxProps"],
      "textButtonProps": ["TextButtonProps"],
      "textLabelProps": ["TextLabelProps"],
      "textProps": ["TextProps"],
      "uiAspectRatioConstraintProps": ["UIAspectRatioConstraintProps"],
      "uiCornerProps": ["UICornerProps"],
      "uiGradientProps": ["UIGradientProps"],
      "uiGridLayoutProps": ["UIGridLayoutProps"],
      "uiListLayoutProps": ["UIListLayoutProps"],
      "uiPaddingProps": ["UIPaddingProps"],
      "uiPageLayoutProps": ["UIPageLayoutProps"],
      "uiScaleProps": ["UIScaleProps"],
      "uiSizeConstraintProps": ["UISizeConstraintProps"],
      "uiStrokeProps": ["UIStrokeProps"],
      "uiTextSizeConstraintProps": ["UITextSizeConstraintProps"],
      "videoFrameProps": ["VideoFrameProps"],
      "viewportFrameProps": ["ViewportFrameProps"],
    },
  },

  valueExports: {
    "core/scheduler": {
      "Priority": ["Priority"],
    },
    "runtime/hostConfig": {
      "Attributes": ["Attributes"],
      "Change": ["Change"],
      "Event": ["Event"],
      "Tag": ["Tag"],
    },
    "virtual/element": {
      "Fragment": ["Fragment"],
    },
  },

  namespaceExports: {
    "Children": "virtual/child",
    "Command": "interface/command",
    "Component": "interface/component",
    "Debug": "diagnostics/debug",
    "Device": "interface/device",
    "Drag": "interface/drag",
    "Focus": "interface/focus",
    "Form": "interface/form",
    "History": "state/history",
    "Hover": "interface/hover",
    "Input": "interface/input",
    "Interaction": "interface/interaction",
    "Layer": "interface/layer",
    "Layout": "interface/layout",
    "Measure": "interface/measure",
    "Modal": "interface/modal",
    "Motion": "runtime/motion",
    "Popover": "interface/popover",
    "Presence": "runtime/presence",
    "Props": "interface/props",
    "Resize": "interface/resize",
    "Responsive": "interface/responsive",
    "SafeArea": "interface/safeArea",
    "Scroll": "interface/scroll",
    "Selection": "state/selection",
    "Shortcut": "interface/shortcut",
    "StrictModeDiagnostics": "diagnostics/strictMode",
    "Style": "interface/style",
    "Tooltip": "interface/tooltip",
    "Validator": "interface/validator",
    "VirtualGrid": "interface/virtualGrid",
    "VirtualList": "interface/virtualList",
    "VirtualWindow": "interface/virtualWindow",
  },

  callableNamespaces: {
    Profiler: {
      "namespaceModule": "diagnostics/profiler",
      "componentModule": "virtual/reactCompat",
      "componentFunction": "Profiler",
      "propsType": "profilerProps",
    },
  },

  featureFlags: [
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
    "virtual-window"
  ],

  compatibilityAliases: {
    "new": "createRoot",
    "useEvent": "useEffectEvent",
    "useExternalStore": "useSyncExternalStore",
  },
};
