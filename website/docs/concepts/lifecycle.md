---
sidebar_position: 3
title: Lifecycle
---

# Lifecycle

Reactily-owned resources use `delete()` and `isDeleted()`.
```typescript
local root = Reactily.createRoot(playerGui)

-- Later:
root.delete()
```
Deletion should:

1. disconnect owned connections,
2. stop owned runtime work,
3. release owned Instances/resources,
4. make repeated deletion safe.

Roblox-owned resources retain Roblox names:
```typescript
instance:Destroy()
connection:Disconnect()
```
## Ownership rule

The object that creates or adopts a resource should have an obvious cleanup path for that resource.

## Idle behavior

Reactily is designed so idle UI does not require a permanent self-generated frame loop. Continuous work should exist only while a feature such as an active animation genuinely needs it.
