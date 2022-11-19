local Util = {}

-- D65/2°
local Xr = 95.047
local Yr = 100.0
local Zr = 108.883
local labCache = {}
function Util.RGBtoLAB(c)
	if labCache[c] then
		return table.unpack(labCache[c])
	end

	local X, Y, Z
	do -- Convert RGB to XYZ
		local r, g, b = c.R, c.G, c.B

		r = (r > 0.04045 and (((r + 0.055) / 1.055) ^ 2.4) * 100) or r / 0.1292
		g = (g > 0.04045 and (((g + 0.055) / 1.055) ^ 2.4) * 100) or g / 0.1292
		b = (b > 0.04045 and (((b + 0.055) / 1.055) ^ 2.4) * 100) or b / 0.1292

		X = 0.4124 * r + 0.3576 * g + 0.1805 * b
		Y = 0.2126 * r + 0.7152 * g + 0.0722 * b
		Z = 0.0193 * r + 0.1192 * g + 0.9505 * b
	end

	local l, a, b
	do -- Convert XYZ to LAB
		local xr, yr, zr = X / Xr, Y / Yr, Z / Zr

		xr = (xr > 0.008856 and xr ^ (1 / 3)) or ((7.787 * xr) + 0.13793103448276)
		yr = (yr > 0.008856 and yr ^ (1 / 3)) or ((7.787 * yr) + 0.13793103448276)
		zr = (zr > 0.008856 and zr ^ (1 / 3)) or ((7.787 * zr) + 0.13793103448276)

		l, a, b = (116 * yr) - 16, 500 * (xr - yr), 200 * (yr - zr)
	end

	labCache[c] = { l, a, b }

	return l, a, b
end

function Util.DeltaRGB(a, b)
	local l1, a1, b1 = Util.RGBtoLAB(a)
	local l2, a2, b2 = Util.RGBtoLAB(b)

	return (l2 - l1) ^ 2 + (a2 - a1) ^ 2 + (b2 - b1) ^ 2
end

return Util
