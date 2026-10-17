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

## Understanding this API

A scheduler queues tasks by priority so work can be processed intentionally instead of all at once.

### Practical guidance

Use keyed tasks when newer work supersedes an older queued task. Cancel pending work on teardown to avoid running callbacks against deleted UI objects.

## Additional usage notes

### When to use it

Use a scheduler to control the order and priority of queued work.

### Behavior and ownership

Tasks are enqueued then processed according to the configured scheduler and priority behavior.

### Pitfalls to avoid

> **Note:** Cancel pending tasks or dispose of the scheduler when its owner shuts down.
