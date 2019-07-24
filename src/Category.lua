require "News"
require "translateDate"
require "html"

local xml = require("xml").newParser()

--@class
Category = {name = nil, url = nil, news = {}}


--- create a new object of instance Category
-- @param table
-- @return table
function Category:new (object)
    object = object or {}
    setmetatable(object, self)
    self.__index = self
    return object
end


--Adds a object New in table of object Category
--@param Object of instance New
function Category:appendNews(new)
    table.insert(self.news,new)
end


---search news in url of object and adds in table
--@return boolean
function Category:loadingNews()
    self.news = {}
    local text
   
    if(isLocal)then
		if(#self.name == 3)then
			local file = io.open(MOCK_PATH .. "XMLs News/".. self.name[1] .. ".xml", "r")
			text = file:read("*a") 
		else
			local file = io.open(MOCK_PATH .. "XMLs News/".. self.name .. ".xml", "r")
			text = file:read("*a")
		end
    else
		local lib = require("request") 
		text = lib.downloadInformation(self.url)
    end
   
    if(text == nil or string.sub(text,3,5) ~= "xml") then
		print("Connection failed")
		local newsFail = News:new({title = {}, day = {}, description ={}})
		newsFail:appendTitle(" ")
		newsFail:appendDescription("A conexão falhou! Use a função atualizar para tentar novamete")
		newsFail:appendDay(" ")
		self:appendNews(newsFail)
		return false
    end
    
    local parsedxml = xml:ParseXmlText(text)
	
    for i,child in ipairs(parsedxml.rss.channel:children()) do
        if(child:name()=="item") then

            local new = News:new({title = {}, day = {}, description ={}})
            new:appendTitle(child.title:value())
            new:appendDay(filterDate(child.pubDate:value()))

            if(string.sub(child.description:value(),1,1) == "<") then
                new:appendDescription(HTML_ToText(child.description:value()))
            else
                new:appendDescription(child.description:value())
            end
            self:appendNews(new)
        end
    end
    return true
end

--- return titles of news
--@param number
--@return string
function Category:showTitle(index)
	return self.news[index].title[1]

end

---return date of news
--@param number
--@return string
function Category:showDate(index)
	return self.news[index].day[1]
end

---return titles of news
--@param number
--@return string
function Category:showDescription(index)
    return self.news[index].description[1]
end

---Show the background image in category
function Category:showBackground()
	categoryBackground = canvas:new(RES_PATH .. "news/elements/icones_bg_tela2/" .. self.name[1] .. ".png")
	canvas:compose(350,70,categoryBackground)
end


