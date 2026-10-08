---
title: Reactily.Activity
description: Compatibility component that controls whether its children are rendered.
---

# `Reactily.Activity`

Compatibility component that controls whether its children are rendered. Use `Mode = "visible"` to display the subtree or `Mode = "hidden"` to hide it while retaining the Activity subtree. This export is present in the Reactily v2.1.0 package (API v1).

## Signature

```luau
Reactily.Activity(props: { Mode: "visible" | "hidden", Children: {any}, Key: string? }): Element
```

## Usage

```luau
local activity = Reactily.Activity({ Mode = "visible", Children = { child } })
```

See the related API pages for parameter details and supported behavior. Check the v2.1.0 release source when integrating APIs whose callback or option types are important to your project.
