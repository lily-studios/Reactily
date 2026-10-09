
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

export type ComponentProfile = {
	averageTime: number,
	lastReason: string,
	lastTime: number,
	maximumTime: number,
	renderCount: number,
	totalTime: number,
}

type Component = (props: any) -> any
type ProfileMap = { [Component]: ComponentProfile }

type SlowComponent = {
	component: Component,
	profile: ComponentProfile,
}

--————————————————————————————————————————————————————————————————————--

local enabled = false
local profiles: ProfileMap = {}

do
	local weakProfiles: any = profiles

	setmetatable(weakProfiles, {
		__mode = "k",
	})
end

--————————————————————————————————————————————————————————————————————--

--- Clears all collected profiler data.
function module.clear()
	if next(profiles) == nil then
		return
	end

	table.clear(profiles)
end

--————————————————————————————————————————————————————————————————————--

--- Returns whether component profiling is enabled.
--- @return boolean Current profiling state.
function module.isEnabled(): boolean
	return enabled
end

--————————————————————————————————————————————————————————————————————--

--- Returns a copy of profile data for one component.
--- @param componentValue Component Component function to inspect.
--- @return ComponentProfile? Profile data when available.
function module.get(componentValue: Component): ComponentProfile?
	local profile = profiles[componentValue]

	if not profile then
		return nil
	end

	return table.clone(profile)
end

--————————————————————————————————————————————————————————————————————--

--- Returns all currently collected component profiles.
--- @return ProfileMap Independent snapshot of collected profiles.
function module.snapshot(): ProfileMap
	local output: ProfileMap = {}

	for componentValue, profile in profiles do
		output[componentValue] = table.clone(profile)
	end

	return output
end

--————————————————————————————————————————————————————————————————————--

--- Returns the slowest recorded components ordered by average render time.
--- @param limit number? Maximum number of entries to return.
--- @return {SlowComponent} Ordered slow-component entries.
function module.getSlowComponents(limit: number?): { SlowComponent }
	local output: { SlowComponent } = {}

	for componentValue, profile in profiles do
		output[#output + 1] = {
			component = componentValue,
			profile = table.clone(profile),
		}
	end

	table.sort(output, function(first: SlowComponent, second: SlowComponent): boolean
		return first.profile.averageTime > second.profile.averageTime
	end)

	if limit == nil then
		return output
	end

	local maximum = math.clamp(math.floor(limit), 0, #output)

	for index = #output, maximum + 1, -1 do
		output[index] = nil
	end

	return output
end

--————————————————————————————————————————————————————————————————————--

--- Records one component render when profiling is enabled.
--- @param componentValue Component Component function that rendered.
--- @param duration number Render duration in seconds.
--- @param reason string Human-readable rerender reason.
function module.record(componentValue: Component, duration: number, reason: string)
	if not enabled then
		return
	end

	local profile = profiles[componentValue]

	if not profile then
		profile = {
			averageTime = 0,
			lastReason = reason,
			lastTime = duration,
			maximumTime = duration,
			renderCount = 0,
			totalTime = 0,
		}

		profiles[componentValue] = profile
	end

	profile.renderCount += 1
	profile.totalTime += duration
	profile.averageTime = profile.totalTime / profile.renderCount
	profile.lastReason = reason
	profile.lastTime = duration
	profile.maximumTime = math.max(profile.maximumTime, duration)
end

--————————————————————————————————————————————————————————————————————--

--- Enables or disables component profiling.
--- @param value boolean New profiling state.
function module.setEnabled(value: boolean)
	if enabled == value then
		return
	end

	enabled = value
end

--————————————————————————————————————————————————————————————————————--

--- Returns the most recent render reason for a component.
--- @param componentValue Component Component function to inspect.
--- @return string? Most recent render reason, when available.
function module.getRenderReason(componentValue: Component): string?
	local profile = module.get(componentValue)

	return if profile then profile.lastReason else nil
end

--————————————————————————————————————————————————————————————————————--

-- Canonical public API names (discoverable directly from Luau).

module.getProfile = module.get
module.getProfilerSnapshot = module.snapshot
module.resetProfiler = module.clear
module.setProfilingEnabled = module.setEnabled

return module
