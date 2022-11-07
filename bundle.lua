local __pack
__pack={
	modules = {
		    ["real.lua"] = (function(...)
        
        
        
        return {["real"]=40}
    
    end),

	};
	cache = {};
}
__pack.require = function(idx)
    local cache = __pack.cache[idx]
    if cache then
        return cache
    end

    local module = __pack.modules[idx]()
    __pack.cache[idx] = module
    return module
end




print("master".."@".."56aec48".." , built on ".."Sun Nov 06 16:56:33 2022")


local yuhh = __pack.require('real.lua');
print(yuhh.real)
