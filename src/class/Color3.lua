local constructor
local P = {}
local function clamp(n,min,max)
    return math.min(math.max(n,min),max)
end
-- base arith
function P:__add(other)
    return constructor(clamp(self.R+other.R,0,1),clamp(self.G+other.G,0,1),clamp(self.B+other.B,0,1))
end
function P:__sub(other)
    return constructor(clamp(self.R-other.R,0,1),clamp(self.G-other.G,0,1),clamp(self.B-other.B,0,1))
end
function P:__mul(other)
    return constructor(clamp(self.R*other.R,0,1),clamp(self.G*other.G,0,1),clamp(self.B*other.B,0,1))
end
function P:__div(other)
    return constructor(clamp(self.R/other.R,0,1),clamp(self.G/other.G,0,1),clamp(self.B/other.B,0,1))
end
P.__index=P

local Color3 = {}
function Color3.new(R,G,B)
    if R==nil then R=0 end
    if G==nil then G=0 end
    if B==nil then B=0 end
    return setmetatable({R=R,G=G,B=B},P)
end
function Color3.fromRGB(R,G,B)
    return Color3.new(R/255,G/255,B/255)
end
constructor=Color3.new
return Color3