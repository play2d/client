local Format = setmetatable({}, Core.Maps.Format.Base.Metatable)
Format.Metatable = {__index = Format}

Core.Maps.Format.Map = Format

-- http://www.cs2d.com/entities.php?cat=all
Format.EntName = {
	[0] = "Info_T",
	[1] = "Info_CT",
	[2] = "Info_VIP",
	[3] = "Info_Hostage",
	[4] = "Info_RescuePoint",
	[5] = "Info_BombSpot",
	[6] = "Info_EscapePoint",
	[8] = "Info_Animation",
	[9] = "Info_Storm",
	[10] = "Info_TileFX",
	[11] = "Info_NoBuying",
	[12] = "Info_NoWeapons",
	[13] = "Info_NoFOW",
	[14] = "Info_Quake",
	[15] = "Info_CTF_Flag",
	[16] = "Info_OldRender",
	[17] = "Info_Dom_Point",
	[18] = "Info_NoBuildings",
	[19] = "Info_BotNode",
	[20] = "Info_TeamGate",
	[21] = "Env_Item",
	[22] = "Env_Sprite",
	[23] = "Env_Sound",
	[24] = "Env_Decal",
	[25] = "Env_Breakable",
	[26] = "Env_Explode",
	[27] = "Env_Hurt",
	[28] = "Env_Image",
	[29] = "Env_Object",
	[30] = "Env_Building",
	[31] = "Env_NPC",
	[32] = "Env_Room",
	[33] = "Env_Light",
	[34] = "Env_LightStripe",
	[50] = "Gen_Particles",
	[51] = "Gen_Sprites",
	[52] = "Gen_Weather",
	[53] = "Gen_FX",
	[70] = "Func_Teleport",
	[71] = "Func_DynWall",
	[72] = "Func_Message",
	[73] = "Func_GameAction",
	[80] = "Info_NoWeather",
	[90] = "Trigger_Start",
	[91] = "Trigger_Move",
	[92] = "Trigger_Hit",
	[93] = "Trigger_Use",
	[94] = "Trigger_Delay",
	[95] = "Trigger_Once",
	[96] = "Trigger_If",
}

function Format.Load(Path, File)
	local Header = File:ReadLine()
	if Header:sub(1, 44) ~= "Unreal Software's Counter-Strike 2D Map File" then
		return nil, "Not a Counter-Strike 2D Map File"
	end
	
	local Map = {
		Path = Path,
		Byte = {},
		Int = {},
		String = {},
		Background = {},
		Tiles = {},
		TileMode = {},
		Tile = {},
		Entity = {}
	}

	for i = 1, 10 do
		Map.Byte[i] = File:ReadByte()
	end
	
	for i = 1, 10 do
		Map.Int[i] = File:ReadInt()
	end
	
	for i = 1, 10 do
		Map.String[i] = File:ReadLine()
	end
	
	Map.Info = File:ReadLine()
	Map.Tileset = File:ReadLine()
	Map.TilesRequired = File:ReadByte()
	Map.Width = File:ReadInt()
	Map.Height = File:ReadInt()
	Map.Background.File = File:ReadLine()
	Map.Background.Scroll = {
		x = File:ReadInt(),
		y = File:ReadInt(),
	}
	Map.Background.Color = {
		R = File:ReadByte(),
		G = File:ReadByte(),
		B = File:ReadByte(),
	}
	
	local Header = File:ReadLine()
	if Header ~= "ed.erawtfoslaernu" then
		return nil, "Header damaged"
	end
	
	for i = 0, Map.TilesRequired do
		Map.TileMode[i] = File:ReadByte()
	end
	
	if CLIENT then
		Map.TilesetImage = love.graphics.newImage("gfx/tiles/"..Map.Tileset)
		if not Map.TilesetImage then
			return nil, "Failed to load image: gfx/tiles/"..Map.Tileset.." "..#Map.Tileset
		end
		
		local TileIndex = 0
		for y = 0, math.floor(Map.TilesetImage:getHeight()/32) do
			for x = 0, math.floor(Map.TilesetImage:getWidth()/32) do
				Map.Tiles[TileIndex] = love.graphics.newQuad(x * 32, y * 32, 32, 32, Map.TilesetImage:getDimensions())
				TileIndex = TileIndex + 1
			end
		end
	end
	
	for x = 0, Map.Width do
		Map.Tile[x] = {}
		for y = 0, Map.Height do
			Map.Tile[x][y] = {File:ReadByte()}
		end
	end
	
	if Map.Byte[2] == 1 then
		for x = 0, Map.Width do
			for y = 0, Map.Height do
				local Modifier = File:ReadByte()
				local HAS64BIT = Modifier % 128 >= 64
				local HAS128BIT = Modifier % 256 >= 128
				if HAS64BIT or HAS128BIT then
					if HAS64BIT and HAS128BIT then
						File:ReadLine()
					elseif HAS64BIT and not HAS128BIT then
						-- Frame for tile modification
						Map.Tile[x][y][2] = File:ReadByte()
					elseif not HAS64BIT and HAS128BIT then
						-- Red, green, blue, overlay frame
						Map.Tile[x][y][3] = File:ReadByte()
						Map.Tile[x][y][4] = File:ReadByte()
						Map.Tile[x][y][5] = File:ReadByte()
						Map.Tile[x][y][6] = File:ReadByte()
					end
				end
			end
		end
	end
	
	local Entities = File:ReadInt()
	for i = 1, Entities do
		local Entity = {}
		Entity.Name = File:ReadLine()
		Entity.Type = File:ReadByte()
		Entity.Position = {}
		Entity.Position.x = File:ReadInt()
		Entity.Position.y = File:ReadInt()
		Entity.Trigger = File:ReadLine()
		Entity.Int = {}
		Entity.String = {}

		for i = 1, 10 do
			Entity.Int[i] = File:ReadInt()
			Entity.String[i] = File:ReadLine()
		end
		table.insert(Map.Entity, Entity)
	end
	
	return setmetatable(Map, Format.Metatable)
