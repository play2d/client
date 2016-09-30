local Path, PLAY2D, Interface, Options = ...
local gui = PLAY2D.gui

local Net = {}

function Net.load()
	
	Options.Tab:AddItem( Interface.Language:Get("options_net") )
	
	Options.Panel[6] = gui.create("Panel", 10, 50, Options.Window:GetWidth() - 20, Options.Window:GetHeight() - 80, Options.Window)
	
	Options.UserLabel = gui.create("Label", Interface.Language:Get("net_login_user"), 10, 50, 100, 20, Options.Panel[6])
	Options.PasswordLabel = gui.create("Label", Interface.Language:Get("net_login_password"), 10, 80, 100, 20, Options.Panel[6])
	
	Options.UserField = gui.create("TextField", 200, 50, 200, 20, Options.Panel[6])
	Options.PasswordField = gui.create("TextField", 200, 80, 200, 20, Options.Panel[6]):SetPassword(true)
	
	-- Setup
	Options.UserField:SetText(PLAY2D.Master.Login.User)
	Options.PasswordField:SetText(PLAY2D.Master.Login.Password)
	
	Net.load = nil
	
end

function Net.Okay()
	
	PLAY2D.Master.Login.User = Options.UserField:GetText()
	PLAY2D.Master.Login.Password = Options.UserField:GetText()
	PLAY2D.Master.SaveLogin()
	
end

function Net.Cancel()
	
	Options.UserField:SetText(PLAY2D.Master.Login.User)
	Options.PasswordField:SetText(PLAY2D.Master.Login.Password)
	
end

return Net