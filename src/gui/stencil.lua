local Path, gui = ...

local StencilFunction
local StencilFunctionOverride

function StencilFunctionOverride()
	
	if StencilFunction then
		
		StencilFunction(gui.Current)
		
	end
	
end

function gui.stencil(Function, ...)
	
	StencilFunction = Function
	love.graphics.stencil(StencilFunctionOverride, ...)
	
end