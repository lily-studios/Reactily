---
title: Reactily.useCurrentCamera
description: Returns the current Workspace camera and updates when CurrentCamera changes.
---

# `Reactily.useCurrentCamera`

Returns the current Workspace camera and updates when CurrentCamera changes. This export is included in Reactily v2.2.0 (API v1).

## Signature

```luau
Reactily.useCurrentCamera(): Camera?
```

## Usage

```luau
local camera = Reactily.useCurrentCamera()
```

Use this hook or constructor only in a valid Reactily component/render context, as applicable.

## Understanding this API

The current workspace camera can change, for example after a camera replacement or player initialization. This hook makes camera access part of component observation.

### Practical guidance

Treat the camera as potentially unavailable until it is initialized and avoid holding on to a destroyed old camera object.

## Additional usage notes

### When to use it

Use this hook when the component needs returns the current Workspace camera and updates when CurrentCamera changes. This export is included in Reactily v2.2.0 (API v1).

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
