---
title: Reactily.key
sidebar_label: key
sidebar_position: 10
description: API reference for Reactily.key.
---

# `Reactily.key`

Returns a clone of an element with a stable key.

## Signature
```typescript
Reactily.key(key: string, elementValue: element): element
```
## Usage
```typescript
local keyed = Reactily.key(
	tostring(item.id),
	element
)
```
## Works with

Pairs naturally with lists, virtualization, keyed reconciliation.
