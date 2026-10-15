---
title: Reactily.UseShortcut
description: Legacy PascalCase spelling; use Reactily.useShortcut.
---

# `Reactily.UseShortcut`

This older PascalCase spelling is **not exported** by the current Reactily build. Use [`Reactily.useShortcut`](./use-shortcut.md).

```luau
-- Use Reactily.useShortcut instead
```

## Additional usage notes

### When to use it

Use this helper when this older PascalCase spelling is **not exported** by the current Reactily build. Use [Reactily.useShortcut](./use-shortcut.md).

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
