local LuaLib = ffi.load("lua51")

ffi.cdef [[
	enum {
	/* option for multiple returns in `lua_pcall' and `lua_call' */
		LUA_MULTRET = (-1),
	/* pseudo-indices */
		LUA_REGISTRYINDEX = (-10000),
		LUA_ENVIRONINDEX = (-10001),
		LUA_GLOBALSINDEX = (-10002),
	/* thread status; 0 is OK */
		LUA_YIELD = 1,
		LUA_ERRRUN = 2,
		LUA_ERRSYNTAX = 3,
		LUA_ERRMEM = 4,
		LUA_ERRERR = 5,
	/* basic types */
		LUA_TNONE = (-1),
		LUA_TNIL = 0,
		LUA_TBOOLEAN = 1,
		LUA_TLIGHTUSERDATA = 2,
		LUA_TNUMBER = 3,
		LUA_TSTRING = 4,
		LUA_TTABLE = 5,
		LUA_TFUNCTION = 6,
		LUA_TUSERDATA = 7,
		LUA_TTHREAD = 8,
	/* minimum Lua stack available to a C function */
		LUA_MINSTACK = 20,
	/* garbage collection options */
		LUA_GCSTOP = 0,
		LUA_GCRESTART = 1,
		LUA_GCCOLLECT = 2,
		LUA_GCCOUNT = 3,
		LUA_GCCOUNTB = 4,
		LUA_GCSTEP = 5,
		LUA_GCSETPAUSE = 6,
		LUA_GCSETSTEPMUL = 7,
	/* Event codes */
		LUA_HOOKCALL = 0,
		LUA_HOOKRET = 1,
		LUA_HOOKLINE = 2,
		LUA_HOOKCOUNT = 3,
		LUA_HOOKTAILRET = 4,
	/* Event masks */
		LUA_MASKCALL = (1 << LUA_HOOKCALL),
		LUA_MASKRET = (1 << LUA_HOOKRET),
		LUA_MASKLINE = (1 << LUA_HOOKLINE),
		LUA_MASKCOUNT = (1 << LUA_HOOKCOUNT),
	};
	
	/* type of numbers in Lua */
	typedef double lua_Number;

	/* type for integer functions */
	typedef ptrdiff_t lua_Integer;
	
	typedef union GCObject GCObject;
	
	typedef union {
		GCObject * gc;
		void * p;
		lua_Number n;
		int b;
	} Value;
	
	typedef struct lua_TValue {
		Value value;
		int tt;
	} TValue;
	
	typedef struct Table {
		struct Table *metatable;
		TValue *array;  /* array part */
		GCObject *gclist;
		int sizearray;  /* size of `array' array */
	} Table;
	
	typedef struct global_State {
		void * ud;         /* auxiliary data to `frealloc' */
		struct lua_State * mainthread;
	} global_State;

	typedef struct lua_State {
		struct global_State * l_G;
		TValue * l_gt;
		TValue * env;
		GCObject * openupval;  /* list of open upvalues in this stack */
		GCObject * gclist;
	} lua_State;
	
	typedef int (*lua_CFunction) (lua_State *L);

	/* functions that read/write blocks when loading/dumping Lua chunks */
	typedef const char * (*lua_Reader) (lua_State *L, void *ud, size_t *sz);
	typedef int (*lua_Writer) (lua_State *L, const void* p, size_t sz, void* ud);

	/* prototype for memory-allocation functions */
	typedef void * (*lua_Alloc) (void *ud, void *ptr, size_t osize, size_t nsize);

	/* state manipulation */

	lua_State *(lua_newstate) (lua_Alloc f, void *ud);
	void       (lua_close) (lua_State *L);
	lua_State *(lua_newthread) (lua_State *L);
	lua_CFunction (lua_atpanic) (lua_State *L, lua_CFunction panicf);

	/* basic stack manipulation */

	int   (lua_gettop) (lua_State *L);
	void  (lua_settop) (lua_State *L, int idx);
	void  (lua_pushvalue) (lua_State *L, int idx);
	void  (lua_remove) (lua_State *L, int idx);
	void  (lua_insert) (lua_State *L, int idx);
	void  (lua_replace) (lua_State *L, int idx);
	int   (lua_checkstack) (lua_State *L, int sz);
	void  (lua_xmove) (lua_State *from, lua_State *to, int n);

	/* access functions (stack -> C) */

	int             (lua_iscfunction) (lua_State *L, int idx);
	int             (lua_isuserdata) (lua_State *L, int idx);
	int             (lua_type) (lua_State *L, int idx);
	const char     *(lua_typename) (lua_State *L, int tp);

	int            (lua_equal) (lua_State *L, int idx1, int idx2);
	int            (lua_rawequal) (lua_State *L, int idx1, int idx2);
	int            (lua_lessthan) (lua_State *L, int idx1, int idx2);

	lua_Number      (lua_tonumber) (lua_State *L, int idx);
	lua_Integer     (lua_tointeger) (lua_State *L, int idx);
	int             (lua_toboolean) (lua_State *L, int idx);
	const char     *(lua_tolstring) (lua_State *L, int idx, size_t *len);
	size_t          (lua_objlen) (lua_State *L, int idx);
	lua_CFunction   (lua_tocfunction) (lua_State *L, int idx);
	void	         *(lua_touserdata) (lua_State *L, int idx);
	lua_State      *(lua_tothread) (lua_State *L, int idx);
	const void     *(lua_topointer) (lua_State *L, int idx);

	/* push functions (C -> stack) */

	void  (lua_pushnil) (lua_State *L);
	void  (lua_pushnumber) (lua_State *L, lua_Number n);
	void  (lua_pushinteger) (lua_State *L, lua_Integer n);
	void  (lua_pushlstring) (lua_State *L, const char *s, size_t l);
	void  (lua_pushstring) (lua_State *L, const char *s);
	const char *(lua_pushvfstring) (lua_State *L, const char *fmt,
																			va_list argp);
	const char *(lua_pushfstring) (lua_State *L, const char *fmt, ...);
	void  (lua_pushcclosure) (lua_State *L, lua_CFunction fn, int n);
	void  (lua_pop) (lua_State *L, int n);
	void  (lua_pushboolean) (lua_State *L, int b);
	void  (lua_pushlightuserdata) (lua_State *L, void *p);
	int   (lua_pushthread) (lua_State *L);

	/* get functions (Lua -> stack) */

	void  (lua_gettable) (lua_State *L, int idx);
	void  (lua_getfield) (lua_State *L, int idx, const char *k);
	void  (lua_rawget) (lua_State *L, int idx);
	void  (lua_rawgeti) (lua_State *L, int idx, int n);
	void  (lua_createtable) (lua_State *L, int narr, int nrec);
	void *(lua_newuserdata) (lua_State *L, size_t sz);
	int   (lua_getmetatable) (lua_State *L, int objindex);
	void  (lua_getfenv) (lua_State *L, int idx);

	/* set functions (stack -> Lua) */

	void  (lua_settable) (lua_State *L, int idx);
	void  (lua_setfield) (lua_State *L, int idx, const char *k);
	void  (lua_rawset) (lua_State *L, int idx);
	void  (lua_rawseti) (lua_State *L, int idx, int n);
	int   (lua_setmetatable) (lua_State *L, int objindex);
	int   (lua_setfenv) (lua_State *L, int idx);


	/* `load' and `call' functions (load and run Lua code) */

	void  (lua_call) (lua_State *L, int nargs, int nresults);
	int   (lua_pcall) (lua_State *L, int nargs, int nresults, int errfunc);
	int   (lua_cpcall) (lua_State *L, lua_CFunction func, void *ud);
	int   (lua_load) (lua_State *L, lua_Reader reader, void *dt,
														 const char *chunkname);

	int (lua_dump) (lua_State *L, lua_Writer writer, void *data);


	/*  coroutine functions */

	int  (lua_yield) (lua_State *L, int nresults);
	int  (lua_resume) (lua_State *L, int narg);
	int  (lua_status) (lua_State *L);

	/* garbage-collection function */

	int (lua_gc) (lua_State *L, int what, int data);

	/* miscellaneous functions */

	int   (lua_error) (lua_State *L);
	int   (lua_next) (lua_State *L, int idx);
	void  (lua_concat) (lua_State *L, int n);

	lua_Alloc (lua_getallocf) (lua_State *L, void **ud);
	void lua_setallocf (lua_State *L, lua_Alloc f, void *ud);

	/* hack */
	void lua_setlevel	(lua_State *from, lua_State *to);

	/* Debug API */

	typedef struct lua_Debug lua_Debug;  /* activation record */

	/* Functions to be called by the debuger in specific events */
	typedef void (*lua_Hook) (lua_State *L, lua_Debug *ar);

	int lua_getstack (lua_State *L, int level, lua_Debug *ar);
	int lua_getinfo (lua_State *L, const char *what, lua_Debug *ar);
	const char *lua_getlocal (lua_State *L, const lua_Debug *ar, int n);
	const char *lua_setlocal (lua_State *L, const lua_Debug *ar, int n);
	const char *lua_getupvalue (lua_State *L, int funcindex, int n);
	const char *lua_setupvalue (lua_State *L, int funcindex, int n);

	int lua_sethook (lua_State *L, lua_Hook func, int mask, int count);
	lua_Hook lua_gethook (lua_State *L);
	int lua_gethookmask (lua_State *L);
	int lua_gethookcount (lua_State *L);

	struct lua_Debug {
	  int event;
	  const char *name;	/* (n) */
	  const char *namewhat;	/* (n) `global', `local', `field', `method' */
	  const char *what;	/* (S) `Lua', `C', `main', `tail' */
	  const char *source;	/* (S) */
	  int currentline;	/* (l) */
	  int nups;		/* (u) number of upvalues */
	  int linedefined;	/* (S) */
	  int lastlinedefined;	/* (S) */
	  char short_src[60]; /* (S) */
	  /* private part */
	  int i_ci;  /* active function */
	};

	/* lauxlib.h ------------------------------------------------------ */


	enum {
	/* extra error code for `luaL_load' */
		LUA_ERRFILE = (LUA_ERRERR+1),
	/* pre-defined references */
		LUA_NOREF = (-2),
		LUA_REFNIL = (-1),
	};
	typedef struct luaL_Reg {
	  const char *name;
	  lua_CFunction func;
	} luaL_Reg;
	void (luaI_openlib) (lua_State *L, const char *libname,
											  const luaL_Reg *l, int nup);
	void (luaL_register) (lua_State *L, const char *libname,
											  const luaL_Reg *l);
	int (luaL_getmetafield) (lua_State *L, int obj, const char *e);
	int (luaL_callmeta) (lua_State *L, int obj, const char *e);
	int (luaL_typerror) (lua_State *L, int narg, const char *tname);
	int (luaL_argerror) (lua_State *L, int numarg, const char *extramsg);
	const char *(luaL_checklstring) (lua_State *L, int numArg,
																				 size_t *l);
	const char *(luaL_optlstring) (lua_State *L, int numArg,
															const char *def, size_t *l);
	lua_Number (luaL_checknumber) (lua_State *L, int numArg);
	lua_Number (luaL_optnumber) (lua_State *L, int nArg, lua_Number def);
	lua_Integer (luaL_checkinteger) (lua_State *L, int numArg);
	lua_Integer (luaL_optinteger) (lua_State *L, int nArg,
															lua_Integer def);
	void (luaL_checkstack) (lua_State *L, int sz, const char *msg);
	void (luaL_checktype) (lua_State *L, int narg, int t);
	void (luaL_checkany) (lua_State *L, int narg);
	int   (luaL_newmetatable) (lua_State *L, const char *tname);
	void *(luaL_checkudata) (lua_State *L, int ud, const char *tname);
	void (luaL_where) (lua_State *L, int lvl);
	int (luaL_error) (lua_State *L, const char *fmt, ...);
	int (luaL_checkoption) (lua_State *L, int narg, const char *def,
												  const char *const lst[]);
	int (luaL_ref) (lua_State *L, int t);
	void (luaL_unref) (lua_State *L, int t, int ref);
	int (luaL_loadfile) (lua_State *L, const char *filename);
	int (luaL_loadbuffer) (lua_State *L, const char *buff, size_t sz,
												 const char *name);
	int (luaL_loadstring) (lua_State *L, const char *s);
	lua_State *(luaL_newstate) (void);
	const char *(luaL_gsub) (lua_State *L, const char *s, const char *p,
																	  const char *r);
	const char *(luaL_findtable) (lua_State *L, int idx,
														  const char *fname, int szhint);
	/* Generic Buffer manipulation */
	typedef struct luaL_Buffer {
	  char *p;	/* current position in buffer */
	  int lvl;  /* number of strings in the stack (level) */
	  lua_State *L;
	  char buffer[?];
	} luaL_Buffer;
	void (luaL_buffinit) (lua_State *L, luaL_Buffer *B);
	char *(luaL_prepbuffer) (luaL_Buffer *B);
	void (luaL_addlstring) (luaL_Buffer *B, const char *s, size_t l);
	void (luaL_addstring) (luaL_Buffer *B, const char *s);
	void (luaL_addvalue) (luaL_Buffer *B);
	void (luaL_pushresult) (luaL_Buffer *B);
	/* lualib.h -------------------------------------------------------- */
	int (luaopen_base) (lua_State *L);
	int (luaopen_table) (lua_State *L);
	int (luaopen_io) (lua_State *L);
	int (luaopen_os) (lua_State *L);
	int (luaopen_string) (lua_State *L);
	int (luaopen_math) (lua_State *L);
	int (luaopen_debug) (lua_State *L);
	int (luaopen_package) (lua_State *L);
	/* open all previous libraries */
	void (luaL_openlibs) (lua_State *L);
	
	typedef struct CType {
      uint32_t info;
      uint32_t size;
      uint16_t sib;
      uint16_t next;
      uint32_t name;
   } CType;

	typedef struct CTState {
      CType *tab;
      uint32_t top;
      uint32_t sizetab;
      lua_State *L;
      lua_State *g;
      void *finalizer;
		void *miscmap;
   } CTState;
]]

