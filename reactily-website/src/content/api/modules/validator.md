---
title: Reactily.Validator
sidebar_label: Validator
sidebar_position: 30
description: Public Reactily Validator module.
---

# `Reactily.Validator`

`Reactily.Validator` is a public namespace exported by the runtime. Its methods are listed below.

## Methods

### `Validator.Combine`

Combines validators and returns the first validation error.

```luau
Reactily.Validator.Combine<T>(validators: { validator<T> }): validator<T>
```

### `Validator.MaxLength`

Validates a string maximum length.

```luau
Reactily.Validator.MaxLength(maximum: number, message: string?): validator<string>
```

### `Validator.Number`

Validates that a value is numeric.

```luau
Reactily.Validator.Number(message: string?): validator<any>
```

### `Validator.Pattern`

Validates a Lua string pattern.

```luau
Reactily.Validator.Pattern(pattern: string, message: string?): validator<string>
```

### `Validator.Range`

Validates a numeric range inclusively.

```luau
Reactily.Validator.Range(minimum: number, maximum: number, message: string?): validator<number>
```

### `Validator.Required`

Validates that a value is present and non-empty when it is a string.

```luau
Reactily.Validator.Required(message: string?): validator<any>
```
