local Path, PLAY2D = ...
local Master = {}

function Master.load()
	
	Master.Socket = PLAY2D.Connection.CreateServer("*:0")
	
	print("Master server started: ".. tostring(Master.Socket))
	
	Master.load = nil
	
end

function Master.update()
	
	
	
end

return Master