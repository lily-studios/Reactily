---
sidebar_position: 1
title: Rendering
description: Understand roots, virtual elements, components, and keyed updates.
---

Reactily renders Roblox UI by turning virtual element descriptions into Instances. Your components describe **what the UI should look like**, while the renderer creates and reconciles the actual Roblox objects.

## Roots and ownership

Start with a `PlayerGui`, `SurfaceGui`, or another appropriate Roblox parent. A [render root](/docs/api/virtual-tree/create-root) owns the Reactily tree mounted underneath it.

```luau
local Root = Reactily.createRoot(PlayerGui)
Root.render(Reactily.createFrame({
    Size = UDim2.fromOffset(320, 180),
}))
```

## Virtual elements and typed creators

Typed creators such as `createFrame`, `createTextLabel`, and `createTextButton` describe Roblox GUI objects. These calls do not immediately create Instances.

All Roblox host properties use **PascalCase**.

## Function components

A component is a Luau function that returns an element. Use components to group and reuse UI behavior.

```luau
type GreetingProps = {
    Name: string,
}

local function Greeting(props: GreetingProps): Reactily.Element
    return Reactily.createTextLabel({
        Size = UDim2.fromOffset(240, 44),
        Text = `Hello, {props.Name}`,
    })
end

Root.render(Reactily.createComponent(Greeting, { Name = "Lily" }))
```

Components can use hooks such as [useState](/docs/api/hooks/use-state) to update UI from local state.

## Reconciliation and keys

When you render a new virtual tree, Reactily compares it with the previous one instead of blindly remounting every object. For lists whose items move, insert, or disappear, provide stable keys so item identities survive reordering.

## Portals

A portal renders a subtree into a different Roblox parent while maintaining the logical relationship of the component tree. Use it for overlays or UI hosted outside the normal parent.

## Cleanup

Call `Root.Delete()` to release the root (`Root.render()` intentionally remains lowercase). For more detail see [Lifecycle](/docs/concepts/lifecycle) and [Examples](/docs/guides/examples).
