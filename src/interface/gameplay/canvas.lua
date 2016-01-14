local State = Core.State

Interface.Gameplay = {}

function Interface.Gameplay.Initialize()
	Interface.Gameplay.Canvas = gui.CreateCanvas(0, 0, Interface.Desktop:GetWidth(), Interface.Desktop:GetHeight(), Interface.Desktop)
	Interface.Gameplay.Canvas:Hide()
	
	function Interface.Gameplay.Canvas:Draw(x, y, Width, Height, dt)
		State.Render(dt, x, y, Width, Height)
	end
end