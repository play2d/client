Network = {}

local Path = ...
require("socket")
require(Path..".server")
require(Path..".client")
require(Path..".packet")
require(Path..".channel")
zlib = require(Path..".zlib")

function string:ReadByte()
	return self:byte(1) or 0, self:sub(2)
end

function string:ReadShort()
	return (self:byte(1) or 0) + (self:byte(2) or 0) * 256, self:sub(3)
end

function string:ReadInt()
	return (self:byte(1) or 0) + (self:byte(2) or 0) * 256 + (self:byte(3) or 0) * (256^2) + (self:byte(4) or 0) * (256^3), self:sub(5)
end

function string:ReadString(Length)
	return self:sub(1, Length), self:sub(Length + 1)
end

function string:ReadLine()
	local Find = self:find("\n")
	if Find then
		return self:sub(1, Find - 1), self:sub(Find + 1)
	end
	return self, ""
end

function string:WriteByte(n)
	return self .. string.char(n)
end

function string:WriteShort(n)
	local n1 = n % 256
	local n2 = (n - n1)/256
	return self .. string.char(n1) .. string.char(n2)
end

function string:WriteInt(n)
	local n1 = n % 256; n = (n - n1)/256
	local n2 = n % 256; n = (n - n2)/256
	local n3 = n % 256; n = (n - n3)/256
	return self .. string.char(n1) .. string.char(n2) .. string.char(n3) .. string.char(n)
end

function string:WriteString(String)
	return self .. String
end

function string:WriteLine(String)
	return self .. String .. "\n"
end