---
title: Reactily.cloneElement
sidebar_label: cloneElement
sidebar_position: 30
description: Clones an existing Reactily element while merging replacement props.
---

# `Reactily.cloneElement`

Clones an existing Reactily element while merging replacement props.

## Signature

```luau
Reactily.cloneElement(elementValue: Element, props: genericProps?, children: { any }?): Element
```

## Usage

```luau
local nextElement = Reactily.cloneElement(Element, { Text = "Updated" })
```
