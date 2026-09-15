---
title: Reactily.useLatest
sidebar_label: useLatest
sidebar_position: 18
description: API reference for Reactily.useLatest.
---

# `Reactily.useLatest`

Returns a stable ref whose current field is refreshed every render.

## Signature
```typescript
Reactily.useLatest<T>(value: T): ref<T>
```
## Usage
```typescript
local latestValue = Reactily.useLatest(value)
```
## Works with

Pairs naturally with `useEvent`, effects, long-lived subscriptions.
