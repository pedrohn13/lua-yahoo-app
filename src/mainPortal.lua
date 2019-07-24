require "Category"
require "mainNews"
require "mainWeather"

local app = 1
local home = {}
local countFail = 0

background = canvas:new(RES_PATH .."portal/background.png")
 
--- Carries current information
function loadInformation()
	canvas:compose(520,300,loadings[1])
	canvas:flush()

	local woeidFile = io.open(RES_PATH .."weather/woeidFavorite.txt","r")
	local temp = woeidFile:read()
	
	
	if (temp ~= nil) then
		temp = split(temp, ',')
		home[2] = Clima:new(temp[1])
		if(home[2])then
			home[2]:setCidade(temp[2])
			if (currentIdiom == "en") then
				home[2]:changeUnit()
			end
		end
	else
		home[2] = nil
	end
	
	if(home[2] == false)then
		countFail = countFail + 1
	end
	
	woeidFile:close()
	canvas:clear()
	paintHomeScreenPortal()
	
	canvas:compose(520,300,loadings[2])
	canvas:flush()
	
	local file = io.open(RES_PATH .."news/lastNews.txt", "r")
	last = Category:new({name = {file:read(), file:read(), file:read()}, url = "".. file:read(), news = {}})
	file:close()
	
	if(not last:loadingNews())then	
		countFail = countFail + 1
	end
	
	if(countFail == 2)then
		canvas:clear()
		paintHomeScreenPortal()
		local noConnection = canvas:new(RES_PATH .."portal/no-connection.png")
		canvas:compose(520,300,noConnection)
		canvas:flush()
		connection = false
		return
	end
	connection = true
	
	canvas:clear()
	paintHomeScreenPortal()	
	canvas:compose(520,300,loadings[3])
	canvas:flush()
	connection = true
end

--- show widgets boxes
function paint()
	paintNews()
	paintWeather()
	drawBorder()
end

--- show background
function paintHomeScreenPortal()
	canvas:compose(0,0,background)
	paintControlsPortal()
end

function paintControlsPortal()
	local botton
	local botton = canvas:new(RES_PATH .."portal/ic-blue-s.png")
	canvas:compose(1130,676,botton)
	local botton = canvas:new(RES_PATH .."portal/ic-navigate-2.png")
	canvas:compose(144,676,botton)
	local botton = canvas:new(RES_PATH .."weather/elements/ic-exit.png")
	canvas:compose(40,676,botton)
	local botton = canvas:new(RES_PATH .."weather/elements/ic-ok.png")
	canvas:compose(280,676, botton)
	
	canvas:attrColor ("white")
  	canvas:attrFont("Tirésias",17)
  	
  	canvas:drawText(1175, 685,language:getWordControls(4))
  	canvas:drawText(330, 685,language:getWordControls(5))
  	canvas:drawText(189, 685,language:getWordControls(3))
  	canvas:drawText(90, 685,language:getWordControls(1))
end

