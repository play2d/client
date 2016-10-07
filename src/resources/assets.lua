local Path, PLAY2D = ...

local Assets = { Buffer = {} }
local AssetsMT = {__index = Assets}

Assets.Font = love.graphics.getFont()
Assets.Function = {}

-- Static functions
function Assets.Function:image(Asset)
	
	local AssetFile = Asset[2]
	
	if type(AssetFile) == "string" then
		
		AssetFile = self.Path .. "/" .. Asset[2]
		
	end
	
	local Resource = love.graphics.newImage(AssetFile)
	
	Assets.Buffer[AssetFile] = Resource
	Asset.Resource = Resource
	
end

function Assets.Function:font(Asset)
	
	local AssetFile = Asset[2]
	
	if type(AssetFile) == "string" then
		
		AssetFile = self.Path .. "/" .. Asset[2]
		
	end
	
	local Resource = love.graphics.newFont(AssetFile, Asset[3])
	
	Assets.Buffer[AssetFile] = Resource
	Asset.Resource = Resource
	
end

function Assets.Function:sound(Asset)
	
	local AssetFile = Asset[2]
	
	if type(AssetFile) == "string" then
		
		AssetFile = self.Path .. "/" .. Asset[2]
		
	end
	
	local Resource = love.sound.newSoundData(AssetFile)
	
	Assets.Buffer[AssetFile] = Resource
	Asset.File = Resource
	
end

function Assets.Function:DrawStencil()

   love.graphics.circle("fill", 400, 300, 18)
   
end

-- Class functions
function Assets.CreateQueue(Path, Name)
	
	local Buffer = Assets.Buffer
	local self = {}
	
	self.Path = Path
	self.Name = Name
	self.Queue = {
		List = {},
		Loaded = {},
		Total = 0
	}
	
	self.LoadingEffect = false
		
	return setmetatable(self, AssetsMT)
	
end

function Assets:Update(Delta)
	
	if not self.LoadingEffect or self.LoadingEffect:IsDone() then
	
		self.Delay = 0
		
		local Queue = self.Queue
		local List = Queue.List

		if #Queue.Loaded < Queue.Total then
			
			local Asset = List[1]
			local AssetType = Asset[1]
			
			local Function = Assets.Function[AssetType]
			
			if Function then
				
				Function(self, Asset)
				
			end
			
			table.insert(Queue.Loaded, Asset[2])
			table.remove(List, 1)
			
			-- The second parameter represents the loading delay, change it and see what happens
			self.LoadingEffect = PLAY2D.Easing.new("linear", 0.065)
		
		end	
	
	end
	
	self.LoadingEffect:Update(Delta)
end

function Assets:GetCurrentAsset()
	
	return self.Queue.Loaded[#self.Queue.Loaded]
	
end

function Assets:GetTotalLoadedAssets()
	
	return #self.Queue.Loaded
	
end

function Assets:GetTotalQueuedAssets()
	
	return self.Queue.Total
	
end

function Assets:IsDone()
	
	return #self.Queue.Loaded == self.Queue.Total and (not self.LoadingEffect or self.LoadingEffect:IsDone())
	
end

function Assets:AddToQueue(...)
	
	for Num, Asset in pairs({...}) do
		
		self:AddSingle(Asset)
		
	end
	
end

function Assets:AddSingle(Asset)
	
	if Asset[1] and Asset[2] then
		
		local AssetPath = self.Path .. "/" .. Asset[2]
		
		if not love.filesystem.exists(AssetPath) then
			
			print("Err, "..AssetPath.." not found on both Game and Root directories")
		
		else
			
			self.Queue.Total = self.Queue.Total + 1
			
			table.insert(self.Queue.List, Asset)
			
		end
		
	end
	
	return Asset
	
end

function Assets:Draw()
	
	local w, h = love.graphics.getDimensions()
	
	local tq = self:GetTotalQueuedAssets()
	local tl =  self:GetTotalLoadedAssets()
	
	local rad = (math.pi * 2 * ((tl - 1) / tq)) + (math.pi * 2 * (1 / tq) * (self.LoadingEffect:getProgress(1) or 1))

	love.graphics.setLineWidth(3)
	love.graphics.stencil(Assets.Function.DrawStencil, "replace", 1)
	love.graphics.setStencilTest("equal", 0)
	love.graphics.arc("line", math.floor(w * 0.5), math.floor(h * 0.5), 20, 0, rad)
	love.graphics.setStencilTest()	
	
	if self.Name then
		
		local Text = "Loading " .. self.Name .. "..."
		
		love.graphics.setFont(self.Font)
		love.graphics.setColor(255, 255, 255, 255)
		
		love.graphics.print(Text, math.floor( (w - self.Font:getWidth(Text) ) / 2), (h - self.Font:getHeight(Text) ) / 2 + 50)
		
	end
	
end

return Assets
