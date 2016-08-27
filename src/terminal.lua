local PLAY2D = ...

local Terminal = {}
local TerminalMT = {__index = Terminal}

function PLAY2D.CreateTerminal(Functions)
	local self = {}
	
	self.Functions = Functions;
	
	return setmetatable(self, TerminalMT)
end

function Terminal:Execute(Command)
	local Instructions = self:Parse(Command)
end

function Terminal:Parse(Command)
end