---
title: Reactily.Motion
sidebar_label: Motion
sidebar_position: 17
description: Public Reactily Motion module.
---

# `Reactily.Motion`

`Reactily.Motion` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

This module provides the operations for constructing or playing managed motion animations. Use it when you want a reusable motion definition or explicit playback control.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

## Methods

### `Motion.create`

Creates a Reactily animation without playing it.

```luau
Reactily.Motion.create(instance: Instance, goals: { [string]: any }, options: MotionOptions?): Reactily.Animation
```

### `Motion.play`

Plays a Roblox property animation immediately.

```luau
Reactily.Motion.play(instance: Instance, goals: { [string]: any }, options: MotionOptions?): Reactily.Animation
```

## Notes and common mistakes

- **Input:** Motion helpers produce behavior that needs an owner and potentially cleanup after the UI is removed.
- **Common mistake:** Assuming every created motion starts immediately without a playback call.

