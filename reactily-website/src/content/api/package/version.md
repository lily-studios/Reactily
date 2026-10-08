---
title: Reactily.version
sidebar_label: version
sidebar_position: 1
description: Current Reactily runtime version string.
---

# `Reactily.version`

The public version string exported by the Reactily package.

## Type

```luau
Reactily.version: string
```

## Current runtime

```luau
print(Reactily.version) -- "1.3.1"
```

Use this for diagnostics and display. Production packages should prefer feature detection over exact-version equality when possible.
