---
title: Reactily.createStrictMode
description: Creates a StrictMode wrapper around child elements.
---

# `Reactily.createStrictMode`

Creates a StrictMode wrapper around child elements. This export is included in Reactily v2.1.0 (API v1).

## Signature

```luau
Reactily.createStrictMode(children: {any}, key: string?): Element
```

## Usage

```luau
local checked = Reactily.createStrictMode({ app })
```

Use this hook or constructor only in a valid Reactily component/render context, as applicable.
