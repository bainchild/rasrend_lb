@@"pp/build.lua"
!(@@"pp/instance.lua")
@@"pp/getscript.lua"
@@LOG("info",!(build.branch).."@"..!(build.hash).." , built on "..!(build.build_date))

!(
    local carrs = {}
    local function recur(p)
        for i,v in pairs(p:GetChildren()) do
            local c = rawget(v,"_children");
            if c then
                if table_find(carrs,c) then
                    error("DUPLICATE CHILD ARRAY!!!");
                else
                    table.insert(carrs,c)
                end
            end
        end
    end
    recur(game)
)
local abc = !!(S_require(script.Parent:FindFirstChild("real")));
print(abc)