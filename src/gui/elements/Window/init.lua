local Path, gui = ...

assert(love.filesystem.load(Path.."Window.lua"))(gui)
assert(love.filesystem.load(Path.."CloseButton.lua"))(gui)