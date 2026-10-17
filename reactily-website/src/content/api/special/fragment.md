---
title: Reactily.Fragment
sidebar_label: Fragment
sidebar_position: 5
description: Fragment marker accepted by Reactily.createElement for grouping children without a host Instance.
---

# `Reactily.Fragment`

Fragment marker accepted by Reactily.createElement for grouping children without a host Instance.

## Usage

```luau
local fragment = Reactily.createElement(Reactily.Fragment, nil, first, second)
```

## Understanding this API

Special elements and host metadata influence how Reactily reconciles children or applies behavior that is not represented by a single ordinary Roblox class.

### Practical guidance

Use the documented input shape rather than guessing Roblox properties. Reactily-specific metadata is different from native Instance properties and may be handled specially by the renderer.

## Additional usage notes

### When to use it

Use this helper when fragment marker accepted by Reactily.createElement for grouping children without a host Instance.

### Behavior and ownership

This API integrates with rendering, lifecycle, or host behavior through Reactily’s public contract.

### Pitfalls to avoid

> **Note:** Check whether the operation must be called during rendering or during an event callback.
