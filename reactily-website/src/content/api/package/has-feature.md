---
title: Reactily.hasFeature
sidebar_label: hasFeature
sidebar_position: 5
description: Tests whether the current Reactily runtime supports a named capability.
---

# `Reactily.hasFeature`

Checks a named feature capability.

## Signature

```luau
Reactily.hasFeature(feature: string): boolean
```

## Usage

```luau
if Reactily.hasFeature("virtual-grid") then
	-- use Reactily.VirtualGrid
end
```

Prefer this over exact-version checks for optional functionality.
