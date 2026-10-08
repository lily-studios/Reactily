--[[
	Reactily · Lily Studios
	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]
--!strict

local module = {}

export type mode = "visible" | "hidden"

type visibilitySnapshot = {
	PropertyName: string,
	Value: boolean,
}

local snapshots: { [Instance]: visibilitySnapshot } = {}
do
	local weak: any = snapshots
	setmetatable(weak, { __mode = "k" })
end

local function resolveVisibilityProperty(instance: Instance): string?
	if instance:IsA("GuiObject") then
		return "Visible"
	end
	if instance:IsA("LayerCollector") then
		return "Enabled"
	end
	if instance:IsA("UIStroke") then
		return "Enabled"
	end
	return nil
end

function module.Hide(instance: Instance)
	local propertyName = resolveVisibilityProperty(instance)
	if not propertyName then
		return
	end
	if snapshots[instance] then
		return
	end

	local target = instance :: any
	local success, current = pcall(function(): boolean
		return target[propertyName]
	end)
	if not success then
		return
	end

	snapshots[instance] = {
		PropertyName = propertyName,
		Value = current,
	}

	pcall(function()
		target[propertyName] = false
	end)
end

function module.Show(instance: Instance)
	local snapshot = snapshots[instance]
	if not snapshot then
		return
	end
	snapshots[instance] = nil

	local target = instance :: any
	pcall(function()
		target[snapshot.PropertyName] = snapshot.Value
	end)
end

function module.Clear(instance: Instance)
	snapshots[instance] = nil
end

return module
