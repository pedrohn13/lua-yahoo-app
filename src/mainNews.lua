require('init')
require('Textview')

local position = 1
local cleaner = canvas:new(RES_PATH.."news/elements/cleaners/clean1.png")
local cleaner4 = canvas:new(RES_PATH.."news/elements/cleaners/clean4.jpg")
local sombra = canvas:new(RES_PATH.."news/elements/BOX/box-sombra.png")
local selector = canvas:new(RES_PATH.."news/elements/BOX/box-select.png")
local selector2 = canvas:new(RES_PATH.."news/elements/BOX/box-select2.png")


--- Show initial elements of the screen
function showHomeScreen() 
	canvas:compose(0,0,background)
	showControls()
	showShortcut()
	
    if(navegation[3])then
        shortcutSelect()
    end
    
	if(#categories[1].news == 0)then 
		local connection = downloadNews(categories)
		if(not connection)then return end
	end
	
	showCategoriesWidget()
	showSubcategoryWidget()
end

---Show second background
function showSecondScreen()
	cleanScreen()
	canvas:compose(0,0,background)
	showControls()
end

--- Show boxes of the categories
function showCategoriesWidget()
	local arrowRight = canvas:new(RES_PATH.."news/elements/SETA_DIREITA-01.png")
	local arrowLeft = canvas:new(RES_PATH.."news/elements/SETA_ESQUERDA-06.png")
	canvas:compose(0,70, cleaner)
	
	if(indexTheme == 0)then
		canvas:compose(1200,180,arrowRight)
	else
		canvas:compose(40,180,arrowLeft)
	end
	
	canvas:attrFont("Tirésias",30, "bold")
	x,y = 120,90
	
	for i = 1, 3  do
		canvas:compose(x,y,box)
		if(currentCat == i and navegation[1])then 
			drawBordCategory()
		else
			canvas:compose(x,y,sombra)
		end
		
		name = language:getWordCategory(indexTheme + i)
		name = stringUpper(name) 
	
		canvas:attrColor(255, 255, 255, 255)
		canvas:drawText(centralize(name,320) + x + 10, y + 10, name)
		x = x + 350
	end
	if(navegation[1])then
		drawBordCategory()
	end
	drawCategoryWidget()
end

--- Draw news in categories boxes
function drawCategoryWidget()
	local points = canvas:new(RES_PATH.."news/elements/leia_mais-01.png")
	
	x,y = 135,150
	b,e = 1,3
	if(indexTheme == 3)then b,e = 4,6 end
		
	for i = b, e do
		canvas:attrFont("Tirésias",18, "bold")
		local text_title = TextView:new(x, y + 20 , 310, 65, categories[i]:showTitle(1)) 
		text_title:draw(246,147,33)

		if(countLine == 1 and categories[i]:showTitle(1) ~= " ")then
			canvas:attrFont("Tirésias",16, "bold")
			local text_description = TextView:new(x, y + 45, 310, 70, categories[i]:showDescription(1))
			text_description:draw(208, 210, 211)
		
		elseif(categories[i]:showTitle(1) == " ")then 
			canvas:attrFont("Tirésias",18, "bold")
			local text_description = TextView:new(x + 30, y + 20 , 315, 90, categories[i]:showDescription(1))
			text_description:draw(88, 201, 232)
		else
			canvas:attrFont("Tirésias",16, "bold")
			local text_description = TextView:new(x, y + 75, 310, 70, categories[i]:showDescription(1))
			text_description:draw(208, 210, 211)
		end

		canvas:attrFont("Tirésias",13, "bold")
		canvas:attrColor(88,201,232,255)
		canvas:drawText(x + 5 , 150, string.sub(categories[i]:showDate(1),1,5))
		canvas:drawText(x + 225, 150, string.sub(categories[i]:showDate(1),10,21))
		
		
		if(#categories[i]:showDescription(1) >= 80)then
			canvas:compose(x + 275, y + 130, points)
		end
		x = x + 350
	end
end

--- Draw a selection border in the categories
function drawBordCategory()
	if(currentCat == 1)then
		canvas:compose(120,90,cleaner, 120, 20, 11, 221)
		canvas:compose(450,90,cleaner, 450, 20, 11, 221)
		canvas:compose(120,90,cleaner, 120, 20, 341, 10)
		canvas:compose(120,300,cleaner, 120, 200, 341, 10)
		canvas:compose(120,90,selector)
	elseif(currentCat == 2)then
		canvas:compose(470,90,cleaner, 470, 20, 11, 221)	
		canvas:compose(800,90,cleaner, 800, 20, 11, 221)
		canvas:compose(470,90,cleaner, 470, 20, 341, 10)
		canvas:compose(470,300,cleaner, 470, 200, 341, 10)
		canvas:compose(470,90,selector)
	elseif(currentCat == 3)then
		canvas:compose(820,90,cleaner, 820, 20, 11, 221)
		canvas:compose(1150,90,cleaner, 1150, 20, 11, 221)
		canvas:compose(820,90,cleaner, 820, 20, 341, 10)
		canvas:compose(820,300,cleaner, 820, 200, 341, 10)
		canvas:compose(820,90,selector)
	end
end

---Show subcategories of a category and draw last news
function showSubcategoryWidget()
	local arrowRight = canvas:new(RES_PATH.."news/elements/SETA_DIREITA-01.png")
	local arrowLeft = canvas:new(RES_PATH.."news/elements/SETA_ESQUERDA-06.png")
	local points = canvas:new(RES_PATH.."news/elements/leia_mais-01.png")
	
	local x_sub,y_sub = 120,355
	local index = currentCat + indexTheme
	
	limit = #subcategories[categoryName[index]]
	session_sub = {1,limit} 
	
	local list	= subcategories[categoryName[index]]
	if(#list[1].news == 0)then 
		if(not downloadNews(list))then return end
	end
	
	cleanHalf()
	canvas:attrFont("Tirésias",70, "bold")
	canvas:attrColor(9,128,175,255)
	local name = language:getWordCategory(indexTheme + currentCat)
	name = stringUpper(name) 
	canvas:drawText(20,330,name)
	
	if(limit > 3 and session_value_sub == 1) then
		session_sub = {1,3}
		canvas:compose(1200,420,arrowRight)
	
	elseif((limit >= 4 and limit <= 6) and session_value_sub == 2) then
		session_sub = {4,limit}
		canvas:compose(40,420,arrowLeft)
	
	elseif(limit >= 6 and session_value_sub == 2) then
		session_sub = {4,6}
		canvas:compose(1200,420,arrowRight)
		canvas:compose(40,420,arrowLeft)
	
	elseif (limit >= 7 and session_value_sub == 3) then
		session_sub = {7,limit}
		canvas:compose(40,420,arrowLeft)
	end
	
	for i= session_sub[1], session_sub[2] do
		canvas:compose(x_sub,y_sub,boxersSub[i])
		canvas:attrFont("Tirésias",20, "bold")
		canvas:attrColor(246,147,33,255)
		canvas:drawText(x_sub + 20, y_sub + 35 , subcategories[categoryName[index]][i].name[indexIdiom])
		
		canvas:attrFont("Tirésias",13, "bold")
		canvas:attrColor(88,201,232,255)
		canvas:drawText(x_sub + 20 , y_sub + 15, string.sub(subcategories[categoryName[index]][i]:showDate(1),1,5))
		canvas:drawText(x_sub + 240, y_sub + 15, string.sub(subcategories[categoryName[index]][i]:showDate(1),10,21))
		
		if(subcategories[categoryName[index]][i]:showDate(1) == " ")then 
			canvas:attrFont("Tirésias",18, "bold")
			textSubDes = TextView:new(x_sub + 45, y_sub + 60 , 305, 100, subcategories[categoryName[index]][i]:showDescription(1)) 
			textSubDes:draw(88,201,232)
		else
			canvas:attrFont("Tirésias",16, "bold")
			textSubDes = TextView:new(x_sub + 15, y_sub + 60 , 305, 100, subcategories[categoryName[index]][i]:showTitle(1)) 
			textSubDes:draw(208,210,211)
		end
		
		if(#subcategories[categoryName[index]][i]:showTitle(1) > 120)then
			canvas:compose(x_sub + 290, y_sub + 150, points)
		end
		
		x_sub = x_sub + 350
	end
	canvas:flush()
end

--- show shortcut icon
function showShortcut()
	local arrowRight = canvas:new(RES_PATH.."news/elements/SETA_DIREITA-01.png")
	local arrowLeft = canvas:new(RES_PATH.."news/elements/SETA_ESQUERDA-06.png")
	local session_icon = {{1,8},{9,16},{17,21}}
	local x = 195
	
	canvas:attrFont("Tirésias",12, "bold")
	canvas:attrColor(147,149,152,255)
	
	for i = session_icon[session_shot][1], session_icon[session_shot][2] do
			local icon = canvas:new(iconUnselect[i])
			canvas:compose(x,560, icon)

		if(#language:getWordShortcut(i) == 2)then
			canvas:drawText(centralize(language:getWordShortcut(i)[1],113) + x ,635, language:getWordShortcut(i)[1])
			canvas:drawText(centralize(language:getWordShortcut(i)[2],113) + x ,650, language:getWordShortcut(i)[2])
		elseif(language:getWordShortcut(i) == "Literatura" or language:getWordShortcut(i) == "Literature")then
			canvas:drawText(centralize(language:getWordShortcut(i),113) + x - 15 ,635, language:getWordShortcut(i))
		else
			canvas:drawText(centralize(language:getWordShortcut(i),113) + x ,635, language:getWordShortcut(i))
		end
		x = x + 110
	end
	
	if(session_shot == 1)then 
		canvas:compose(1200,600,arrowRight)
	
	elseif(session_shot == 2)then
		canvas:compose(1200,600,arrowRight)
		canvas:compose(40,600,arrowLeft)
	
	elseif(session_shot == 3)then
		canvas:compose(40,600,arrowLeft)
	end
end

--- Show cursor of the shortcut
function shortcutSelect()
	local iconselect = canvas:new(iconSelect[currentShot])
	canvas:compose(x_shot, 560, iconselect)
	canvas:attrFont("Tirésias",12, "bold")
	canvas:attrColor(255,255,255,255)
	
	if(#language:getWordShortcut(currentShot) == 2)then
		canvas:drawText(centralize(language:getWordShortcut(currentShot)[1],113) + x_shot ,635, language:getWordShortcut(currentShot)[1])
		canvas:drawText(centralize(language:getWordShortcut(currentShot)[2],113) + x_shot ,650, language:getWordShortcut(currentShot)[2])	
	elseif(language:getWordShortcut(currentShot) == "Literatura" or language:getWordShortcut(currentShot) == "Literature")then
		canvas:drawText(centralize(language:getWordShortcut(currentShot),113) + x_shot - 15 ,635, language:getWordShortcut(currentShot))	
	else	
		canvas:drawText(centralize(language:getWordShortcut(currentShot),113) + x_shot ,635, language:getWordShortcut(currentShot))
	end
end

--- Show options of the remote control
function showControls()
	local botton
	local botton = canvas:new(RES_PATH.."portal/ic-blue-s.png")
	canvas:compose(1130,676,botton)
	local botton = canvas:new(RES_PATH.."weather/elements/ic-navigate-1.png")
	canvas:compose(264,676,botton)
	local botton = canvas:new(RES_PATH.."weather/elements/ic-back.png")
	canvas:compose(144,676,botton)
	local botton = canvas:new(RES_PATH.."weather/elements/ic-exit.png")
	canvas:compose(40,676,botton)
	local botton = canvas:new(RES_PATH.."weather/elements/ic-ok.png")
	canvas:compose(400,676,botton)
	
	canvas:attrColor ("white")
  	canvas:attrFont("Tirésias",17)
	canvas:drawText(90, 684,language:getWordControls(1))
	canvas:drawText(189, 684,language:getWordControls(2))
	canvas:drawText(309, 684,language:getWordControls(3))
	canvas:drawText(450, 684,language:getWordControls(5))
	canvas:drawText(1175, 684,language:getWordControls(4))
	
end

--- Download news of a categories
function downloadNews(list)
	local countFail = 0
	local loadCount = 1
	
	for i,v in ipairs(list) do
		cleanHalf()
		canvas:compose(520,400,loadings[loadCount])
		canvas:flush()
		
		if (not v:loadingNews()) then
			countFail = countFail + 1
		end
		
		loadCount = loadCount + 1
		if(loadCount > 3)then 
			loadCount = 1 
		end
	end
	cleanHalf()
	if(countFail == 6)then
		connectionFailed()
		connectioNews = false 
		return false
	end
	connectioNews = true
	return connectioNews
end

--- Reports that the connection failed
function connectionFailed()
	local backgroundFail = canvas:new(RES_PATH.."news/elements/BG/BG_TELA_1_NO_CONNECTION.png")
	local backgroundFail2 = canvas:new(RES_PATH.."news/elements/BG/BG_TELA_2_NO_CONNECTION.png")
	
	
	if(not navegation[4])then
		canvas:compose(0,0,backgroundFail)
		showControls()
	else
		canvas:compose(0,0,backgroundFail2)
		showControls()
	end
	
	showShortcut()
	navegation = {false,false,false,false,false}
	canvas:flush()
end

--- Update screen
function update()
	if(not secondScreen)then
		canvas:compose(0,70,cleaner)
		cleanHalf()
		if(position == 3)then shortcutSelect() end
		if(not downloadNews(categories))then return end
		showCategoriesWidget()
		if(position == 1)then drawBordCategory() end
		if(not downloadNews(subcategories[categoryName[currentCat + indexTheme]]))then return end
		showSubcategoryWidget()
		navegation[position] = true
		
	
	else
		canvas:clear()
		showSecondScreen()
		if(not currentNews:loadingNews())then connectionFailed() return end
		cleanNews()
		showAllNews()
		drawBordNews()
		navegation[4] = true
		canvas:flush()
	end
end

--- Saves last visited category
function saveNews()
	local file = io.open(RES_PATH.."news/lastNews.txt", "w")
	file:write(currentNews.name[1] .. "\n" .. currentNews.name[2] .. "\n" .. currentNews.name[3] .. "\n" .. currentNews.url)
	file:close()
end

---Show full news
function showFullNews()
	local points = canvas:new(RES_PATH.."news/elements/leia_mais-01.png")
	local boxSelected3	= canvas:new (RES_PATH.."news/elements/BOX/BOX_4_SELECTED.png")
	canvas:compose(column[columnIndex],115,boxSelected3)
	canvas:attrFont("Tirésias",20, "bold")
		
	local title = TextView:new(column[columnIndex] + 20, 160, 300, 100, currentNews:showTitle(selected)) 
	title:draw(246,147,33)
	
	canvas:attrFont("Tirésias",16, "bold")
	if(countLine == 1)then
		local description = TextView:new(column[columnIndex] + 20, 200 , 300, 380, currentNews:showDescription(selected))
		description:draw(255,255,255)
	
	elseif(countLine == 2)then
		local description = TextView:new(column[columnIndex] + 20, 230 , 300, 380, currentNews:showDescription(selected))
		description:draw(255,255,255)
	
	else
		local description = TextView:new(column[columnIndex] + 20, 255 , 300, 380, currentNews:showDescription(selected))
		description:draw(255,255,255)
		if(#currentNews:showDescription(selected) > 550)then
			canvas:compose(column[columnIndex] + 290, 623 ,points)
		end
	end
	
	canvas:attrFont("Tirésias",13, "bold")
	canvas:attrColor(88,201,232,255)
	canvas:drawText(column[columnIndex] + 25, 133, string.sub(currentNews:showDate(selected),1,5))
	canvas:drawText(column[columnIndex] + 235, 133, string.sub(currentNews:showDate(selected),10,21))
	canvas:flush()
end

--- Show all news of a category
function showAllNews()
	
	local points = canvas:new(RES_PATH.."news/elements/leia_mais-01.png")
	
	if(navegation[1])then 
		currentNews = categories[currentCat + indexTheme]
	
	elseif(navegation[2])then 
		currentNews = subcategories[categories[currentCat + indexTheme].name[1]][currentSub]
	
	elseif(navegation[3])then
		currentNews = shortcutAdress[currentShot]
		if(not currentNews:loadingNews())then connectionFailed() return end
	end
	
	currentNews:showBackground()
	saveNews()
	
	navegation = {false,false,false,true}
	session_news = {{1,9},{10,18},{19,27}}
	local x_news,y_news = 120,115
	local control = 1
	local v = 1
	
	local n = #currentNews.news
	if( n < 9)then 
		session_news = {{1,n}}
	elseif (n < 18 and n > 10)then 
		session_news = {{1,9}}
	elseif (n < 27 and n > 19)then 
		session_news = {{1,9},{10,18}}
	end
	
	local arrowRight = canvas:new(RES_PATH.."news/elements/SETA_DIREITA-01.png")
	local arrowLeft = canvas:new(RES_PATH.."news/elements/SETA_ESQUERDA-06.png")
	
	if(session_value == 1 and #session_news >= 2)then
		canvas:compose(1200,330,arrowRight)
	elseif(session_value == 2 and #session_news == 3)then
		canvas:compose(1200,330,arrowRight)
		canvas:compose(40,330,arrowLeft)
	elseif(session_value == 3) then
		canvas:compose(40,330,arrowLeft)
	end
	
	for i = session_news[session_value][1], session_news[session_value][2] do	
		if(control > 3)then 
			x_news, y_news = 120, y_news + 180
			control = 1
		end
		canvas:compose(x_news, y_news, box3)
		canvas:attrFont("Tirésias",18, "bold")
		
		local title = TextView:new(x_news + 15, y_news + 35, 305, 70, currentNews:showTitle(i)) 
		title:draw(246,147,33)
		
		canvas:attrFont("Tirésias",16, "bold")
		
		if(countLine == 1 and currentNews:showTitle(i) ~= " ")then
			local description = TextView:new(x_news + 15, y_news + 63, 305, 70, currentNews:showDescription(i))
			description:draw(208, 210, 211)
		
		elseif(currentNews:showTitle(i) == " ")then
			canvas:attrFont("Tirésias",18, "bold")
			local textSubDes = TextView:new(x_news + 45, y_news + 60 , 305, 100, currentNews:showDescription(i)) 
			textSubDes:draw(88,201,232)
		else
			local description = TextView:new(x_news + 15, y_news + 88, 305, 65, currentNews:showDescription(i))
			description:draw(208, 210, 211)
		end
		
		if(#currentNews:showDescription(i) >= 80)then
			canvas:compose(x_news + 290, y_news + 150, points)
		end		
		
		canvas:attrFont("Tirésias",13, "bold")
		canvas:attrColor(88,201,232,255)
		canvas:drawText(x_news + 20 , y_news + 20, string.sub(currentNews:showDate(i),1,5))
		canvas:drawText(x_news + 240, y_news + 20, string.sub(currentNews:showDate(i),10,21))
		
		x_news = x_news + 350
		v = v + 1
		control = control + 1
		
	end
end

--- Draw a selection border in the second screen
function drawBordNews()
	if(selected == 1 or selected == 10 or selected == 19)then
		canvas:compose(120,115,selector2)
		
	elseif(selected == 2 or selected == 11 or selected == 20)then
		canvas:compose(470,115,selector2)
		
	elseif(selected == 3 or selected == 12 or selected == 21)then
		canvas:compose(820,115,selector2)
		
	elseif(selected == 4 or selected == 13 or selected == 22)then
		canvas:compose(120,295,selector2) 
		
	elseif(selected == 5 or selected == 14 or selected == 23)then
		canvas:compose(470,295,selector2) 
	
	elseif(selected == 6 or selected == 15 or selected == 24)then
		canvas:compose(820,295,selector2) 
		
	elseif(selected == 7 or selected == 16 or selected == 25)then
		canvas:compose(120,475,selector2) 
		
	elseif(selected == 8 or selected == 17 or selected == 26)then
		canvas:compose(470,475,selector2) 
	
	elseif(selected == 9 or selected == 18 or selected == 27)then
		canvas:compose(820,475,selector2)  
	end
	canvas:flush()
end

--- Centered text in a region
function centralize(text,width)
    local w = 0
    local h = 0
    w, h = canvas:measureText(text)
    return (width/2) - (w/2)
end

--- Clears category boxes
function cleanBoxers()
	if(currentCat == 1)then
		canvas:compose(120,90,cleaner, 120, 20, 11, 221)
		canvas:compose(450,90,cleaner, 450, 20, 11, 221)
		canvas:compose(120,90,cleaner, 120, 20, 341, 11)
		canvas:compose(120,300,cleaner, 120, 200, 341, 11)
		canvas:compose(120,90,sombra)
	elseif(currentCat == 2)then
		canvas:compose(470,90,cleaner, 470, 20, 11, 221)	
		canvas:compose(800,90,cleaner, 800, 20, 11, 221)
		canvas:compose(470,90,cleaner, 470, 20, 341, 11)
		canvas:compose(470,300,cleaner, 470, 200, 341, 11)
		canvas:compose(470,90,sombra)
	elseif(currentCat == 3)then
		canvas:compose(820,90,cleaner, 820, 20, 11, 221)
		canvas:compose(1150,90,cleaner, 1150, 20, 11, 221)
		canvas:compose(820,90,cleaner, 820, 20, 341, 11)
		canvas:compose(820,300,cleaner, 820, 200, 341, 11)
		canvas:compose(820,90,sombra)
	end
end

--- Clears the middle region
function cleanHalf()
	local cleaner2 = canvas:new(RES_PATH.."news/elements/cleaners/clean2.png")
	canvas:compose(0,330,cleaner2)
end

--- Clean shortcut
function cleanShortcut()
	local cleaner3 = canvas:new(RES_PATH.."news/elements/cleaners/clean3.png")
	canvas:compose(0,556,cleaner3)
end

--- Clean news 
function cleanNews()
	if(selected == 1 or selected == 10 or selected == 19)then
		canvas:compose(120,115,cleaner4, 120, 49, 10, 170)
		canvas:compose(120,115,cleaner4, 120, 49, 340, 10)
		canvas:compose(120,275,cleaner4, 120, 204, 341, 10)
		canvas:compose(450,115,cleaner4, 449, 49, 10, 170)
	
	elseif(selected == 2 or selected == 11 or selected == 20)then
		canvas:compose(470,115,cleaner4, 470, 49, 10, 170)
		canvas:compose(470,115,cleaner4, 470, 49, 340, 10)
		canvas:compose(470,275,cleaner4, 470, 204, 341, 10)
		canvas:compose(800,115,cleaner4, 800, 49, 10, 170)
	
	elseif(selected == 3 or selected == 12 or selected == 21)then
		canvas:compose(820,115,cleaner4, 820, 49, 10, 170)
		canvas:compose(820,115,cleaner4, 820, 49, 340, 10)
		canvas:compose(820,275,cleaner4, 820, 204, 341, 10)
		canvas:compose(1150,115,cleaner4, 1150, 49, 10, 170)
	
	elseif(selected == 4 or selected == 13 or selected == 22)then
		canvas:compose(120,295,cleaner4, 120, 229, 10, 170) 
		canvas:compose(120,295,cleaner4, 120, 229, 330, 10) 
		canvas:compose(120,455,cleaner4, 120, 384, 341, 10)
		canvas:compose(450,295,cleaner4, 449, 229, 10, 161) 
	
	elseif(selected == 5 or selected == 14 or selected == 23)then
		canvas:compose(470,295,cleaner4, 470, 229, 10, 170) 
		canvas:compose(470,295,cleaner4, 470, 229, 340, 10) 
		canvas:compose(470,455,cleaner4, 470, 384, 341, 10)
		canvas:compose(800,295,cleaner4, 800, 229, 10, 170) 
	
	elseif(selected == 6 or selected == 15 or selected == 24)then
		canvas:compose(820,295,cleaner4, 820, 229, 10, 170) 
		canvas:compose(820,295,cleaner4, 820, 229, 340, 10) 
		canvas:compose(820,455,cleaner4, 820, 384, 341, 10)
		canvas:compose(1150,295,cleaner4, 1150, 229, 10, 170) 
	
	elseif(selected == 7 or selected == 16 or selected == 25)then
		canvas:compose(120,475,cleaner4, 120, 409, 10, 170) 
		canvas:compose(120,475,cleaner4, 120, 409, 340, 10) 
		canvas:compose(120,635,cleaner4, 120, 564, 341, 10)
		canvas:compose(450,475,cleaner4, 449, 409, 10, 170) 
	
	elseif(selected == 8 or selected == 17 or selected == 26)then
		canvas:compose(470,475,cleaner4, 470, 409, 10, 170) 
		canvas:compose(470,475,cleaner4, 470, 409, 340, 10) 
		canvas:compose(470,635,cleaner4, 470, 564, 341, 10)
		canvas:compose(800,475,cleaner4, 800, 409, 10, 170)
	
	elseif(selected == 9 or selected == 18 or selected == 27)then
		canvas:compose(820,475,cleaner4, 820, 409, 10, 170) 
		canvas:compose(820,475,cleaner4, 820, 409, 340, 10) 
		canvas:compose(820,635,cleaner4, 820, 564, 341, 10)
		canvas:compose(1150,475,cleaner4, 1150, 409, 10, 170) 
	end
end

--- Draws icons as background
function drawIcones()
	if(selected == 1 or selected == 10 or selected == 19)then
		canvas:compose(120,125,categoryBackground, 120 - 350, 56, 10, 151) 
		canvas:compose(120,115,categoryBackground, 120 - 350, 47, 330, 10) 
		canvas:compose(120,276,categoryBackground, 120 - 350, 206, 341, 9)
		canvas:compose(450,115,categoryBackground, 449 - 349, 45, 10, 161)
	
	elseif(selected == 2 or selected == 11 or selected == 20)then
		canvas:compose(470,125,categoryBackground, 470 - 350, 55, 10, 151)
		canvas:compose(470,115,categoryBackground, 470 - 350, 46, 330, 10)
		canvas:compose(470,276,categoryBackground, 470 - 350, 206, 341, 9)
		canvas:compose(800,115,categoryBackground, 800 - 350, 45, 10, 161)
	
	elseif(selected == 3 or selected == 12 or selected == 21)then
		canvas:compose(820,125,categoryBackground, 820 - 350, 56, 10, 151)
		canvas:compose(820,115,categoryBackground, 820 - 350, 46, 330, 10)
		canvas:compose(820,276,categoryBackground, 820 - 350, 206, 341, 9)
		canvas:compose(1150,115,categoryBackground, 1150 - 350, 46, 10, 161)
	
	elseif(selected == 4 or selected == 13 or selected == 22)then
		canvas:compose(120,305,categoryBackground, 120 - 350, 236, 10, 151) 
		canvas:compose(120,295,categoryBackground, 120 - 350, 226, 330, 10) 
		canvas:compose(120,456,categoryBackground, 120 - 350, 386, 341, 9)
		canvas:compose(450,295,categoryBackground, 449 - 349, 225, 10, 161) 
	
	elseif(selected == 5 or selected == 14 or selected == 23)then
		canvas:compose(470,305,categoryBackground, 470 - 350, 235, 10, 151) 
		canvas:compose(470,295,categoryBackground, 470 - 350, 225, 330, 10) 
		canvas:compose(470,456,categoryBackground, 470 - 350, 386, 341, 9)
		canvas:compose(800,295,categoryBackground, 800 - 350, 225, 10, 161) 
	
	elseif(selected == 6 or selected == 15 or selected == 24)then
		canvas:compose(820,305,categoryBackground, 820 - 350, 235, 10, 151) 
		canvas:compose(820,295,categoryBackground, 820 - 350, 225, 330, 10) 
		canvas:compose(820,456,categoryBackground, 820 - 350, 386, 341, 9)
		canvas:compose(1150,295,categoryBackground, 1150 - 350, 225, 10, 161) 
	
	elseif(selected == 7 or selected == 16 or selected == 25)then
		canvas:compose(120,485,categoryBackground, 120 - 350, 416, 10, 151) 
		canvas:compose(120,475,categoryBackground, 120 - 350, 405, 330, 10) 
		canvas:compose(120,636,categoryBackground, 120 - 350, 566, 341, 9)
		canvas:compose(450,475,categoryBackground, 449 - 350, 405, 10, 161) 
	
	elseif(selected == 8 or selected == 17 or selected == 26)then
		canvas:compose(470,485,categoryBackground, 470 - 350, 415, 10, 151) 
		canvas:compose(470,475,categoryBackground, 470 - 350, 406, 330, 10) 
		canvas:compose(470,636,categoryBackground, 470 - 350, 566, 341, 9)
		canvas:compose(800,475,categoryBackground, 800 - 350, 405, 10, 161)
	
	elseif(selected == 9 or selected == 18 or selected == 27)then
		canvas:compose(820,485,categoryBackground, 820 - 350, 415, 10, 151) 
		canvas:compose(820,475,categoryBackground, 820 - 350, 406, 330, 10) 
		canvas:compose(820,636,categoryBackground, 820 - 350, 562, 341, 9)
		canvas:compose(1150,475,categoryBackground, 1150 - 350, 406, 10, 161) 
	end
end

--- Clean all screen
function cleanScreen()
	canvas:clear()
end

--- Move cursor to the right category
function moveRightBox()
	cleanBoxers()
	currentCat = currentCat + 1
	drawBordCategory()
	
	if(currentCat > 3 and indexTheme == 0)then 
		currentCat,indexTheme = 1,3
		showCategoriesWidget()
		
	
	elseif (currentCat > 3 and indexTheme == 3) then
		currentCat = 3
		return 
	end
	
	session_value_sub = 1
	session_value = 1
	currentSub = 1
	showSubcategoryWidget()
end

--- Move cursor to the left category
function moveLeftBox()
	cleanBoxers()
	currentCat = currentCat - 1
	drawBordCategory()
	
	if(currentCat < 1 and indexTheme == 3)then 
		currentCat, indexTheme = 3,0
		showCategoriesWidget() 
	
	elseif (currentCat < 1 and indexTheme == 0)then 
		currentCat = 1
		return
	end
	
	session_value_sub = 1
	session_value = 1
	currentSub = 1
	showSubcategoryWidget()
end

--- Move cursor to the right subcategory
function moveRightSub()
	cleanHalf()
	boxersSub[currentSub] = box2
	currentSub = currentSub + 1	
	
	if(currentSub > limit)then
		currentSub = limit
	end
	
	if(currentSub == 4 ) then 
		session_value_sub = 2
		
	elseif(currentSub == 7)then
		session_value_sub = 3
	end
	boxersSub[currentSub] = boxSelected2
	showSubcategoryWidget()
end

--- Move cursor to the left subcategory
function moveLeftSub()
	cleanHalf()
	boxersSub[currentSub] = box2
	currentSub = currentSub - 1
	
	if(currentSub < 1)then
		currentSub = 1
	end
	
	if(currentSub == 3 ) then 
		session_value_sub = 1
		
	elseif(currentSub == 6)then
		session_value_sub = 2
	end
	boxersSub[currentSub] = boxSelected2
	showSubcategoryWidget()
end

--- Move cursor to the right shortcut
function moveRightShortcut()
	x_shot = x_shot + 110
	currentShot = currentShot + 1
	
	if(currentShot == 9 or currentShot == 17) then 
		session_shot = session_shot + 1
		x_shot = 195
	end
	
	if(currentShot > 21)then x_shot,currentShot = 635,21 
		return 
	end
	cleanShortcut()
	showShortcut()
	
	local iconSelect = canvas:new(iconSelect[currentShot])
	canvas:compose(x_shot, 560, iconSelect)
	
	canvas:attrFont("Tirésias",12, "bold")
	canvas:attrColor(255,255,255,255)
	
	if(#language:getWordShortcut(currentShot) == 2)then
		canvas:drawText(centralize(language:getWordShortcut(currentShot)[1],113) + x_shot ,635, language:getWordShortcut(currentShot)[1])
		canvas:drawText(centralize(language:getWordShortcut(currentShot)[2],113) + x_shot ,650, language:getWordShortcut(currentShot)[2])
	
	elseif(language:getWordShortcut(currentShot) == "Literatura" or language:getWordShortcut(currentShot) == "Literature")then
		canvas:drawText(centralize(language:getWordShortcut(currentShot),113) + x_shot - 15 ,635, language:getWordShortcut(currentShot))
	
	else	
		canvas:drawText(centralize(language:getWordShortcut(currentShot),113) + x_shot ,635, language:getWordShortcut(currentShot))
	end
	canvas:flush()
end

--- Move cursor to the left shortcut
function moveLeftShortcut()
	x_shot = x_shot - 110
	currentShot = currentShot - 1
	
	if(currentShot == 8 or currentShot == 16) then 
		session_shot = session_shot - 1
		x_shot = 965
	end
	
	if(currentShot < 1)then x_shot,currentShot = 195,1 return end
	cleanShortcut()
	showShortcut()
	
	local iconSelect = canvas:new(iconSelect[currentShot])
	canvas:compose(x_shot, 560, iconSelect)

	canvas:attrFont("Tirésias",12, "bold")
	canvas:attrColor(255,255,255,255)
	
	if(#language:getWordShortcut(currentShot) == 2)then
		canvas:drawText(centralize(language:getWordShortcut(currentShot)[1],113) + x_shot ,635, language:getWordShortcut(currentShot)[1])
		canvas:drawText(centralize(language:getWordShortcut(currentShot)[2],113) + x_shot ,650, language:getWordShortcut(currentShot)[2])
	
	elseif(language:getWordShortcut(currentShot) == "Literatura" or language:getWordShortcut(currentShot) == "Literature")then
		canvas:drawText(centralize(language:getWordShortcut(currentShot),113) + x_shot - 15 ,635, language:getWordShortcut(currentShot))
	
	else	
		canvas:drawText(centralize(language:getWordShortcut(currentShot),113) + x_shot ,635, language:getWordShortcut(currentShot))
	end
	
	canvas:flush()
end

--- Move cursor to the right all news
function moveRightNews()
	if(selected == session_news[#session_news][2] - 6 or 
		selected == session_news[#session_news][2] - 3 or 
		selected == session_news[#session_news][2])then 
		return
	end
	
    if(navegation[5])then
        navegation[4] = true
        navegation[5] = false
        background = canvas:new(RES_PATH.."news/elements/BG/BG_TELA_2-01.png")
        canvas:compose(0,673,background, 0 , 673, 1280, 50)
        showControls()
        canvas:compose(0,70,cleaner4)
        showAllNews()
    end
    
	cleanNews()
	drawIcones()
	columnIndex = columnIndex + 1
	selected = selected + 1
	
	if(columnIndex == 4) then 
		session_value = session_value + 1
		selected = selected + 6
		columnIndex = 1   
		canvas:compose(0,70,cleaner4)
		showAllNews()
	end
	drawBordNews()
	canvas:flush()
end

--- Move cursor to the left all news
function moveLeftNews()
	
	if(selected == 1 or selected == 4 or selected == 7)then 
		return 
	end
	
    if(navegation[5])then
        navegation[4] = true
        navegation[5] = false
        background = canvas:new(RES_PATH.."news/elements/BG/BG_TELA_2-01.png")
        canvas:compose(0,673,background, 0 , 673, 1280, 50)
        showControls()
        canvas:compose(0,70,cleaner4)
        showAllNews()
    end
    
	cleanNews()
	drawIcones()
	selected = selected - 1
	columnIndex = columnIndex - 1
	
	if(columnIndex == 0) then 
		session_value = session_value - 1
		selected = selected - 6   
		columnIndex = 3 
		canvas:compose(0,70,cleaner4)
		showAllNews() 
	end
	drawBordNews()
	
end

--- Move cursor to up
function moveUp()
    if(navegation[5])then
        navegation[4] = true
        navegation[5] = false
        background = canvas:new(RES_PATH.."news/elements/BG/BG_TELA_2-01.png")
        canvas:compose(0,673,background, 0 , 673, 1280, 50)
        showControls()
        canvas:compose(0,70,cleaner4)
        showAllNews()
    end
    
	if(navegation[2])then
		boxersSub[currentSub] = box2
		
		drawBordCategory()
		showSubcategoryWidget()
		
		navegation[1] = true
		navegation[2] = false
		
		position = 1
		
	elseif(navegation[3]) then
		cleanShortcut()
		showShortcut()
		
		boxersSub[currentSub] = boxSelected2
		showSubcategoryWidget()
		navegation[2] = true
		navegation[3] = false
		
		position = 2
	
	elseif(navegation[4])then
		cleanNews()
		drawIcones()
		selected = selected - 3

		if(selected < session_news[session_value][1]) then 
			selected = selected + 3 return 
		end
		drawBordNews()
	end
end

--- Move cursor to down
function moveDown()
	
    if(navegation[5])then
        navegation[4] = true
        navegation[5] = false
        background = canvas:new(RES_PATH.."news/elements/BG/BG_TELA_2-01.png")
        canvas:compose(0,673,background, 0 , 673, 1280, 50)
        showControls()
        canvas:compose(0,70,cleaner4)
        showAllNews()
    end
    
    if(navegation[1])then
		cleanBoxers()
		
		boxersSub[currentSub] = boxSelected2
		showSubcategoryWidget()

		navegation[1] = false
		navegation[2] = true
		
		position = 2
	elseif(navegation[2])then
		canvas:attrFont("Tirésias",12, "bold")
		canvas:attrColor(255,255,255,255)
		local iconSelect = canvas:new(iconSelect[currentShot])
		canvas:compose(x_shot, 560, iconSelect)
		
		if(#language:getWordShortcut(currentShot) == 2)then
			canvas:drawText(centralize(language:getWordShortcut(currentShot)[1],113) + x_shot ,635, language:getWordShortcut(currentShot)[1])
			canvas:drawText(centralize(language:getWordShortcut(currentShot)[2],113) + x_shot ,650, language:getWordShortcut(currentShot)[2])
		
		elseif(language:getWordShortcut(currentShot) == "Literatura" or language:getWordShortcut(currentShot) == "Literature")then
			canvas:drawText(centralize(language:getWordShortcut(currentShot),113) + x_shot - 15 ,635, language:getWordShortcut(currentShot))
		
		else	
			canvas:drawText(centralize(language:getWordShortcut(currentShot),113) + x_shot ,635, language:getWordShortcut(currentShot))
		end
		
		boxersSub[currentSub] = box2
		showSubcategoryWidget()
		
		navegation[2] = false
		navegation[3] = true
		position = 3
	
	elseif(navegation[4])then
		cleanNews()
		drawIcones()
		selected = selected + 3
		
		if(selected > session_news[session_value][2]) then 
			selected = selected - 3 return 
		end
		drawBordNews()
    
	end
end

--- Capture events
local function handlerN(evt)
    if (evt.class == 'key' and evt.type == 'press') then
		if (evt.key == 'CURSOR_RIGHT' and connectioNews) then
			if(navegation[1])then moveRightBox() end
			if(navegation[2])then moveRightSub() end
			if(navegation[3])then moveRightShortcut() end
			if(navegation[4] or navegation[5])then moveRightNews() end
		
		elseif (evt.key == 'CURSOR_LEFT' and connectioNews) then
			if(navegation[1])then moveLeftBox() end
			if(navegation[2])then moveLeftSub() end
			if(navegation[3])then moveLeftShortcut() end
			if(navegation[4] or navegation[5])then moveLeftNews() end
		
		elseif (evt.key == 'CURSOR_UP' and connectioNews) then
			if(not navegation[1]) then moveUp() end
		
		elseif (evt.key == 'CURSOR_DOWN' and connectioNews) then
			if(not navegation[3]) then moveDown() end
		
		elseif (evt.key == 'ENTER' and connectioNews) then
			secondScreen = true
			if(navegation[1])then 
				indexNavigate = 1 
				selected,columnIndex = 1, 1 
			end
		
			if(navegation[2])then 
				indexNavigate = 2
				selected,columnIndex,session_value  = 1, 1, 1 
			end
		
			if(navegation[3])then
				indexNavigate = 3
				selected,columnIndex = 1, 1   
			end
		
			if(not navegation[4] and not navegation[5])then 
				background = canvas:new(RES_PATH.."news/elements/BG/BG_TELA_2-01.png")
				showSecondScreen() 
				showAllNews()
				drawBordNews()
			
            elseif(navegation[4])then 
				showFullNews()
				navegation[4] = false
				navegation[5] = true
			end
		
		elseif (evt.key == 'BACK') then
			secondScreen = false
			if(navegation[4] or navegation[5])then 
				navegation[4] = false
                navegation[5] = false
				navegation[indexNavigate] = true
				cleanScreen()
				session_value = 1 
				
				background = canvas:new(RES_PATH.."news/elements/BG/BG_TELA_1-01.png")
				canvas:compose(0,0,background)
				showControls()
				showShortcut()
				
				if(indexNavigate == 3)then
					shortcutSelect()
					showCategoriesWidget()
					cleanBoxers()
					showSubcategoryWidget()
				
				elseif(indexNavigate == 2)then
					showCategoriesWidget()
					cleanBoxers()
					showSubcategoryWidget()
				
				elseif(indexNavigate == 1)then
					showHomeScreen()	
				end
			else
				--dofile('init.lua')
				background = canvas:new(RES_PATH.."portal/background.png")
				cleanScreen()
				event.unregister(handlerN)
				registerMain()
			end
		
		elseif (evt.key == 'BLUE') then
			update()
			if(navegation[5])then navegation[5] = false end
				
		elseif (evt.key == 'EXIT') then
			event.unregister(handlerN)
			canvas:attrColor('black')
			local app = applicationManager.getRunningApplication()
			applicationManager.stopApplication(app["id"])
		end
	end
    collectgarbage()
end

--- init application
function registerNews()
	canvas:clear()
	background = canvas:new(RES_PATH.."news/elements/BG/BG_TELA_1-01.png")
	showHomeScreen()
	event.register(handlerN)
end
