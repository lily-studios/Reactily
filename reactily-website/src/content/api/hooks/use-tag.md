---
title: Reactily.useTag
description: Subscribes to whether an Instance has a CollectionService tag.
---

# `Reactily.useTag`

Subscribes to whether an Instance has a CollectionService tag. This export is included in Reactily v2.2.0 (API v1).

## Signature

```luau
Reactily.useTag(instance: Instance, tag: string): boolean
```

## Usage

```luau
local tagged = Reactily.useTag(instance, "Selected")
```

Use this hook or constructor only in a valid Reactily component/render context, as applicable.

## Understanding this API

Tags allow Roblox CollectionService to identify Instances that belong to a named group.

### Practical guidance

Avoid assuming tagged Instances remain present forever; a tag subscription or query must account for Instances being added and removed.

## Additional usage notes

### When to use it

Use this hook when the component needs subscribes to whether an Instance has a CollectionService tag. This export is included in Reactily v2.2.0 (API v1).

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
