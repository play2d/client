coro = {}
local CoroMetatable = {__index = coro}
local yield = coroutine.yield
local pcall = pcall
local unpack = unpack

function coro.create()
	local Coro = {}

	Coro.Coroutine = coroutine.create(coro.loop(Coro, yield, pcall, unpack))

	return setmetatable(Coro, CoroMetatable)
end

function coro.loop(Coro, yield, pcall, unpack)
	return function ()
		while true do
			if Coro.Exit then
				break
			else
				yield(pcall(Coro.Function, unpack(Coro.Arguments)))
			end
		end
	end
end

function coro:newfenv()
	local Env = {}
	
	Env._G = Env
	Env._VERSION = _VERSION
	Env.assert = assert
	Env.collectgarbage = collectgarbage
	Env.error = error
	Env.getfenv = getfenv
	Env.getmetatable = getmetatable
	Env.ipairs = ipairs
	Env.next = next
	Env.pairs = pairs
	Env.pcall = pcall
	Env.print = print
	Env.rawequal = rawequal
	Env.rawget = rawget
	Env.rawset = rawset
	Env.select = select
	Env.setmetatable = setmetatable
	Env.tonumber = tonumber
	Env.tostring = tostring
	Env.type = type
	Env.unpack = unpack
	Env.xpcall = xpcall
	
	function Env.require(mod)
		local PackageTable = package
		package = Env.package
		local Success, Error = pcall(require, mod)
		package = PackageTable
		if Success then
			Env[mod] = Error
			return Error
		end
		return Success, Error
	end
	
	function Env.dofile(Path)
		local Function = assert(loadfile(Path))
		setfenv(Function, Env)
		return Function()
	end
	
	function Env.getfenv(f)
		local Env = getfenv(f)
		if Env == _G then
			return nil
		end
		return Env
	end
	
	function Env.setfenv(f, e)
		local Env = getfenv(f)
		if Env == _G then
			return nil
		end
		return setfenv(f, e)
	end
	
	function Env.load(func, chunkname)
		local Load, Error = load(func, chunkname)
		if Load then
			setfenv(Load, Env)
			return Load
		end
		return Load, Error
	end
	
	function Env.loadfile(filename)
		local Load, Error = loadfile(filename)
		if Load then
			setfenv(Load, Env)
			return Load
		end
		return Load, Error
	end
	
	function Env.loadstring(str, chunkname)
		local Load, Error = loadstring(str, chunkname)
		if Load then
			setfenv(Load, Env)
			return Load
		end
		return Load, Error
	end
	
	Env.coroutine = {}
	Env.coroutine.create = coroutine.create
	Env.coroutine.resume = coroutine.resume
	Env.coroutine.status = coroutine.status
	Env.coroutine.wrap = coroutine.wrap
	
	function Env.coroutine.running()
		local Coroutine = coroutine.running()
		if Coroutine == State.Lua.Coroutine then
			return nil
		end
		return Coroutine
	end
	
	function Env.coroutine.yield(...)
		local Coroutine = coroutine.running()
		if Coroutine ~= State.Lua.Coroutine then
			return coroutine.yield(...)
		end
	end
	
	Env.debug = {}
	Env.debug.gethook = debug.gethook
	Env.debug.getinfo = debug.getinfo
	Env.debug.getlocal = debug.getlocal
	Env.debug.getmetatable = debug.getmetatable
	Env.debug.getregistry = debug.getregistry
	Env.debug.getupvalue = debug.getupvalue
	Env.debug.setfenv = debug.setfenv
	Env.debug.sethook = debug.sethook
	Env.debug.setlocal = debug.setlocal
	Env.debug.setmetatable = debug.setmetatable
	Env.debug.setupvalue = debug.setupvalue
	Env.debug.traceback = debug.traceback
	
	function Env.debug.getfenv(obj)
		local Env = debug.getfenv(obj)
		if Env == _G then
			return nil
		end
		return Env
	end
	
	Env.io = {}
	Env.io.close = io.close
	Env.io.flush = io.flush
	Env.io.input = io.input
	Env.io.lines = io.lines
	Env.io.open = io.open
	Env.io.output = io.output
	Env.io.popen = io.popen
	Env.io.read = io.read
	Env.io.stderr = io.stderr
	Env.io.stdin = io.stdin
	Env.io.stdout = io.stdout
	Env.io.tmpfile = io.tmpfile
	Env.io.type = io.type
	Env.io.write = io.write
	
	Env.math = {}
	Env.math.abs = math.abs
	Env.math.acos = math.acos
	Env.math.asin = math.asin
	Env.math.atan = math.atan
	Env.math.atan2 = math.atan2
	Env.math.ceil = math.ceil
	Env.math.cos = math.cos
	Env.math.cosh = math.cosh
	Env.math.deg = math.deg
	Env.math.exp = math.exp
	Env.math.floor = math.floor
	Env.math.fmod = math.fmod
	Env.math.frexp = math.frexp
	Env.math.huge = math.huge
	Env.math.ldexp = math.ldexp
	Env.math.log = math.log
	Env.math.log10 = math.log10
	Env.math.max = math.max
	Env.math.min = math.min
	Env.math.modf = math.modf
	Env.math.pi = math.pi
	Env.math.pow = math.pow
	Env.math.rad = math.rad
	Env.math.random = math.random
	Env.math.randomseed = math.randomseed
	Env.math.sin = math.sin
	Env.math.sinh = math.sinh
	Env.math.sqrt = math.sqrt
	Env.math.tan = math.tan
	Env.math.tanh = math.tanh
	
	Env.os = {}
	Env.os.clock = os.clock
	Env.os.date = os.date
	Env.os.difftime = os.difftime
	Env.os.execute = os.execute
	Env.os.exit = os.exit
	Env.os.getenv = os.getenv
	Env.os.remove = os.remove
	Env.os.rename = os.rename
	Env.os.setlocale = os.setlocale
	Env.os.time = os.time
	Env.os.tmpname = os.tmpname
	Env.os.name = jit.os
	
	Env.package = {}
	Env.package.cpath = Env.package.cpath
	Env.package.loaded = setmetatable({}, {__index = package.loaded})
	Env.package.loaders = setmetatable({}, {__index = package.loaders})
	Env.package.loadlib = Env.package.loadlib
	Env.package.path = Env.package.path
	Env.package.preload = setmetatable({}, {__index = package.preload})
	Env.package.seeall = Env.package.seall
	
	Env.string = {}
	Env.string.byte = string.byte
	Env.string.char = string.char
	Env.string.dump = string.dump
	Env.string.find = string.find
	Env.string.format = string.format
	Env.string.gmatch = string.gmatch
	Env.string.gsub = string.gsub
	Env.string.len = string.len
	Env.string.lower = string.lower
	Env.string.match = string.match
	Env.string.rep = string.rep
	Env.string.reverse = string.reverse
	Env.string.sub = string.sub
	Env.string.upper = string.upper
	
	local StringMetatable = getmetatable("")
	setmetatable(StringMetatable.__index, {__index = Env.string})
	
	Env.table = {}
	Env.table.concat = table.concat
	Env.table.insert = table.insert
	Env.table.maxn = table.maxn
	Env.table.remove = table.remove
	Env.table.sort = table.sort
	
	Env.json = {}
	Env.json.encode = json.encode
	Env.json.decode = json.decode
	
	self:setfenv(Env)
	
	return Env
