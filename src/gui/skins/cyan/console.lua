local Path, gui = ...
local Console = {}

Console.TextFont = love.graphics.newFont(gui.Fonts["Mode Nine"], 14)
Console.TextColor = {200, 200, 200, 255}
Console.BackgroundColor = {0, 0, 0, 255}

local function CanDelete(TextArea, Position, Length, Line)
	if Line >= #TextArea.Text.Line then
		return true
	end
end

function Console:Init()
	local Width, Height = self:GetDimensions()
	
	self.Layout.TextFont = Console.TextFont
	self.Layout.TextColor = Console.TextColor
	self.Layout.BackgroundColor = Console.BackgroundColor
	
	self.Layout.TextArea = gui.create("TextArea", 0, 0, Width, Height, self)
	self.Layout.TextArea.Layout.BackgroundColor = self.Layout.BackgroundColor
	self.Layout.TextArea.Layout.TextFont = self.Layout.TextFont
	self.Layout.TextArea.Layout.TextColor = self.Layout.TextColor
	self.Layout.TextArea.CanDelete = CanDelete
end

function Console:UpdateLayout()
	local Width, Height = self:GetDimensions()
	
	self.Layout.TextArea:SetDimensions(Width, Height)
	self.Layout.TextArea.Layout.BackgroundColor = self.Layout.BackgroundColor
	self.Layout.TextArea.Layout.TextFont = self.Layout.TextFont
	self.Layout.TextArea.Layout.TextColor = self.Layout.TextColor
end

function Console:Render()
end

return Console