ffi.cdef [[
	typedef struct Vector {
		float x;
		float y;
	}
]]

local VectorMT = {}
ffi.metatype("struct Vector", VectorMT)

function VectorMT.__add(A, B)
	if type(B) == "cdata" then
		if tostring(ffi.typeof(B)) == "ctype<struct Vector>" then
			return ffi.new("struct Vector", {x = A.x + B.x, y = A.y + B.y})
		end
	end
end

function VectorMT.__sub(A, B)
	if type(B) == "cdata" then
		if tostring(ffi.typeof(B)) == "ctype<struct Vector>" then
			return ffi.new("struct Vector", {x = A.x - B.x, y = A.y - B.y})
		end
	end
end

function VectorMT.__mult(A, B)
	local Type = type(B)
	if Type == "number" then
		return ffi.new("struct Vector", {x = A.x * B, y = A.y * B})
	elseif Type == "cdata" then
		if tostring(ffi.typeof(B)) == "ctype<struct Vector>" then
			return ffi.new("struct Vector", {x = A.x * B.x, y = A.y * B.y})
		end
	end
end

function VectorMT.__div(A, B)
	local Type = type(B)
	if Type == "number" then
		return ffi.new("struct Vector", {x = A.x / B, y = A.y / B})
	elseif Type == "cdata" then
		if tostring(ffi.typeof(B)) == "ctype<struct Vector>" then
			return ffi.new("struct Vector", {x = A.x / B.x, y = A.y / B.y})
		end
	end
end

function VectorMT.__mod(A, B)
	local Type = type(B)
	if Type == "number" then
		return ffi.new("struct Vector", {x = A.x % B, y = A.y % B})
	elseif Type == "cdata" then
		if tostring(ffi.typeof(B)) == "ctype<struct Vector>" then
			return ffi.new("struct Vector", {x = A.x % B.x, y = A.y % B.y})
		end
	end
end

function VectorMT.__pow(A, B)
	local Type = type(B)
	if Type == "number" then
		return ffi.new("struct Vector", {x = A.x ^ B, y = A.y ^ B})
	elseif Type == "cdata" then
		if tostring(ffi.typeof(B)) == "ctype<struct Vector>" then
			return ffi.new("struct Vector", {x = A.x ^ B.x, y = A.y ^ B.y})
		end
	end
end

function VectorMT:__unm()
	return ffi.new("struct Vector", {x = -self.x, y = -self.y})
end

function VectorMT.__concat(A, B)
	return tostring(A) .. tostring(B)
end

function VectorMT:__len()
	return (self.x^2 + self.y^2)^0.5
end

function VectorMT.__eq(A, B)
	return A.x == B.x and A.y == B.y
end

function VectorMT:__tostring()
	return tonumber(self.x)..", "..tonumber(self.y)
end

function Vector(x, y)
	return ffi.new("struct Vector", {x = x, y = y})
end