---
title: Reactily.mergeSignals
sidebar_label: mergeSignals
sidebar_position: 6
description: API reference for Reactily.mergeSignals.
---

# `Reactily.mergeSignals`

Creates a derived signal that forwards emissions from all supplied sources.

## Signature
```luau
Reactily.mergeSignals<T>(sources: {Signal<T>}): Signal<T>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `sources` | `{Signal<T>}` | Yes | Source signals to merge into one derived signal. |

## Returns

A `Signal<T>`.

## Usage
```luau
local merged = Reactily.mergeSignals({
	firstSignal,
	secondSignal,
})
```
