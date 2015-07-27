local TRadioButton = {}
local TRadioButtonMetatable = {__index = TRadioButton}
TRadioButton.Type = "RadioButton"
setmetatable(TRadioButton, gui.TGadgetMetatable)

function gui.CreateRadioButton(Text, x, y, Width, Height, Parent)
	local RadioButton = TRadioButton.New()
	if Parent:AddGadget(RadioButton) then
		RadioButton:SetText(Text)
		RadioButton:SetPosition(x, y)
		RadioButton:SetDimensions(Width, Height)
		return RadioButton:Init()
	end
end

function TRadioButton.New()
	return setmetatable({}, TRadioButtonMetatable)
end

function TRadioButton:Init()
	if not self.Parent.RadioButton then
		self.Parent.RadioButton = self
	end
	return self
end

function TRadioButton:MouseClicked(x, y)
	if self.BaseClass.MouseClicked(self, x, y) then
		self.Parent.RadioButton = self
		return true
	end
end