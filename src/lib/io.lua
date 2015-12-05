local FileMetatable = debug.getregistry()["FILE*"]
local File = FileMetatable.__index

function File:size()
	local CurrentPosition = self:seek("cur")
	local Size = self:seek("end")
	self:seek("set", CurrentPosition)
	return Size
end

function File:eof()
	return self:seek() >= self:size()
end

function File:ReadByte()
	return self:read(1):ReadByte()
end

function File:ReadShort()
	return self:read(2):ReadShort()
end

function File:ReadInt24()
	return self:read(3):ReadInt24()
end

function File:ReadInt()
	return self:read(4):ReadInt()
end

function File:ReadNumber()
	return self:read(8):ReadNumber()
end

function File:ReadFloat()
	return self:read(8):ReadFloat()
end

function File:ReadString(Size)
	return self:read(8)
end

function File:ReadLine()
	return self:read("*l")
end

function File:WriteByte(n)
	local Data = (""):WriteByte(n)
	return self:write(Data)
end

function File:WriteShort(n)
	local Data = (""):WriteShort(n)
	return self:write(Data)
end

function File:WriteInt24(n)
	local Data = (""):WriteInt24(n)
	return self:write(Data)
end

function File:WriteInt(n)
	local Data = (""):WriteInt(n)
	return self:write(Data)
end

function File:WriteNumber(n)
	local Data = (""):WriteNumber(n)
	return self:write(Data)
end

function File:WriteFloat(n)
	local Data = (""):WriteFloat(n)
	return self:write(Data)
end

function File:WriteString(Str)
	if type(Str) == "string" then
		return self:write(Str)
	end
end

function File:WriteLine(Str)
	if type(Str) == "string" then
		return self:write(Str.."\n")
	end
end