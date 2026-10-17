---
title: Reactily.Validator
sidebar_label: Validator
sidebar_position: 30
description: Public Reactily Validator module.
---

# `Reactily.Validator`

`Reactily.Validator` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

Validators return functions that check incoming values for common requirements, numeric bounds, and patterns. Combine several to validate a form field with multiple rules.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

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

## Choosing the right validator

Use `required` to reject missing values, `number` for numeric inputs, `range` for numeric limits, `pattern` for string matching, and `maxLength` for maximum string length. `combine` groups checks for a field that has multiple rules. Read the returned validator's result contract before displaying its errors in a form; do not assume the validator itself creates or changes a GUI object.

## Notes and common mistakes

- **Use:** Refer to the available method signatures above for inputs and output types; methods are ordinary Lua functions exported by this namespace.
- **Careful:** Framework method names and option keys must match their documented casing. Do not apply Roblox Instance naming rules to custom Reactily methods.

