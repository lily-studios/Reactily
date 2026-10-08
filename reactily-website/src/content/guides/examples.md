---
sidebar_position: 2
title: Examples
---

# Examples

## Counter
```luau
local function counter(): Reactily.Element
	local count, setCount = Reactily.useState(0)

	return Reactily.createTextButton({
		Text = `Count: {count}`,

		OnActivated = function()
			setCount(count + 1)
		end,
	})
end
```
## theme
```luau
local Theme = Reactily.createTheme({
	surface = Color3.fromRGB(28, 28, 32),
	Text = Color3.fromRGB(245, 245, 245),
})
```
## Virtualized list
```luau
local range = Reactily.resolveVirtualList(
	#items,
	36,
	scrollingFrame.CanvasPosition.Y,
	scrollingFrame.AbsoluteWindowSize.Y,
	4
)
```
## Owned animation
```luau
local Animation = Reactily.playTween(
	panel,
	{
		Position = UDim2.fromScale(.5, .5),
		BackgroundTransparency = 0,
	},
	{
		Time = .25,
		EasingStyle = Enum.EasingStyle.Quad,
		EasingDirection = Enum.EasingDirection.Out,
	}
)

Animation.onCompleted(function(playbackState)
	if playbackState ~= Enum.PlaybackState.Completed then return end

	Animation.delete()
end)
```
