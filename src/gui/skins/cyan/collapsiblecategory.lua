local CollapsibleCategory = {}

function CollapsibleCategory:UpdateLayout()
	local LastChild
	for Index, Child in pairs(self.Children) do
		if LastChild then
			Child.y = LastChild.y + LastChild:GetHeight() - 1
		else
			Child.y = 0
		end
		LastChild = Child
	end
	self.LastChild = LastChild
end

return CollapsibleCategory