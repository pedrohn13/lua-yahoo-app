require 'Tempo'
require 'weatherLang'
require 'ordenator'

--- data structure
--tables
local statesFile = {"acre","alagoas","amapa","amazonas","bahia","ceara","distritofederal",
"espiritosanto","goias","maranhao","matogrosso","matogrossodosul","minasgerais",
"para","paraiba","parana","pernambuco","piaui","riodejaneiro","riograndedonorte",
"riograndedosul","rondonia","roraima","santacatarina","saopaulo","sergipe","tocantins"}
local statesName = {"Acre","Alagoas","Amapá","Amazonas","Bahia","Ceará","Distrito Federal","Espirito Santo","Goiás","Maranhão",
		"Mato Grosso","Mato Grosso do Sul","Minas Gerais","Pará","Paraiba","Paraná","Pernambuco","Piauí","Rio de Janeiro","Rio Grande do Norte",
		"Rio Grande do Sul","Rondônia","Roraima","Santa Catarina","São Paulo","Sergipe","Tocantins"}

local charac = {'A','B','C','D','E','G','M','P','R','S','T'}
local charac2 = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'}
local cities = {}
local favorites = {}
local position = {{118,423}, {118,540}, {465,423}, {465,540}, {813,423} , {813,540}}
local woeids = {}
local words = {}

-- idiom detection
local idiom = currentIdiom
if (idiom == "pt") then
	words = wordsPT
elseif (idiom == "en") then
	words = wordsEN
elseif (idiom == "sp") then
	words = wordsSP
else
	words = wordsPT
end

background = canvas:new(RES_PATH .."weather/elements/bg-1.png")

-- control variables
local currentPosition = 1
local lastPosition = 1
local currentExib = 1
local currentRgCha = 1
local currentRg = 1
local currentRgBt = 1
local firstRg = 1
local currentCtCha = 1
local currentCt = 1
local currentCtBt = 1
local currentChaBt = 1
local firstCt = 1
local firstCha = 1
local currentFv = 1
local colum = 1
local screen = 1
local details = false
local ok = true
local internet
local removed

-- images
local frameCity = canvas:new(RES_PATH .."weather/elements/frame-city.png")
local frameCityNeon = canvas:new(RES_PATH .."weather/elements/frame-city-select.png")
local list1 = canvas:new(RES_PATH .."weather/elements/list1.png")
local list2 = canvas:new(RES_PATH .."weather/elements/list2.png")
local list1Selected = canvas:new(RES_PATH .."weather/elements/list1-select.png")
local list2Selected = canvas:new(RES_PATH .."weather/elements/list2-select.png")
local orangebox = canvas:new(RES_PATH .."weather/elements/frame-temp.png")
local orangeLine = canvas:new(RES_PATH .."weather/elements/line.png")
local arrowLeft = canvas:new(RES_PATH .."weather/elements/arrow-left.png")
local arrowRight = canvas:new(RES_PATH .."weather/elements/arrow-right.png")



--- Loads favorites cities and store in favorites table
function loadFavorites()
	local cont = 1
	local temp = {}
	woeids = {}
	for line in io.lines(RES_PATH .."weather/woeidFavorite.txt") do
		if (line ~= nil) then			
			canvas:compose(0,0,background)
			canvas:compose(520,300,loadings[(cont%3)+1])
			canvas:flush()
			temp = split(line, ',')
			local city = Clima:new(temp[1])
			if (city) then
				city:setCidade(temp[2])
				table.insert(favorites,	city)
				table.insert(woeids,city:getWoeid())
				if (idiom == "en") then
					city:changeUnit()
				end
			else				
				internet = false
				return
			end
			cont = cont + 1
		end
	end
	internet = true
end

--- Loads cities of a region
function loadCities()
	dofile(RES_PATH .."weather/woeidCities/"..statesFile[currentRg]..".lua")
	for name in pairs(locais) do
		table.insert(cities,name)
	end
	table.sort(cities,stringComparator)
end

