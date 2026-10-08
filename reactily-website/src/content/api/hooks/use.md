---
title: Reactily.use
description: Reads a Reactily context or resource value using the unified React-style API.
---

# `Reactily.use`

Reads a Reactily context or resource value using the unified React-style API. This export is present in the Reactily v2.1.0 package (API v1).

## Signature

```luau
Reactily.use<T>(readable: Context<T> | Resource<T>): T
```

## Usage

```luau
local Theme = Reactily.use(ThemeContext)
```

See the related API pages for parameter details and supported behavior. Check the v2.1.0 release source when integrating APIs whose callback or option types are important to your project.