lua = setmetatable({}, {__index = LuaLib})

function lua.luaL_checkstring(L, idx)
	return lua.luaL_checklstring(L, idx, nil)
end

function lua.luaL_dostring(L, string)
	lua.luaL_loadstring(L, string)
	return tonumber(lua.lua_pcall(L, 0, lua.LUA_MULTRET, 0))
end

function lua.luaL_dofile(L, file)
	lua.luaL_loadfile(L, file)
	return tonumber(lua.lua_pcall(L, 0, lua.LUA_MULTRET, 0))
end

function lua.lua_geterror(L)
	return ffi.string(lua.lua_tostring(L, -1))
end

function lua.lua_getglobal(L, name)
	lua.lua_getfield(L, lua.LUA_GLOBALSINDEX, name)
end

function lua.lua_isboolean(L, idx)
	return lua.lua_type(L, idx) == lua.LUA_TBOOLEAN
end

function lua.lua_isfunction(L, idx)
	return lua.lua_type(L, idx) == lua.LUA_TFUNCTION
end

function lua.lua_islightuserdata(L, idx)
	return lua.lua_type(L, idx) == lua.LUA_TLIGHTUSERDATA
end

function lua.lua_isnil(L, idx)
	return lua.lua_type(L, idx) == lua.LUA_TNIL
