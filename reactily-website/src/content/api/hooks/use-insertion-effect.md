---
title: Reactily.useInsertionEffect
description: Runs an effect after host mutations and before layout effects.
---

# `Reactily.useInsertionEffect`

Runs an effect after host mutations and before layout effects. This export is present in the Reactily v2.1.0 package (API v1).

## Signature

```luau
Reactily.useInsertionEffect(effect: () -> (() -> ())?, dependencies: {any}?): () -> ()
```

## Usage

```luau
Reactily.useInsertionEffect(function()
	local previous = applyStyles()
	return function() restoreStyles(previous) end
end, {Theme})
```

See the related API pages for parameter details and supported behavior. Check the v2.1.0 release source when integrating APIs whose callback or option types are important to your project.
