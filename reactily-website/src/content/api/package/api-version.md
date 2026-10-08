---
title: Reactily.apiVersion
sidebar_label: apiVersion
sidebar_position: 2
description: Stable compatibility-line identifier for Reactily consumers.
---

# `Reactily.apiVersion`

The stable compatibility identifier for Reactily's public API.

```luau
Reactily.apiVersion: number
```

Reactily v2.1.0 (API v1) exports:

```luau
Reactily.apiVersion == 1
```

Use this instead of requiring one exact patch version when your package depends on the Reactily API v1 contract.