--- show news last visited category
function paintNews()
	local boxNews = canvas:new(RES_PATH .."portal/box-news.png")
	
	canvas:compose(300,103,boxNews)
	canvas:attrColor ("white")
  	canvas:attrFont("Tirésias",25)
	canvas:drawText(centralize(language:getWordControls(8),341)+300,170,language:getWordControls(8))	
	
	canvas:attrFont("Tirésias",25, "bold")
	canvas:attrColor(246,147,33,255)
	canvas:drawText(325,215,last.name[indexIdiom])
	
	if(last == nil)then return end
	
	canvas:attrFont("Tirésias",14, "bold")
	canvas:attrColor(88,201,232,255)
	canvas:drawText(325,245,last:showDate(1))
	
	canvas:attrFont("Tirésias",18, "bold")
	local title = TextView:new(320, 270 , 300, 80, last:showTitle(1))
	title:draw(255,255,255)
	
	
	if(countLine == 1 and last:showTitle(1) ~= " ")then 
		canvas:attrFont("Tirésias",16, "bold")
		local description = TextView:new(320, 300 , 300, 270, last:showDescription(1))
		description:draw(200, 200, 200)
	
	elseif(countLine == 2)then
		canvas:attrFont("Tirésias",16, "bold")
		local description = TextView:new(320, 330 , 300, 270, last:showDescription(1))
		description:draw(200, 200, 200)
		
	elseif(last:showTitle(1) == " ")then
		canvas:attrFont("Tirésias",18, "bold")
		local description = TextView:new(345, 300 , 300, 270, last:showDescription(1))
		description:draw(88, 201, 232)
	
	else
		canvas:attrFont("Tirésias",16, "bold")
		local description = TextView:new(320, 340 , 300, 270, last:showDescription(1))
		description:draw(200, 200, 200)
	end
	
	if(#last:showDescription(1) > 430 )then
		local points = canvas:new(RES_PATH .."news/elements/leia_mais-01.png")
		canvas:compose(590, 600, points)
	end
	
end

--- show weather last visited city
function paintWeather()
	local boxWeather = canvas:new(RES_PATH .."portal/box-weather.png")
	canvas:compose(650,101,boxWeather)
	
	canvas:attrColor ("white")
  	canvas:attrFont("Tirésias",25)
	canvas:drawText(centralize(language:getWordControls(9),341)+650,170,language:getWordControls(9))
	
	if (home[2] ~= nil) then
		local fontSize = 35
		canvas:attrColor(224, 115, 7, 255)
		canvas:attrFont("Tirésias",fontSize)
		while (centralize(home[2]:getCidade(),341) < 10) do
			fontSize = fontSize - 1
			canvas:attrFont("Tirésias",fontSize)
		end
		canvas:drawText(centralize(home[2]:getCidade(),341)+650,240,home[2]:getCidade())
		
		local icon = loadIcon(home[2]:getCondicaoClimatica().id)
		icon:attrScale(260, true)
		canvas:compose(690,280, icon)
	
		canvas:attrColor (128, 128, 128, 255)
		canvas:attrFont("Tirésias",20)
		canvas:drawText(centralize(home[2]:getCondicaoClimatica().text,341)+650,450,home[2]:getCondicaoClimatica().text)
		canvas:attrFont("Tirésias",38)
		canvas:drawText(850,490,home[2]:getUnitTemp())
		canvas:attrFont("Tirésias",128)
		canvas:drawText(710,460,home[2]:getTemperatura())
		canvas:attrFont("Tirésias",30)		
		canvas:drawText(895,512,home[2]:getPrevisaoDeHoje().min..home[2]:getUnitTemp())
		canvas:attrColor ("white")
		canvas:drawText(893,510,home[2]:getPrevisaoDeHoje().min..home[2]:getUnitTemp())		
		canvas:attrColor (128, 128, 128, 255)
		canvas:drawText(895,562,home[2]:getPrevisaoDeHoje().max..home[2]:getUnitTemp())
		canvas:attrColor ("white")
		canvas:drawText(893,560,home[2]:getPrevisaoDeHoje().max..home[2]:getUnitTemp())
		
		
		canvas:attrColor (224, 115, 7, 255)
		canvas:attrFont("Tirésias",128)
		canvas:drawText(708,458,home[2]:getTemperatura())
		canvas:attrFont("Tirésias",38)
		canvas:drawText(848,488,home[2]:getUnitTemp())
		canvas:attrFont("Tirésias",22)	
		canvas:attrColor (101, 180, 225, 255)
		canvas:drawText(895,492,language:getWordControls(7))
		canvas:attrColor (227, 78, 84, 255)
		canvas:drawText(895,542,language:getWordControls(6))
		
	end
end

--- Clean bord
function cleanBorder()
	if(app == 1)then
		canvas:compose(300,100,background, 300, 100, 11, 530)
		canvas:compose(300,99,background, 300, 99, 340, 11)
		canvas:compose(632,100,background, 632, 100, 11, 530)
		canvas:compose(300,623,background, 300, 623, 340, 11)
	else	
		canvas:compose(650,100,background, 650, 100, 11, 530)
		canvas:compose(650,99,background, 650, 99, 340, 11)
		canvas:compose(982,100,background, 982, 100, 11, 530)
		canvas:compose(650,622,background, 650, 622, 340, 11)
	end
end

function drawBorder()
	local border
	local border = canvas:new(RES_PATH .."portal/bord.png")
	
	if(app == 1)then
		border:attrScale(343,535)
		canvas:compose(299, 98, border)
		local border = canvas:new(RES_PATH .."portal/sombra.png")
		border:attrScale(341,532)
		canvas:compose(650, 99, border)
	else	
		border:attrScale(343,true)
		canvas:compose(649, 98, border)
		local border = canvas:new(RES_PATH .."portal/sombra.png")
		border:attrScale(340,533)
		canvas:compose(301, 99, border)
	end
	canvas:flush()

end

--- Enters the selected section
function open()
	if (app == 1) then
		registerNews()

	elseif (app == 2) then 
		registerWeather()
	end
end

--- Update page
function updatePortal()
	countFail = 0
	canvas:clear()
	paintHomeScreenPortal()
	canvas:flush()
	loadInformation()
	canvas:clear()
	paintHomeScreenPortal()
	if(not connection)then return end
	paint()
end

--- Capture portal events
function handlerP(evt)
	if (evt.class == 'key' and evt.type == 'press') then
		if (evt.key == 'CURSOR_RIGHT' and connection) then
			if (app < 2) then
				cleanBorder()
				app = app + 1
				drawBorder()
				
			end
		elseif (evt.key == 'CURSOR_LEFT' and connection) then
			if (app > 1) then
				cleanBorder()
				app = app - 1
				drawBorder()
				
			end
		elseif (evt.key == 'ENTER' and connection) then
			event.unregister(handlerP)
			canvas:clear()
			open()
		elseif (evt.key == 'BLUE') then
			updatePortal()
		elseif (evt.key == 'EXIT') then
			event.unregister(handlerP)
			local app = applicationManager.getRunningApplication()
			canvas:attrColor('black')
			applicationManager.stopApplication(app["id"])
		end
	end
end

--- Update page and register events
function registerMain()	
	updatePortal()
	event.register(handlerP)
end

