local Command = ...

Command.Category = "Multiplayer"
Command.Value = ""

function Command:Execute(Terminal, String)
	
	if type(String) == "string" then
		
		self.Value = String
		
	end
	
end

function Command:Set(String)
	
	if type(String) == "string" then
		
		self.Value = String
		
	end
	
end