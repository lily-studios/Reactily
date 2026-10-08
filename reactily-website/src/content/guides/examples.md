---
sidebar_position: 2
title: Examples
description: Practical, copyable Luau patterns for Reactily v2.1.0.
---

The examples below follow the [v2.1.0 release](https://github.com/lily-studios/Reactily/releases/tag/v2.1.0). Public function names stay camelCase, exported types and Roblox host properties use PascalCase, and render roots expose `render()` and `delete()`.

## Before you begin

Install the published `Reactily.rbxm` package in `ReplicatedStorage`. Put the following setup in a `LocalScript` under `StarterPlayerScripts`:

```luau
--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Reactily = require(ReplicatedStorage:WaitForChild("Reactily"))
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Root = Reactily.createRoot(PlayerGui)
```

Each rendering example can reuse this setup. Replace the previously rendered tree when trying a different example.

## Interactive counter

**Use this for:** Learning components, `useState`, and Roblox button events. The label changes when the player activates the button; no manual TextLabel updates are needed.

```luau
type CounterProps = {
    InitialValue: number,
}

local function Counter(props: CounterProps): Reactily.Element
    local count, setCount = Reactily.useState(props.InitialValue)

    return Reactily.createTextButton({
        Size = UDim2.fromOffset(240, 56),
        Text = `Count: {count}`,
        OnActivated = function()
            setCount(function(previous: number): number
                return previous + 1
            end)
        end,
    })
end

Root.render(Reactily.createComponent(Counter, {
    InitialValue = 0,
}))
```

The state setter receives the previous value, avoiding a stale captured count when updates are queued. [Read the useState API](/docs/api/hooks/use-state).

## Frame with child content

**Use this for:** A simple panel with Roblox-native dimensions and colors. The frame and label are virtual elements until they are passed to a render root.

```luau
local Panel = Reactily.createFrame({
    Size = UDim2.fromOffset(340, 150),
    Position = UDim2.fromOffset(24, 24),
    BackgroundColor3 = Color3.fromRGB(27, 34, 40),
    BorderSizePixel = 0,
}, {
    Reactily.createTextLabel({
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "Welcome to Reactily",
        TextColor3 = Color3.fromRGB(240, 247, 250),
    }),
})

Root.render(Panel)
```

[Frame creator reference](/docs/api/typed-creators/create-frame) explains the arguments and return value.

## Standalone atom

**Use this for:** Shared reactive state outside a component. Atoms notify subscribers when their stored value changes.

```luau
local CounterAtom = Reactily.createAtom(0)
local Connection = CounterAtom.subscribe(function(value: number)
    print("Count:", value)
end)

CounterAtom.set(1)
Connection()
```

Subscriptions must be cleaned up when no longer needed. Check the [atom reference](/docs/api/state/create-atom) for its precise subscription contract.

## Virtual list range

**Use this for:** Long inventories, search results, or menus where only visible rows should be mounted. Calculating a range does not automatically render or recycle rows.

```luau
local ItemCount = 5000
local RowHeight = 44
local ScrollOffset = 250
local ViewportHeight = 420
local Overscan = 3

local Range = Reactily.resolveVirtualList(
    ItemCount,
    RowHeight,
    ScrollOffset,
    ViewportHeight,
    Overscan
)

print(Range.first, Range.last, Range.totalSize)
```

Use the returned range to choose which items to create. [Virtual list reference](/docs/api/virtualization/resolve-virtual-list).

## Animation

**Use this for:** Changing properties of an actual Roblox Instance with an owned animation. Unlike virtual elements, the first argument must be a mounted Instance.

```luau
local Frame = Instance.new("Frame")
Frame.Size = UDim2.fromOffset(240, 120)
Frame.BackgroundTransparency = 1
Frame.Parent = PlayerGui

local Animation = Reactily.playTween(Frame, {
    BackgroundTransparency = 0,
}, {
    Time = 0.25,
    EasingStyle = Enum.EasingStyle.Quad,
    EasingDirection = Enum.EasingDirection.Out,
})

-- When this animation is no longer needed:
-- Animation.delete()
```

[Animation reference](/docs/api/animation/play-tween) covers the owned animation handle.

## Render root cleanup

**Use this for:** Closing an interface or disposing of a local UI controller.

```luau
Root.delete()
```

Do not continue rendering into a root after deleting it. Use Roblox's own `:Destroy()` and `:Disconnect()` methods for Roblox-owned resources.

## Next steps

- [Getting Started](/docs/getting-started) — complete setup and first UI
- [Rendering](/docs/concepts/rendering) — elements, components, and roots
- [State and Reactivity](/docs/concepts/state) — choosing reactive primitives
- [Browse API](/api) — search the complete reference
