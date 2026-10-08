---
title: Reactily.createScheduler
sidebar_label: createScheduler
sidebar_position: 5
description: API reference for Reactily.createScheduler.
---

# `Reactily.createScheduler`

Creates Reactily's idle-safe one-shot work scheduler.

## Signature
```luau
Reactily.createScheduler(): scheduler
```
## Parameters

_No parameters._

## Returns

A Reactily scheduler.

## Usage
```luau
local scheduler = Reactily.createScheduler()
scheduler.enqueue(function()
	print("scheduled")
end)
```
