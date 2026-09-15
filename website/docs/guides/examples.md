---
sidebar_position: 2
title: Examples
---

# Examples

## Counter
```typescript
local function counter(): Reactily.element
	local count, setCount = Reactily.useState(0)

	return Reactily.createTextButton({
		text = `Count: {count}`,

		onActivated = function()
			setCount(count + 1)
		end,
	})
end
```
## Theme
```typescript
local theme = Reactily.createTheme({
	surface = Color3.fromRGB(28, 28, 32),
	text = Color3.fromRGB(245, 245, 245),
})
```
## Virtualized list
```typescript
local range = Reactily.resolveVirtualList(
	#items,
	36,
	scrollingFrame.CanvasPosition.Y,
	scrollingFrame.AbsoluteWindowSize.Y,
	4
)
```
## Owned animation
```typescript
local animation = Reactily.playTween(
	panel,
	{
		Position = UDim2.fromScale(.5, .5),
		BackgroundTransparency = 0,
	},
	{
		time = .25,
		easingStyle = Enum.EasingStyle.Quad,
		easingDirection = Enum.EasingDirection.Out,
	}
)

animation.onCompleted(function(playbackState)
	if playbackState ~= Enum.PlaybackState.Completed then return end

	animation.delete()
end)
```
