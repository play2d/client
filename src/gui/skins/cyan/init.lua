local Path, gui = ...

return {
	CollapsibleCategory = love.filesystem.load(Path.."collapsiblecategory.lua")(Path, gui),
	CollapsibleNode = love.filesystem.load(Path.."collapsiblenode.lua")(Path, gui),
	Console = love.filesystem.load(Path.."console.lua")(Path, gui),
	ListBox = love.filesystem.load(Path.."listbox.lua")(Path, gui),
	Menu = love.filesystem.load(Path.."menu.lua")(Path, gui),
	MenuButton = love.filesystem.load(Path.."menubutton.lua")(Path, gui),
	MenuPanel = love.filesystem.load(Path.."menupanel.lua")(Path, gui),
	MenuSpacer = love.filesystem.load(Path.."menuspacer.lua")(Path, gui),
	ProgressBar = love.filesystem.load(Path.."progressbar.lua")(Path, gui),
	TextArea = love.filesystem.load(Path.."textarea.lua")(Path, gui),
	TreeView = love.filesystem.load(Path.."treeview.lua")(Path, gui),
	TreeViewNode = love.filesystem.load(Path.."treeviewnode.lua")(Path, gui),
	VSlider = love.filesystem.load(Path.."vslider.lua")(Path, gui),
}