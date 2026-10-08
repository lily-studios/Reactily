---
title: Reactily.Validator
sidebar_label: Validator
sidebar_position: 30
description: Public Reactily Validator module.
---

# `Reactily.Validator`

`Reactily.Validator` is a public namespace exported by the runtime. Its methods are listed below.

## Methods

### `Validator.combine`

Combines validators and returns the first validation error.

```luau
Reactily.Validator.combine<T>(validators: { validator<T> }): validator<T>
```

### `Validator.maxLength`

Validates a string maximum length.

```luau
Reactily.Validator.maxLength(maximum: number, message: string?): validator<string>
```

### `Validator.number`

Validates that a value is numeric.

```luau
Reactily.Validator.number(message: string?): validator<any>
```

### `Validator.pattern`

Validates a Lua string pattern.

```luau
Reactily.Validator.pattern(pattern: string, message: string?): validator<string>
```

### `Validator.range`

Validates a numeric range inclusively.

```luau
Reactily.Validator.range(minimum: number, maximum: number, message: string?): validator<number>
```

### `Validator.required`

Validates that a value is present and non-empty when it is a string.

```luau
Reactily.Validator.required(message: string?): validator<any>
```
