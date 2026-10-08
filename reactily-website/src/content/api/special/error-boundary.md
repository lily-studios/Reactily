---
title: Reactily.ErrorBoundary
sidebar_label: ErrorBoundary
sidebar_position: 8
description: React-compatible error-boundary component marker.
---

# `Reactily.ErrorBoundary`

React-compatible error-boundary component marker.

## Usage

```luau
local boundary = Reactily.createElement(Reactily.ErrorBoundary, {
	fallback = fallback,
	children = { child },
})
```
