--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

--- @reactilyType Validator<T>
export type validator<T> = (value: T) -> string?

--————————————————————————————————————————————————————————————————————--

--- Combines validators and returns the first validation error.
--- @param validators {validator<T>} Validators to run in order.
--- @return validator<T> Combined validator.
function module.Combine<T>(validators: { validator<T> }): validator<T>
	return function(value: T): string?
		for _, validator in validators do
			local failure = validator(value)
			if failure == nil then
				continue
			end

			return failure
		end

		return nil
	end
end

--————————————————————————————————————————————————————————————————————--

--- Validates a string maximum length.
--- @param maximum number Maximum number of characters.
--- @param message string? Custom validation message.
--- @return validator<string> String validator.
function module.MaxLength(maximum: number, message: string?): validator<string>
	assert(maximum >= 0, "Reactily validator maximum length must be non-negative.")

	return function(value: string): string?
		if utf8.len(value) and (utf8.len(value) :: number) <= maximum then
			return nil
		end

		return message or `Maximum length is {maximum}.`
	end
end

--————————————————————————————————————————————————————————————————————--

--- Validates that a value is numeric.
--- @param message string? Custom validation message.
--- @return validator<any> Number validator.
function module.Number(message: string?): validator<any>
	return function(value: any): string?
		if type(value) == "number" then
			return nil
		end

		return message or "Value must be a number."
	end
end

--————————————————————————————————————————————————————————————————————--

--- Validates a Lua string pattern.
--- @param pattern string Lua pattern.
--- @param message string? Custom validation message.
--- @return validator<string> Pattern validator.
function module.Pattern(pattern: string, message: string?): validator<string>
	return function(value: string): string?
		if string.match(value, pattern) then
			return nil
		end

		return message or "Value does not match the required format."
	end
end

--————————————————————————————————————————————————————————————————————--

--- Validates a numeric range inclusively.
--- @param minimum number Minimum allowed value.
--- @param maximum number Maximum allowed value.
--- @param message string? Custom validation message.
--- @return validator<number> Range validator.
function module.Range(minimum: number, maximum: number, message: string?): validator<number>
	assert(minimum <= maximum, "Reactily validator minimum must not exceed maximum.")

	return function(value: number): string?
		if value >= minimum and value <= maximum then
			return nil
		end

		return message or `Value must be between {minimum} and {maximum}.`
	end
end

--————————————————————————————————————————————————————————————————————--

--- Validates that a value is present and non-empty when it is a string.
--- @param message string? Custom validation message.
--- @return validator<any> Required-value validator.
function module.Required(message: string?): validator<any>
	return function(value: any): string?
		if value == nil then
			return message or "Value is required."
		end
		if type(value) == "string" and value == "" then
			return message or "Value is required."
		end

		return nil
	end
end

--————————————————————————————————————————————————————————————————————--

return module
