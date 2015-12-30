local State = Core.LuaState
local LuaState = Core.LuaState

LuaState.Function = {}
LuaState.ClassMT = {}

local Path = ...

require(Path..".convar")
require(Path..".convars")
require(Path..".core")
require(Path..".entities")
require(Path..".entity")
require(Path..".hooks")