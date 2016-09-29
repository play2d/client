local Path, PLAY2D = ...
local utf8 = PLAY2D.UTF8

local UTF8Any = utf8.charpattern
local UTF8Char = utf8.charpattern:sub(1, -2)

local Terminal = {}
local TerminalMT = {__index = Terminal}

function Terminal:Execute(Command)
	
	local Instructions, Error = self:Parse(Command)
	
	self.Error = nil
	
	if Error then
		
		self.Error = Error
	
	elseif self.Function then
	
		for Index, Instruction in pairs(Instructions) do
			
			local Function = self.Function[Instruction.Command]
			
			if type(Function) == "function" then
				
				pcall(Function, self, unpack(Instruction.Arguments) )
			
			elseif type(Function) == "table" and type(Function.Execute) == "function" then
				
				pcall(Function.Execute, Function, self, unpack(Instruction.Arguments) )
			
			else
				
				self.Error = 'Command "' .. Instruction.Command .. '" does not exist'
				
			end
			
		end
	
	else
		
		self.Error = '"self.Function" table missing, no available commands'
	
	end
	
	return self.Error ~= nil
end

function Terminal:Parse(Command)
	
	local Instructions = {}
	local Arguments = {}
	
	local Line
	
	while #Command > 0 do
		local Character = Command:match(UTF8Any) or ""
		Command = Command:sub(#Character + 1)
		
		if Character:match("%d") or ( Character == "-" and Command:sub(1, 1):match("%d") ) then
			local Number = Character
			
			Character = Command:match(UTF8Any) or ""
			Command = Command:sub(#Character + 1)
			
			while Character:match("%d") do
				Number = Number .. Character
				
				Character = Command:match(UTF8Any) or ""
				Command = Command:sub(#Character + 1)
			end
			
			if Character == "." and Command:sub(1, 1):match("%d") then
				Number = Number .. Character
				
				Character = Command:match(UTF8Any) or ""
				Command = Command:sub(#Character + 1)
				
				while Character:match("%d") do
					Number = Number .. Character
					
					Character = Command:match(UTF8Any) or ""
					Command = Command:sub(#Character + 1)
				end
				
			end
			
			if Line then
				table.insert(Arguments, tonumber(Number) )
			else
				return nil, "Unexpected number '"..Number.."'"
			end
			
		end
		
		if Character:match("%a") or Character:match(UTF8Char) then
			
			if Line then
				
				local String = Character
				
				Character = Command:match(UTF8Any) or ""
				Command = Command:sub(#Character + 1)
				
				while Character:match("%a") or Character:match(UTF8Char) do
					String = String .. Character
					
					Character = Command:match(UTF8Any) or ""
					Command = Command:sub(#Character + 1)
				end
				
				table.insert(Arguments, String)
				
			else
				
				Line = Character
				
				Character = Command:match(UTF8Any) or ""
				Command = Command:sub(#Character + 1)
				
				while Character:match("%a") or Character:match(UTF8Char) do
					Line = Line .. Character
					
					Character = Command:match(UTF8Any) or ""
					Command = Command:sub(#Character + 1)
				end
				
			end
		end
		
		if Character == '"' or Character == "'" then
			
			local BreakCharacter = Character
			local String = ""
			
			Character = Command:match(UTF8Any) or ""
			Command = Command:sub(#Character + 1)
			
			while #Command > 0 do
				
				if Character == BreakCharacter then
					
					Character = Command:match(UTF8Any) or ""
					Command = Command:sub(#Character + 1)
					break
				
				elseif Character == "\\" then
				
					Character = Command:match(UTF8Any) or ""
					Command = Command:sub(#Character + 1)
				
				end
				
				String = String .. Character
				
				Character = Command:match(UTF8Any) or ""
				Command = Command:sub(#Character + 1)
				
			end
			
			table.insert(Arguments, String)
		
		end
		
		if Character == ";" then
			
			if Line then
				local Instruction = {}
				
				Instruction.Command = Line
				Instruction.Arguments = Arguments
				
				table.insert(Instructions, Instruction)
				
				Line = nil
				Arguments = {}
			else
				return nil, "Unexpected command break character '"..Character.."'"
			end
			
		end
		
	end
	
	if Line then
		
		local Instruction = {}
		
		Instruction.Command = Line
		Instruction.Arguments = Arguments
		
		table.insert(Instructions, Instruction)
		
	end

	return Instructions
	
end

local function CreateTerminal(Functions)
	
	local self = {}
	
	self.Function = Functions
	
	return setmetatable(self, TerminalMT)
	
end

return {
	Create = CreateTerminal
}