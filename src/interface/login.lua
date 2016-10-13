local Path, PLAY2D, Interface = ...
local CONST = PLAY2D.Constants
local gui = PLAY2D.gui

local Login = {}

function Login.load()
	
	Login.Label = gui.create("Label", "Test", 30, 200, 250, 25, PLAY2D.Main)
	Login.Label.Layout.TextColor = {255, 255, 0, 200}
	Login.Label.Layout.TextFont = love.graphics.newFont(gui.Fonts["Kanit Light"], 16)
	
	local Master = PLAY2D.Master
	local Color = Login.Label.Layout.TextColor
	
	function Login.Label:Update(...)
		
		local Out
		
		if Master.Connecting then
			
			Out = Interface.Language:Get("master_login_connect")
			
			Color[1] = 255
			Color[2] = 255
			Color[3] = 0
		
		elseif Master.Logging then
			
			Out = Interface.Language:Get("master_login_attempt")
			
			Color[1] = 255
			Color[2] = 255
			Color[3] = 0
			
		elseif Master.Error then
			
			if Master.Error == CONST.NET.LOGINBADUSERNAME then
				
				Out = Interface.Language:Get("master_login_badname")
				
			elseif Master.Error == CONST.NET.LOGINBADPASSWORD then
				
				Out = Interface.Language:Get("master_login_badpass")
				
			elseif Master.Error == CONST.NET.LOGINBANNED then
				
				Out = Interface.Language:Get("master_login_banned")
				
			end
			
			Color[1] = 0
			Color[2] = 0
			Color[3] = 255
			
		elseif Master.Logged then
			
			Out = Interface.Language:Get("master_login_success")
			Out.Arguments.USER = Master.Logged.User
			
			Color[1] = 0
			Color[2] = 255
			Color[3] = 0
			
		end
		
		if Out and tostring(Out) ~= self.Text:Get() then
			
			self.Text:SetText(Out)
			self.Changed = true
			
		end
		
		self.Base.Update(self, ...)
		
	end
	
	function Login.Label:OnMouseEnter()
		
		Color[4] = 255
		
		self.Changed = true
		
	end
	
	function Login.Label:OnMouseExit()
		
		Color[4] = 200
		
		self.Changed = true
		
	end
	
end

return Login