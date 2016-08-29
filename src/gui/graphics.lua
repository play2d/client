local Path, gui = ...
gui.graphics = {}

function gui.graphics.roundedbox(mode, Radius, x, y, Width, Height, Segments)
	Segments = Segments or Radius
	
	if mode == "line" then
		love.graphics.arc("line", "open", x + Radius, y + Radius, Radius, -math.pi, -math.pi/2, Segments)
		love.graphics.arc("line", "open", x + Width - Radius, y + Radius, Radius, -math.pi/2, 0, Segments)
		love.graphics.arc("line", "open", x + Width - Radius, y + Height - Radius, Radius, 0, math.pi/2, Segments)
		love.graphics.arc("line", "open", x + Radius, y + Height - Radius, Radius, math.pi/2, math.pi, Segments)
		love.graphics.line(x + Radius, y, x + Width - Radius, y)
		love.graphics.line(x + Width, y + Radius, x + Width, y + Height - Radius)
		love.graphics.line(x + Radius, y + Height, x + Width - Radius, y + Height)
		love.graphics.line(x, y + Radius, x, y + Height - Radius)
	elseif mode == "fill" then
		love.graphics.arc("fill", x + Radius, y + Radius, Radius, -math.pi, -math.pi/2, Segments)
		love.graphics.arc("fill", x + Width - Radius, y + Radius, Radius, -math.pi/2, 0, Segments)
		love.graphics.arc("fill", x + Width - Radius, y + Height - Radius, Radius, 0, math.pi/2, Segments)
		love.graphics.arc("fill", x + Radius, y + Height - Radius, Radius, math.pi/2, math.pi, Segments)
		love.graphics.rectangle("fill", x + Radius, y, Width - Radius * 2, Radius)
		love.graphics.rectangle("fill", x + Width - Radius, y + Radius, Radius, Height - Radius * 2)
		love.graphics.rectangle("fill", x + Radius, y + Height - Radius, Width - Radius * 2, Radius)
		love.graphics.rectangle("fill", x, y + Radius, Radius, Height - Radius * 2)
		love.graphics.rectangle("fill", x + Radius, y + Radius, Width - Radius * 2, Height - Radius * 2)
	end
end