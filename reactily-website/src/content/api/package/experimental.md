---
title: Reactily.Experimental
sidebar_label: Experimental
sidebar_position: 7
description: Reserved namespace for unstable future Reactily APIs.
---

# `Reactily.Experimental`

Reserved namespace for future APIs that are intentionally not covered by the stable 1.x compatibility contract.

The unreleased Reactily 1.4.0 development runtime exports an empty frozen table:

```luau
Reactily.Experimental
```

When experimental features are introduced, they may change between minor releases. Stable APIs should graduate out of this namespace before production users depend on them.
