yahoo = {}

local temp = package.path
package.path = package.path..";../?.lua"
require("config")
package.path = temp 

isLocal = MOCK
currentIdiom = settings.system.language

if(currentIdiom == "pt")then
	loadings = {canvas:new(RES_PATH .."portal/CARREGANDO-1.png"), canvas:new(RES_PATH .."portal/CARREGANDO-2.png"), canvas:new(RES_PATH .."portal/CARREGANDO-3.png")}
elseif(currentIdiom == "en")then
	loadings = {canvas:new(RES_PATH .."portal/loading1.png"), canvas:new(RES_PATH .."portal/loading2.png"), canvas:new(RES_PATH .."portal/loading3.png")}
elseif(currentIdiom == "sp")then
	loadings = {canvas:new(RES_PATH .."portal/CARGANDO-1.png"), canvas:new(RES_PATH .."portal/CARGANDO-2.png"), canvas:new(RES_PATH .."portal/CARGANDO-3.png")}
end

function yahoo.init()
	require('mainPortal')
	registerMain()
end

function yahoo.init2()
	local res, msg = pcall(yahoo.init)
	if (not res) then
	    print(msg)
	end
end

yahoo.init2()

return yahoo