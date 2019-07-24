---@class 
package.path = package.path ..";".. RES_PATH.."weather/?.lua"

local idiom = currentIdiom

local words = {} 

require 'loadIcon'
require 'utils'
require 'weatherLang'

--- Idiom selection
if (idiom == "pt") then
	require 'conditionPT'
	words = wordsPT
elseif (idiom == "en") then
	require 'conditionEN'
	words = wordsEN
elseif (idiom == "sp") then
	require 'conditionSP'
	words = wordsSP
else
	require 'conditionPT'
	words = wordsPT
end

--- get the weather condition text, icon and background image according to a number passed as parameter
function getCondic(num)
	local con = tonumber(num)
	local n = con
	
	if (con == 0 or con == 2) then
		n = 2
	elseif (con == 1 or con == 3 or con == 4 or con == 11 or con == 12 or con == 40) then
		n = 4
	elseif (con == 5 or con == 6 or con == 7 or con == 8 or con == 10 or
			con == 13 or con == 14 or con == 15 or con == 16 or con == 17 or con == 18 or
			con == 25 or con == 35 or con == 41 or con == 42 or con == 43 or con == 46) then
				n = 25
	elseif (con == 19 or con == 22) then
		n = 19
	elseif (con == 20 or con == 21 or con == 26) then
		n = 26
	elseif (con == 23 or con == 24) then
		n = 23
	elseif (con == 27 or con == 29) then
		n = 29
	elseif (con == 28 or con == 30 or con == 44) then
		n = 30
	elseif (con == 31 or con == 33) then
		n = 31
	elseif (con == 32 or con == 34 or con == 36) then
		n = 32
	elseif (con == 37 or con == 38 or con == 39 or con == 45 or con == 47) then
		n = 45
	end
	
	local iconB = RES_PATH .."weather/icons/"..n.."b.png"
	return {text = condition[con], ic1 = iconB, id = n}
end

--- get the date from a xml page 
--@param xmlPage
--@return date
function data(parsedXml)
	local data = parsedXml.rss.channel:children()[5]:value()
	a, b = data:find("m")
	data = data:sub(1, a)
	data = traduzData(data)
	return data
end

--- translate date to brazilian format
--@param date in american format
--@return date in brazilian format
function traduzData(data)
   local sp1 = split(data, ',')
   local sp2 = split(sp1[2], ' ')
   
   month = sp2[3]

   local months = {Jan= '01', Feb= '02', Mar= '03', Apr= '04', May= '05',
                   Jun= '06', Jul= '07', Aug= '08', Sep= '09', Oct= '10',
                   Nov= '11', Dec= '12'}
                   
  local d = sp2[2].."/"..months[month].."/"..sp2[4]
  local h = sp2[5].." "..sp2[6]

  return {day = d, hour = h}
end

--- get the location from a xml page 
--@param xmlPage
--@return city, region and country 
function localizacao(parsedXml)
	local tag = parsedXml.rss.channel:children()[7]
	local cidade = tag["@city"]
	local estado = tag["@region"]
	local pais = tag["@country"]
	return cidade, estado, pais
end

--- get the unit symbols from a xml page 
--@param xmlPage
--@return table with temperature unit, distance unit, speed unit and pressure unit
function unidades(parsedXml)
	local tag = parsedXml.rss.channel:children()[8]
	local temperatura = tag["@temperature"]
	local distancia = tag["@distance"]
	local velocidade = tag["@speed"]
	local pressao = tag["@pressure"]
	return {temp = temperatura, dist = distancia, vel = velocidade, press = pressao}
end

--- get the wind  direction according the angle degree 
--@param angle degree
--@return direction string
function direcaoVento(string)
	local value = tonumber(string)
	if (value >= 338 or value < 23) then result = words[13]
	elseif (value >= 23 and value < 68) then result = words[14]
	elseif (value >= 68 and value < 113) then result = words[15]
	elseif (value >= 113 and value < 158) then result = words[16]
	elseif (value >= 158 and value < 203) then result = words[17]
	elseif (value >= 203 and value < 248) then result = words[18]
	elseif (value >= 248 and value < 293) then result = words[19]
	elseif (value >= 293 and value < 338) then result = words[20] end
	return result
end

--- get the wind information from a xml page 
--@param xmlPage
--@return chill, direction and speed
function vento(parsedXml)
	local tag = parsedXml.rss.channel:children()[9]
	local sensacaoTermica = tag["@chill"]
	local direcao = tag["@direction"]
	local velocidade = tag["@speed"]
	return sensacaoTermica, direcaoVento(direcao), velocidade
end

