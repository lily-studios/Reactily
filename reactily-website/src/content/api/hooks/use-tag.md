---
title: Reactily.useTag
sidebar_label: useTag
sidebar_position: 51
description: Subscribes to whether an Instance has a CollectionService tag.
---

# `Reactily.useTag`

Subscribes to whether an Instance has a CollectionService tag.

## Signature

```luau
Reactily.useTag(instance: Instance, tag: string): boolean
```

## Usage

```luau
local tagged = Reactily.useTag(instance, "Selected")
```

## Notes

This API is exported by the current unreleased Reactily 1.4.0 development runtime and is safe to use from a function component where the hook rules allow it.