end

function lua.lua_isnumber(L, idx)
	return lua.lua_type(L, idx) == lua.LUA_TNUMBER
end

function lua.lua_isstring(L, idx)
	return lua.lua_type(L, idx) == lua.LUA_TSTRING
end

function lua.lua_istable(L, idx)
	return lua.lua_type(L, idx) == lua.LUA_TTABLE
end

function lua.lua_isthread(L, idx)
	return lua.lua_type(L, idx) == lua.LUA_TTHREAD
end

function lua.lua_isuserdata(L, idx)
	return lua.lua_type(L, idx) == lua.LUA_TUSERDATA
end

function lua.lua_pop(L, n)
	return lua.lua_settop(L, -n - 1)
end

function lua.lua_pushcfunction(L, f)
	return lua.lua_pushcclosure(L, f, 0)
end

function lua.lua_pushrawarguments(L, ...)
	local Count = 0
	for _, Value in pairs({...}) do
		Count = Count + 1
		lua.lua_pushrawvalue(L, Value)
	end
	return Count
end

function lua.lua_pushrawtable(L, tab)
	lua.lua_newtable(L)
	
	for k, v in pairs(tab) do
		lua.lua_pushrawvalue(L, k)
		lua.lua_pushrawvalue(L, v)
		lua.lua_settable(L, -3)
	end
