---
title: Reactily.inspectRoot
sidebar_label: inspectRoot
sidebar_position: 9
description: API reference for Reactily.inspectRoot.
---

# `Reactily.inspectRoot`

Returns a diagnostic snapshot of a mounted Reactily root tree.

## Signature
```luau
Reactily.inspectRoot(rootValue: root): any
```
## Usage
```luau
local snapshot = Reactily.inspectRoot(root)
```
## Works with

Pairs naturally with profiling, render reasons, reconciliation diagnostics.
