package.path = "../src/?.lua;".. package.path

require "lunit"
require "Tempo"
require "xml"
require "mainWeather"


pag =  [[ <?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
		<rss version="2.0" xmlns:yweather="http://xml.weather.yahoo.com/ns/rss/1.0" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#">
			<channel>
		
<title>Yahoo! Weather - Los Angeles, CA</title>
<link>http://us.rd.yahoo.com/dailynews/rss/weather/Los_Angeles__CA/*http://weather.yahoo.com/forecast/USCA0638_c.html</link>
<description>Yahoo! Weather for Los Angeles, CA</description>
<language>en-us</language>
<lastBuildDate>Mon, 23 Jul 2012 11:47 am PDT</lastBuildDate>
<ttl>60</ttl>
<yweather:location city="Los Angeles" region="CA"   country="United States"/>
<yweather:units temperature="C" distance="km" pressure="mb" speed="km/h"/>
<yweather:wind chill="24"   direction="0"   speed="0" />
<yweather:atmosphere humidity="60"  visibility="11.27"  pressure="1014.1"  rising="1" />
<yweather:astronomy sunrise="5:57 am"   sunset="8:00 pm"/>
<image>
<title>Yahoo! Weather</title>
<width>142</width>
<height>18</height>
<link>http://weather.yahoo.com</link>
<url>http://l.yimg.com/a/i/brand/purplelogo//uh/us/news-wea.gif</url>
</image>
<item>
<title>Conditions for Los Angeles, CA at 11:47 am PDT</title>
<geo:lat>34.05</geo:lat>
<geo:long>-118.25</geo:long>
<link>http://us.rd.yahoo.com/dailynews/rss/weather/Los_Angeles__CA/*http://weather.yahoo.com/forecast/USCA0638_c.html</link>
<pubDate>Mon, 23 Jul 2012 11:47 am PDT</pubDate>
<yweather:condition  text="Fair"  code="34"  temp="24"  date="Mon, 23 Jul 2012 11:47 am PDT" />
<description><![CDATA[
<img src="http://l.yimg.com/a/i/us/we/52/34.gif"/><br />
<b>Current Conditions:</b><br />
Fair, 24 C<BR />
<BR /><b>Forecast:</b><BR />
Mon - Sunny. High: 24 Low: 18<br />
Tue - Partly Cloudy. High: 26 Low: 17<br />
<br />
<a href="http://us.rd.yahoo.com/dailynews/rss/weather/Los_Angeles__CA/*http://weather.yahoo.com/forecast/USCA0638_c.html">Full Forecast at Yahoo! Weather</a><BR/><BR/>
(provided by <a href="http://www.weather.com" >The Weather Channel</a>)<br/>
></description>
<yweather:forecast day="Mon" date="23 Jul 2012" low="18" high="24" text="Sunny" code="32" />
<yweather:forecast day="Tue" date="24 Jul 2012" low="17" high="26" text="Partly Cloudy" code="30" />
<guid isPermaLink="false">USCA0638_2012_07_24_7_00_PDT</guid>
</item>
</channel>
</rss>

<!-- api12.weather.ac4.yahoo.com Mon Jul 23 19:50:12 PST 2012 -->
]]

local parser = require("xml").newParser()
	page = pag:gsub("r:", "r")
	page = parser:ParseXmlText(page)


module( "TempoTest", package.seeall, lunit.testcase )

function setup()
	day = data(page)
	cidade, estado, pais = localizacao(page)
	unit = unidades(page)
	st, dv, v = vento(page)
	h, vi, p, r = atmosfera(page)
	ns, ps = astronomia(page)
	con, tem = condicoesClimaticas(page)
	hoje = previsaoParaHoje(page)
	amanha = previsaoParaAmanha(page)
	
	woeid ={} -- table 
	woeid[1] = '455839'
	woeid[2] = '455820'
	woeid[3] = '455821'
	woeid[4] = '455936'
	woeid[5] = '455819'
	woeid[6] = '455849'
	woeid[7] = '455829'
	woeid[8] = '455822'
	woeid[9] = '455861'
	woeid[10] = '455830'
	woeid[11] = '455831'
	woeid[12] = '455872'
	woeid[13] = '455970'
	woeid[14] = '455880'
	woeid[15] = '455833'
	woeid[16] = '455888'
	woeid[17] = '457721'
	woeid[18] = '455823'
	woeid[19] = '455901'
	woeid[20] = '455824'
	woeid[21] = '455904'
	woeid[22] = '455825'
	woeid[23] = '455826'
	woeid[24] = '455834'
	woeid[25] = '455827'
	woeid[26] = '455835'
	woeid[27] = '455922'
	woeid[28] = '455848'
end

function test_localizacao()
	assert_equal("Los Angeles",cidade)
	assert_equal("CA",estado)
	assert_equal("United States",pais)
end

function test_unidades()
	assert_equal("C",unit.temp)
	assert_equal("km",unit.dist)
	assert_equal("mb",unit.press)
	assert_equal("km/h",unit.vel)
end

function test_vento()
	assert_equal("24",st)
	assert_equal("Norte",dv)
	assert_equal("0",v)
end

function test_atmosfera()	
	assert_equal("60",h)
	assert_equal("11.27",vi)
	assert_equal("1014.1",p)
	assert_equal("Elevando-se",r)
end

function test_astronomia()
	assert_equal("5:57 am",ns)
	assert_equal("8:00 pm",ps)
end

function test_condicoesClimaticas()
	assert_equal("Céu Limpo (dia)",con.text)
	assert_equal("24",tem)
end

function test_previsaoHoje()
	assert_equal("18",hoje.min)
	assert_equal("24",hoje.max)
	assert_equal("Ensolarado",hoje.condicaoCli.text)	
end

function test_previsaoAmanha()
	assert_equal("17",amanha.min)
	assert_equal("26",amanha.max)
	assert_equal("Parcialmente nublado (dia)",amanha.condicaoCli.text)	
end

function test_search_save()
	city1 = Clima:new('455827')
	city2 = Clima:new('455819')
	favorite = {city1}
	
	assert_true(search(favorite,city1))
	assert_false(search(favorite,city2))
	-- function search() to search a city is already added and
	-- allows the function save() is executed.
end

function test_internetConnection()
	for i,v in ipairs(woeid) do
		assert_not_equal(false, Clima:new(v))
	end
end



