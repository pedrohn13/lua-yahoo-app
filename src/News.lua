--@class news
News = {title = {}, description = {}, day = {}}

---create a new object of instance New
-- @param table
-- @return table
function News:new (object)
    object = object or {}
    setmetatable(object, self)
    self.__index = self
    return object
end

---adds a string in table title of object New
--@param String

function News:appendTitle(title)
    table.insert(self.title, title)
end

---adds a string in table day of object New
--@param String
function News:appendDay(day)
    table.insert(self.day, day)
end

---adds a string in table description of object New
--@param String
function News:appendDescription(description)
    table.insert(self.description, description)
end
