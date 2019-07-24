images = {}

-- Return a path to load an image
function getC(num)
	local n = tonumber(num)
	return RES_PATH .."weather/icons/"..n.."b.png"
	
end

-- Loads the weather condition icon if are not loaded
function loadIcon(id)
	id = tonumber(id)
	if (images[id] == nil) then
		images[id] = canvas:new(getC(id))
	end
	return images[id]	
end


