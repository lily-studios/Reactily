---
title: Reactily.createActivity
description: Creates an Activity element with a visible or hidden mode and child elements.
---

# `Reactily.createActivity`

Creates an Activity element with a visible or hidden mode and child elements. This export is included in Reactily v2.1.0 (API v1).

## Signature

```luau
Reactily.createActivity(mode: "visible" | "hidden", children: {any}, key: string?): Element
```

## Usage

```luau
local panel = Reactily.createActivity("visible", { Reactily.createTextLabel({ Text = "Ready" }) })
```

Use this hook or constructor only in a valid Reactily component/render context, as applicable.
