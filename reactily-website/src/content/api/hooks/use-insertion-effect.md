---
title: Reactily.useInsertionEffect
description: Runs an effect after host mutations and before layout effects.
---

# `Reactily.useInsertionEffect`

Runs an effect after host mutations and before layout effects. This export is present in the Reactily v2.1.0 package (API v1).

## Signature

```luau
Reactily.useInsertionEffect(effect: () -> (() -> ())?, dependencies: {any}?): () -> ()
```

## Usage

```luau
Reactily.useInsertionEffect(function()
	local previous = applyStyles()
	return function() restoreStyles(previous) end
end, {Theme})
```

See the related API pages for parameter details and supported behavior. Check the v2.1.0 release source when integrating APIs whose callback or option types are important to your project.

## Understanding this API

This hook runs an effect after host mutations and before layout effects. This export is present in the Reactily v2.1.0 package (API v1). Its result belongs to the component instance, allowing Reactily to preserve the appropriate state or subscription between renders.

### Practical guidance

Call this hook at the top level of a Reactily function component, in a consistent order. Do not place hook calls inside conditionals, loops, event callbacks, or ordinary helper functions. A component may render more than once, so avoid changing Roblox instances directly during render.

## Additional usage notes

### When to use it

Use this hook when the component needs runs an effect after host mutations and before layout effects. This export is present in the Reactily v2.1.0 package (API v1).

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
