---
title: Reactily.createDiagnostics
sidebar_label: createDiagnostics
sidebar_position: 2
description: API reference for Reactily.createDiagnostics.
---

# `Reactily.createDiagnostics`

Creates explicit runtime counters with no background polling.

## Signature
```typescript
Reactily.createDiagnostics(): diagnostics
```
## Parameters

_No parameters._

## Returns

A diagnostics counter owner.

## Usage
```typescript
local diagnostics = Reactily.createDiagnostics()
diagnostics.increment("renders")
```
