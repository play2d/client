-- CS2D Map Parser

local Map = {}
local MapMetatable = {__index}

function Map:Render(x, y, Width, Height, dt)
end

function Map:Update(dt)
end

function Map:NETMessage(Message)
	-- Perhaps trigger a entity?
end

local function Read(f)
end

local function Write(f)
end

return {Read = Read, Write = Write}
