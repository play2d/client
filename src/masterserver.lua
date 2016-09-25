local Path, PLAY2D = ...
local Master = {}

function Master.load()
	
	Master.Socket = PLAY2D.Connection.CreateServer("*:0")
	
	if Master.Socket then
		
		PLAY2D.Print("Master server started: ".. tostring(Master.Socket), 0, 175, 0, 255)
		
	end
	
	Master.load = nil
	
end

function Master.update()
	
	
	
end

return Master