--- Shows the navigation cursor in screen 1
function barCity()	
	local i
	
	if (currentExib == 1) then
		if (lastPosition == 7 or lastPosition == 8) then
			lastPosition = currentPosition
		end
		i = lastPosition
		canvas:compose(position[i][1],position[i][2],background,position[i][1],position[i][2],15,118)
		canvas:compose(position[i][1]+15,position[i][2],background,position[i][1]+15,position[i][2],335,15)
		canvas:compose(position[i][1]+15,position[i][2]+104,background,position[i][1]+15,position[i][2]+104,335,15)
		canvas:compose(position[i][1]+336,position[i][2]+14,background,position[i][1]+336,position[i][2]+14,15,118)
			
		i = currentPosition
		if (favorites[i] ~= nil) then				
			canvas:compose(position[i][1],position[i][2],frameCityNeon)
		end	
		
	elseif (currentExib == 2) then	
		
		if (lastPosition > 6) then
			i = lastPosition
			canvas:compose(position[i-6][1],position[i-6][2],background,position[i-6][1],position[i-6][2],15,118)
			canvas:compose(position[i-6][1]+15,position[i-6][2],background,position[i-6][1]+15,position[i-6][2],335,15)
			canvas:compose(position[i-6][1]+15,position[i-6][2]+104,background,position[i-6][1]+15,position[i-6][2]+104,335,15)
			canvas:compose(position[i-6][1]+336,position[i-6][2]+14,background,position[i-6][1]+336,position[i-6][2]+14,15,118)
		end
		i = currentPosition

		if (favorites[i] ~= nil) then				
			canvas:compose(position[i-6][1],position[i-6][2],frameCityNeon)
					
		end		
	end	
end

--- Shows the Weather forecast of the current favorite
function paintForecast()	
	canvas:compose(132,93,background,132,93,1014,291)
	canvas:compose(675,164,orangeLine)
	canvas:compose(796, 164, orangebox)
	favorites[currentPosition]:paintInfo()
	details = false
end

--- Shows the Weather forecast of the current favorite with details
function paintDetails()		
	details = true
	canvas:compose(796,164,background,796,164,325,198)
	paintControls()
	favorites[currentPosition]:paintMoreInfo()	
	canvas:flush()
end

--- Show the Favorites in screen
function paintFavorites()
	background = canvas:new(RES_PATH .."weather/elements/bg-1.png")
	canvas:compose(0,0,background)	
	if (currentExib == 1) then
		for i=1, 6 do			
			if (favorites[i] ~= nil) then				
				canvas:compose(position[i][1],position[i][2],frameCity)						
				favorites[i]:paintMini(position[i][1], position[i][2])				
			end
		end
		
	elseif (currentExib == 2) then
		for i=7, 12 do				
			if (favorites[i] ~= nil) then					
				canvas:compose(position[i-6][1],position[i-6][2],frameCity)						
				favorites[i]:paintMini(position[i-6][1], position[i-6][2])				
			end			
		end
	end
end

