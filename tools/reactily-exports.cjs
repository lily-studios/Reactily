"use strict";

/**
 * Reactily public API generation configuration.
 *
 * Keep aliases here instead of embedding JSON strings inside the generator.
 * Modules can also opt in with:
 *
 *   --- @reactilyExport [optionalPublicName]
 *   --- @reactilyType [optionalPublicName]
 */
module.exports = {
  sourceDir: "scripts",
  outputFile: "init.luau",
  fallbackVersion: "2.0.0",
  apiVersion: 1,

  requiredRuntimeDirectories: [
    "core",
    "runtime",
    "state",
    "virtual",
  ],

  functionExports: {
  "core/batching": {
    "run": [
      "batch"
    ]
  },
  "core/compare": {
    "shallowEqual": [
      "shallowEqual"
    ]
  },
  "core/devMode": {
    "isStrictMode": [
      "isStrictMode"
    ],
    "setStrictMode": [
      "setStrictMode"
    ]
  },
  "core/lifecycle": {
    "new": [
      "createLifecycleOwner"
    ]
  },
  "core/objectPool": {
    "instance": [
      "createInstancePool"
    ],
    "new": [
      "createObjectPool"
    ]
  },
  "core/scheduler": {
    "new": [
      "createScheduler"
    ]
  },
  "core/signal": {
    "distinct": [
      "distinctSignal"
    ],
    "filter": [
      "filterSignal"
    ],
    "map": [
      "mapSignal"
    ],
    "merge": [
      "mergeSignals"
    ],
    "new": [
      "createSignal"
    ],
    "skip": [
      "skipSignal"
    ],
    "take": [
      "takeSignal"
    ]
  },
  "core/tableUtility": {
    "patch": [
      "patch"
    ]
  },
  "diagnostics/diagnostics": {
    "new": [
      "createDiagnostics"
    ]
  },
  "diagnostics/profiler": {
    "clear": [
      "resetProfiler"
    ],
    "get": [
      "getProfile"
    ],
    "getSlowComponents": [
      "getSlowComponents"
    ],
    "setEnabled": [
      "setProfilingEnabled"
    ],
    "snapshot": [
      "getProfilerSnapshot"
    ]
  },
  "interface/focus": {
    "clearSelection": [
      "clearFocus"
    ],
    "new": [
      "createFocusGroup"
    ]
  },
  "interface/style": {
    "apply": [
      "applyStyle"
    ],
    "merge": [
      "createStyle"
    ]
  },
  "interface/theme": {
    "new": [
      "createTheme"
    ],
    "resolve": [
      "resolveTheme"
    ]
  },
  "interface/virtualGrid": {
    "resolve": [
      "resolveVirtualGrid"
    ]
  },
  "interface/virtualList": {
    "new": [
      "createVirtualList"
    ],
    "resolve": [
      "resolveVirtualList"
    ],
    "slice": [
      "sliceVirtualList"
    ]
  },
  "interface/virtualWindow": {
    "new": [
      "createVariableVirtualList"
    ],
    "resolve": [
      "resolveVariableVirtualList"
    ]
  },
  "runtime/animation": {
    "play": [
      "playTween"
    ],
    "tween": [
      "createTween"
    ]
  },
  "runtime/animationGroup": {
    "delay": [
      "createAnimationDelay"
    ],
    "parallel": [
      "parallelAnimations"
    ],
    "sequence": [
      "sequenceAnimations"
    ]
  },
  "runtime/binding": {
    "attachAttribute": [
      "bindAttribute"
    ],
    "attachProperty": [
      "bindProperty"
    ],
    "clamp": [
      "clampBinding"
    ],
    "combine": [
      "combineBindings"
    ],
    "combineMany": [
      "combineBindingsMany"
    ],
    "format": [
      "formatBinding"
    ],
    "map": [
      "mapBinding"
    ],
    "new": [
      "createBinding"
    ],
    "round": [
      "roundBinding"
    ]
  },
  "runtime/lazy": {
    "new": [
      "lazy"
    ],
    "preload": [
      "preloadLazy"
    ]
  },
  "runtime/resource": {
    "new": [
      "createResource"
    ]
  },
  "runtime/root": {
    "new": [
      "createRoot"
    ]
  },
  "runtime/spring": {
    "new": [
      "createSpring"
    ]
  },
  "state/atom": {
    "computed": [
      "createComputed"
    ],
    "fromAttribute": [
      "createAttributeAtom"
    ],
    "history": [
      "createHistoryAtom"
    ],
    "new": [
      "createAtom"
    ]
  },
  "state/context": {
    "new": [
      "createContext"
    ]
  },
  "state/hooks": {
    "createRef": [
      "createRef"
    ],
    "useActionState": [
      "useActionState"
    ],
    "useAttribute": [
      "useAttribute"
    ],
    "useBinding": [
      "useBinding"
    ],
    "useBoolean": [
      "useBoolean"
    ],
    "useCallback": [
      "useCallback"
    ],
    "useContext": [
      "useContext"
    ],
    "useControllableState": [
      "useControllableState"
    ],
    "useCounter": [
      "useCounter"
    ],
    "useCurrentCamera": [
      "useCurrentCamera"
    ],
    "useDebouncedValue": [
      "useDebouncedValue"
    ],
    "useDebugValue": [
      "useDebugValue"
    ],
    "useDeferredValue": [
      "useDeferredValue"
    ],
    "useDevice": [
      "useDevice"
    ],
    "useEffect": [
      "useEffect"
    ],
    "useEffectEvent": [
      "useEffectEvent"
    ],
    "useFocus": [
      "useFocus"
    ],
    "useHover": [
      "useHover"
    ],
    "useId": [
      "useId"
    ],
    "useImperativeHandle": [
      "useImperativeHandle"
    ],
    "useInsertionEffect": [
      "useInsertionEffect"
    ],
    "useLatest": [
      "useLatest"
    ],
    "useLayoutEffect": [
      "useLayoutEffect"
    ],
    "useLocalPlayer": [
      "useLocalPlayer"
    ],
    "useMeasure": [
      "useMeasure"
    ],
    "useMemo": [
      "useMemo"
    ],
    "useMount": [
      "useMount"
    ],
    "useOptimistic": [
      "useOptimistic"
    ],
    "useOwned": [
      "useOwned"
    ],
    "usePressed": [
      "usePressed"
    ],
    "usePrevious": [
      "usePrevious"
    ],
    "useProperty": [
      "useProperty"
    ],
    "useReducer": [
      "useReducer"
    ],
    "useRef": [
      "useRef"
    ],
    "useShortcut": [
      "useShortcut"
    ],
    "useSpring": [
      "useSpring"
    ],
    "useState": [
      "useState"
    ],
    "useStore": [
      "useStore"
    ],
    "useSyncExternalStore": [
      "useSyncExternalStore"
    ],
    "useTag": [
      "useTag"
    ],
    "useToggle": [
      "useToggle"
    ],
    "useTransition": [
      "useTransition"
    ],
    "useTween": [
      "useTween"
    ],
    "useUnmount": [
      "useUnmount"
    ],
    "useUpdateEffect": [
      "useUpdateEffect"
    ]
  },
  "state/readable": {
    "use": [
      "use"
    ]
  },
  "state/store": {
    "combine": [
      "combineStores"
    ],
    "new": [
      "createStore"
    ],
    "select": [
      "createSelector"
    ]
  },
  "virtual/element": {
    "createActivity": [
      "createActivity"
    ],
    "createProfiler": [
      "createProfiler"
    ],
    "createStrictMode": [
      "createStrictMode"
    ],
    "createViewTransition": [
      "createViewTransition"
    ],
    "cloneElement": [
      "cloneElement"
    ],
    "createBillboardGui": [
      "createBillboardGui"
    ],
    "createCanvasGroup": [
      "createCanvasGroup"
    ],
    "createComponent": [
      "createComponent"
    ],
    "createElement": [
      "createElement"
    ],
    "createErrorBoundary": [
      "createErrorBoundary"
    ],
    "createFragment": [
      "createFragment"
    ],
    "createFrame": [
      "createFrame"
    ],
    "createImageButton": [
      "createImageButton"
    ],
    "createImageLabel": [
      "createImageLabel"
    ],
    "createPortal": [
      "createPortal"
    ],
    "createScreenGui": [
      "createScreenGui"
    ],
    "createScrollingFrame": [
      "createScrollingFrame"
    ],
    "createSurfaceGui": [
      "createSurfaceGui"
    ],
    "createSuspense": [
      "createSuspense"
    ],
    "createTextBox": [
      "createTextBox"
    ],
    "createTextButton": [
      "createTextButton"
    ],
    "createTextLabel": [
      "createTextLabel"
    ],
    "createUIAspectRatioConstraint": [
      "createUIAspectRatioConstraint"
    ],
    "createUICorner": [
      "createUICorner"
    ],
    "createUIGradient": [
      "createUIGradient"
    ],
    "createUIGridLayout": [
      "createUIGridLayout"
    ],
    "createUIListLayout": [
      "createUIListLayout"
    ],
    "createUIPadding": [
      "createUIPadding"
    ],
    "createUIPageLayout": [
      "createUIPageLayout"
    ],
    "createUIScale": [
      "createUIScale"
    ],
    "createUISizeConstraint": [
      "createUISizeConstraint"
    ],
    "createUIStroke": [
      "createUIStroke"
    ],
    "createUITextSizeConstraint": [
      "createUITextSizeConstraint"
    ],
    "createVideoFrame": [
      "createVideoFrame"
    ],
    "createViewportFrame": [
      "createViewportFrame"
    ],
    "flattenChildren": [
      "flattenChildren"
    ],
    "isValidElement": [
      "isValidElement"
    ]
  },
  "virtual/forwardRef": {
    "new": [
      "forwardRef"
    ]
  },
  "virtual/memo": {
    "wrap": [
      "memo"
    ]
  },
  "virtual/reactCompat": {
    "Activity": [
      "Activity"
    ],
    "ErrorBoundary": [
      "ErrorBoundary"
    ],
    "StrictMode": [
      "StrictMode"
    ],
    "Suspense": [
      "Suspense"
    ],
    "ViewTransition": [
      "ViewTransition"
    ]
  }
},

  typeExports: {
  "core/lifecycle": {
    "owner": [
      "lifecycleOwner"
    ]
  },
  "core/objectPool": {
    "objectPool": [
      "objectPool"
    ]
  },
  "core/scheduler": {
    "priority": [
      "priority"
    ],
    "scheduler": [
      "scheduler"
    ]
  },
  "core/signal": {
    "connection": [
      "connection"
    ],
    "signal": [
      "signal"
    ]
  },
  "diagnostics/diagnostics": {
    "diagnostics": [
      "diagnostics"
    ]
  },
  "diagnostics/profiler": {
    "componentProfile": [
      "componentProfile"
    ]
  },
  "interface/command": {
    "command": [
      "command"
    ],
    "commandRegistry": [
      "commandRegistry"
    ]
  },
  "interface/component": {
    "componentOptions": [
      "componentOptions"
    ]
  },
  "interface/device": {
    "deviceMonitor": [
      "deviceMonitor"
    ],
    "deviceState": [
      "deviceState"
    ]
  },
  "interface/drag": {
    "dragAxis": [
      "dragAxis"
    ],
    "dragController": [
      "dragController"
    ],
    "dragOptions": [
      "dragOptions"
    ]
  },
  "interface/focus": {
    "focusGroup": [
      "focusGroup"
    ]
  },
  "interface/form": {
    "validationMap": [
      "validationMap"
    ]
  },
  "interface/input": {
    "inputBinding": [
      "inputBinding"
    ],
    "inputOptions": [
      "inputOptions"
    ],
    "keyOptions": [
      "keyInputOptions"
    ]
  },
  "interface/interaction": {
    "interactionController": [
      "interactionController"
    ],
    "interactionOptions": [
      "interactionOptions"
    ],
    "interactionStyle": [
      "interactionStyle"
    ]
  },
  "interface/layer": {
    "layerDefinition": [
      "layerDefinition"
    ],
    "layerManager": [
      "layerManager"
    ]
  },
  "interface/layout": {
    "commonOptions": [
      "layoutOptions"
    ],
    "gridOptions": [
      "gridLayoutOptions"
    ],
    "listOptions": [
      "listLayoutOptions"
    ]
  },
  "interface/measure": {
    "bounds": [
      "measureBounds"
    ],
    "measure": [
      "measure"
    ]
  },
  "interface/modal": {
    "modalOptions": [
      "modalOptions"
    ]
  },
  "interface/popover": {
    "placement": [
      "popoverPlacement"
    ],
    "popoverOptions": [
      "popoverOptions"
    ]
  },
  "interface/props": {
    "propMap": [
      "propMap"
    ]
  },
  "interface/resize": {
    "resizeController": [
      "resizeController"
    ],
    "resizeOptions": [
      "resizeOptions"
    ]
  },
  "interface/responsive": {
    "breakpointValues": [
      "responsiveValues"
    ],
    "breakpoints": [
      "responsiveBreakpoints"
    ]
  },
  "interface/safeArea": {
    "insets": [
      "safeAreaInsets"
    ]
  },
  "interface/shortcut": {
    "shortcutOptions": [
      "shortcutOptions"
    ]
  },
  "interface/style": {
    "style": [
      "style"
    ],
    "variantStyle": [
      "variantStyle"
    ]
  },
  "interface/theme": {
    "theme": [
      "theme"
    ]
  },
  "interface/tooltip": {
    "tooltip": [
      "tooltip"
    ],
    "tooltipOptions": [
      "tooltipOptions"
    ]
  },
  "interface/virtualGrid": {
    "gridRange": [
      "gridRange"
    ],
    "renderOptions": [
      "virtualGridRenderOptions"
    ]
  },
  "interface/virtualList": {
    "range": [
      "virtualRange"
    ],
    "renderOptions": [
      "virtualListRenderOptions"
    ],
    "virtualList": [
      "virtualList"
    ]
  },
  "interface/virtualWindow": {
    "variableRange": [
      "variableVirtualRange"
    ],
    "variableVirtualList": [
      "variableVirtualList"
    ]
  },
  "runtime/animation": {
    "animation": [
      "animation"
    ],
    "tweenOptions": [
      "tweenOptions"
    ]
  },
  "runtime/animationGroup": {
    "animationGroup": [
      "animationGroup"
    ],
    "playable": [
      "animationPlayable"
    ]
  },
  "runtime/binding": {
    "binding": [
      "binding"
    ],
    "bindingChange": [
      "bindingChange"
    ]
  },
  "runtime/fragmentRef": {
    "fragmentInstance": [
      "fragmentInstance"
    ]
  },
  "runtime/hostConfig": {
    "changeKeys": [
      "changeKeys"
    ],
    "eventKeys": [
      "eventKeys"
    ]
  },
  "runtime/motion": {
    "motionOptions": [
      "motionOptions"
    ]
  },
  "runtime/presence": {
    "presence": [
      "presence"
    ],
    "presenceOptions": [
      "presenceOptions"
    ]
  },
  "runtime/resource": {
    "resource": [
      "resource"
    ],
    "resourceStatus": [
      "resourceStatus"
    ]
  },
  "runtime/root": {
    "root": [
      "root"
    ]
  },
  "runtime/spring": {
    "spring": [
      "spring"
    ],
    "springOptions": [
      "springOptions"
    ]
  },
  "state/atom": {
    "atom": [
      "atom"
    ],
    "atomChange": [
      "atomChange"
    ],
    "computed": [
      "computed"
    ],
    "historyAtom": [
      "historyAtom"
    ]
  },
  "state/context": {
    "context": [
      "context"
    ]
  },
  "state/hooks": {
    "controllableStateOptions": [
      "controllableStateOptions"
    ],
    "counterControls": [
      "counterControls"
    ],
    "reducerDispatch": [
      "reducerDispatch"
    ],
    "ref": [
      "ref"
    ],
    "refTarget": [
      "refTarget"
    ],
    "stateSetter": [
      "stateSetter"
    ],
    "transitionStarter": [
      "transitionStarter"
    ]
  },
  "state/store": {
    "middleware": [
      "storeMiddleware"
    ],
    "selector": [
      "selector"
    ],
    "store": [
      "store"
    ]
  },
  "virtual/element": {
    "attributeMap": [
      "attributeMap"
    ],
    "attributeValue": [
      "attributeValue"
    ],
    "billboardGuiProps": [
      "billboardGuiProps"
    ],
    "buttonEvents": [
      "buttonEvents"
    ],
    "canvasGroupProps": [
      "canvasGroupProps"
    ],
    "commonGuiProps": [
      "commonGuiProps"
    ],
    "component": [
      "component"
    ],
    "element": [
      "element"
    ],
    "frameProps": [
      "frameProps"
    ],
    "hostMetadataProps": [
      "hostMetadataProps"
    ],
    "imageButtonProps": [
      "imageButtonProps"
    ],
    "imageLabelProps": [
      "imageLabelProps"
    ],
    "imageProps": [
      "imageProps"
    ],
    "screenGuiProps": [
      "screenGuiProps"
    ],
    "scrollingFrameProps": [
      "scrollingFrameProps"
    ],
    "surfaceGuiProps": [
      "surfaceGuiProps"
    ],
    "textBoxProps": [
      "textBoxProps"
    ],
    "textButtonProps": [
      "textButtonProps"
    ],
    "textLabelProps": [
      "textLabelProps"
    ],
    "textProps": [
      "textProps"
    ],
    "uiAspectRatioConstraintProps": [
      "uiAspectRatioConstraintProps"
    ],
    "uiCornerProps": [
      "uiCornerProps"
    ],
    "uiGradientProps": [
      "uiGradientProps"
    ],
    "uiGridLayoutProps": [
      "uiGridLayoutProps"
    ],
    "uiListLayoutProps": [
      "uiListLayoutProps"
    ],
    "uiPaddingProps": [
      "uiPaddingProps"
    ],
    "uiPageLayoutProps": [
      "uiPageLayoutProps"
    ],
    "uiScaleProps": [
      "uiScaleProps"
    ],
    "uiSizeConstraintProps": [
      "uiSizeConstraintProps"
    ],
    "uiStrokeProps": [
      "uiStrokeProps"
    ],
    "uiTextSizeConstraintProps": [
      "uiTextSizeConstraintProps"
    ],
    "videoFrameProps": [
      "videoFrameProps"
    ],
    "viewportFrameProps": [
      "viewportFrameProps"
    ]
  }
},

  valueExports: {
  "core/scheduler": {
    "Priority": [
      "Priority"
    ]
  },
  "runtime/hostConfig": {
    "Attributes": [
      "Attributes"
    ],
    "Change": [
      "Change"
    ],
    "Event": [
      "Event"
    ],
    "Tag": [
      "Tag"
    ]
  },
  "virtual/element": {
    "Fragment": [
      "Fragment"
    ]
  }
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
  "VirtualWindow": "interface/virtualWindow"
},

  callableNamespaces: {
    Profiler: {
      namespaceModule: "diagnostics/profiler",
      componentModule: "virtual/reactCompat",
      componentFunction: "Profiler",
      propsType: "profilerProps",
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
    new: "createRoot",
    useEvent: "useEffectEvent",
    useExternalStore: "useSyncExternalStore",
  },
};
