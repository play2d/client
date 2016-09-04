local Path, PLAY2D = ...
local Assets = {}

Assets.Buffer = {}
Assets.Queue = {List = {}, Total = 0, Loaded = 0}

Assets.Path = "assets/"

function Assets.Load(...)
	
	local Queue = Assets.Queue
	local List = Queue.List
	local Buffer = Assets.Buffer
	
	for Num, Asset in pairs({...}) do
		
		if tostring(Asset[1]) and tostring(Asset[2]) then
			
			local AssetPath = Assets.Path..Asset[2]

			if not love.filesystem.exists(AssetPath) then
				print("Err, "..AssetPath.." not found on both Game and Root directories")

			else
				
				Queue.Total = Queue.Total + 1
				table.insert(List, {Asset[1], Asset[2]})

			end
		end
	end
	
end

function Assets.update(...)
	
	local Queue = Assets.Queue
	local Total = Queue.Total
	local List = Queue.List
	local Buffer = Assets.Buffer

	if Queue.Loaded < Total then
		
		local Asset = List[1]
		local AssetType = Asset[1]
		local AssetPath = Assets.Path..Asset[2]

		if AssetType == "image" then
			local AssetPath = Assets.Path..Asset[2]
			Buffer[AssetPath] = love.graphics.newImage(AssetPath)
		end

		Queue.Loaded = Queue.Loaded + 1
		table.remove(List, 1)

	end

end

function Assets.draw(...)
	
	local Queue = Assets.Queue
	local Total = Queue.Total
	local Loaded = Queue.Loaded

	if Loaded < Total then

		local LG = love.graphics
		local winHeight = LG.getHeight()
		local winWidth = LG.getWidth()	

		local ProgressBarWidth = 240
		local ProgressBarHeight = 40

		LG.setColor(0, 0, 0)
		LG.rectangle("fill", 0, 0, winHeight, winWidth)
		LG.setColor(129, 129, 129)
		LG.rectangle("line", (winWidth / 2) - (ProgressBarWidth / 2) - 5, (winHeight / 2) - (ProgressBarHeight / 2) - 5, ProgressBarWidth + 10, ProgressBarHeight + 10)
		LG.rectangle("fill", (winWidth / 2) - (ProgressBarWidth / 2), (winHeight / 2) - (ProgressBarHeight / 2), math.floor(ProgressBarWidth * (Loaded/Total)), ProgressBarHeight)
	--	love.timer.sleep(2) -- (For testing ^-^)
		
	end
	
end

return Assets