local __metamethods = {
    ["__index"] = function(s,i)  return    s[i]    end;
    ["__newindex"] = function(s,i,v)       s[i]=v  end;
    ["__call"] = function(s,...) return    s(...)  end;
    ["__tostring"] = function(s) return tostring(s)end;
    ["__len"] = function(s)      return    #s      end;
    ["__unm"] = function(s)      return    -s      end;
    ["__add"] = function(s,o)    return    s+o     end;
    ["__sub"] = function(s,o)    return    s-o     end;
    ["__mul"] = function(s,o)    return    s*o     end;
    ["__div"] = function(s,o)    return    s/o     end;
    ["__mod"] = function(s,o)    return    s%o     end;
    ["__pow"] = function(s,o)    return    s^o     end;
    ["__concat"] = function(s,o) return    s..o    end;
    ["__eq"] = function(s,o)     return    s==o    end;
    ["__lt"] = function(s,o)     return    s<o     end;
    ["__le"] = function(s,o)     return    s<=o    end;
}
function string_split(string,delimiter)
    local n = {}
    for match in (string..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(n,match)
    end
    return n
end
local hook = function(f,of)
    return function(...)
        return of(f,...)
    end
end
local table_find = table.find or function(table,pin)
    for i,v in pairs(table) do if v==pin then return i end end
end
local newproxy = newproxy or function(m) return setmetatable({},m and {} or {})end
function popen(n)
    local c = io.popen(n)
    local content = c:read("*a")
    c:close()
    return content
end
function udata_pointer(n)
    local m = newproxy(true);
    local _m = getmetatable(m);
    for i,v in pairs(__metamethods) do
        _m[i]=hook(v,function(o,self,...)
            self=n();
            return o(self,...)
        end)
    end
    return m
end