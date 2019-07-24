http = require('socket.http')
function formatedName(city)
	return city:gsub("'", "")
end

function woeidCode(city)
  -- The API key, perhaps, should be placed somewhere else among other constants
  -- MuInuz7V34E2r0Hlf9HDaEj4F4yXfeJS41MUuQbi_Chg_y7k4qIqgnor9rr1t8qgQ5A-
  
  local APIKEY = 'MuInuz7V34E2r0Hlf9HDaEj4F4yXfeJS41MUuQbi_Chg_y7k4qIqgnor9rr1t8qgQ5A-'
  city = formatedName(city)
  local URI = "http://where.yahooapis.com/v1/places.q('" .. city .. "')"
  URI = URI .. "?appid=[" .. APIKEY .. "]"

  rss = http.request(URI)
  if (rss == nil) then error("Verifique o nome da cidade ou a conexÃ£o com a internet") end
  a, b = rss:find("<woeid>")
  c, d = rss:find("</woeid>")
  return rss:sub(b+1, c-1)
end

file = io.open(SRC_PATH.."cidades.txt", "r")
file2 = io.open("goias.lua", "a")
file2:write("locais = {}" )
while true do
	linha = file:read()

	if (linha == nil) then
		break
	else
		file2:write("\nlocais['"..linha.. "'] = " .. woeidCode(linha .." goias") )
	end
	print (linha)

end
