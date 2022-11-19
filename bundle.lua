local __pack
__pack={
	modules = {
		    ["GreedyCanvas/init.lua"] = (function(...)
        local module = {}
        
        local GuiPool = require("GuiPool")
        local Util = require("Util")
        
        function module.new(ResX, ResY)
        	local Canvas = {
        		_Active = 0,
        		_ColumnFrames = {},
        		_UpdatedColumns = {},
        
        		Threshold = 2,
        		LossyThreshold = 4,
        	}
        
        	local invX, invY = 1 / ResX, 1 / ResY
        	local dist = ResY * 0.03
        
        	-- Generate initial grid of color data
        	local Grid = table.create(ResX)
        	for x = 1, ResX do
        		Grid[x] = table.create(ResY, Color3.new(1, 1, 1))
        	end
        	Canvas._Grid = Grid
        
        	-- Create a pool of Frame instances with Gradients
        	do
        		local Pixel = Instance.new("Frame")
        		Pixel.BackgroundColor3 = Color3.new(1, 1, 1)
        		Pixel.BorderSizePixel = 0
        		Pixel.Name = "Pixel"
        		local Gradient = Instance.new("UIGradient")
        		Gradient.Name = "Gradient"
        		Gradient.Rotation = 90
        		Gradient.Parent = Pixel
        
        		Canvas._Pool = GuiPool.new(Pixel, ResX)
        		Pixel:Destroy()
        	end
        
        	-- Create GUIs
        	local Gui = Instance.new("Frame")
        	Gui.Name = "GradientCanvas"
        	Gui.BackgroundTransparency = 1
        	Gui.ClipsDescendants = true
        	Gui.Size = UDim2.fromScale(1, 1)
        	Gui.Position = UDim2.fromScale(0.5, 0.5)
        	Gui.AnchorPoint = Vector2.new(0.5, 0.5)
        
        	local AspectRatio = Instance.new("UIAspectRatioConstraint")
        	AspectRatio.AspectRatio = ResX / ResY
        	AspectRatio.Parent = Gui
        
        	local Container = Instance.new("Folder")
        	Container.Name = "FrameContainer"
        	Container.Parent = Gui
        
        	-- Define API
        	local function createGradient(colorData, x, pixelStart, pixelCount)
        		local Sequence = table.create(#colorData)
        		for i, data in ipairs(colorData) do
        			Sequence[i] = ColorSequenceKeypoint.new(data.p / pixelCount, data.c)
        		end
        
        		local Frame = Canvas._Pool:Get()
        		Frame.Position = UDim2.fromScale(invX * (x - 1), pixelStart * invY)
        		Frame.Size = UDim2.fromScale(invX, invY * pixelCount)
        		Frame.Gradient.Color = ColorSequence.new(Sequence)
        		Frame.Parent = Container
        
        		if Canvas._ColumnFrames[x] == nil then
        			Canvas._ColumnFrames[x] = { Frame }
        		else
        			table.insert(Canvas._ColumnFrames[x], Frame)
        		end
        
        		Canvas._Active = Canvas._Active+1
        	end
        
        	function Canvas:Destroy()
        		table.clear(Canvas._Grid)
        		table.clear(Canvas)
        		Gui:Destroy()
        	end
        
        	function Canvas:SetParent(parent)
        		Gui.Parent = parent
        	end
        
        	function Canvas:SetPixel(x, y, color)
        		local Col = self._Grid[x]
        
        		if Col[y] ~= color then
        			Col[y] = color
        			self._UpdatedColumns[x] = Col
        		end
        	end
        
        	function Canvas:Clear(x)
        		if x then
        			local column = self._ColumnFrames[x]
        			if column == nil then return end
        
        			for _, object in ipairs(column) do
        				self._Pool:Return(object)
        				self._Active = self._Active-1
        			end
        			table.clear(column)
        		else
        			for _, object in ipairs(Container:GetChildren()) do
        				self._Pool:Return(object)
        			end
        			self._Active = 0
        			table.clear(self._ColumnFrames)
        		end
        	end
        
        	function Canvas:Render()
        		for x, column in pairs(self._UpdatedColumns) do
        			self:Clear(x)
        
        			local colorCount, colorData = 1, {
        				{ p = 0, c = column[1] },
        			}
        
        			local pixelStart, lastPixel, pixelCount = 0, 0, 0
        			local lastColor = column[1]
        
        			-- Compress into gradients
        			for y, color in ipairs(column) do
        				pixelCount = pixelCount+1
        
        				-- Early exit to avoid the delta check on direct equality
        				if lastColor ~= color then
        					local delta = Util.DeltaRGB(lastColor, color)
        					if delta > self.Threshold then
        						local offset = y - pixelStart - 1
        	
        						if (delta > self.LossyThreshold) or (y-lastPixel > dist) then
        							table.insert(colorData, { p = offset - 0.08, c = lastColor })
        							colorCount = colorCount+1
        						end
        						table.insert(colorData, { p = offset, c = color })
        						colorCount = colorCount+1
        	
        						lastColor = color
        						lastPixel = y
        	
        						if colorCount > 17 then
        							table.insert(colorData, { p = pixelCount, c = color })
        							createGradient(colorData, x, pixelStart, pixelCount)
        	
        							pixelStart = y - 1
        							pixelCount = 0
        							colorCount = 1
        							table.clear(colorData)
        							colorData[1] = { p = 0, c = color }
        						end
        					end
        				end
        			end
        
        			if pixelCount + pixelStart ~= ResY then
        				pixelCount = pixelCount+1
        			end
        			table.insert(colorData, { p = pixelCount, c = lastColor })
        			createGradient(colorData, x, pixelStart, pixelCount)
        		end
        
        		table.clear(self._UpdatedColumns)
        	end
        
        	return Canvas
        end
        
        return module
    
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





local r3d = require("3dOperations")
local gc = __pack.require('GreedyCanvas/init.lua')

local w,h = 10,10
local pxg = table.create(w)
local canvas = gc.new(w,h)
for i=1,w do pxg[i]=table.create(h,{Color={B=0,G=0,R=0}}) end
canvas:SetParent(Instance.new("ScreenGui",script))
for x,row in pxg do for y,pixel in row do canvas:SetPixel(x,y,pixel.Color);end;end;canvas:Render()

