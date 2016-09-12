local Path, gui = ...

local StencilFunction
local StencilFunctionOverride

function StencilFunctionOverride()
	
	StencilFunction(gui.Current)
	
end

function gui.stencil(Function, ...)
	
	StencilFunction = Function
	love.graphics.stencil(StencilFunctionOverride, ...)
	
end