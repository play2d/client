local Path, PLAY2D = ...

local Assets = { Buffer = {} }
local AssetsMT = {__index = Assets}

Assets.Path = "assets/"

function Assets:Update(...)
	
	local Queue = self.Queue
	local Total = Queue.Total
	local List = Queue.List
	local Buffer = Assets.Buffer

	if #Queue.Loaded < Total then
		
		local Asset = List[1]
		local AssetType = Asset[1]
		local AssetPath = Assets.Path..Asset[2]

		if AssetType == "image" then
			local AssetPath = Assets.Path..Asset[2]
			Buffer[AssetPath] = love.graphics.newImage(AssetPath)
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
				table.insert(self.Queue.List, {Asset[1], Asset[2]})
				
			end
		end
	end
end

function Assets.CreateQueue(...)
	local Buffer = Assets.Buffer
	local self = {}
	
	self.Queue =  { List = {}, Loaded = {}, Total = 0 }

	for Num, Asset in pairs({...}) do
		
		if tostring(Asset[1]) and tostring(Asset[2]) then
			
			local AssetPath = Assets.Path..Asset[2]

			if not love.filesystem.exists(AssetPath) then
				print("Err, "..AssetPath.." not found on both Game and Root directories")

			else
				self.Queue.Total = self.Queue.Total + 1
				table.insert(self.Queue.List, {Asset[1], Asset[2]})
				
			end
		end
	end
	
	return setmetatable(self, AssetsMT)
end

return Assets
