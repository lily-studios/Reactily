---
sidebar_position: 2
title: State & Reactivity
---

# State & Reactivity

Reactily exposes component state and standalone reactive primitives.

## Hooks
```typescript
local count, setCount = Reactily.useState(0)
```
Hooks must be called in a stable order for every render of a component.

## Atoms

Atoms are useful outside component-local state:
```typescript
local count = Reactily.createAtom(0)

count.subscribe(function(value)
	print(value)
end)

count.set(1)
```
Reactily avoids downstream work when the resolved value has not changed.

## Stores and selectors

Stores group related state. Selectors subscribe to a derived slice so unrelated updates do not force unnecessary work.

## Bindings and signals

Bindings represent reactive values that can feed UI props. Signals are event-style reactive primitives with explicit ownership and cleanup.
