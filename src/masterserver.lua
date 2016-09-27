local Path, PLAY2D = ...
local Master = {}

function Master.load()
	
	Master.Socket = PLAY2D.Connection.CreateServer(PLAY2D.Commands.List["masterport"]:GetInt())
	
	if Master.Socket then
		
		PLAY2D.Print("Master server started: ".. tostring(Master.Socket), 0, 175, 0, 255)
		
	else
		
		PLAY2D.Print("Failed to initialize master server socket", 175, 0, 0, 255)
		
	end
	
	Master.load = nil
	
end

function Master.update()
	
	Master.Socket:Update()
	
end

return Master