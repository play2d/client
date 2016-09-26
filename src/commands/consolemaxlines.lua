local Command = ...

Command.Category = "Console"
Command.Value = 150

function Command:Execute(Terminal, Lines)
	
	if type(Lines) == "number" and Lines > 0 then
		
		Command.Value = Lines
		
	end
	
end

function Command:Set(Lines)
	
	if type(Lines) == "number" and Lines > 0 then
		
		Command.Value = Lines
		
	end
	
end