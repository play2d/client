local TDesktop = {}
local TDesktopMetatable = {__index = TDesktop}
TDesktop.Type = "Desktop"
setmetatable(TDesktop, gui.TGadgetMetatable)

-- Description: Creates a new desktop gadget
function gui.CreateDesktop(ThemePath)
	return TDesktop.New():Init(ThemePath)
end

function TDesktop.New()
	return setmetatable({}, TDesktopMetatable)
end

function TDesktop:Init(ThemePath)
	self.Gadgets = {}
	self.GadgetsOrder = {}
	self.Offset = {x = 0, y = 0}
	self.Size = {Width = love.graphics.getWidth(), Height = love.graphics.getHeight()}
	self.LastMouseMovement = love.timer.getTime()
	self.FirstHoverMouseMovement = love.timer.getTime()
	self.Theme = {love = love}

	if Hook then
		Hook.Add("draw", function(dt) self:Render(dt * 1000) end)
		Hook.Add("update", function(dt) self:Update(dt * 1000) end)
		Hook.Add("mousepressed", function(x, y, button) self:mousepressed(x, y, button) end)
		Hook.Add("mousereleased", function(x, y, button) self:mousereleased(x, y, button) end)
		Hook.Add("mousemoved", function(x, y, dx, dy) self:mousemoved(x, y, dx, dy) end)
		Hook.Add("keypressed", function(key, unicode) self:keypressed(key) end)
		Hook.Add("textinput", function(text) self:textinput(text) end)
	end

	local f = assert(loadfile(ThemePath))
	setfenv(f, self.Theme)
	f()
	return self
end

function TDesktop:Update(dt)
	if not self.Disabled then
		self:UpdateGadgets(dt)
		self.LastHover = self.CurrentHover
		self.CurrentHover = self:HoverGadget()
		self.CurrentFirst = self:FirstGadget()
		if self.CurrentHover ~= self.LastHover then
			self.FirstHoverMouseMovement = love.timer.getTime()
			if self.LastHover then
				self.LastHover:MouseExit()
			end
			if self.CurrentHover then
				self.CurrentHover:MouseEnter()
			end
		end
		self:UpdateGadgets(dt)
	end
end

function TDesktop:Render(dt)
	if not self.Hidden then
		self:RenderGadgets(dt)
		if self.CurrentHover then
			local Cursor = self.CurrentHover:GetCursor() or self:GetCursor()
			love.mouse.setCursor(Cursor)
			love.graphics.setScissor(self:x(), self:y(), self:GetDimensions())
			if self:MouseHoverIdle() > 0.5 then
				if self.CurrentHover.Hint then
					local Font = self:GetFont()
					love.graphics.setFont(Font)
					local FontHeight = Font:getHeight()
					local Width, Height = 0, 0
					local Lines = {}
					for Line in string.gmatch(self.CurrentHover.Hint, "([^\n]+)") do
						table.insert(Lines, Line)
						local LineWidth = Font:getWidth(Line)
						if LineWidth > Width then
							Width = LineWidth
						end
						Height = Height + FontHeight + 2.5
					end
					local MouseX, MouseY = love.mouse.getX(), love.mouse.getY()
					love.graphics.setColor(unpack(self.Theme.Hint.Background))
					love.graphics.rectangle("fill", MouseX, MouseY, Width + 10, Height + 6)
					love.graphics.setColor(unpack(self.Theme.Hint.Border))
					love.graphics.rectangle("line", MouseX, MouseY, Width + 10, Height + 6)
					love.graphics.setColor(unpack(self.Theme.Hint.Text))
					for i, Line in pairs(Lines) do
						love.graphics.print(Line, MouseX + 5, MouseY + FontHeight * (i - 1) + 2.5 * i)
					end
				end
			end
		end
	end
end

function TDesktop:GetHoverAll()
	return self.CurrentHover
end

function TDesktop:GetFirstAll()
	return self.CurrentFirst
end

function TDesktop:MouseClicked(x, y)
	if self:Hover(x, y) then
		self:OnClick(x, y)
		if self.CurrentHover and self.CurrentHover ~= self then
			self.CurrentHover:MouseClicked(x, y)
			self.CurrentGrabbed = self.CurrentHover
		else
			self.CurrentGrabbed = nil
			if self.Context then
				self.Context.Hidden = true
			end
		end
	end
end

function TDesktop:MouseRightClicked(x, y)
	if self:Hover(x, y) then
		self:OnClick(x, y)
		if self.CurrentHover and self.CurrentHover ~= self then
			self.CurrentHover:MouseRightClicked(x, y)
		end
	end
end 

function TDesktop:MouseDropped(x, y)
	if self:Hover(x, y) then
		if self.CurrentGrabbed then
			self.CurrentGrabbed:MouseDropped(x, y)
			self.CurrentGrabbed = nil
		end
	end
end

function TDesktop:Write(Text)
	local Gadget = self.CurrentFirst
	if Gadget and Gadget ~= self then
		Gadget:Write(Text)
	end
end

function TDesktop:Copy()
	local Gadget = self.CurrentFirst
	if Gadget and Gadget ~= self then
		return Gadget:Copy()
	end
end

function TDesktop:MouseIdle()
	return love.timer.getTime() - self.LastMouseMovement
end

function TDesktop:MouseHoverIdle()
	return love.timer.getTime() - self.FirstHoverMouseMovement
end

function TDesktop:mousepressed(x, y, Button)
	if Button == "l" then
		self:MouseClicked(x, y)
	elseif Button == "r" then
		self:MouseRightClicked(x, y)
	elseif Button == "wu" then
		self:WheelUp()
	elseif Button == "wd" then
		self:WheelDown()
	end
end

function TDesktop:mousereleased(x, y, Button)
	if Button == "l" then
		self:MouseDropped(x, y)
	end
end

function TDesktop:mousemoved(x, y, dx, dy)
	if self.CurrentGrabbed then
		self.CurrentGrabbed:MouseMove(x, y, dx, dy)
	end
	self.LastMouseMovement = love.timer.getTime()
end

function TDesktop:keypressed(key)
	if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then
		if key == "v" then
			local Text = love.system.getClipboardText()
			if #Text > 0 then
				self:textinput(Text)
			end
		elseif key == "c" then
			local Text = self:Copy()
			if Text and #Text > 0 then
				love.system.setClipboardText(Text)
			end
		end
	else
		local Gadget = self.CurrentFirst
		if Gadget then
			Gadget:keypressed(key)
		end
	end
end

function TDesktop:textinput(text)
	game.Desktop:Write(text)
end
