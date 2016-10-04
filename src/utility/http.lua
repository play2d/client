local Path, PLAY2D = ...
local http = PLAY2D.HTTP
local https = PLAY2D.HTTPS

function PLAY2D.HttpRequest(URL, ...)
	
	local url
	
	if type(URL) == "string" then
	
		url = URL
		
	elseif type(URL) == "table" then
		
		url = URL.url
		
	else
		
		return nil, "url not found"
		
	end
	
	if url:sub(1, 6) == "https:" then
		
		-- Function loaded from a DLL requires to be checked
		if https then
			
			return https.request(URL, ...)
			
		end
		
	elseif url:sub(1, 5) == "http:" then
		
		return http.request(URL, ...)
		
	end
	
	return nil, "protocol not found"
	
end