end

function lua.lua_pushrawvalue(L, value)
	local ValueType = type(value)
	if ValueType == "string" then
		lua.lua_pushstring(L, value)
	elseif ValueType == "number" then
		lua.lua_pushnumber(L, value)
	elseif ValueType == "table" then
		lua.lua_pushrawtable(L, value)
	elseif ValueType == "userdata" or ValueType == "cdata" then
		local ToString = tostring(Value)
		if ToString:sub(1, 25) == "cdata<struct lua_State *>" then
			lua.lua_pushthread(L, value)
		elseif ToString:sub(1, 20) == "cdata<struct Entity>" or ToString:sub(1, 22) == "cdata<struct Entity *>" then
			lua.lua_pushentity(L, value)
		else
			lua.lua_pushlightuserdata(L, value)
		end
	elseif ValueType == "boolean" then
		lua.lua_pushboolean(L, value)
	end
end

function lua.lua_register(L, name, f)
	lua.lua_pushcfunction(L, f)
	lua.lua_setglobal(L, name)
end

function lua.lua_setglobal(L, s)
	return lua.lua_setfield(L, lua.LUA_GLOBALSINDEX, s)
end

function lua.lua_toboolean(L, idx)
	return LuaLib.lua_toboolean(L, idx) ~= 0
end

