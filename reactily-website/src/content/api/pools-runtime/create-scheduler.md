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
Reactily.createScheduler(): Scheduler
```
## Parameters

_No parameters._

## Returns

A Reactily scheduler.

## Usage
```luau
local Scheduler = Reactily.createScheduler()
Scheduler.enqueue(function()
	print("scheduled")
end)
```
