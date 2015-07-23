local TContext = {}
local TContextMetatable = {__index = TContext}
TContext.Type = "Context"
setmetatable(TContext, gui.TGadgetMetatable)

function gui.TGadget:AddContext(...)
	if not self.Context then
		local Context = TContext.New()
		if self:ForceAddGadget(Context) then
			Context.Hidden = true
			self.Context = Context:Init()
		end
	end
	if self.Context then
		for _, Item in pairs({...}) do
			self.Context:AddItem(Item)
		end
	end
	return self.Context
end

function TContext.New()
	return setmetatable({}, TContextMetatable)
end

function TContext:Init()
	self.Items = {}
	self.Size = {Width = 0, Height = 0}
	return self
end

function TContext:SetItem(Index, Item)
	if Item then
		self.Items[Index] = Item
		
		local Font = self:GetFont()
		self.Size.Width = 0
		self.Size.Height = 0
		for _, Item in pairs(self.Items) do
			local Width = Font:getWidth(Item) + 5
			if Width > self.Size.Width then
				self.Size.Width = Width
			end
			self.Size.Height = self.Size.Height + Font:getHeight() + 5
		end
	end
end

function TContext:RemoveItem(Index)
	if self.Items[Index] then
		self.Items[Index] = nil
		
		local Font = self:GetFont()
		self.Size.Width = 0
		self.Size.Height = 0
		for _, Item in pairs(self.Items) do
			local Width = Font:getWidth(Item) + 5
			if Width > self.Size.Width then
				self.Size.Width = Width
			end
			self.Size.Height = self.Size.Height + Font:getHeight() + 5
		end
	end
end

function TContext:Render(dt)
	if not self.Hidden then
		local x, y = self:x(), self:y()
		local Width, Height = self:GetDimensions()
		local Theme = self:GetTheme()
		local Font = self:GetFont()
		
		love.graphics.setScissor(x, y, Width, Height)
		love.graphics.setColor(unpack(Theme.Border))
		love.graphics.rectangle("line", x, y, Width, Height)
		
		love.graphics.setColor(unpack(Theme.Background))
		love.graphics.rectangle("fill", x + 1, y + 1, Width - 2, Height - 2)
		
		local FontHeight = Font:getHeight()
		local HeightOffset = 0
		love.graphics.setFont(Font)
		love.graphics.setColor(unpack(Theme.Text))
		for _, Item in pairs(self.Items) do
			love.graphics.print(Item, x + 2.5, y + HeightOffset + 2.5)
			if self:MouseHoverArea(0, HeightOffset, Width, FontHeight + 4.5) then
				love.graphics.setColor(unpack(Theme.Hover))
				love.graphics.rectangle("fill", x + 2.5, y + HeightOffset, Width - 5, FontHeight + 5)
				love.graphics.setColor(unpack(Theme.Text))
			end
			HeightOffset = HeightOffset + FontHeight + 5
		end
	end
end

function TContext:MouseClicked(x, y)
	if not self.Disabled and not self.Hidden then
		local Width = self:GetWidth()
		local FontHeight = self:GetFont():getHeight()
		local HeightOffset = 0
		for Index, Item in pairs(self.Items) do
			if self:MouseHoverArea(0, HeightOffset, Width, FontHeight + 4.5) then
				self.Hidden = true
				if self.Parent.OnContext then
					self.Parent:OnContext(Index, Item)
					break
				end
			end
			HeightOffset = HeightOffset + FontHeight + 5
		end
		self:OnClick(x - self:x(), y - self:y())
	end
end