function lua.lua_tostring(L, idx)
	return lua.lua_tolstring(L, idx, nil)
end

function lua.lua_totable(L, idx)
	local Table = {}
	
	lua.lua_pushvalue(L, idx)
	lua.lua_pushnil(L)
	
	while lua.lua_next(L, -2) ~= 0 do
		lua.lua_pushvalue(L, -2)
		
		local Key = lua.lua_torawvalue(L, -1)
		local Value = lua.lua_torawvalue(L, -2)
		
		if Key and Value then
			Table[Key] = Value
		end
		
		lua.lua_pop(L, 2)
	end
	lua.lua_pop(L, 1)
	
	return Table
end

function lua.lua_torawvalue(L, idx)
	if lua.lua_isstring(L, idx) then
		return ffi.string(lua.lua_tostring(L, idx))
	elseif lua.lua_isnumber(L, idx) then
		return tonumber(lua.lua_tonumber(L, idx))
	elseif lua.lua_istable(L, idx) then
		return lua.lua_totable(L, idx)
	elseif lua.lua_isuserdata(L, idx) then
		return lua.lua_touserdata(L, idx)
	elseif lua.lua_isboolean(L, idx) then
		return lua.lua_toboolean(L, idx)
	elseif lua.lua_isthread(L, idx) then
		return lua.lua_tothread(L, idx)
	end
end

function lua.lua_toarguments(L, idx)
	local Top = tonumber(lua.lua_gettop(L))
	local Arguments = {}
	if Top >= idx then
		for i = idx, Top do
			table.insert(Arguments, lua.lua_torawvalue(L, i))
		end
	end
	return Arguments
end

function lua.lua_newtable(L)
	return lua.lua_createtable(L, 0, 0)
end

local function MemPtr(gcobj)
  return tonumber(tostring(gcobj):match"%x*$", 16)
end

function lua.lua_newlocalthread()
	local CTState
	local Coroutine = coroutine.create(function () end)
	local MemoryPointer = MemPtr(Coroutine)
	local Cast = ffi.cast("uint32_t *", MemoryPointer)
	local G = ffi.cast("uint32_t *", Cast[2])
	
	local IndexCast = ffi.cast("const char *", "__index")
	local Anchor = ffi.cast("uint32_t", IndexCast)
	local i = 0
	while math.abs(tonumber(G[i] - Anchor)) > 64 do
		i = i + 1
	end

	repeat
		i = i - 1
		CTState = ffi.cast("CTState *", G[i])
	until ffi.cast("uint32_t *", CTState.g) == G

	return lua.lua_newthread(CTState.L)
end

function lua.cdata_to_lightuserdata(CData)
	local ConversionThread = lua.lua_newlocalthread()
	lua.lua_getglobal(ConversionThread, "lua")
	lua.lua_pushlightuserdata(ConversionThread, CData)
	lua.lua_setfield(ConversionThread, -2, "userdata")
	
	local Userdata = lua.userdata
	lua.userdata = nil
	
	return Userdata, ConversionThread
end
