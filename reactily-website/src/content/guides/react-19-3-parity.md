---
title: React 19.3 parity
sidebar_label: React 19.3 parity
sidebar_position: 4
description: How the current Reactily runtime maps modern React concepts onto Roblox and which DOM-only APIs intentionally do not carry over.
---

# React 19.3 parity

Reactily is React-inspired, not a DOM renderer. The current documentation site itself runs on React 19.3, while the Roblox runtime exposes the React-style concepts that make sense for Roblox Instances and Luau.

## Current Reactily equivalents

Reactily v2.1.0 (API v1) already includes modern state and concurrency-style APIs:

```luau
Reactily.useActionState
Reactily.useOptimistic
Reactily.useEffectEvent
Reactily.useDeferredValue
Reactily.useTransition
Reactily.startTransition
Reactily.Suspense
Reactily.lazy
Reactily.memo
Reactily.forwardRef
Reactily.createContext
```

It also includes Roblox-specific hooks that do not exist in React DOM:

```luau
Reactily.useCurrentCamera
Reactily.useDevice
Reactily.useLocalPlayer
Reactily.useMeasure
Reactily.useProperty
Reactily.useShortcut
Reactily.useTag
```

## APIs mapped to Roblox

Reactily v2.1.0 includes Roblox-native `ViewTransition` and Fragment ref capabilities. These do not render browser DOM snapshots; they operate on Reactily elements and Roblox Instances. For transition configuration, see the [`createViewTransition` API](/docs/api/animation/create-view-transition). The package also exposes the `FragmentInstance` type.

React DOM's `browser()` and Trusted Types support are also web/server-rendering features and do not map to Roblox clients.

## Compatibility rule

New React-inspired functionality should be additive throughout Reactily 2.x. Existing public names and behavior remain supported, deprecated APIs get a migration period, and intentionally breaking changes wait for the next major release.
