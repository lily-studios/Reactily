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

The unreleased Reactily 1.4.0 development runtime exports:

```luau
Reactily.apiVersion == 1
```

Use this instead of requiring one exact patch version when your package only depends on the Reactily 1.x public contract.
