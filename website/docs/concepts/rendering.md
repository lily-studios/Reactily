---
sidebar_position: 1
title: Rendering
---

# Rendering

Reactily elements are virtual descriptions. Rendering a tree causes the root reconciler to create, update, move, and delete the Roblox Instances required by that tree.

## Typed creators

Prefer class-specific creators:
```typescript
Reactily.createFrame({
	size = UDim2.fromScale(1, 1),
	backgroundTransparency = .15,
})
```
Use `createElement()` when a generic class name is genuinely useful.

## Components

Function components return elements:
```typescript
local function greeting(): Reactily.element
	return Reactily.createTextLabel({
		text = "Hello",
		size = UDim2.fromOffset(180, 40),
	})
end
```
## Keys

Use stable keys when children can be reordered. Keys let reconciliation preserve identity instead of treating a reordered entry as a brand-new element.

## Portals

Portals render a subtree under another Roblox parent without moving the component's logical ownership.
