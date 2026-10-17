---
title: Reactily.ViewTransition
description: Compatibility component for configuring enter, exit, and update transitions.
---

# `Reactily.ViewTransition`

Compatibility component for configuring enter, exit, and update transitions. This export is present in the Reactily v2.1.0 package (API v1).

## Signature

```luau
Reactily.ViewTransition(props: { Children: Element, Config: {[string]: any}?, Key: string?, OnEnter: ((...any) -> ())?, OnExit: ((...any) -> ())?, OnUpdate: ((...any) -> ())? }): Element
```

## Usage

```luau
local transition = Reactily.ViewTransition({ Children = child, Config = { Duration = 0.2 } })
```

See the related API pages for parameter details and supported behavior. Check the v2.1.0 release source when integrating APIs whose callback or option types are important to your project.

## Understanding this API

This animation operation fits into Reactily’s handling of time-based UI behavior. Check the return type carefully: composing a sequence, creating a spring, and playing a Tween have different lifetime and playback rules.

### Practical guidance

Review the return type before using the result: an animation handle may need to be played and eventually cleaned up, whereas a transition helper may schedule an existing callback. Keep native property names in official Roblox casing.

## Additional usage notes

### When to use it

Use this helper when compatibility component for configuring enter, exit, and update transitions. This export is present in the Reactily v2.1.0 package (API v1).

### Behavior and ownership

Animation helpers have different ownership and playback behavior. Review the return type before composing them.

### Pitfalls to avoid

> **Note:** Do not assume every animation helper returns a Tween or starts playing immediately.
