---
title: Reactily.Motion
sidebar_label: Motion
sidebar_position: 17
description: Public Reactily Motion module.
---

# `Reactily.Motion`

`Reactily.Motion` is a public namespace exported by the runtime. Its methods are listed below.

## Methods

### `Motion.create`

Creates a Reactily animation without playing it.

```luau
Reactily.Motion.create(instance: Instance, goals: { [string]: any }, options: MotionOptions?): animationModule.Animation
```

### `Motion.play`

Plays a Roblox property animation immediately.

```luau
Reactily.Motion.play(instance: Instance, goals: { [string]: any }, options: MotionOptions?): animationModule.Animation
```
