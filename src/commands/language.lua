local Command, PLAY2D = ...

Command.Category = "Local"
Command.Language = "English"

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

function Command:GetLink()
	
	return PLAY2D.Language.List[self.Language]
	
end