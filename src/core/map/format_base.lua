local Format = {}
Format.Metatable = {__index = Format}

Core.Maps.Format.Base = Format

function Format:Load(File)
end

if CLIENT then
	function Format:Render(x, y, Width, Height, ScreenX, ScreenY, ScreenWidth, ScreenHeight)
	end
end

function Format:GenerateWorld()
end

function Format:GenerateEntities(EntitiesTable)
end