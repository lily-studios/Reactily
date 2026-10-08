---
title: Reactily.useTag
description: Subscribes to whether an Instance has a CollectionService tag.
---

# `Reactily.useTag`

Subscribes to whether an Instance has a CollectionService tag. This export is included in Reactily v2.1.0 (API v1).

## Signature

```luau
Reactily.useTag(instance: Instance, tag: string): boolean
```

## Usage

```luau
local tagged = Reactily.useTag(instance, "Selected")
```

Use this hook or constructor only in a valid Reactily component/render context, as applicable.
