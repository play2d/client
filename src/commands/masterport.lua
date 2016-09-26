local Command = ...

Command.Category = "Net"
Command.Value = 0

function Command:Execute(Terminal, Port)
	
	if type(Port) == "number" and Port > 0 and Port <= 65535 then
		
		self.Value = Port
		
	end
	
end

function Command:Set(Port)
	
	if type(Port) == "number" and Port > 0 and Port <= 65535 then
		
		self.Value = Port
		
	end
	
end