package.path = "../src/?.lua;".. package.path
require "lunit"
require "Languages"

module("testLanguages", package.seeall, lunit.testcase )

function setup()
	currentIdiom = "pt"
end

function addWordCategory()
	language = languages:new()
	language:addWordCategory("Mundo", "World", "Mundo")
	assert_equal("Mundo", language:getWordCategory(1))
	
	language = languages:new()
	language:addWordCategory("Mundo", "World", "Mundo")
	assert_equal("World", language:getWordCategory(1))
	
	language = languages:new()
	language:addWordCategory("Mundo", "World", "Mundo")
	assert_equal("Mundo", language:getWordCategory(1))
end

function addWordShortcut()
	language = languages:new()
	language:addWordShortcut("Cinema", "Cinema", "Cine")
	assert_equal("Cinema", language:getWordShortcut(1))
	
	language = languages:new()
	language:addWordShortcut("Cinema", "Cinema", "Cine")
	assert_equal("Cinema", language:getWordShortcut(1))
	
	language = languages:new()
	language:addWordShortcut("Cinema", "Cinema", "Cine")
	assert_equal("Cine", language:getWordShortcut(1))
end

function addWordControls()
	language = languages:new()
	language:addWordControls("Atualizar", "Update", "Actualizar")
	assert_equal("Atualizar", language:getWordControls(1))
	
	language = languages:new()
	language:addWordControls("Atualizar", "Update", "Actualizar")
	assert_equal("Update", language:getWordControls(1))
	
	language = languages:new()
	language:addWordControls("Atualizar", "Update", "Actualizar")
	assert_equal("Actualizar", language:getWordControls(1))
end

