local Path, gui = ...
local Label = {}

Label.TextFont = love.graphics.newFont(gui.Fonts["Kanit Light"], 13)
Label.TextColor = {80, 80, 80, 255}

function Label:Init()
	self.Layout.TextFont = Label.TextFont
	self.Layout.TextColor = Label.TextColor
	
	self.Text:SetFont(self.Layout.TextFont)
	self.Text:SetColor(unpack(self.Layout.TextColor))
end

function Label:UpdateLayout()
	self.Text:SetFont(self.Layout.TextFont)
	self.Text:SetColor(unpack(self.Layout.TextColor))
end

function Label:Render(dt)
	self.Text:Draw(0, 0)
end

return Label