local TCombobox = {}
local TComboboxMetatable = {__index = TCombobox}
TCombobox.Type = "Combobox"
TCombobox.ItemCount = 0
setmetatable(TCombobox, gui.TGadgetMetatable)

function gui.CreateCombobox(x, y, Width, Height, Parent)
	local Combobox = TCombobox.New()
	if Parent:AddGadget(Combobox) then
		Combobox:SetPosition(x, y)
		Combobox:SetSize(Width, Height)
		return Combobox:Init()
	end
end

function TCombobox.New()
	return setmetatable({}, TComboboxMetatable)
end

function TCombobox:Init()
	self.Items = {}
	return self
end

function TCombobox:Height()
	if self.Open then
		return self.Size.Height + self.ItemCount * (self:GetFont():getHeight() + 5)
	end
	return self.Size.Height
end

function TCombobox:SetItem(Index, Item)
	if not self.Items[Index] then
		self.ItemCount = self.ItemCount + 1
	end
end

function TCombobox:RemoveItem(Index)
	if self.Items[Index] then
		self.Items[Index] = nil
		self.ItemCount = self.ItemCount - 1
	end
end

function TCombobox:MouseClicked(x, y)
	if not self.Disabled and not self.Hidden then
		self.Dropped = mil
		self.Grabbed = {x = x - self:x(), y = y - self:y()}
		self:OnClick(self.Grabbed.x, self.Grabbed.y)
		self:SetHoverAll()
		self.Open = not self.Open
	end
end

function TCombobox:Render(dt)
	if not self.Hidden then
		local x, y = self:x(), self:y()
		local Width, Height = self:Width(), self.Size.Height
		local Theme = self:GetTheme()
		local Font = self:GetFont()
		
		love.graphics.setScissor(x, y, Width, Height)
		love.graphics.setColor(unpack(Theme.Border))
		love.graphics.rectangle("line", x, y, Width, Height)
		
		love.graphics.setColor(unpack(Theme.Background))
		love.graphics.rectangle("fill", x + 1, y + 1, Width - 2, Height - 2)
		
		if self.Open then
			local BoxHeight = self.ItemCount * (Font:getHeight() + 5)
			love.graphics.setScissor(x, y + Height, Width, BoxHeight)
			
			love.graphics.setColor(unpack(Theme.Border))
			love.graphics.rectangle("line", x, y + Height, Width, BoxHeight)
			
			love.graphics.setColor(unpack(Theme.Background))
			love.graphics.rectangle("fill", x + 1, y + Height + 1, Width - 2, BoxHeight - 2)
		end
	end
end