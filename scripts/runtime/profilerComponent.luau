--[[
    Reactily · Lily Studios
    Copyright (c) Lily Studios and contributors.
    Licensed under the MIT License.
    See LICENSE in the repository root for full terms.
]]

--!strict

local profilerModule = require(script.Parent.Parent.diagnostics.profiler)
local reactCompatModule = require(script.Parent.Parent.virtual.reactCompat)

local elementModule = require(script.Parent.Parent.virtual.element)

local module = {}

module.Profiler = setmetatable(profilerModule, {
    __call = function(_self: any, props: reactCompatModule.ProfilerProps): elementModule.Element
        return reactCompatModule.Profiler(props)
    end,
})

return module
