
---@class
languages = {}

--- create a new object of instance Languages
function languages:new()

	idiom = {}
	idiom['pt'] = {{},{},{}} 
	idiom['en']    = {{},{},{}} 
	idiom['sp']    = {{},{},{}}
	
	setmetatable(idiom,self)
	self.__index = self
	return idiom

end

--- Add a word in three idioms, to list of names of the categories
--- @param Strings
function languages:addWordCategory(portuguese, english, spanish)
	table.insert(idiom['pt'][1], portuguese)
	table.insert(idiom['en'][1], english)
	table.insert(idiom['sp'][1], spanish)
	
end

--- Add a word in three idioms, to list of names of the shortcut
--- @param Strings
function languages:addWordShortcut(portuguese, english, spanish)
	table.insert(idiom['pt'][2], portuguese)
	table.insert(idiom['en'][2], english)
	table.insert(idiom['sp'][2], spanish)
end

--- Add a word in three idioms, to list of names of the controls
--- @param Strings
function languages:addWordControls(portuguese, english, spanish)
	table.insert(idiom['pt'][3], portuguese)
	table.insert(idiom['en'][3], english)
	table.insert(idiom['sp'][3], spanish)
end

--- return a word, in the current idiom of the list of categories.
--- @param number
--- @return string
function languages:getWordCategory(n)
	return idiom[currentIdiom][1][n]
end

--- return a word, in the current idiom of the list of shortcut.
--- @param number
--- @return string
function languages:getWordShortcut(n)
	return idiom[currentIdiom][2][n]
end

--- return a word, in the current idiom of the list of controls.
--- @param number
--- @return string
function languages:getWordControls(n)
	return idiom[currentIdiom][3][n]
end

