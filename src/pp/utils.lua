function string_split(string,delimiter)
    local n = {}
    for match in (string..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(n,match)
    end
    return match
end
function popen(n)
    local c = io.popen(n)
    local content = c:read("*a")
    c:close()
    return content
end