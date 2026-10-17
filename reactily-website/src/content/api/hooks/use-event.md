---
title: Reactily.useEvent
sidebar_label: useEvent (deprecated)
sidebar_position: 90
description: Deprecated compatibility alias for Reactily.useEffectEvent.
---

# `Reactily.useEvent`

> Deprecated in Reactily 1.4. Use `Reactily.useEffectEvent` instead.

```luau
local handler = Reactily.useEvent(function()
	print(value)
end)
```

The alias is preserved throughout the Reactily 2.x line for compatibility.

## Understanding this API

This hook > Deprecated in Reactily 1.4. Use `Reactily.useEffectEvent` instead. Its result belongs to the component instance, allowing Reactily to preserve the appropriate state or subscription between renders.

### Practical guidance

Call this hook at the top level of a Reactily function component, in a consistent order. Do not place hook calls inside conditionals, loops, event callbacks, or ordinary helper functions. A component may render more than once, so avoid changing Roblox instances directly during render.

## Additional usage notes

### When to use it

Use this hook when the component needs > Deprecated in Reactily 1.4. Use Reactily.useEffectEvent instead.

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
