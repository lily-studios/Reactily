---
title: Reactily.preloadLazy
sidebar_label: preloadLazy
sidebar_position: 9
description: API reference for Reactily.preloadLazy.
---

# `Reactily.preloadLazy`

Starts loading a lazy component before it is rendered.

## Signature
```luau
Reactily.preloadLazy(componentValue: Component<any>): boolean
```
## Usage
```luau
Reactily.preloadLazy(lazyComponent)
```
## Works with

Pairs naturally with `lazy`, `createSuspense`, route/page preparation.

## Understanding this API

Advanced component utilities change how Reactily constructs, loads, wraps, or reuses part of the virtual tree. Their behavior affects rendering and component boundaries, not the underlying Roblox Instance class directly.

### Practical guidance

Choose these only when you need their particular behavior; ordinary user interfaces can be built with typed creators and `createComponent`. Understand the component lifecycle and return type before adding wrappers.

## Additional usage notes

### When to use it

Use this helper when starts loading a lazy component before it is rendered.

### Behavior and ownership

Component helpers affect how an element is wrapped, loaded, or constructed inside the virtual tree.

### Pitfalls to avoid

> **Note:** A component wrapper does not become a Roblox Instance until rendered by a root.