--- get the atmosphere information from a xml page 
--@param xmlPage
--@return humidity, visibility, pressure and pressure rise 
function atmosfera(parsedXml)
	local tag = parsedXml.rss.channel:children()[10]
	local humidade = tag["@humidity"]
	local visibilidade = tag["@visibility"]
	local pressao = tag["@pressure"]
	local rise = tag["@rising"]
	if (rise == "0") then
		rising = "Estável"
	elseif (rise == "1") then
		rising = "Elevando-se"
	elseif (rise == "2") then
		rising = "Caindo"
	end
	return humidade, visibilidade, pressao, rising
end

--- get the astronomy information from a xml page 
--@param xmlPage
--@return hours of sunrise and sunset
function astronomia(parsedXml)
	local tag = parsedXml.rss.channel:children()[11]
	local nascerDoSol = tag["@sunrise"]
	local porDoSol = tag["@sunset"]
	return nascerDoSol, porDoSol
end

--- get the weather condition from a xml page 
--@param xmlPage
--@return table with weather condition midias(text,icon and background) and current temperature
function condicoesClimaticas(parsedXml)
	local tag = parsedXml.rss.channel:children()[13].yweathercondition
	local condic = tag["@code"]
	local temperatura = tag["@temp"]
	return getCondic(condic), temperatura
end

--- get the weather forecast for the rest of the day from a xml page 
--@param xmlPage
--@return table with weather condition, minimum and maximum temperature
function previsaoParaHoje(parsedXml)
	local tag = parsedXml.rss.channel:children()[13].yweatherforecast[1]
	local mini = tag["@low"]
	local maxi = tag["@high"]
	local condicao =  getCondic(tag["@code"])
	return {min = mini, max = maxi, condicaoCli = condicao}
end

--- get the weather forecast for tomorrow from a xml page 
--@param xmlPage
--@return table with weather condition, minimum and maximum temperature
function previsaoParaAmanha(parsedXml)
	local tag = parsedXml.rss.channel:children()[13].yweatherforecast[2]
	local mini = tag["@low"]
	local maxi = tag["@high"]
	local condicao = getCondic(tag["@code"])
	return {min = mini, max = maxi, condicaoCli = condicao}
end

Clima = {cidade = "", estado = "", pais = "", data = {}, unidades = {}, sensacaoTermica = "",
	dirVento = "", velVento = "", humidadeDoAr = "", visibilidade = "", pressao = "",
	rise = "", nascerDoSol = "", porDoSol = "", condicaoClimatica = "", temperatura = "",
	previsaoDeHoje = {}, previsaoDeAmanha = {}}

--- constructor
function Clima:new(cod)
	local page
	
	if(isLocal)then
		local file = io.open(MOCK_PATH .. "XMLs Weather/" .. cod .. ".xml", "r")
		page = file:read("*a")
	
	else
		local lib = require("request")
		local url = "http://weather.yahooapis.com/forecastrss?w=" ..cod.."&u=c" 
		page = lib.downloadInformation(url) 
	end
	
	if (page == nil) then 
		print("Connection failed")
		return false
	end
	
	local parser = require("xml").newParser()
	page = page:gsub("r:", "r")
	page = parser:ParseXmlText(page)
	if (page.rss.channel:children()[1]:value() == "Yahoo! Weather - Error") then error("verifique o nome da cidade") end
	city, region, country = localizacao(page)
	date = data(page)
	units = unidades(page)
	sensacao, direcVento, velocVento = vento(page)
	humidade, visibility, pressure, rising = atmosfera(page)
	nascer, por = astronomia(page)
	condicao, temp = condicoesClimaticas(page)
	previsaoHoje = previsaoParaHoje(page)
	previsaoAmanha = previsaoParaAmanha(page)
	
	if(tonumber(temp) < tonumber(previsaoHoje.min)) then
		previsaoHoje.min = temp
	end
	
	if(tonumber(temp) > tonumber(previsaoHoje.max)) then
		previsaoHoje.max = temp
	end
	
	local table = {cidade = city, estado = region, pais = country, data = date, unidades = units, sensacaoTermica = sensacao,
	dirVento = direcVento, velVento = velocVento, humidadeDoAr = humidade, visibilidade = visibility, pressao = pressure,
	rise = rising, nascerDoSol = nascer, porDoSol = por, condicaoClimatica = condicao, temperatura = temp,
	previsaoDeHoje = previsaoHoje, previsaoDeAmanha = previsaoAmanha, woeid = cod}
	setmetatable(table, self)
	self.__index = self
	return table
end


