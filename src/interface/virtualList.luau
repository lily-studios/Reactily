--!strict

-- resolves visible ranges for large fixed-size interface lists

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

export type range = {
	first: number,
	last: number,
	offset: number,
	totalSize: number,
}

--————————————————————————————————————————————————————————————————————--

function module.resolve(
	itemCount: number,
	itemSize: number,
	scrollOffset: number,
	viewportSize: number,
	overscan: number?
): range
	assert(itemCount >= 0, "Reactily itemCount must be non-negative.")
	assert(itemSize > 0, "Reactily itemSize must be greater than zero.")
	assert(viewportSize >= 0, "Reactily viewportSize must be non-negative.")

	if itemCount == 0 then
		return {
			first = 0,
			last = 0,
			offset = 0,
			totalSize = 0,
		}
	end

	local extra = 2

	if overscan ~= nil then
		extra = math.max(math.floor(overscan), 0)
	end

	local first = math.floor(math.max(scrollOffset, 0) / itemSize) + 1 - extra
	local visibleCount = math.ceil(viewportSize / itemSize) + extra * 2
	local last = first + visibleCount - 1

	first = math.clamp(first, 1, itemCount)
	last = math.clamp(last, first, itemCount)

	return {
		first = first,
		last = last,
		offset = (first - 1) * itemSize,
		totalSize = itemCount * itemSize,
	}
end

--————————————————————————————————————————————————————————————————————--

function module.slice<T>(items: {T}, rangeValue: range): {T}
	if rangeValue.first == 0 then return {} end

	local output: {T} = table.create(rangeValue.last - rangeValue.first + 1)

	for index = rangeValue.first, rangeValue.last do
		output[#output + 1] = items[index]
	end

	return output
end

--————————————————————————————————————————————————————————————————————--

return module
