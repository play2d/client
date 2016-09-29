local Path, PLAY2D = ...
local Master = {}

function Master.load()
	
	Master.Socket = PLAY2D.Connection.CreateServer(PLAY2D.Commands.List["masterport"]:GetInt())
	
	Master.load = nil
	
end

function Master.update()
	
	if Master.Socket then
		
		Master.Socket:Update()
		
	end
	
end

return Master