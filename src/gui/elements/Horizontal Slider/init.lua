local Path, gui = ...

assert(love.filesystem.load(Path.."Slider.lua"))(gui)
assert(love.filesystem.load(Path.."Thumb.lua"))(gui)