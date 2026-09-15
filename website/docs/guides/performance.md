---
sidebar_position: 1
title: Performance
---

# Performance

Reactily's performance model is based on avoiding work rather than trying to make unnecessary work cheaper.

## Change-only updates

Do not write state, props, callbacks, or Instances again when the resolved value is unchanged.

## Keyed reconciliation

Stable keys let Reactily preserve child identity during list changes.

## Virtualization

Use virtual lists/grids when only a small window of a large collection is visible.

## Runtime work

Schedulers and animation systems should disconnect or become dormant when there is no pending work.

## Cleanup symmetry

Every subscription, scheduled callback, animation, pooled object, and root should have a matching cleanup path.
