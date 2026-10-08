---
title: Reactily.Motion
sidebar_label: Motion
sidebar_position: 17
description: Public Reactily Motion module.
---

# `Reactily.Motion`

`Reactily.Motion` is a public namespace exported by the runtime. Its methods are listed below.

## Methods

### `Motion.Create`

Creates a Reactily animation without playing it.

```luau
Reactily.Motion.Create(instance: Instance, goals: { [string]: any }, options: MotionOptions?): Reactily.Animation
```

### `Motion.Play`

Plays a Roblox property animation immediately.

```luau
Reactily.Motion.Play(instance: Instance, goals: { [string]: any }, options: MotionOptions?): Reactily.Animation
```
