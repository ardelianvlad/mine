scullTiming = {
	[0.10] = 1,
	
	[0.45] = 2,
	[0.60] = 1,
	[0.66] = 2,
	[0.80] = 1,
	[0.83] = 2,
	[1.00] = 1,
	[1.04] = 2,

	[1.25] = 3,
	[1.40] = 2,
	[1.42] = 3,
	[1.55] = 2,
	[1.58] = 3,
	[1.65] = 1,

	[1.84] = 4,
	[2.04] = 3,
	[2.09] = 4,
	[2.30] = 3,
	[2.33] = 4,
	[2.55] = 3,
	[2.59] = 4,

	[2.70] = 3,
	[2.83] = 5,
	[2.90] = 4,

	[2.93] = 6,
	[3.15] = 4,
	[3.20] = 6,
	[3.45] = 4,
	[3.50] = 6,
	[3.71] = 4,
	[3.76] = 6,
	[3.94] = 4,
	[3.99] = 6,
	[4.20] = 5,
	[4.25] = 6,

	[4.35] = 3,
	[4.59] = 5,
	[4.65] = 3,
	[4.85] = 5,
	[5.00] = 3,
	[5.12] = 5,
	[5.25] = 3,
	[5.36] = 5,
	[5.40] = 1
}

local tkeys = {}
for k in pairs(scullTiming) do
	table.insert(tkeys, k)
end
table.sort(tkeys)

function getScullFrame(dt)
	if dt > 5.4 then
		return 1
	end
	prev = 0
	for _, k in ipairs(tkeys) do
		if dt > prev and dt <= k then
			return scullTiming[k]
		end 
		prev = k
	end
	return 1
end