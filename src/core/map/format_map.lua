local Format = setmetatable({}, Core.Maps.Format.Base.Metatable)
Format.Metatable = {__index = Format}

Core.Maps.Format.Map = Format

function Format.Load(File)
	local Header = File:read("*l")
	if Header:sub(1, 44) ~= "Unreal Software's Counter-Strike 2D Map File" then
		return nil, "Not a Counter-Strike 2D Map File"
	end
	
	local Map = {
		Byte = {},
		Int = {},
		String = {},
		Background = {},
		TileMode = {},
		Tile = {},
		Entity = {}
	}

	for i = 1, 10 do
		Map.Byte[i] = File:read(1):ReadByte()
	end
	
	for i = 1, 10 do
		Map.Int[i] = File:read(4):ReadInt()
	end
	
	for i = 1, 10 do
		Map.String[i] = File:read("*l")
	end
	
	Map.Info = File:read("*l")
	Map.Tileset = File:read("*l")
	Map.TilesRequired = File:read(1):ReadByte()
	Map.Width = File:read(4):ReadInt()
	Map.Height = File:read(4):ReadInt()
	Map.Background.File = File:read("*l")
	Map.Background.Scroll = {
		x = File:read(4):ReadInt(),
		y = File:read(4):ReadInt(),
	}
	Map.Background.Color = {
		R = File:read(1):ReadByte(),
		G = File:read(1):ReadByte(),
		B = File:read(1):ReadByte(),
	}
	
	if File:read("*l"):sub(1, -2) ~= "ed.erawtfoslaernu" then
		return nil, "Header damaged"
	end
	
	for i = 0, Map.TilesRequired do
		Map.TileMode[i] = File:read(1):ReadByte()
	end
	
	for x = 0, Map.Width do
		Map.Tile[x] = {}
		for y = 0, Map.Height do
			Map.Tile[x][y] = {File:read(1):ReadByte()}
		end
	end
	
	if Map.Byte[2] == 1 then
		for x = 0, Map.Width do
			for y = 0, Map.Height do
				local Modifier = File:read(1):ReadByte()
				local HAS64BIT = Modifier % 128 >= 64
				local HAS128BIT = Modifier % 256 >= 128
				if HAS64BIT or HAS128BIT then
					if HAS64BIT and HAS128BIT then
						File:read("*l")
					elseif HAS64BIT and not HAS128BIT then
						-- Frame for tile modification
						Map.Tile[x][y][2] = File:read(1):ReadByte()
					elseif not HAS64BIT and HAS128BIT then
						-- Red, green, blue, overlay frame
						Map.Tile[x][y][3] = File:read(1):ReadByte()
						Map.Tile[x][y][4] = File:read(1):ReadByte()
						Map.Tile[x][y][5] = File:read(1):ReadByte()
						Map.Tile[x][y][6] = File:read(1):ReadByte()
					end
				end
			end
		end
	end
	
	local Entities = File:read(4):ReadInt()
	for i = 1, Entities do
		local Entity = {
			Name = File:read("*l"),
			Type = File:read(1):ReadByte(),
			Position = {
				x = File:read(4):ReadInt(),
				y = File:read(4):ReadInt(),
			},
			Trigger = File:read("*l"),
			Int = {},
			String = {},
		}
		for i = 1, 10 do
			Entity.Int[i] = File:read(4):ReadInt()
			Entity.String[i] = File:read("*l")
		end
		table.insert(Entity, Map.Entity)
	end
	
	return setmetatable(Map, Format.Metatable)
end

function Format:GetTileMode(x, y)
	local Horizontal = self.Tile[x]
	if Horizontal then
		local Vertical = self.Tile[x][y]
		if Vertical then
			return self.TileMode[Vertical[1]]
		end
	end
	return 0
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
		local ShapeGenerated
		
		local Start
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
		local ShapeGenerated
		
		local Start
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

function Format:GenerateEntities(EntitiesTable)
end