--- Shows the screen with weather forecasts and favorites
function paintScreen1()	
	if (#favorites > 0 and internet) then
		barCity()
		paintForecast()	
	
	elseif (#favorites == 0 or not internet) then
		background = canvas:new(RES_PATH .."weather/elements/bg-2.png")
		canvas:compose(0,0,background)
		if (not internet) then
			local noConnection = canvas:new(RES_PATH .."portal/no-connection.png")
			canvas:compose(520,300,noConnection)
			canvas:flush()
		end
	end
	if (removed ~= nil) then
		w, h = canvas:measureText(removed:getCidade()..words[32])
		canvas:compose(1150 - w,42,background,1150 - w,42,w,h)
	end
	paintControls()
	canvas:flush()
end

--- Shows the screen to add new cities to favorites
function paintScreen2()	
	canvas:attrColor ("white")
  	canvas:attrFont("Tirésias",40)
	canvas:drawText(centralize(words[1],1280), 95,words[1])
	if (colum == 1 or colum == 2) then
		paintRegions()
	else
		paintCities()
	end
	paintControls()
	canvas:flush()
end

--- Show the current screen icons and text controls
function paintControls()
	local botton
	local point1
	local point2
	
	canvas:compose(0,670,background,0,670,1280,50)
	botton = canvas:new(RES_PATH .."weather/elements/ic-exit.png")
	canvas:compose(40,676,botton)
	canvas:attrColor ("white")
  	canvas:attrFont("Tirésias",17)
	canvas:drawText(90, 685,words[2])
	point1 = 90 + canvas:measureText(words[2]) 
	botton = canvas:new(RES_PATH .."weather/elements/ic-back.png")
	canvas:compose(point1+10,676,botton)
	canvas:drawText(point1+55, 685,words[3])
	point1 = point1 + 55 + canvas:measureText(words[3])

	if (screen == 1) then
		if (#favorites == 12) then
			
			botton = canvas:new(RES_PATH .."weather/elements/ic-navigate-1.png")
			canvas:compose(point1+10,676,botton)
			canvas:drawText(point1+55, 685,words[5])
			
			botton = canvas:new(RES_PATH .."portal/ic-blue-s.png")
			canvas:compose(1130,676,botton)						
			canvas:drawText(1175, 685,words[6])	
			
			botton = canvas:new(RES_PATH .."portal/ic-yellow-s.png")			
			if(details)then
				point2 = 1130 - canvas:measureText(words[10])
				canvas:drawText(point2-10, 685,words[10])
			else
				point2 = 1130 - canvas:measureText(words[9])
				canvas:drawText(point2-10, 685,words[9])
			end
			point2 = point2 - 50
			canvas:compose(point2,676,botton)
			
			botton = canvas:new(RES_PATH .."portal/ic-red-s.png")	
			point2 = point2 - canvas:measureText(words[8])
			canvas:drawText(point2-10, 685,words[8])
			point2 = point2 - 50
			canvas:compose(point2,676,botton)			
			
			

		
		elseif (#favorites == 0 and internet) then
		
			botton = canvas:new(RES_PATH .."portal/ic-green-s.png")	
			canvas:compose(1054,676,botton)
			canvas:drawText(1094, 685,words[7])	
			
		elseif (not internet) then
			botton = canvas:new(RES_PATH .."portal/ic-blue-s.png")
			canvas:compose(1130,676,botton)						
			canvas:drawText(1175, 685,words[6])
			
		else
		
			botton = canvas:new(RES_PATH .."weather/elements/ic-navigate-1.png")
			canvas:compose(point1+10,676,botton)
			canvas:drawText(point1+55, 685,words[5])
			
			botton = canvas:new(RES_PATH .."portal/ic-blue-s.png")
			canvas:compose(1130,676,botton)						
			canvas:drawText(1175, 685,words[6])	
			
			botton = canvas:new(RES_PATH .."portal/ic-yellow-s.png")			
			if(details)then
				point2 = 1130 - canvas:measureText(words[10])
				canvas:drawText(point2-10, 685,words[10])
			else
				point2 = 1130 - canvas:measureText(words[9])
				canvas:drawText(point2-10, 685,words[9])
			end
			point2 = point2 - 50
			canvas:compose(point2,676,botton)	
			
			botton = canvas:new(RES_PATH .."portal/ic-green-s.png")				
			point2 = point2 - canvas:measureText(words[7])
			canvas:drawText(point2-10, 685,words[7])
			point2 = point2 - 50
			canvas:compose(point2,676,botton)
			
			botton = canvas:new(RES_PATH .."portal/ic-red-s.png")	
			point2 = point2 - canvas:measureText(words[8])
			canvas:drawText(point2-10, 685,words[8])
			point2 = point2 - 50
			canvas:compose(point2,676,botton)
			
			

					
			
			
			
		end
		
		if (currentExib == 2) then
			canvas:compose(81,523,background,81,523,23,36)	
			canvas:compose(81,523,arrowLeft)
		elseif (currentExib == 1 and #favorites > 6) then
			canvas:compose(1175,523,background,1175,523,23,36)
			canvas:compose(1175,523,arrowRight)
		end		
		
	elseif (screen == 2) then		
		botton = canvas:new(RES_PATH .."weather/elements/ic-navigate-1.png")
		canvas:compose(point1+10,676,botton)
		canvas:drawText(point1+55, 685,words[5])
		point1 = point1 + 55 + canvas:measureText(words[5])
		
		if(ok)then
			botton = canvas:new(RES_PATH .."weather/elements/ic-ok.png")
			canvas:compose(point1+10,676,botton)
			canvas:drawText(point1+55, 685,words[4])
		end
		ok = true
	end
end

--- Shows the list of regions
function paintRegions()
	canvas:compose(133,166,background,133,166,500,503)
	canvas:attrColor ("white")
	canvas:attrFont("Tirésias",30)
	canvas:drawText(200, 165,words[11])
	
	canvas:compose(133,186,list1)
	canvas:compose(188,186,list2)
	canvas:compose(133,266,list1)
	canvas:compose(188,266,list2)
	canvas:compose(133,346,list1)
	canvas:compose(188,346,list2)
	canvas:compose(133,426,list1)
	canvas:compose(188,426,list2)
	canvas:compose(133,506,list1)
	canvas:compose(188,506,list2)
	canvas:compose(133,586,list1)
	canvas:compose(188,586,list2)

	canvas:attrColor(46, 114, 154, 255)
	canvas:attrFont("Tirésias",25)
	canvas:drawText(165,205,charac[1])
	canvas:drawText(165,245,charac[2])
	canvas:drawText(165,285,charac[3])
	canvas:drawText(165,325,charac[4])
	canvas:drawText(165,365,charac[5])
	canvas:drawText(165,405,charac[6])
	canvas:drawText(165,445,charac[7])
	canvas:drawText(165,485,charac[8])
	canvas:drawText(165,525,charac[9])
	canvas:drawText(165,565,charac[10])
	canvas:drawText(165,605,charac[11])

	if (statesName[firstRg] ~= nil) then canvas:drawText(220,205,statesName[firstRg]) end
	if (statesName[firstRg+1] ~= nil) then canvas:drawText(220,245,statesName[firstRg+1]) end
	if (statesName[firstRg+2] ~= nil) then canvas:drawText(220,285,statesName[firstRg+2]) end
	if (statesName[firstRg+3] ~= nil) then canvas:drawText(220,325,statesName[firstRg+3]) end
	if (statesName[firstRg+4] ~= nil) then canvas:drawText(220,365,statesName[firstRg+4]) end
	if (statesName[firstRg+5] ~= nil) then canvas:drawText(220,405,statesName[firstRg+5]) end
	if (statesName[firstRg+6] ~= nil) then canvas:drawText(220,445,statesName[firstRg+6]) end
	if (statesName[firstRg+7] ~= nil) then canvas:drawText(220,485,statesName[firstRg+7]) end
	if (statesName[firstRg+8] ~= nil) then canvas:drawText(220,525,statesName[firstRg+8]) end
	if (statesName[firstRg+9] ~= nil) then canvas:drawText(220,565,statesName[firstRg+9]) end
	if (statesName[firstRg+10] ~= nil) then canvas:drawText(220,605,statesName[firstRg+10]) end

	if (colum == 1) then		
		canvas:compose(133,(186+(40*(currentRgCha-1))),list1Selected)
	elseif (colum == 2) then	
		canvas:compose(188,(186+(40*(currentRgBt-1))),list2Selected)
	end
	
	canvas:attrColor (224, 115, 7, 255)
	canvas:drawText(165,(205+(40*(currentRgCha-1))),charac[currentRgCha])

	if (colum > 1) then
		canvas:drawText(220,(205+(40*(currentRgBt-1))),statesName[currentRg])
	end
	
	if (colum == 2) then
		if (currentRg < #statesName and firstRg+10 < #statesName) then
			local arrowDown = canvas:new(RES_PATH .."weather/elements/arrow-down.png")
			canvas:compose(380,648,arrowDown)
		end
		if (firstRg > 1) then
			local arrowUp = canvas:new(RES_PATH .."weather/elements/arrow-up.png")	
			canvas:compose(380,178,arrowUp)
		end
	end
end

--- Shows the list of cities from the selected region
function paintCities()
	canvas:compose(663,166,background,663,166,500,503)
	canvas:attrColor ("white")
	canvas:attrFont("Tirésias",30)
	canvas:drawText(730, 165,words[12])
	
	local check1 = canvas:new(RES_PATH .."weather/elements/check1.png")
	local check2 = canvas:new(RES_PATH .."weather/elements/check2.png")
	
	canvas:compose(663,186,list1)
	canvas:compose(718,186,list2)
	canvas:compose(663,266,list1)
	canvas:compose(718,266,list2)
	canvas:compose(663,346,list1)
	canvas:compose(718,346,list2)
	canvas:compose(663,426,list1)
	canvas:compose(718,426,list2)
	canvas:compose(663,506,list1)
	canvas:compose(718,506,list2)
	canvas:compose(663,586,list1)
	canvas:compose(718,586,list2)

	canvas:attrColor(46, 114, 154, 255)
	canvas:attrFont("Tirésias",25)
	canvas:drawText(695,205,charac2[firstCha])
	canvas:drawText(695,245,charac2[firstCha+1])
	canvas:drawText(695,285,charac2[firstCha+2])
	canvas:drawText(695,325,charac2[firstCha+3])
	canvas:drawText(695,365,charac2[firstCha+4])
	canvas:drawText(695,405,charac2[firstCha+5])
	canvas:drawText(695,445,charac2[firstCha+6])
	canvas:drawText(695,485,charac2[firstCha+7])
	canvas:drawText(695,525,charac2[firstCha+8])
	canvas:drawText(695,565,charac2[firstCha+9])
	canvas:drawText(695,605,charac2[firstCha+10])
	
	dofile(RES_PATH .."weather/woeidCities/"..statesFile[currentRg]..".lua")
	
	if (cities[firstCt] ~= nil) then
		for i=1,#woeids do
			if (tonumber(locais[cities[firstCt]]) == tonumber(woeids[i])) then
				canvas:compose(745,212,check1)
				break				
			end						
		end	
		canvas:drawText(775,205,cities[firstCt])
	end
	
	if (cities[firstCt+1] ~= nil) then
		for i=1,#woeids do
			if (tonumber(locais[cities[firstCt+1]]) == tonumber(woeids[i])) then
				canvas:compose(745,252,check1)
				break				
			end						
		end	
		canvas:drawText(775,245,cities[firstCt+1]) 
	end
	
	if (cities[firstCt+2] ~= nil) then
		for i=1,#woeids do
			if (tonumber(locais[cities[firstCt+2]]) == tonumber(woeids[i])) then
				canvas:compose(745,292,check1)
				break				
			end						
		end	 
		canvas:drawText(775,285,cities[firstCt+2]) 
	end
	
	if (cities[firstCt+3] ~= nil) then 
		for i=1,#woeids do
			if (tonumber(locais[cities[firstCt+3]]) == tonumber(woeids[i])) then
				canvas:compose(745,332,check1)
				break				
			end						
		end
		canvas:drawText(775,325,cities[firstCt+3]) 
	end
	
	if (cities[firstCt+4] ~= nil) then 
		for i=1,#woeids do
			if (tonumber(locais[cities[firstCt+4]]) == tonumber(woeids[i])) then
				canvas:compose(745,372,check1)
				break				
			end						
		end
		canvas:drawText(775,365,cities[firstCt+4]) 
	end
	
	if (cities[firstCt+5] ~= nil) then 
		for i=1,#woeids do
			if (tonumber(locais[cities[firstCt+5]]) == tonumber(woeids[i])) then
				canvas:compose(745,412,check1)
				break				
			end						
		end
		canvas:drawText(775,405,cities[firstCt+5]) 
	end
	
	if (cities[firstCt+6] ~= nil) then 
		for i=1,#woeids do
			if (tonumber(locais[cities[firstCt+6]]) == tonumber(woeids[i])) then
				canvas:compose(745,452,check1)
				break				
			end						
		end
		canvas:drawText(775,445,cities[firstCt+6]) 
	end
	
	if (cities[firstCt+7] ~= nil) then 
		for i=1,#woeids do
			if (tonumber(locais[cities[firstCt+7]]) == tonumber(woeids[i])) then
				canvas:compose(745,492,check1)
				break				
			end						
		end
		canvas:drawText(775,485,cities[firstCt+7]) 
	end
	
	if (cities[firstCt+8] ~= nil) then 
		for i=1,#woeids do
			if (tonumber(locais[cities[firstCt+8]]) == tonumber(woeids[i])) then
				canvas:compose(745,532,check1)
				break				
			end						
		end
		canvas:drawText(775,525,cities[firstCt+8]) 
	end
	
	if (cities[firstCt+9] ~= nil) then 
		for i=1,#woeids do
			if (tonumber(locais[cities[firstCt+9]]) == tonumber(woeids[i])) then
				canvas:compose(745,572,check1)
				break				
			end						
		end
		canvas:drawText(775,565,cities[firstCt+9]) 
	end
	
	if (cities[firstCt+10] ~= nil) then 
		for i=1,#woeids do
			if (tonumber(locais[cities[firstCt+10]]) == tonumber(woeids[i])) then
				canvas:compose(745,612,check1)
				break				
			end						
		end
		canvas:drawText(775,605,cities[firstCt+10]) 
	end

	canvas:attrColor (224, 115, 7, 255)
	if (colum == 3) then		
		canvas:compose(663,(186+(40*(currentChaBt-1))),list1Selected)
	elseif (colum == 4) then
		canvas:compose(718,(186+(40*(currentCtBt-1))),list2Selected)
		for i=1,#woeids do
			if (locais[cities[currentCt]] == tonumber(woeids[i])) then
				canvas:compose(745,212+(40*(currentCtBt-1)),check2)
				ok = false
				break				
			end						
		end
		canvas:drawText(775,(205+(40*(currentCtBt-1))),cities[currentCt])
	end
	
	canvas:drawText(695,(205+(40*(currentChaBt-1))),charac2[currentCtCha])

	if (colum == 3) then
		if (currentCtCha < #charac2 and firstCha+10 < #charac2) then
			local arrowDown = canvas:new(RES_PATH .."weather/elements/arrow-down.png")
			canvas:compose(693,648,arrowDown)
		end
		if (firstCha > 1) then
			local arrowUp = canvas:new(RES_PATH .."weather/elements/arrow-up.png")	
			canvas:compose(693,178,arrowUp)
		end
	elseif (colum == 4) then
		if (currentCt < #cities and firstCt+10 < #cities) then
			local arrowDown = canvas:new(RES_PATH .."weather/elements/arrow-down.png")
			canvas:compose(910,648,arrowDown)
		end
		if (firstCt > 1) then
			local arrowUp = canvas:new(RES_PATH .."weather/elements/arrow-up.png")	
			canvas:compose(910,178,arrowUp)
		end
	end
end

--- Starts the application
function start()
	background = canvas:new(RES_PATH .."weather/elements/bg-2.png")
	canvas:compose(0,0,background)
	canvas:flush()
	loadFavorites()
	if (internet) then
		paintFavorites()		
	end
	paintScreen1()
end

--- Search an object in a table
-- @param table and object
-- @return true or false
function search(table,obj)
	for i=1,#table do
		if (obj:equals(table[i])) then
			return true
		end
	end
	return false
end

--- Search a name that starts with some letter
-- @param letter and table to search
-- @return index of first word with the letter
function findName(letter,table)
	for i=1, #table do
		local word = replaceString(table[i])
		letra = word:sub(1,1)
		if (letter == letra) then
			return i
		end
	end
end

--- Save selected city to favorites
local function save()
	dofile(RES_PATH .."weather/woeidCities/"..statesFile[currentRg]..".lua")
	local city = Clima:new(locais[cities[currentCt]])
	if (not search(favorites,city)) then
		table.insert(favorites,city)
		table.insert(woeids,city:getWoeid())
		if (idiom == "en") then
			city:changeUnit()
		end
		screen = 1
		lastPosition = currentPosition
		currentPosition = #favorites
		favorites[#favorites]:setCidade(cities[currentCt])
		currentCt = 1
		currentCtBt = 1
		firstCt = 1
		currentCtCha = 1
		currentChaBt = 1
		firstCha = 1
		currentRg = 1
		currentRgBt = 1
		firstRg = 1
		currentRgCha = 1
		colum = 1		
		if (currentPosition > 6) then
			currentExib = 2
		end
		
		paintFavorites()
		paintScreen1()
		
	end
	local woeidFile = io.open(RES_PATH .."weather/woeidFavorite.txt","w")
	woeidFile:write(favorites[1]:getWoeid()..","..favorites[1]:getCidade())
	for i=2, #favorites do
		woeidFile:write("\n"..favorites[i]:getWoeid()..","..favorites[i]:getCidade())
	end
	woeidFile:close()
end

--- Remove selected city from favorites
function forget()
	local tab = {}
	local tab2 = {}
	removed = favorites[currentPosition]
	
	for i,v in ipairs(favorites)do
		if(v:getCidade() ~= favorites[currentPosition]:getCidade())then
			table.insert(tab,v)
		end
	end
	
	for i,v in ipairs(woeids)do
		if(tonumber(v) ~= tonumber(woeids[currentPosition]))then
			table.insert(tab2,v)
		end
	end
	
	favorites = tab
	woeids = tab2
	
	if (currentPosition == #favorites + 1 and currentPosition > 1) then
		lastPosition = currentPosition
		currentPosition = currentPosition - 1
	end
	
	local woeidFile = io.open(RES_PATH .."weather/woeidFavorite.txt","w")
	
	if (#favorites == 0) then
		woeidFile:close()
	else
		woeidFile:write(favorites[1]:getWoeid()..","..favorites[1]:getCidade())
		for i=2, #favorites do
			woeidFile:write("\n"..favorites[i]:getWoeid()..","..favorites[i]:getCidade())
		end
		woeidFile:close()
	end
	
	if(currentPosition < 7)then 
		currentExib = 1 
	end
	paintFavorites()
	paintScreen1()
end

--- Reset all control variables
function reset()
	cities = {}
	favorites = {}
	woeids = {}
	currentPosition = 1
	lastPosition = 1
	currentExib = 1
	currentRgCha = 1
	currentRg = 1
	currentRgBt = 1
	firstRg = 1
	currentCtCha = 1
	currentCt = 1
	currentCtBt = 1
	currentChaBt = 1
	firstCt = 1
	firstCha = 1
	currentFv = 1
	colum = 1
	screen = 1
	details = false
end

--- Move cursor down according the current screen
function moveSelDown()
	if (screen == 1) then
		local temp = currentPosition + 1
		if (currentExib == 1 and temp > 6) then
			currentExib = 2
			paintFavorites()
		end
		if (temp <= #favorites) then
			lastPosition = currentPosition
			currentPosition = temp
			paintScreen1()
		end
	elseif (screen == 2) then
		local temp = currentRgCha + 1
		local temp2 = currentRg + 1
		local temp3 = currentCtCha + 1
		local temp4 = currentCt + 1

		if (colum == 2 and currentRgBt == 11 and temp2 <= #statesFile) then
			firstRg = firstRg + 1
		
		elseif(colum == 3 and currentChaBt == 11 and temp3 <= #charac2) then
			firstCha = firstCha + 1
		
		elseif(colum == 4 and currentCtBt == 11 and temp4 <= #cities) then
			firstCt = firstCt + 1
	
		end		

		if (temp <= 11 and colum == 1) then
			currentRgCha = temp
			
		elseif (temp2 <= #statesFile and colum == 2) then
			if (currentRgBt < 11) then
				currentRgBt = currentRgBt + 1
			end			
			currentRg = temp2
			if (statesName[currentRg]:sub(1,1) ~= charac[currentRgCha]) then
				currentRgCha = currentRgCha + 1
			end
		
		elseif (temp3 <= #charac2 and colum == 3) then
			if (currentChaBt < 11) then
				currentChaBt = currentChaBt + 1
			end
			currentCtCha = temp3
		elseif (temp4 <= #cities and colum == 4) then
			if (currentCtBt < 11) then
				currentCtBt = currentCtBt + 1
			end
			currentCt = temp4
			if (cities[currentCt]:sub(1,1) ~= charac2[currentCtCha]) then
				local word = replaceString(cities[currentCt])
				letra = word:sub(1,1)				
				while ((letra ~= charac2[currentCtCha])) do
					currentCtCha = currentCtCha + 1
					if (currentChaBt < 11) then
						currentChaBt = currentChaBt + 1
					else
						firstCha = firstCha + 1
					end
					if (currentCtCha > #charac2)  then
						currentCtCha = 1
						firstCha = 1
						currentChaBt = 1
					end
				end
			end
		end
		paintScreen2()
	end
end

--- Move cursor up  according the current screen
function moveSelUp()
	if (screen == 1) then
		local temp = currentPosition - 1
		if (currentExib == 2 and temp < 7) then
			currentExib = 1
			paintFavorites()
		end
		if (temp > 0) then
			lastPosition = currentPosition
			currentPosition = temp
			paintScreen1()
		end
	elseif (screen == 2) then
		local temp = currentRgCha - 1
		local temp2 = currentRg - 1
		local temp3 = currentCtCha - 1
		local temp4 = currentCt - 1
		if (colum == 2 and currentRgBt == 1 and temp2 > 0) then
			firstRg = firstRg - 1
		
		elseif(colum == 3 and currentChaBt == 1 and temp3 > 0) then
			firstCha = firstCha - 1
			
		elseif(colum == 4 and currentCtBt == 1 and temp4 > 0) then
			firstCt = firstCt - 1
			
		end
		if (temp > 0 and colum == 1) then
			currentRgCha = temp
			
		elseif (temp2 > 0 and colum == 2) then
			if (currentRgBt > 1) then
				currentRgBt = currentRgBt - 1
			end
			currentRg = temp2
			if (statesName[currentRg]:sub(1,1) ~= charac[currentRgCha]) then
				currentRgCha = currentRgCha - 1
			end
			
		elseif (temp3 > 0 and colum == 3) then
			if (currentChaBt > 1) then
				currentChaBt = currentChaBt - 1
			end
			currentCtCha = temp3
			
		elseif (temp4 > 0 and colum == 4) then
			if (currentCtBt > 1) then
				currentCtBt = currentCtBt - 1
			end
			currentCt = temp4
			if (cities[currentCt]:sub(1,1) ~= charac2[currentCtCha]) then
				local word = replaceString(cities[currentCt])
				letra = word:sub(1,1)
				while ((letra ~= charac2[currentCtCha])) do
					currentCtCha = currentCtCha - 1
					if (currentChaBt <= 11 and currentChaBt > 1) then
						currentChaBt = currentChaBt - 1
					else
						firstCha = firstCha - 1
					end
					if (currentCtCha == 0)  then
						currentCtCha = #charac2
						firstCha = 16
						currentChaBt = 11
					end
				end
			end
			
		end
		paintScreen2()
	end
end

--- Move cursor right
function moveSelRight()
	local temp = currentPosition + 2
	if (currentExib == 1 and temp >= 7 and #favorites > 6) then
		currentExib = 2
		paintFavorites()
	end	
	if (temp <= #favorites) then
		lastPosition = currentPosition
		currentPosition = temp
		paintScreen1()
	end	
end

--- Move cursor left
function moveSelLeft()
	local temp = currentPosition - 2
	if (currentExib == 2 and temp < 7) then
		currentExib = 1
		paintFavorites()
	end
	if (temp > 0) then
		lastPosition = currentPosition
		currentPosition = temp		
		paintScreen1()
	end
end

function limpa()
	w, h = canvas:measureText(removed:getCidade()..words[32])
	canvas:compose(1150 - w,42,background,1150 - w,42,w,h)
	canvas:flush()
end
--- Captures events
function handlerW(evt)
	if (evt.class == 'key' and evt.type == 'press' and screen == 1) then
		if (evt.key == 'CURSOR_UP') then
			moveSelUp()
		
		elseif (evt.key == 'CURSOR_DOWN') then
			moveSelDown()
		
		elseif (evt.key == 'CURSOR_RIGHT') then
			moveSelRight()

		elseif (evt.key == 'CURSOR_LEFT') then
			moveSelLeft()

		elseif (evt.key == 'BLUE') then
			if (#favorites > 0 or not internet) then
				background = canvas:new(RES_PATH .."weather/elements/bg-2.png")
				favorites = {}
				loadFavorites()
				if (internet) then
					paintFavorites()
				end
				
				paintScreen1()								
			end

		elseif (evt.key == 'GREEN' and internet) then
			if (#favorites < 12) then
				lastPosition = currentPosition
				currentPosition = 1
				currentExib = 1
				screen = 2
				background = canvas:new(RES_PATH .."weather/elements/bg-2.png")
				canvas:clear()
				canvas:compose(0,0,background)
				paintScreen2()			
			end
			
		elseif (evt.key == 'RED' and internet) then
			if (#favorites > 0) then
				forget()
				canvas:attrFont("Tirésias",25)
				w, h = canvas:measureText(removed:getCidade()..words[32])
				canvas:drawText(1150 - w,42,removed:getCidade()..words[32])
				event.timer(4000,limpa)
				canvas:flush()
			end
		
		elseif (evt.key == 'YELLOW' and internet) then
			if (#favorites > 0 and not details) then
				paintDetails()
			elseif(details)then
				paintForecast()
				paintControls()
				canvas:flush()
			end
		
		elseif (evt.key == 'BACK') then
			canvas:clear()
			background = canvas:new(RES_PATH .."portal/background.png")
			reset()
			event.unregister(handlerW)
			registerMain()
			
		elseif (evt.key == 'EXIT') then
			event.unregister(handlerW)
			local app = applicationManager.getRunningApplication()
			canvas:attrColor('black')
			applicationManager.stopApplication(app["id"])
		end
	end
	
	if (evt.class == 'key' and evt.type == 'press' and screen == 2) then
		if (evt.key == 'CURSOR_UP') then
			moveSelUp()
		
		elseif (evt.key == 'CURSOR_DOWN') then
			moveSelDown()
			
		elseif (evt.key == 'EXIT') then
			event.unregister(handlerW)
			local app = applicationManager.getRunningApplication()
			canvas:attrColor('black')
			applicationManager.stopApplication(app["id"])
		
		elseif (evt.key == 'BACK' or evt.key == 'CURSOR_LEFT') then
			local temp = colum - 1
			if (temp > 0) then
				if (colum == 2) then
					currentRg = 1
					currentRgBt = 1
					firstRg = 1
				elseif (colum == 3) then
					currentCtCha = 1
					currentChaBt = 1
					firstCha = 1
					canvas:compose(663,166,background,663,166,500,503)
				elseif (colum == 4) then
					currentCt = 1
					currentCtBt = 1
					firstCt = 1
				end
				colum = temp
				paintScreen2()
			end
			if (temp == 0 and evt.key == 'BACK') then
					background = canvas:new(RES_PATH .."weather/elements/bg-1.png")
					canvas:compose(0,0,background)
					currentRgCha = 1
					screen = 1
					paintFavorites()
					paintScreen1()
			end
		
		elseif (evt.key == 'ENTER' or evt.key == 'CURSOR_RIGHT') then			
			if (colum == 4 and #favorites < 12 and evt.key == 'ENTER') then
					save()
			end
			
			local temp = colum + 1
			if (temp <= 4) then
				local find = false
				if (colum == 1) then
					local index = findName(charac[currentRgCha],statesName)
					if (index ~= nil) then
						local first = index
						
						while ((first + 10) > #statesName) do
							first = first - 1
							currentRgBt = currentRgBt + 1
						end
						
						firstRg = first
						currentRg =index
						find = true
					end
				elseif (colum == 2) then
					cities = {}
					find = true
					loadCities()
				elseif (colum == 3) then
					local index = findName(charac2[currentCtCha],cities)
					local temp = currentCtCha
					
					while (index == nil) do
						temp = temp + 1
						if (temp > #charac2) then
							temp = 1
						end
						 index = findName(charac2[temp],cities)
					end
					
					if (index ~= nil) then
						local first = index
						while ((first + 10) > #cities and #cities > 10) do
							first = first - 1
							currentCtBt = currentCtBt + 1
						end
						firstCt = first
						currentCt = index
						find = true
					end					
				end
				
				if (screen == 2 and find == true) then
					colum = temp
					paintRegions()				
					paintScreen2()
				end
			end
		end
	end
end


--- Starts application
function registerWeather()
	start()
	event.register(handlerW)
end
