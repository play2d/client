local Command = ...

Command.Category = "Console"

local MaxLines = 150

function Command:Execute(Lines)
	
	if type(Lines) == "number" and Lines > 0 then
		
		MaxLines = Lines
		
	end
	
end

function Command:GenerateConfiguration()
	
	return "consolemaxlines "..MaxLines
	
end

function Command:GetInt()
	
	return MaxLines
	
end

function Command:GetString()
	
	return tostring(MaxLines)
	
end

function Command:Set(Lines)
	
	if type(Lines) == "number" and Lines > 0 then
		
		MaxLines = Lines
		
	end
	
end