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

--- @reactilyType responsiveValues
export type breakpointValues<T> = {
	desktop: T?,
	fallback: T,
	mobile: T?,
	tablet: T?,
}

--- @reactilyType responsiveBreakpoints
export type breakpoints = {
	mobileMax: number?,
	tabletMax: number?,
}

--————————————————————————————————————————————————————————————————————--

--- Resolves a responsive value from viewport width.
--- @param viewportSize Vector2 Current viewport size.
--- @param values breakpointValues<T> Responsive values.
--- @param options breakpoints? Width thresholds.
--- @return T Selected value.
function module.resolve<T>(viewportSize: Vector2, values: breakpointValues<T>, options: breakpoints?): T
	local mobileMax = 640
	local tabletMax = 1024

	if options then
		if options.mobileMax ~= nil then
			mobileMax = options.mobileMax
		end

		if options.tabletMax ~= nil then
			tabletMax = options.tabletMax
		end
	end

	assert(mobileMax <= tabletMax, "Reactily responsive mobileMax cannot exceed tabletMax.")

	local width = viewportSize.X

	if width <= mobileMax then
		local mobile = values.mobile

		if mobile ~= nil then
			return mobile
		end
	end

	if width <= tabletMax then
		local tablet = values.tablet

		if tablet ~= nil then
			return tablet
		end
	end

	local desktop = values.desktop

	if desktop ~= nil then
		return desktop
	end

	return values.fallback
end

--————————————————————————————————————————————————————————————————————--

return module
