gui.TGadget = {}
gui.TGadgetMetatable = {__index = gui.TGadget}
gui.TGadget.Type = "TGadget"
gui.TGadget.BaseClass = gui.TGadget

-- This functions here are intended for callbacks

-- Description: Called when this gadget needs to be updated
function gui.TGadget:Update(dt)
	if not self.Disabled then
		self:UpdateGadgets(dt)
	end
end

-- Description: Called when this gadget needs to be rendered
function gui.TGadget:Render(dt)
	if not self.Hidden then
		self:RenderGadgets(dt)
	end
end

-- Description: Called when the mouse starts grabbing this gadget
function gui.TGadget:OnClick(x, y)
end

-- Description: Called when the mouse right clicks this gadget
function gui.TGadget:OnRightClick(x, y)
end

-- Description: Called when the mouse stops grabbing this gadget
function gui.TGadget:OnDrop(x, y)
end

-- Description: Called when the user writes a text on this gadget
function gui.TGadget:Write(Text)
end

-- Description: Called when the user tries to copy a test from this gadget
function gui.TGadget:Copy()
end

-- Description: Called when this gadget is grabbed and the mouse is moved
function gui.TGadget:MouseMove(x, y, dx, dy)
end

-- Description: Called when this gadget has the mouse hovering it, and the mouse is moved
function gui.TGadget:MouseMoveInside(x, y, dx, dy)
end

-- Description: Called when the mouse wheel is moved up
function gui.TGadget:WheelUp()
end

-- Description: Called when the mouse wheel is moved down
function gui.TGadget:WheelDown()
end

-- Description: Called when the mouse enters this gadget's area
function gui.TGadget:MouseEnter()
end

-- Description: Called when the mouse exits this gadget's area
function gui.TGadget:MouseExit()
end

-- Description: Called when a key is pressed
function gui.TGadget:keypressed(key)
end

--[[ This functions here are the base functions ]]

-- Returns: [Gadget] A new object
function gui.TGadget.New()
	return setmetatable({}, gui.TGadgetMetatable)
end

-- Description: Initializes the object
function gui.TGadget:Init()
	--self.Gadgets = {} -- Child gadgets
	--self.GadgetsOrder = {} -- Rendering order
	--self.Items = {} -- Gadget items
	--self.Offset = {x = 0, y = 0}
	--self.Size = {Width = 0, Height = 0}
	--self.Hidden = false
	--self.Disabled = false
	--self.Text = ""
	--self.Hint = ""
	--self.Context = ""
	return self
end

-- Description: Removes the object
function gui.TGadget:Remove()
	if self.Parent then
		self.Parent:RemoveGadget(self)
	end
end

-- Description: Changes the size of the object
function gui.TGadget:SetDimensions(Width, Height)
	self.Size = {Width = Width, Height = Height}
end

-- Description: Changes the position of the object according to it's parent
function gui.TGadget:SetPosition(x, y)
	self.Offset = {x = x, y = y}
end

-- Returns: [Number] The width of this gadget
function gui.TGadget:GetWidth()
	return self.Size.Width
end

-- Returns: [Number] The height of this gadget
function gui.TGadget:GetHeight()
	return self.Size.Height
end

-- Returns: [Number] The width of this gadget, [Number] The height of this gadget
function gui.TGadget:GetDimensions()
	return self:GetWidth(), self:GetHeight()
end

-- Returns: [Number] The X coordinate of this gadget, [Number] The Y coordinate of this gadget
function gui.TGadget:GetPosition()
	return self:x(), self:y()
end

-- Returns: [Number] The X coordinate of this gadget
function gui.TGadget:x()
	if self.Parent then
		return self.Parent:x() + self.Offset.x
	end
	return self.Offset.x
end

-- Returns: [Number] The Y coordinate of this gadget
function gui.TGadget:y()
	if self.Parent then
		return self.Parent:y() + self.Offset.y
	end
	return self.Offset.y
end

-- Returns: [true/false] If a gadget managed to be parented
function gui.TGadget:AddGadget(Gadget)
	if self.Gadgets then
		self:RemoveGadget(Gadget)
		Gadget.ID = #self.Gadgets + 1
		Gadget.Parent = self
		Gadget.Theme = self.Theme
		self.Gadgets[Gadget.ID] = Gadget
		if self.GadgetsOrder then
			table.insert(self.GadgetsOrder, Gadget)
		end
		return true
	end
	return false
end

-- Returns: [true/false] If a gadget managed to be parented forcefully
function gui.TGadget:ForceAddGadget(Gadget)
	if self:AddGadget(Gadget) then
		return true
	end
	if not self.Gadgets then
		self.Gadgets = {}
	end
	if not self.GadgetsOrder then
		self.GadgetsOrder = {}
	end
	return self:AddGadget(Gadget)
end

