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
Reactily.preloadLazy(componentValue: component<any>): boolean
```
## Usage
```luau
Reactily.preloadLazy(lazyComponent)
```
## Works with

Pairs naturally with `lazy`, `createSuspense`, route/page preparation.
