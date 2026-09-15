---
sidebar_position: 1
title: Introduction
description: What Reactily is, why it exists, and where to start.
---

# Introduction

## What is Reactily?

Reactily is a typed, React-inspired interface framework for Roblox Luau.

It provides virtual elements, function components, hooks, keyed reconciliation, reactive state, stores, signals, bindings, themes, animation systems, virtualization, object pools, diagnostics, and explicit lifecycle ownership through one public package.

Reactily is designed for developers who want component-driven UI without giving up direct control over Roblox Instances, cleanup, and runtime behavior.

## Why use it?

- **Strict typed API:** Public contracts are designed for `--!strict`, autocomplete, and clear ownership.
- **Component-driven UI:** Build interfaces from reusable function components and virtual elements.
- **Explicit lifecycle:** Reactily-owned resources use `.delete()` / `.isDeleted()` instead of hiding cleanup.
- **Change-only work:** State, UI, and runtime systems avoid work when the resolved value has not changed.
- **Idle-safe runtime:** Continuous work exists only while a feature actually needs it.
- **Roblox-aware:** Reactily keeps Roblox lifecycle and method conventions where Roblox owns the object.

## When should I not use it?

Reactily may not be the right fit when:

- the interface is tiny enough that direct Instance construction is simpler,
- your codebase does not need component composition or reactive state,
- your team prefers a fully imperative UI architecture,
- you do not want to adopt stable hook ordering and explicit Reactily ownership.

## How do I get started?

1. Read [Getting Started](./getting-started.md).
2. Learn the core concepts in [Rendering](./concepts/rendering.md), [State & Reactivity](./concepts/state.md), and [Lifecycle](./concepts/lifecycle.md).
3. Use the [API reference](/api) when you need an exact function signature or usage example.
4. Review [Examples](./guides/examples.md) for practical patterns.

## API conventions

Reactily-owned APIs use dot calls:
```typescript
local root = Reactily.createRoot(playerGui)

root.render(element)
root.delete()
```
Roblox-owned APIs keep Roblox syntax:
```typescript
connection:Disconnect()
instance:Destroy()
instance:SetAttribute("enabled", true)
```