--- Change the defalt units to US system or BR system
function Clima:changeUnit()
        if (self.unidades.temp == "C") then

                self.unidades.temp = "F"
                self.unidades.dist = "mi"
                self.unidades.press = "in"
                self.unidades.vel = "mph"
	
                self.temperatura = string.format("%.0f",self.temperatura*(9/5) + 32)
                self.sensacaoTermica = string.format("%.0f",(self.sensacaoTermica*(9/5)) + 32)
                self.previsaoDeHoje.min = string.format("%.0f",(self.previsaoDeHoje.min*(9/5)) + 32)
                self.previsaoDeHoje.max = string.format("%.0f",(self.previsaoDeHoje.max*(9/5)) + 32)
                self.previsaoDeAmanha.min = string.format("%.0f",(self.previsaoDeAmanha.min*(9/5)) + 32)
                self.previsaoDeAmanha.max = string.format("%.0f",(self.previsaoDeAmanha.max*(9/5)) + 32)

                self.visibilidade = string.format("%.2f",self.visibilidade / 1.61)
                self.velVento = self.velVento / 1.61
                self.pressao = self.pressao * 0.03
	
        elseif (self.unidades.temp == "F") then

                self.unidades.temp = "C"
                self.unidades.dist = "km"
                self.unidades.press = "mb"
                self.unidades.vel = "km/h"

                self.temperatura = (self.temperatura - 32) / 1.8
                self.sensacaoTermica = (self.sensacaoTermica - 32) / 1.8
                self.previsaoDeHoje.min = (self.previsaoDeHoje.min - 32) / 1.8
                self.previsaoDeHoje.max = (self.previsaoDeHoje.max - 32) / 1.8
                self.previsaoDeAmanha.min = (self.previsaoDeAmanha.min - 32) / 1.8
                self.previsaoDeAmanha.max = (self.previsaoDeAmanha.max - 32) / 1.8

                self.visibilidade = self.visibilidade * 1.61
                self.velVento = self.velVento * 1.61
                self.pressao = self.pressao / 0.03

        end
end

--- get Woeid code
--@return string
function Clima:getWoeid()
	return self.woeid
end

--- get table with units symbols
--@return table
function Clima:getUnidades()
	return self.unidades
end

--- get tomorrow weather forecast
--@return table
function Clima:getPrevisaoDeAmanha()
	return self.previsaoDeAmanha
end

--- get tomorrow weather forecast
--@return table
function Clima:getPrevisaoDeHoje()
	return self.previsaoDeHoje
end

--- get current temperature
--@return string
function Clima:getTemperatura()
	return self.temperatura
end

--- get current temperature unit
--@return string
function Clima:getUnitTemp()
	return "°"..self.unidades.temp
end

--- get current weather condition
--@return table
function Clima:getCondicaoClimatica()
	return self.condicaoClimatica
end

--- get hours sunset
--@return string
function Clima:getPorDoSol()
	return self.porDoSol
end

--- get hours sunrise
--@return string
function Clima:getNascerDoSol()
	return self.nascerDoSol
end

--- get hours sunset
--@return string
function Clima:getRise()
	return self.rise
end

--- get pressure
--@return string
function Clima:getPressao()
	return self.pressao .. " " .. self.unidades.press
end

--- get visibility
--@return string
function Clima:getVisibilidade()
	return self.visibilidade .. " " .. self.unidades.dist
end

--- get humidity
--@return string
function Clima:getUmidadeDoAr()
	return self.humidadeDoAr.."%"
end

--- get wind speed 
--@return string
function Clima:getVelVento()
	return self.velVento .. " " .. self.unidades.vel
end

--- get wind direction
--@return string
function Clima:getDirVento()
	return self.dirVento
end

--- get chill
--@return string
function Clima:getSensacaoTermica()
	return self.sensacaoTermica.."°"..self.unidades.temp
end

--- get date
--@return string
function Clima:getData()
	return self.data
end

--- get country name
--@return string
function Clima:getPais()
	return self.pais
end

--- get city name
--@return string
function Clima:getCidade()
	return self.cidade
end

--- set city name
function Clima:setCidade(name)
	self.cidade = name
end

--- get region name
--@return string
function Clima:getEstado()
	return self.estado
end

--- compare if two Clima are equals
--@param Clima
--@return boolean
function Clima:equals(clima2)
	if (tonumber(self:getWoeid()) == tonumber(clima2:getWoeid())) then
		return true
	end
	return false
end

--- centralize string in a frame
-- @param string and frame width
-- @return x position to draw the text
function centralize(string,width)
	local w = 0
	local h = 0
	w, h = canvas:measureText(string)
	local point = (width/2) - (w/2)
	if (point > 0) then
		return point
	else
		return 0
	end
