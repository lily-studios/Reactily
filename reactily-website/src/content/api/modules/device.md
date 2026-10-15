---
title: Reactily.Device
sidebar_label: Device
sidebar_position: 5
description: Public Reactily Device module.
---

# `Reactily.Device`

`Reactily.Device` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

A device monitor observes relevant input or viewport information so a UI can adapt to different platforms.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

## Methods

### `Device.create`

Creates an event-driven monitor for Roblox device and viewport capabilities.

```luau
Reactily.Device.create(): DeviceMonitor
```

## Notes and common mistakes

- **Input:** Device information depends on live input and client conditions.
- **Common mistake:** Treating a device classification as an immutable property throughout a session.

