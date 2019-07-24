require "lunit"
require "News"

module( "newsTest", package.seeall, lunit.testcase )

function setup()
	news = News:new({title = {}, description = {}, day = {}})
	news:appendTitle("Headline of a news")
	news:appendDay("08 jul 2012")
	news:appendDescription("Sumary of a news")
end

function test_appendTitle()
	assert_equal(1, #news.title, "title fail")
	assert_equal("Headline of a news", news.title[1], "title fail")
	assert_equal(nil, news.title[2], "title fail")
end

function test_appendDay()
	assert_equal(1, #news.day, "date fail")
	assert_equal("08 jul 2012", news.day[1], "date fail")
	assert_equal(nil, news.day[2], "date fail")
end

function test_appendDescription()
	assert_equal(1, #news.description, "description fail")
	assert_equal("Sumary of a news", news.description[1], "description fail")
	assert_equal(nil, news.day[2], "description fail")
end
