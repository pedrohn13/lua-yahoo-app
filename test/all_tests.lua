package.path = "../src/?.lua;".. package.path

require "util"
require "lunit"

homePath = util.stringSplit(package.path, ";")
homePath = homePath[#homePath]
homePath = homePath:sub(0, homePath:len() - 5)

local stats = lunit.main({homePath.."testNews.lua",
						homePath.."testLanguage.lua",
						homePath.."testTempo.lua",
						homePath.."testTranslate.lua",
						homePath.."testCategory.lua"})
