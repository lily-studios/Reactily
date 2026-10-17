---
title: "Type: Scheduler"
sidebar_label: Scheduler
description: Luau type Reactily.Scheduler, exported from core.scheduler.
api_types: Scheduler
---

# `Reactily.Scheduler`

`Scheduler` is a public Luau type exported from the `core.scheduler` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type SchedulerAlias = Reactily.Scheduler
```

## Definition

```luau
export type Scheduler = {
	cancel: (taskId: number) -> boolean,
	cancelKey: (key: string) -> boolean,
	clear: () -> (),
	delete: () -> boolean,
	enqueue: (callback: () -> ()) -> number,
	enqueueKeyed: (key: string, callback: () -> ()) -> number,
	enqueueKeyedPriority: (key: string, priorityValue: Priority, callback: () -> ()) -> number,
	enqueuePriority: (priorityValue: Priority, callback: () -> ()) -> number,
	flush: () -> (),
	flushPriority: (priorityValue: Priority) -> (),
	getPendingCount: () -> number,
	getPendingCountByPriority: (priorityValue: Priority) -> number,
	isDeleted: () -> boolean,
	isPending: (key: string) -> boolean,
}
```

## Notes

- Use `Reactily.Scheduler` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

This type represents a Reactily runtime contract. Use it to annotate values returned from the matching factory or to type function parameters.

## Notes and common mistakes

- A type annotation does not create or destroy a runtime object. Manage lifetime through the corresponding instance methods or its owning component/root.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
