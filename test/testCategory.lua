package.path = "../src/?.lua;".. package.path
require "lunit"
require "News"
require "Category"


module( "categoryTest", package.seeall, lunit.testcase )

function setup()
	
	news_false = News:new({title = {"Title of News"}, description = {"Description of news"}, day = {"08/07/2012"}})
	category_false = Category:new({name = "Teste", url = "www.test.com", news = {}})
	
	url = "http://br.noticias.yahoo.com/%s/?format=rss"
	---------------------- Categories true ---------------------------
	categories = {Category:new({name = 'Mundo', url = string.format(url, 'mundo'), news = {}}),
	Category:new({name = 'Economia', url = string.format(url, 'economia'), news = {}}),
	Category:new({name = 'Ciência', url = string.format(url, 'ciencia'), news = {}}),
	Category:new({name = 'Brasil', url = string.format(url, 'brasil'), news = {}}),
	Category:new({name = 'Entretenimento', url = string.format(url, 'entretenimento'), news = {}}),
	Category:new({name = 'Tecnologia', url = string.format(url, 'tecnologia'), news = {}}),
	Category:new({name = 'Nacional', url = string.format(url, 'nacional'), news = {}}),
    Category:new({name = 'Internacional', url = string.format(url, 'internacional'), news = {}}),
    Category:new({name = 'Política Econômica', url = string.format(url, 'politica-economica'), news = {}}),
    Category:new({name = 'Empresas e Negócios', url = string.format(url, 'empresas-negocios'), news = {}}),
    Category:new({name = 'Press Releases', url = string.format(url, 'press-releases'), news = {}}),
	Category:new({name = 'Saúde',   url = string.format(url, 'nacional'), news = {}}),
	Category:new({name = 'Política', url = string.format(url, 'politica'), news = {}}),
    Category:new({name = 'Cidades',  url = string.format(url, 'cidades'), news = {}}),
    Category:new({name = 'Cinema', url = string.format(url, 'cinema'), news = {}}),
    Category:new({name = 'Gente', url = string.format(url, 'gente'), news = {}}),
    Category:new({name = 'Música', url = string.format(url, 'musica'), news = {}}),
    Category:new({name = 'TV', url = string.format(url, 'tv'), news = {}}),
    Category:new({name = 'Vídeo e DVD', url = string.format(url, 'video-dvd'), news = {}}),
    Category:new({name = 'Moda', url = string.format(url, 'moda'), news = {}}),
    Category:new({name = 'Literatura', url = string.format(url, 'literatura'), news = {}}),
    Category:new({name = 'Artes Visuais', url = string.format(url, 'artes-visuais'), news = {}}),
    Category:new({name = 'Empresas', url = string.format(url, 'empresas'), news = {}}),
    Category:new({name = 'Linux', url = string.format(url, 'linux'), news = {}}),
    Category:new({name = 'Macintosh', url = string.format(url, 'macintosh'), news = {}}),
    Category:new({name = 'Jogos', url = string.format(url, 'jogos'), news = {}}),
    Category:new({name = 'Internet', url = string.format(url, 'internet'), news = {}}),
    Category:new({name = 'Telecom', url = string.format(url, 'telecom'), news = {}})}

end

function test_appendNews()
	category_false:appendNews(news_false)
	assert_equal(1, #category_false.news)
	
	category_false:appendNews(news_false)
	assert_equal(2, #category_false.news)
	
	assert_not_equal(nil, category_false.news[1])
	assert_not_equal(nil, category_false.news[2])
	assert_equal(nil, category_false.news[3])
end

--  for this test on the internet connection --
function test_loadingNews()
	for i,v in ipairs(categories) do 
		assert_true(v:loadingNews(), v.name .." Connection failed")
		assert_not_equal(0, #v.news, v.name .. " failed")
		assert_not_equal(nil, v.news[1], v.name .. " failed" )
	end
end

--[[ for this test off the internet connection

function test_loadingNews()
	for i,v in ipairs(categories) do 
		assert_false(v:loadingNews(), v.name .." Connection worked")
		assert_equal(0, #v.news, v.name .. " worked")
		assert_equal(nil, v.news[1], v.name .. " worked" )
	end
end
--]] 

function test_showTitle()
	category_false:appendNews(news_false)
	assert_equal("Title of News", category_false:showTitle(1))
end

function test_showDate()
	category_false:appendNews(news_false)
	assert_equal("08/07/2012", category_false:showDate(1))
end

function test_showDescription()
	category_false:appendNews(news_false)
	assert_equal("Description of news", category_false:showDescription(1))
end
