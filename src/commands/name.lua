local Command = ...

Command.Category = "Multiplayer"
Command.Value = "Player"

function Command:Execute(Terminal, String)
	
	if type(String) == "string" and #String > 0 then
		
		self.Value = String
		
	end
	
end

function Command:Set(String)
	
	if type(String) == "string" and #String > 0 then
		
		self.Value = String
		
	end
	
end