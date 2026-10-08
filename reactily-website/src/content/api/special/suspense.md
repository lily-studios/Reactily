---
title: Reactily.Suspense
sidebar_label: Suspense
sidebar_position: 7
description: React-compatible Suspense component marker for fallback rendering.
---

# `Reactily.Suspense`

React-compatible Suspense component marker for fallback rendering.

## Usage

```luau
local tree = Reactily.createElement(Reactily.Suspense, {
	Fallback = loading,
	Children = { content },
})
```