end

function Format:GetTileMode(x, y)
	return self.TileMode[self:GetTileFrame(x, y)]
end

function Format:GetTileFrame(x, y)
	local Horizontal = self.Tile[x]
	if Horizontal then
		local Vertical = Horizontal[y]
		if Vertical then
			return Vertical[1]
		end
	end
	return 0
end

if CLIENT then
	
	function Format:RenderFloor(MapX, MapY, ScreenX, ScreenY, ScreenWidth, ScreenHeight)
		for x = MapX, Width do
			for y = MapY, Height do
				local TileMode = self:GetTileMode(x, y)
				if TileMode ~= 1 and TileMode ~= 2 then
					love.graphics.draw(self.TilesetImage, self.Tiles[self:GetTileFrame(x, y)], x * 32 + 16 - ScreenX, y * 32 + 16 - ScreenY)
				end
			end
		end
	end

	function Format:RenderTop(MapX, MapY, ScreenX, ScreenY, ScreenWidth, ScreenHeight)
		for x = MapX, Width do
			for y = MapY, Height do
				local TileMode = self:GetTileMode(x, y)
				if TileMode == 1 or TileMode == 2 then
					love.graphics.draw(self.TilesetImage, self.Tiles[self:GetTileFrame(x, y)], x * 32 + 16 - ScreenX, y * 32 + 16 - ScreenY)
				end
			end
		end
	end
end

function Format:GenerateHorizontalShapes(Mode)
	local Point = {}
	local AvailablePoints = {}
	for x = 0, self.Width do
		Point[x] = {}
		for y = 0, self.Height do
			if self:GetTileMode(x, y) == Mode then
				table.insert(AvailablePoints, {x = x, y = y})
			end
		end
	end
	
	local Shapes = {}
	while true do
		local Shape = {}

		for Index, P in pairs(AvailablePoints) do
			AvailablePoints[Index] = nil
			if not Point[P.x][P.y] then
				Shape.x = P.x
				Shape.y = P.y
				break
			end
		end

		if Shape.x == nil or Shape.y == nil then
			break
		end
		
		Shape.Width = 1
		Shape.Height = 1
		for x = Shape.x + 1, self.Width do
			if self:GetTileMode(x, Shape.y) == Mode and not Point[x][Shape.y] then
				Point[x][Shape.y] = Shape
				Shape.Width = Shape.Width + 1
			else
				break
			end
		end
		
		for y = Shape.y + 1, self.Height do
			local Width = 0
			for x = Shape.x, Shape.x + Shape.Width - 1 do
				if self:GetTileMode(x, y) == Mode and not Point[x][y] then
					Width = Width + 1
				else
					break
				end
			end
			
			if Width == Shape.Width then
				for x = Shape.x, Shape.x + Shape.Width - 1 do
					Point[x][y] = Shape
				end
				Shape.Height = Shape.Height + 1
			else
				break
			end
		end

		table.insert(Shapes, Shape)
	end
	return Shapes