end

function coro:setfenv(env)
	return debug.setfenv(self.Coroutine, env)
end

function coro:dostring(str, ...)
	if type(str) == "string" then
		local Function, Error = loadstring(str)
		if not Function then
			return false, Error
		end
		self.Function = Function; setfenv(Function, debug.getfenv(self.Coroutine))
		self.Arguments = {...}

		local Results = {coroutine.resume(self.Coroutine)}
		self.Function = nil
		self.Arguments = nil
		
		if not Results[1] then
			return false, Results[2]
		end
		
		local Return = {}
		for Key, Value in next, Results, 2 do
			table.insert(Return, Value)
		end
		return true, unpack(Return)
	end
	return false, "input a lua string"
end

function coro:dofile(path, ...)
	if type(path) == "string" then
		local Function, Error = loadfile(path)
		if not Function then
			return false, Error
		end
		self.Function = Function; setfenv(Function, debug.getfenv(self.Coroutine))
		self.Arguments = {...}

		local Results = {coroutine.resume(self.Coroutine)}
		self.Function = nil
		self.Arguments = nil
		
		if not Results[1] then
			return false, Results[2]
		end
		
		local Return = {}
		for Key, Value in next, Results, 2 do
			table.insert(Return, Value)
		end
		return true, unpack(Return)
	end
	return false, "input a valid path"
end

function coro:pcall(f, ...)
	if type(f) == "function" then
		self.Function = f
		self.Arguments = {...}
		
		local Results = {coroutine.resume(self.Coroutine)}
		self.Function = nil
		self.Arguments = nil
		
		if not self.Results[1] then
			return false, Results[2]
		end
		
		local Return = {}
		for Key, Value in next, Results, 2 do
			table.insert(Return, Value)
		end
		
		return true, unpack(Return)
	end
	return false, "input a valid function"
end

function coro:status()
	return coroutine.status(self.Coroutine)
end

function coro:close()
	self.Exit = true
	coroutine.resume(self.Coroutine)
end