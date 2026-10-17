---
title: Reactily.useState
sidebar_label: useState
sidebar_position: 28
description: Store local component state and update the rendered UI.
---

`useState` gives a function component a state value and a stable setter. When that value changes, Reactily schedules the component for an update.

## When to use it

Use `useState` for values that belong to one component, such as a counter, selected tab, or whether a menu is open. For shared state outside the component tree, consider an [atom](/docs/api/state/create-atom) or a store instead.

## Signature

```luau
Reactily.useState<T>(initialValue: T): (T, StateSetter<T>)
```

## Parameters

| Parameter | Type | Meaning |
| --- | --- | --- |
| `initialValue` | `T` | Value used when the component first mounts. |

## Returns

Two values: the current state and a setter that accepts a value or an updater function.

## Example: interactive counter

```luau
local function Counter(): Reactily.Element
    local count, setCount = Reactily.useState(0)

    return Reactily.createTextButton({
        Size = UDim2.fromOffset(220, 48),
        Text = `Count: {count}`,
        OnActivated = function()
            setCount(function(previous: number): number
                return previous + 1
            end)
        end,
    })
end
```

Render it with `Reactily.createComponent(Counter, {})` inside a root.

## Important notes

- Call hooks at the top level of a component, in the same order on every render.
- Use the functional setter when the next value depends on the previous state.
- Setting a state value does not directly mutate Roblox Instances; Reactily handles reconciliation.

## Related

[Getting Started](/docs/getting-started) · [State and Reactivity](/docs/concepts/state) · [Examples](/docs/guides/examples)

## Understanding this API

Use this for information a component must remember between renders, such as a selected tab or an input value. The setter schedules another render rather than immediately changing a Roblox Instance.

### Practical guidance

When the next value depends on the previous one, pass an updater function to the setter; this avoids depending on a stale value captured by an earlier callback.

## Additional usage notes

### When to use it

Use component-local state for interaction values that should trigger a rerender, such as a selected tab or open menu.

### Behavior and ownership

Reactily retains the state value across ordinary renders and schedules an update after its setter is called.

### Pitfalls to avoid

> **Note:** Do not change the number or order of hooks between renders. For updates based on the old value, use a functional setter.
