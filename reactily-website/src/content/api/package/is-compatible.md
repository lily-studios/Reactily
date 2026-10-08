---
title: Reactily.isCompatible
sidebar_label: isCompatible
sidebar_position: 6
description: Tests whether a consumer API version is compatible with this Reactily build.
---

# `Reactily.isCompatible`

Checks the stable API compatibility number.

## Signature

```luau
Reactily.isCompatible(requestedApiVersion: number): boolean
```

## Usage

```luau
assert(
	Reactily.isCompatible(1),
	"This package requires Reactily API v1"
)
```
