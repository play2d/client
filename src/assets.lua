local Path, PLAY2D = ...

local Assets = { Buffer = {} }
local AssetsMT = {__index = Assets}

Assets.Path = "assets/"
Assets.Function = {}

-- Static functions
function Assets.Function:image(Asset)
	
	local AssetFile = Asset[2]
	
	if type(AssetFile) == "string" then
		
		AssetFile = self.Path .. "/" .. Asset[2]
		
	end
	
	Assets.Buffer[AssetFile] = love.graphics.newImage(AssetFile)
	
end

function Assets.Function:font(Asset)
	
	local AssetFile = Asset[2]
	
	if type(AssetFile) == "string" then
		
		AssetFile = self.Path .. "/" .. Asset[2]
		
	end
	
	Assets.Buffer[AssetFile] = love.graphics.newFont(AssetFile, Asset[3])
	
end

-- Class functions
function Assets:Update(...)
	
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

	end
	
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
	
	return #self.Queue.Loaded == self.Queue.Total
	
end

function Assets:AddToQueue(...)
	
	local Buffer = Assets.Buffer

	for Num, Asset in pairs({...}) do
		
		if tostring(Asset[1]) and tostring(Asset[2]) then
			
			local AssetPath = Assets.Path..Asset[2]

			if not love.filesystem.exists(AssetPath) then
				print("Err, "..AssetPath.." not found on both Game and Root directories")

			else
				
				self.Queue.Total = self.Queue.Total + 1
				
				table.insert(self.Queue.List, Asset)
				
			end
			
		end
		
	end
	
end

function Assets.CreateQueue(Path)
	
	local Buffer = Assets.Buffer
	local self = {}
	
	self.Path = Path
	self.Queue =  { List = {}, Loaded = {}, Total = 0 }
	
	return setmetatable(self, AssetsMT)
	
end

return Assets
