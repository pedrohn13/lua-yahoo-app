local require, print = require, print

module("request")

local http = require("socket.http")

function downloadInformation(link)
	local info = http.request(link)
	return info
end
