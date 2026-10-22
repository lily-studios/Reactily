--[[
    Reactily · Lily Studios
    Copyright (c) Lily Studios and contributors.
    Licensed under the MIT License.
    See LICENSE in the repository root for full terms.
]]

--!strict

local module = {}

module.version = "2.1.0"

module.apiVersion = 1

-- Derive the numeric metadata from the same version used by getVersion().
local major, minor, patch = string.match(module.version, "^(%d+)%.(%d+)%.(%d+)$")
assert(major and minor and patch, "Reactily version must contain major, minor, and patch numbers.")
module.versionInfo = table.freeze({
	major = assert(tonumber(major)),
	minor = assert(tonumber(minor)),
	patch = assert(tonumber(patch)),
})

local featureFlags: { [string]: boolean } = table.freeze({
	["action-state"] = true,
	["activity"] = true,
	["concurrent-priorities"] = true,
	["effect-events"] = true,
	["fragment-refs"] = true,
	["host-metadata"] = true,
	["insertion-effects"] = true,
	["optimistic-state"] = true,
	["profiler-component"] = true,
	["strict-mode-checks"] = true,
	["suspense"] = true,
	["sync-external-store"] = true,
	["transitions"] = true,
	["use-api"] = true,
	["view-transitions"] = true,
	["virtual-grid"] = true,
	["virtual-list"] = true,
	["virtual-window"] = true,
})

module.features = featureFlags

module.Experimental = table.freeze({})

function module.getVersion(): string
	return module.version
end

function module.hasFeature(feature: string): boolean
	return featureFlags[feature] == true
end

function module.isCompatible(requestedApiVersion: number): boolean
	return requestedApiVersion == module.apiVersion
end

return module