end

function Format:GenerateVerticalShapes(Mode)
	local Point = {}
	local AvailablePoints = {}
	for x = 0, self.Width do
		Point[x] = {}
		for y = 0, self.Height do
			if self:GetTileMode(x, y) == Mode then
				table.insert(AvailablePoints, {x = x, y = y})
			end
		end
	end
	
	local Shapes = {}
	while true do
		local Shape = {}

		for Index, P in pairs(AvailablePoints) do
			AvailablePoints[Index] = nil
			if not Point[P.x][P.y] then
				Shape.x = P.x
				Shape.y = P.y
				break
			end
		end

		if Shape.x == nil or Shape.y == nil then
			break
		end
		
		Shape.Width = 1
		Shape.Height = 1
		for y = Shape.y + 1, self.Height do
			if self:GetTileMode(Shape.x, y) == Mode and not Point[Shape.x][y] then
				Point[Shape.x][y] = Shape
				Shape.Height = Shape.Height + 1
			else
				break
			end
		end
		
		for x = Shape.x + 1, self.Width do
			local Height = 0
			for y = Shape.y, Shape.y + Shape.Height - 1 do
				if self:GetTileMode(x, y) == Mode and not Point[x][y] then
					Height = Height + 1
				else
					break
				end
			end
			
			if Height == Shape.Height then
				for y = Shape.y, Shape.y + Shape.Height - 1 do
					Point[x][y] = Shape
				end
				Shape.Width = Shape.Width + 1
			else
				break
			end
		end

		table.insert(Shapes, Shape)
	end
	return Shapes
end

function Format:GenerateShapes(Mode)
	local HorizontalShapes = self:GenerateHorizontalShapes(Mode)
	local VerticalShapes = self:GenerateVerticalShapes(Mode)
	
	if #HorizontalShapes < #VerticalShapes then
		return HorizontalShapes
	end
	return VerticalShapes
end

function Format:GenerateWorld()
	local Start = love.timer.getTime()
	
	love.physics.setMeter(32)
	self.World = love.physics.newWorld()
	
	self.WorldBody = love.physics.newBody(self.World, 0, 0)
	self.WorldBody:setType("static")
	
	local WallShapes = self:GenerateShapes(1)
	local ObstacleShapes = self:GenerateShapes(2)
	
	for _, Shape in pairs(WallShapes) do
		local Rectangle = love.physics.newRectangleShape(Shape.x * 32, Shape.y * 32, Shape.Width * 32, Shape.Height * 32)
		local Fixture = love.physics.newFixture(self.WorldBody, Rectangle)
		Fixture:setUserData({Wall = true})
	end
	
	for _, Shape in pairs(ObstacleShapes) do
		local Rectangle = love.physics.newRectangleShape(Shape.x * 32, Shape.y * 32, Shape.Width * 32, Shape.Height * 32)
		local Fixture = love.physics.newFixture(self.WorldBody, Rectangle)
		Fixture:setUserData({Obstacle = true})
	end
	
	print("World generated in "..math.floor((love.timer.getTime() - Start)*1000 + 0.5).."ms")
end

function Format:GenerateEntities()
	for _, MapEnt in pairs(self.Entity) do
		Core.State.CreateEntity(Format.EntName[MapEnt.Type], MapEnt.Position.x * 32 + 16, MapEnt.Position.y * 32 + 16, 0, MapEnt)
	end
end

function Format:GetRandomSpawnPoint(Player)
	local Entities = {}
	for ID, Entity in pairs(Core.State.Entities) do
		if Entity.Type == "Info_T" or Entity.Type == "Info_CT" then
			if Entity.State then
				table.insert(Entities, Entity)
			end
		end
	end
	
	if #Entities > 0 then
		return Entities[math.random(1, #Entities)]:GetPosition()
	end
end