end

--- Show weather forecast in screen
function Clima:paintInfo()
	canvas:attrColor(84, 112, 114, 255)
	canvas:attrFont("Tirésias",20)
	canvas:drawText(465, 300, words[21])
	canvas:drawText(590 , 300 , words[22])
	canvas:attrFont("Tirésias",17)
	canvas:drawText(1020, 220, words[21])
	canvas:drawText(1021 , 280 , words[22])
	canvas:drawText(700,180,words[23])
	canvas:drawText(700,197,words[24])	
	canvas:drawText(702,280,words[25])
	canvas:drawText(702,297,words[26])
	
	canvas:attrColor (224, 115, 7, 255)
  	canvas:attrFont("Tirésias",45,"bold")  	
	canvas:drawText(centralize(self:getCidade(),1280),105,self:getCidade())	
	canvas:attrFont("Tirésias",26)
	canvas:drawText(913,165,words[27])
	canvas:attrFont("Tirésias",128)
	canvas:drawText(450,150,self:getTemperatura())
	canvas:attrFont("Tirésias",60)
	canvas:drawText(600,165,self:getUnitTemp())
	canvas:attrFont("Tirésias",33)
	canvas:drawText(700,215,self:getSensacaoTermica())
	canvas:drawText(700,310,self:getUmidadeDoAr())
	
	canvas:attrColor (128, 128, 128, 255)
	canvas:attrFont("Tirésias",20)
	canvas:drawText(155,350,self:getCondicaoClimatica().text)
	canvas:attrFont("Tirésias",15)
	canvas:drawText(815,330,self:getPrevisaoDeAmanha().condicaoCli.text)
	
	local icon1 = loadIcon(self:getCondicaoClimatica().id)
	icon1:attrScale(300, true)	
	canvas:compose(135,150,icon1)
	
	local icon2 = loadIcon(self:getPrevisaoDeAmanha().condicaoCli.id)
	icon2:attrScale(180, true)		
	canvas:compose(795,215,icon2)	
	
	canvas:attrColor (101, 180, 225, 255)
	canvas:attrFont("Tirésias",40)		
	canvas:drawText(445,320,self:getPrevisaoDeHoje().min..self:getUnitTemp())
	canvas:attrFont("Tirésias",33)
	canvas:drawText(1000,230,self:getPrevisaoDeAmanha().min..self:getUnitTemp())
	
	canvas:attrColor (227, 78, 84, 255)
	canvas:drawText(1000,290,self:getPrevisaoDeAmanha().max..self:getUnitTemp())
	canvas:attrFont("Tirésias",40)		
	canvas:drawText(565,320,self:getPrevisaoDeHoje().max..self:getUnitTemp())	
end

--- Show weather forecast detailed
function Clima:paintMoreInfo()

	canvas:attrColor(84, 112, 114, 255)	
	canvas:attrFont("Tirésias",17)
	canvas:drawText(820,197,words[28])		
	canvas:drawText(982,197,words[30])		
	canvas:drawText(825,297,words[29])	
	canvas:drawText(1002,280,words[31])
	
	canvas:attrColor (224, 115, 7, 255)  	
	canvas:attrFont("Tirésias",33)	
	canvas:drawText(810,215,self:getNascerDoSol())
	canvas:drawText(810,310,self:getPorDoSol())
	canvas:drawText(967,215,self:getVisibilidade())
	canvas:attrFont("Tirésias",24)
	canvas:drawText(967, 300, self:getVelVento())
	canvas:drawText(980, 330, self:getDirVento())	
end

--- Shows weather mini forecast
function Clima:paintMini(x,y)
	canvas:attrColor(224, 115, 7, 255)
  	canvas:attrFont("Tirésias",20)
	canvas:drawText(x + centralize(self:getCidade(),349), y + 19,self:getCidade())
	
	local icon = loadIcon(self:getCondicaoClimatica().id)
	icon:attrScale(100, true)
	canvas:compose(x + 25, y + 35, icon)
	
	canvas:attrColor(84, 112, 114, 255)
	canvas:attrFont("Tirésias",17)
	canvas:drawText(x + 143, y + 47 , words[21])
	canvas:drawText(x + 243, y + 47 , words[22])
	
	canvas:attrFont("Tirésias",33)
	canvas:attrColor (101, 180, 225, 255)	
	canvas:drawText(x + 140,y + 60,self:getPrevisaoDeHoje().min..self:getUnitTemp())	
	canvas:attrColor (227, 78, 84, 255)	
	canvas:drawText(x + 240,y + 60,self:getPrevisaoDeHoje().max..self:getUnitTemp())
end