-- Description: Removes a child gadget
function gui.TGadget:RemoveGadget(Gadget)
	if Gadget.Parent == self then
		if self.Gadgets then
			if Gadget.ID then
				self.Gadgets[Gadget.ID] = nil
			else
				for ID, ChildGadget in pairs(self.Gadgets) do
					if ChildGadget == Gadget then
						self.Gadgets[ID] = nil
					end
				end
			end
		end
		if self.GadgetsOrder then
			for ID, ChildGadget in pairs(self.GadgetsOrder) do
				if ChildGadget == Gadget then
					self.GadgetsOrder[ID] = nil
					break
				end
			end
		end
		Gadget.Parent = nil
		Gadget.ID = nil
	end
end

-- Description: Removes all children gadgets
function gui.TGadget:ClearGadgets()
	if self.Gadgets then
		self.Gadgets = {}
	end
	if self.GadgetsOrder then
		self.GadgetsOrder = {}
	end
end

-- Description: Adds a item (Usually text)
function gui.TGadget:AddItem(Item, ...)
	if self.Items then
		self:SetItem(#self.Items + 1, Item, ...)
	end
end

-- Description: Sets a item (Usually text)
function gui.TGadget:SetItem(Index, Item, ...)
	if self.Items then
		self.Items[Index] = Item
	end
end

-- Returns: The gadget item at this index
function gui.TGadget:GetItem(Index)
	if self.Items then
		return self.Items[Index]
	end
end

-- Description: Removes a item
function gui.TGadget:RemoveItem(Index)
	if self.Items then
		self.Items[Index] = nil
	end
end

-- Description: Clears all items
function gui.TGadget:ClearItems()
	if self.Items then
		self.Items = {}
	end
end

-- Description: Renders children gadgets
function gui.TGadget:RenderGadgets(dt)
	if not self.Hidden then
		if self.GadgetsOrder then
			for _, Gadget in pairs(self.GadgetsOrder) do
				Gadget:Render(dt)
			end
		end
	end
end

-- Description: Updates children gadgets
function gui.TGadget:UpdateGadgets(dt)
	if not self.Disabled then
		if self.Gadgets then
			for _, Gadget in pairs(self.Gadgets) do
				Gadget:Update(dt)
			end
		end
	end
end

-- Returns: [true/false] If a vector is inside the area of this gadget
function gui.TGadget:Hover(x, y)
	if not self.Hidden then
		return x >= self:x() and y >= self:y() and x <= self:x() + self:GetWidth() and y <= self:y() + self:GetHeight()
	end
end

-- Description: Do not use
function gui.TGadget:MouseClicked(x, y)
	if not self.Disabled and not self.Hidden then
		self.Dropped = nil
		self.Grabbed = {x = x - self:x(), y = y - self:y()}
		self:Focus()
		self:OnClick(self.Grabbed.x, self.Grabbed.y)
		if self.Context then
			self.Context.Hidden = true
		end
		return true
	end
end

-- Description: Do not use
function gui.TGadget:MouseRightClicked(x, y)
	if not self.Disabled and not self.Hidden then
		local Position = {x = x - self:x(), y = y - self:y()}
		if self.Context then
			self.Context.Hidden = nil
			self.Context:Focus()
			self.Context:SetPosition(Position.x, Position.y)
		end
		self:OnRightClick(Position.x, Position.y)
		return true
	end
end

-- Description: Do not use
function gui.TGadget:MouseDropped(x, y)
	if self.Grabbed then
		self.Grabbed = nil
		self.Dropped = {x = x - self:x(), y = y - self:y()}
		self:OnDrop(self.Dropped.x, self.Dropped.y)
	end
end

-- Returns: [true/false] If the mouse is hovering the area of this gadget
function gui.TGadget:MouseHover()
	if not self.Hidden then
		local MouseX, MouseY = love.mouse.getPosition()
		local x, y = self:GetPosition()
		return MouseX >= x and MouseY >= y and MouseX <= x + self:GetWidth() and MouseY <= y + self:GetHeight()
	end
end

-- Returns [true/false] If the mouse is hovering certain area of this gadget
function gui.TGadget:MouseHoverArea(OffsetX, OffsetY, Width, Height)
	if not self.Hidden then
		local MouseX, MouseY = love.mouse.getPosition()
		local x, y = self:GetPosition()
		return MouseX >= x + OffsetX and MouseY >= y + OffsetY and MouseX <= x + OffsetX + Width and MouseY <= y + OffsetY + Height
	end
end

-- Returns: [Number] The amount of time that the mouse hasn't been moving
function gui.TGadget:MouseIdle()
	if self.Parent then
		return self.Parent:MouseIdle()
	end
end

-- Returns: [Number] The amount of time since the mouse entered the area of any gadget
function gui.TGadget:MouseHoverIdle()
	if self.Parent then
		return self.Parent:MouseHoverIdle()
	end
end

-- Returns: [Gadget] The first gadget that has it's mouse hovered
function gui.TGadget:HoverGadget()
	if not self.Hidden then
		if self.GadgetsOrder then
			local HoverGadget
			for _, Gadget in pairs(self.GadgetsOrder) do
				local HoverChild = Gadget:HoverGadget()
				if HoverChild then
					HoverGadget = HoverChild
				end
			end
			if HoverGadget then
				return HoverGadget
			end
		end
		if self:MouseHover() then
			return self
		end
	end
end

-- Description: Sets this gadget on top of the rest of the parent's children gadgets
function gui.TGadget:SetHover()
	if not self.Hidden then
		if self.Parent and self.Parent.GadgetsOrder then
			local GadgetsOrder = {}
			for _, Gadget in pairs(self.Parent.GadgetsOrder) do
				if Gadget ~= self then
					table.insert(GadgetsOrder, Gadget)
				end
			end
			table.insert(GadgetsOrder, self)
			self.Parent.GadgetsOrder = GadgetsOrder
		end
	end
end

-- Description: Sets this gadget on top of every gadget
function gui.TGadget:Focus()
	if not self.Hidden then
		if self.Parent then
			if self.Parent.GadgetsOrder then
				local GadgetsOrder = {}
				for _, Gadget in pairs(self.Parent.GadgetsOrder) do
					if Gadget ~= self then
						table.insert(GadgetsOrder, Gadget)
					end
				end
				table.insert(GadgetsOrder, self)
				self.Parent.GadgetsOrder = GadgetsOrder
			end
			if self.Parent.Context then
				if self.Parent.Context ~= self then
					self.Parent.Context.Hidden = true
				end
			end
			self.Parent:Focus()
		end
	end
end

-- Returns: [Gadget] The gadget that currently has the mouse hovering it
function gui.TGadget:GetHoverAll()
	if not self.Hidden then
		if self.Parent then
			return self.Parent:GetHoverAll()
		end
	end
end

-- Returns: [true/false] Checks if it's the first of all gadgets that is being rendered, it does not count children gadgets
function gui.TGadget:IsFirst()
	return self:GetFirstAll() == self
end

-- Returns: [true/false] Checks if it's the gadget that has the mouse in
function gui.TGadget:IsHovered()
	return self:GetHoverAll() == self
end

-- Returns: [Gadget] The parent's gadget that goes after this one [Intended to switch gadgets with tab]
function gui.TGadget:NextGadget()
	if self.Parent then
		local NextID = next(self.Parent.Gadgets, self.ID) or next(self.Parent.Gadgets)
		local NextGadget = self.Parent.Gadgets[NextGadget]
		if NextGadget then
			if NextGadget.Hidden then
				return NextGadget:NextGadget()
			end
			return NextGadget
		end
	end
end

-- Returns: [Gadget] The first child gadget of every first child gadget
function gui.TGadget:FirstGadget()
	if self.GadgetsOrder then
		local FirstGadget
		for _, Gadget in pairs(self.GadgetsOrder) do
			local First = Gadget:FirstGadget()
			if First then
				FirstGadget = First
			end
		end
		if FirstGadget then
			return FirstGadget
		end
	end
	if not self.Hidden then
		return self
	end
end

-- Returns: [Gadget] The first of all gadgets
function gui.TGadget:GetFirstAll()
	if self.Parent then
		return self.Parent:GetFirstAll()
	end
end

-- Description: Sets the text of a gadget
function gui.TGadget:SetText(Text, ...)
	self.Text = Text
end

-- Returns: [String] The text of a gadget
function gui.TGadget:GetText()
	return self.Text
end

-- Description: Sets the hint of a gadget
function gui.TGadget:SetHint(Text)
	self.Hint = Text
end

-- Returns: [String] The hint of a gadget
function gui.TGadget:GetHint()
	return self.Hint
end

-- Description: Sets the font of a gadget
function gui.TGadget:SetFont(Font)
	self.Font = Font
end

-- Returns: [Font] The font of a gadget
function gui.TGadget:GetFont()
	if self.Font then
		return self.Font
	elseif self.Theme[self.Type] then
		return self.Theme[self.Type].Font
	end
end

-- Description: Hides a gadget
function gui.TGadget:Hide()
	self.Hidden = true
end

-- Description: Shows a gadget
function gui.TGadget:Show()
	self.Hidden = nil
end

-- Description: Sets the gadget's cursor
function gui.TGadget:SetCursor(Cursor)
	self.Cursor = Cursor
end

-- Returns: The gadget's cursor
function gui.TGadget:GetCursor()
	if self.Cursor then
		return self.Cursor
	end
	local Theme = self:GetTheme()
	if Theme then
		return Theme.Cursor
	end
end

-- Description: Modifies the gadget's color theme
function gui.TGadget:SetColor(What, R, G, B, A)
	if not self.CustomTheme then
		self.CustomTheme = {}
		for k, v in pairs(self.Theme[self.Type]) do
			self.CustomTheme[k] = v
		end
	end
	self.CustomTheme[What] = {R, G, B, A}
end

-- Returns: The gadget's theme object
function gui.TGadget:GetTheme()
	if self.CustomTheme then
		return self.CustomTheme
	end
	return self.Theme[self.Type]
end
