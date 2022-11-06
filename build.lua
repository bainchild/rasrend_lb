local lfs = require('lfs')
local pp = require('preprocess')
local function recurse(path,todo)
	local todo=todo or {}
	for file in lfs.dir(path) do
		if file~="." and file~=".." then
			local attr = lfs.attributes(path.."/"..file);
			if attr.mode=="file" then
				if file:sub(-4) == ".lua" then
					table.insert(todo,{true,path.."/"..file});
				end
			elseif attr.mode=="directory" then
				table.insert(todo,{false,path..'/'..file});
				recurse(path.."/"..file,todo);
			end
		end
	end
	return todo
end
local function recurse_rmdir(dir)
	local todo = recurse(dir);
	for i,v in pairs(todo) do
		if v[1] then
			os.remove(v[2]);
		end
	end
	for i,v in pairs(todo) do
		if not v[1] then
			lfs.rmdir(v[2]);
		end
	end
	lfs.rmdir(dir);
end
local function extend(a,b)
	local n = {}
	for i,v in pairs(a) do n[i]=v end
	for i,v in pairs(b) do n[i]=v end
	return n
end
local function split(a,b)
	local n = {}
	for m in (a..b):gmatch("(.-)"..b) do
		table.insert(n,m)
	end
	return n
end
local args = {}
for i,v in pairs(({...})) do
	if i~=1 then
		local sp = split(v,'=')
		if #sp==2 then
			args[sp[1]]=sp[2]
		end
	end
end
if (...)=="build" then
	lfs.mkdir("build")
	lfs.mkdir("temp")
	local todo = recurse("src")
	for i,v in pairs(todo) do 
		if not v[1] then
			lfs.mkdir('build/'..v[2]:sub(4))
			lfs.mkdir('temp/'..v[2]:sub(4))
		end
	end
	for i,v in pairs(todo) do
		if v[1] then
			local info,err = pp.processFile(extend({
				pathIn=v[2],
				pathOut='build/'..v[2]:sub(4),
				pathMeta='temp/'..v[2]:sub(4)
			},args))
			if not info then
				lfs.rmdir("build");
				lfs.rmdir("temp");
				error(err);
				break
			end
		end
	end
	lfs.rmdir("temp");
elseif (...)=="bundle" then
	local found = false
	for f in lfs.dir(".") do
		if f=="build" then
			found=true;break
		end
	end
	if not found then
		print('You have to use `lua build.lua build` first.')
		os.exit(1)
	end
	lfs.chdir("build");
	os.execute("lua ../pack.lua main.lua ../bundle.lua");
	lfs.chdir("..");
elseif (...)=="clean" then
	os.remove("./bundle.lua");
	recurse_rmdir("build");
	recurse_rmdir("temp");
end


