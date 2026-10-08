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

export type componentProfile = {
	AverageTime: number,
	LastReason: string,
	LastTime: number,
	MaximumTime: number,
	RenderCount: number,
	TotalTime: number,
}

type component = (props: any) -> any
type profileMap = { [component]: componentProfile }

type slowComponent = {
	component: component,
	profile: componentProfile,
}

--————————————————————————————————————————————————————————————————————--

local enabled = false
local profiles: profileMap = {}

do
	local weakProfiles: any = profiles

	setmetatable(weakProfiles, {
		__mode = "k",
	})
end

--————————————————————————————————————————————————————————————————————--

--- Clears all collected profiler data.
function module.Clear()
	if next(profiles) == nil then
		return
	end

	table.clear(profiles)
end

--————————————————————————————————————————————————————————————————————--

--- Returns whether component profiling is enabled.
--- @return boolean Current profiling state.
function module.IsEnabled(): boolean
	return enabled
end

--————————————————————————————————————————————————————————————————————--

--- Returns a copy of profile data for one component.
--- @param componentValue component Component function to inspect.
--- @return componentProfile? Profile data when available.
function module.Get(componentValue: component): componentProfile?
	local profile = profiles[componentValue]
	if not profile then
		return nil
	end

	return table.clone(profile)
end

--————————————————————————————————————————————————————————————————————--

--- Returns all currently collected component profiles.
--- @return profileMap Independent snapshot of collected profiles.
function module.Snapshot(): profileMap
	local output: profileMap = {}

	for componentValue, profile in profiles do
		output[componentValue] = table.clone(profile)
	end

	return output
end

--————————————————————————————————————————————————————————————————————--

--- Returns the slowest recorded components ordered by average render time.
--- @param limit number? Maximum number of entries to return.
--- @return {slowComponent} Ordered slow-component entries.
function module.GetSlowComponents(limit: number?): { slowComponent }
	local output: { slowComponent } = {}

	for componentValue, profile in profiles do
		output[#output + 1] = {
			component = componentValue,
			profile = table.clone(profile),
		}
	end

	table.sort(output, function(first: slowComponent, second: slowComponent): boolean
		return first.profile.AverageTime > second.profile.AverageTime
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
--- @param componentValue component Component function that rendered.
--- @param duration number Render duration in seconds.
--- @param reason string Human-readable rerender reason.
function module.Record(componentValue: component, duration: number, reason: string)
	if not enabled then
		return
	end

	local profile = profiles[componentValue]

	if not profile then
		profile = {
			AverageTime = 0,
			LastReason = reason,
			LastTime = duration,
			MaximumTime = duration,
			RenderCount = 0,
			TotalTime = 0,
		}

		profiles[componentValue] = profile
	end

	profile.RenderCount += 1
	profile.TotalTime += duration
	profile.AverageTime = profile.TotalTime / profile.RenderCount
	profile.LastReason = reason
	profile.LastTime = duration
	profile.MaximumTime = math.max(profile.MaximumTime, duration)
end

--————————————————————————————————————————————————————————————————————--

--- Enables or disables component profiling.
--- @param value boolean New profiling state.
function module.SetEnabled(value: boolean)
	if enabled == value then
		return
	end

	enabled = value
end

--————————————————————————————————————————————————————————————————————--

return module
