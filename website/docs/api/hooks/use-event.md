---
title: Reactily.useEvent
sidebar_label: useEvent
sidebar_position: 12
description: API reference for Reactily.useEvent.
---

# `Reactily.useEvent`

Creates a stable callback that always invokes the latest callback body.

## Signature
```typescript
Reactily.useEvent<T>(callback: T): T
```
## Usage
```typescript
local onActivated = Reactily.useEvent(function()
	print(value)
end)
```
## Works with

Pairs naturally with `useLatest`, event props, external subscriptions.
