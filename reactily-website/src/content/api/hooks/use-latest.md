---
title: Reactily.useLatest
sidebar_label: useLatest
sidebar_position: 18
description: API reference for Reactily.useLatest.
---

# `Reactily.useLatest`

Returns a stable ref whose current field is refreshed every render.

## Signature
```luau
Reactily.useLatest<T>(value: T): Ref<T>
```
## Usage
```luau
local latestValue = Reactily.useLatest(value)
```
## Works with

Pairs naturally with `useEffectEvent`, effects, long-lived subscriptions.
