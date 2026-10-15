---
title: Reactily.UseTag
description: Legacy PascalCase spelling; use Reactily.useTag.
---

# `Reactily.UseTag`

This older PascalCase spelling is **not exported** by the current Reactily build. Use [`Reactily.useTag`](./use-tag.md).

```luau
-- Use Reactily.useTag instead
```

## Additional usage notes

### When to use it

Use this helper when this older PascalCase spelling is **not exported** by the current Reactily build. Use [Reactily.useTag](./use-tag.md).

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
