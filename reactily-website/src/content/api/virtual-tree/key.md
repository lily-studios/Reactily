---
title: Reactily.key
sidebar_label: key
sidebar_position: 10
description: API reference for Reactily.key.
---

# `Reactily.key`

Returns a clone of an element with a stable key.

## Signature
```luau
Reactily.key(key: string, elementValue: Element): Element
```
## Usage
```luau
local Element = Reactily.createTextLabel({ Text = item.name })
local keyed = Reactily.key(tostring(item.id), Element)
```
## Works with

Pairs naturally with lists, virtualization, keyed reconciliation.
