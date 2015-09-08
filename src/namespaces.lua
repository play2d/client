Namespace = {}
Namespace.Metatable = {}

local function _getfenv(Function)
	local Success, Environment = pcall(getfenv, Function)
	if Success then
		if Environment == _G then
			return nil
		end
		return Environment
	end
	return Success, Environment
end

local function _setfenv(Function, Environment)
	if type(Environment) == "table" then
		if Environment == _G then
			return nil
		end
		return pcall(setfenv, Function, Environment)
	end
end

local function debug_getfenv(Object)
	local Success, Environment = pcall(debug.getfenv, Object)
	if Success then
		if Environment == _G then
			return nil
		end
		return Environment
	end
	return Success, Environment
end

local function debug_setfenv(Object, Environment)
	if type(Environment) == "table" then
		if Environment == _G then
			return nil
		end
		return pcall(debug.setfenv, Object, Environment)
	end
end

Namespace.Commands = {
	-- Very unprotected stuff
	Binds = Binds,
	Console = Console,
	Hook = Hook,
	Interface = Interface,
	game = game,
	CFG = Config.CFG,
	
	Lang = Lang,
	table = table,
	math = math,
	string = string,
	io = io,
	love = love,
	debug = {
		getfenv = debug_getfenv,
		setfenv = debug_setfenv,
	},
	
	_VERSION = _VERSION,
	assert = assert,
	collectgarbage = collectgarbage,
	--dofile = dofile,
	error = error,
	getfenv = _getfenv,
	getmetatable = getmetatable,
	ipairs = ipairs,
	--load = load,
	--loadfile = loadfile,
	--loadstring = loadstring,
	--module = module,
	next = next,
	pairs = pairs,
	pcall = pcall,
	print = print,
	rawequal = rawequal,
	rawget = rawget,
	rawset = rawset,
	--require = require,
	--select = select,
	setfenv = _setfenv,
	setmetatable = setmetatable,
	tonumber = tonumber,
	tostring = tostring,
	type = type,
	unpack = unpack,
	xpcall = xpcall,
	CLIENT = true,
}
Namespace.Commands._G = Commands

function Namespace.CreateEnvironment()
	return {
		table = table,
		math = math,
		string = string,
		io = io,
		love = love,
		debug = {
			getfenv = debug_getfenv,
			setfenv = debug_setfenv,
		},
		getfenv = _getfenv,
		setfenv = _setfenv,
	}
end