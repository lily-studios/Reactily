---
sidebar_position: 1
title: Moonwave Authoring
---

# Moonwave Authoring

Moonwave generates the **API** section from Luau doc comments.

A module/class starts with `@class`:
```typescript
--- @class Reactily
---
--- Typed React-inspired UI framework for Roblox Luau.
local Reactily = {}
```
Document public functions directly above their definitions:
```typescript
--- Creates a render root attached to a Roblox parent.
--- @param parent Instance -- Parent that owns the rendered UI.
--- @return root -- New Reactily render root.
--- @within Reactily
function Reactily.createRoot(parent: Instance)
	-- implementation
end
```
For a separate module that belongs to an existing class, use `@within Reactily`.

## Source-of-truth recommendation

Keep human-readable API behavior beside the implementation and let Moonwave generate the website from those comments. Do not maintain the same parameter/return documentation manually in multiple files.

The long Markdown guide should explain concepts, patterns, and examples. Moonwave should own the symbol-by-symbol API reference.
