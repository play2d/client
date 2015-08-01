Network = {}

local Path = ...
require("bit")
require("socket")
require(Path..".Server")
require(Path..".Client")
require(Path..".Packet")
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

--[[
NETWORK PLAN

PACKET HEADER:

[1 BYTE = {
		1 BIT IS IT A PACKET/PING REPLY?,
		1 BIT RELIABLE,
		1 BIT SEQUENCED,
		1 BIT CHANNEL OPENED AND THIS IS THE FIRST PACKET OR NOT,
		1 BIT CHANNEL CLOSED AND THIS IS THE LAST PACKET OR NOT,
		1 BIT PING REQUESTED,
		1 BIT PACKET PART,
	}
] [1 BYTE CHANNEL LENGTH] [STRING CHANNEL] [2 BYTES (SIZE)] [2 BYTES (TYPE)] [COMPRESSED OR UNCOMPRESSED DATA]

--> AND EVERYTHING GETS COMPRESSED TOGETHER AGAIN INTO THIS:
[1 BYTE = {
		1 BIT COMPRESSED WITH ZLIB OR NOT COMPRESSED,
		1 BIT ALL MESSAGES FROM NOW SHOULD BE SENT COMPRESSED WITH ZLIB OR NOT,
	}
] [COMPRESSED OR UNCOMPRESSED DATA]

DEFLATE/INFLATE USAGE:

local Data = "this is a test string I'm trying to compress"
local AMemory = zlib.deflate(Data, {}, DATA_SIZE_HERE, "zlib", 9)
local BMemory = zlib.inflate(AMemory, {}, nil, "zlib")
print(table.concat(BMemory), #AMemory)
]]