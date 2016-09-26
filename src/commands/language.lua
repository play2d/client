local Command = ...

Command.Category = "Local"
Command.Language = "English"
Command.Link = PLAY2D.Language.CreateLink(Language)

function Command:Execute(Terminal, String)
	
	if type(String) == "string" and #String > 0 then
	
		self.Value = String
		self.Link.Language = String
		
	end
	
end

function Command:Set(String)
	
	if type(String) == "string" and #String > 0 then
	
		self.Value = String
		self.Link.Language = String
		
	end
	
end

function Command:GetLink()
	
	return self.Link
	
end