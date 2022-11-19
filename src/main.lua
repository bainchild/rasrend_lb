@@"build.lua"
!(
    function string_split(string,delimiter)
        local n = {}
        for match in (string..delimiter):gmatch("(.-)"..delimiter) do
            table.insert(n,match)
        end
        return n
    end
    function indent(string,indentation)
        local nstr = ""
        for _,line in pairs(string_split(string,"\n")) do
            nstr=nstr..indentation..line.."\n"
        end
        return nstr
    end
)

@@LOG("info","%s - %s@%s, built on %s",@file,!(build.branch),!(build.hash),!(build.build_date))
local r3d = require("3dOperations")
local gc = require("GreedyCanvas")
!(
    local Color3 = require("class.Color3")
    local function Pixel(c)
        return "{Color="..toLua(c or Color3.new()).."}"
    end
    local function Render(c,g)
	    return indent("for x,row in "..g.." do "
                        .."for y,pixel in row do "
                            ..c..":SetPixel(x,y,pixel.Color);"
                        .."end;"
                    .."end;"
                    ..c..":Render()",getCurrentIndentationInOutput())
    end
)
local w,h = 10,10
local pxg = table.create(w)
local canvas = gc.new(w,h)
for i=1,w do pxg[i]=table.create(h,!!(Pixel())) end
canvas:SetParent(Instance.new("ScreenGui",script))
@@Render(canvas,pxg)