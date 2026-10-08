--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

--- @reactilyType ResponsiveValues
export type breakpointValues<T> = {
	Desktop: T?,
	Fallback: T,
	Mobile: T?,
	Tablet: T?,
}

--- @reactilyType ResponsiveBreakpoints
export type breakpoints = {
	MobileMax: number?,
	TabletMax: number?,
}

--————————————————————————————————————————————————————————————————————--

--- Resolves a responsive value from viewport width.
--- @param viewportSize Vector2 Current viewport size.
--- @param values breakpointValues<T> Responsive values.
--- @param options breakpoints? Width thresholds.
--- @return T Selected value.
function module.Resolve<T>(viewportSize: Vector2, values: breakpointValues<T>, options: breakpoints?): T
	local mobileMax = 640
	local tabletMax = 1024

	if options then
		if options.MobileMax ~= nil then
			mobileMax = options.MobileMax
		end

		if options.TabletMax ~= nil then
			tabletMax = options.TabletMax
		end
	end

	assert(mobileMax <= tabletMax, "Reactily responsive mobileMax cannot exceed tabletMax.")

	local width = viewportSize.X

	if width <= mobileMax then
		local mobile = values.Mobile

		if mobile ~= nil then
			return mobile
		end
	end

	if width <= tabletMax then
		local tablet = values.Tablet

		if tablet ~= nil then
			return tablet
		end
	end

	local desktop = values.Desktop

	if desktop ~= nil then
		return desktop
	end

	return values.Fallback
end

--————————————————————————————————————————————————————————————————————--

return module
