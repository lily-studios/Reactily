---
title: React 19.3 parity
sidebar_label: React 19.3 parity
sidebar_position: 4
description: How the current Reactily runtime maps modern React concepts onto Roblox and which DOM-only APIs intentionally do not carry over.
---

# React 19.3 parity

Reactily is React-inspired, not a DOM renderer. The current documentation site itself runs on React 19.3, while the Roblox runtime exposes the React-style concepts that make sense for Roblox Instances and Luau.

## Current Reactily equivalents

The unreleased Reactily 1.4.0 development runtime already includes modern state and concurrency-style APIs:

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

## React 19.3 features that are DOM-specific

React 19.3 stabilized View Transitions and Fragment Refs. React's View Transition implementation is explicitly DOM-based, so Reactily should not copy that API literally onto Roblox. Reactily already provides Roblox-native animation building blocks through `Motion`, `Presence`, tweens, springs, and transition scheduling.

React DOM's `browser()` and Trusted Types support are also web/server-rendering features and do not map to Roblox clients.

## Fragment refs

Reactily currently exposes `Reactily.Fragment` and `Reactily.createFragment`, but it does not claim React 19.3 Fragment Ref parity. If Fragment-group refs are added later, they should use Roblox-native operations and ship as an additive minor-version feature.

## Compatibility rule

New React-inspired functionality should be additive throughout Reactily 1.x. Existing public names and behavior remain supported, deprecated APIs get a migration period, and intentionally breaking changes wait for Reactily 2.0.
