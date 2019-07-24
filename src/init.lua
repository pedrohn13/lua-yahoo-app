require('Languages')

--- Load necessary information
--- init
navegation = {true,false,false,false, false}
indexTheme = 0
currentCat = 1
currentSub = 1
currentShot = 1
session_value = 1
session_value_sub = 1
session_shot = 1
x_shot = 195
column = {120, 470, 820}
secondScreen = false

if(currentIdiom == "pt")then
	indexIdiom = 1
elseif(currentIdiom == "en")then
	indexIdiom = 2
elseif(currentIdiom == "es")then
	indexIdiom = 3 
end



--- Categories
url = "http://br.noticias.yahoo.com/%s/?format=rss"
categories = {
   Category:new({name = {'Mundo', 'World', 'Mundo'},          url = string.format(url, 'mundo'), news = {}}),
   Category:new({name = {'Economia', 'Economy', 'Economia'},       url = string.format(url, 'economia'), news = {}}),
   Category:new({name = {'Ciencia' , 'Science', 'Ciencia'},        url = string.format(url, 'ciencia'), news = {}}),
   Category:new({name = {'Brasil', 'Brazil', 'Brasil'},         url = string.format(url, 'brasil'), news = {}}),
   Category:new({name = {'Entretenimento'	, 'Entertainment' 	, 'Entretenimiento'}, url = string.format(url, 'entretenimento'), news = {}}),
   Category:new({name = {'Tecnologia' , 'Technology' , 'Tecnologia'},     url = string.format(url, 'tecnologia'), news = {}})
}

--- Subcategories
subcategories = {}

subcategories['Mundo'] = {
	Category:new({name = {'Mundo', 'World', 'Mundo'},  url = string.format(url, 'mundo'), news = {}}),}

subcategories['Economia']={
	Category:new({name = {'Nacional', 'National', 'Nacional'},	url = string.format(url, 'nacional'), news = {}}),
	Category:new({name = {'Internacional', 'International', 'Internacional'},	url = string.format(url, 'internacional'), news = {}}),
	Category:new({name = {'Política Econômica', 'Policy Economy' , 'Política Econômica'},	url = string.format(url, 'politica-economica'), news = {}}),
	Category:new({name = {'Empresas e Negócios', 'Companies and businesses', 'Empresas y negocios'},	url = string.format(url, 'empresas-negocios'), news = {}}),
	Category:new({name = {'Press Releases', 'Press Releases', 'Press Releases'},	url = string.format(url, 'press-releases'), news = {}})}

subcategories['Ciencia']={
	Category:new({name = {'Saúde', 'Health', 'Salud'},   url = string.format(url, 'saude'), news = {}}),}

subcategories['Brasil']={
	Category:new({name = {'Política', 'Policy', 'Política'}, url = string.format(url, 'politica'), news = {}}),
	Category:new({name = {'Cidades', 'Cities', 'Ciudades'},  url = string.format(url, 'cidades'), news = {}}),}

subcategories['Entretenimento']={
	Category:new({name = {'Cinema','Cinema', 'Cine'},        				url = string.format(url, 'cinema'        ), news = {}}),
	Category:new({name = {'Gente','People', 'Gente'} ,        				url = string.format(url, 'gente'         ), news = {}}),
	Category:new({name = {'Música', 'Music', 'Música'},      	 			url = string.format(url, 'musica'        ), news = {}}),
	Category:new({name = {'TV', 'TV', 'TV'},       							url = string.format(url, 'tv'            ), news = {}}),
	Category:new({name = {'Vídeo e DVD', 'Video and DVD', 'Vídeo y DVD'},    url = string.format(url, 'video-dvd'     ), news = {}}),
	Category:new({name = {'Moda', 'Fashion', 'Moda'},    					url = string.format(url, 'moda'          ), news = {}}),
	Category:new({name = {'Literatura', 'Literature', 'Literatura'  },   	url = string.format(url, 'literatura'    ), news = {}}),
	Category:new({name = {'Artes Visuais', 'Visual Arts', 'Artes Visuales'}, url = string.format(url, 'artes-visuais' ), news = {}}),}

subcategories['Tecnologia']={
	Category:new({name = {'Empresas', 'Companies', 'Empresas'},    url = string.format(url, 'empresas'  ), news = {}}),
	Category:new({name = {'Linux', 'Linux', 'Linux'},      		   url = string.format(url, 'linux'     ), news = {}}),
    Category:new({name = {'Macintosh', 'Macintosh', 'Macintosh'},  url = string.format(url, 'macintosh' ), news = {}}),
	Category:new({name = {'Jogos', 'Games', 'Juegos'},      	   url = string.format(url, 'jogos'     ), news = {}}),
	Category:new({name = {'Internet', 'Internet', 'Internet'},     url = string.format(url, 'internet'  ), news = {}}),
	Category:new({name = {'Telecom', 'Telecom', 'Telecom'},    	   url = string.format(url, 'telecom'   ), news = {}}),}

--- images boxers
box = canvas:new(RES_PATH .."news/elements/BOX/BOX_1-04.png")
box2 	= canvas:new(RES_PATH .."news/elements/BOX/BOX_2-05.png")
boxSelected2 	= canvas:new(RES_PATH .."news/elements/BOX/BOX_2-selected.png")
box3    = canvas:new(RES_PATH .."news/elements/BOX/box_menor.png")
boxersSub = {box2,box2,box2,box2,box2,box2,box2,box2}



--- images shotcurt
iconUnselect = {RES_PATH .."news/elements/ICONS/ic_apple.png",
	RES_PATH .."news/elements/ICONS/ic_artes_visuais.png",
	RES_PATH .."news/elements/ICONS/ic_cidades.png",
	RES_PATH .."news/elements/ICONS/ic_cinema.png",
	RES_PATH .."news/elements/ICONS/ic_economia_internacional.png",
	RES_PATH .."news/elements/ICONS/ic_economia_nacional.png",
	RES_PATH .."news/elements/ICONS/ic_empresas.png",
	RES_PATH .."news/elements/ICONS/ic_gente.png",
	RES_PATH .."news/elements/ICONS/ic_internet.png",
	RES_PATH .."news/elements/ICONS/ic_jogos.png",
	RES_PATH .."news/elements/ICONS/ic_linux.png",
	RES_PATH .."news/elements/ICONS/ic_literatura.png",
	RES_PATH .."news/elements/ICONS/ic_moda.png",
	RES_PATH .."news/elements/ICONS/ic_musica.png",
	RES_PATH .."news/elements/ICONS/ic_negocios.png",
    RES_PATH .."news/elements/ICONS/ic_politica.png",
    RES_PATH .."news/elements/ICONS/ic_politica_economica.png",
	RES_PATH .."news/elements/ICONS/ic_saude.png",
	RES_PATH .."news/elements/ICONS/ic_telecom.png",
	RES_PATH .."news/elements/ICONS/ic_tv.png",
	RES_PATH .."news/elements/ICONS/ic_video_dvd.png"}
	
iconSelect = {RES_PATH .."news/elements/ICONS/ic_apple_selected.png",
	RES_PATH .."news/elements/ICONS/ic_artes_visuais_selected.png",
	RES_PATH .."news/elements/ICONS/ic_cidades_selected.png",
	RES_PATH .."news/elements/ICONS/ic_cinema_selected.png",
	RES_PATH .."news/elements/ICONS/ic_economia_internacional_selected.png",
	RES_PATH .."news/elements/ICONS/ic_economia_nacional_selected.png",
	RES_PATH .."news/elements/ICONS/ic_empresas_selected.png",
	RES_PATH .."news/elements/ICONS/ic_gente_selected.png",
	RES_PATH .."news/elements/ICONS/ic_internet_selected.png",
	RES_PATH .."news/elements/ICONS/ic_jogos_selected.png",
	RES_PATH .."news/elements/ICONS/ic_linux_selected.png",
	RES_PATH .."news/elements/ICONS/ic_literatura_selected.png",
	RES_PATH .."news/elements/ICONS/ic_moda_selected.png",
	RES_PATH .."news/elements/ICONS/ic_musica_selected.png",
	RES_PATH .."news/elements/ICONS/ic_negocios_selected.png",
	RES_PATH .."news/elements/ICONS/ic_politica_selected.png",
	RES_PATH .."news/elements/ICONS/ic_politica_economica_selected.png",
	RES_PATH .."news/elements/ICONS/ic_saude_selected.png",
	RES_PATH .."news/elements/ICONS/ic_telecom_selected.png",
	RES_PATH .."news/elements/ICONS/ic_tv_selected.png",
	RES_PATH .."news/elements/ICONS/ic_video_dvd_selected.png"}

--- Tables utils
shortcutAdress = {subcategories['Tecnologia'][3], subcategories['Entretenimento'][8], subcategories['Brasil'][2],
				 subcategories['Entretenimento'][1], subcategories['Economia'][2], subcategories['Economia'][1],
				 subcategories['Tecnologia'][1], subcategories['Entretenimento'][2], subcategories['Tecnologia'][5],
				 subcategories['Tecnologia'][4], subcategories['Tecnologia'][2], subcategories['Entretenimento'][7],
				 subcategories['Entretenimento'][6], subcategories['Entretenimento'][3], subcategories['Economia'][4],
				 subcategories['Brasil'][1], subcategories['Economia'][3], subcategories['Ciencia'][1], 
				 subcategories['Tecnologia'][6], subcategories['Entretenimento'][4], subcategories['Entretenimento'][5]}
	

categoryName = {"Mundo", "Economia", "Ciencia", "Brasil", "Entretenimento", "Tecnologia"}

--- idioms
language = languages:new()

language:addWordCategory("Mundo"			, "World"			, "Mundo")
language:addWordCategory("Economia"			, "Economy"			, "Economia")
language:addWordCategory("Ciência"			, "Science"			, "Ciencia")
language:addWordCategory("Brasil"			, "Brazil"			, "Brasil")
language:addWordCategory("Entretenimento"	, "Entertainment" 	, "Entretenimiento")
language:addWordCategory("Tecnologia"		, "Technology"		, "Tecnologia")

language:addWordShortcut("Apple", "Apple", "Apple")
language:addWordShortcut("Artes", "Arts", "Artes")
language:addWordShortcut("Cidades","Cities", "Ciudades")
language:addWordShortcut("Cinema", "Cinema", "Cine")
language:addWordShortcut({"Economia","Internacional"}, {"Economy","International"}, {"Economia","Internacional"})
language:addWordShortcut({"Economia", "Nacional"}, {"Economy", "National"}, {"Economia", "Nacional"})
language:addWordShortcut("Empresas", "Companies", "Empresas")
language:addWordShortcut("Gente", "People", "Personas")
language:addWordShortcut("Internet", "Internet", "Internet")
language:addWordShortcut("Jogos", "Games", "Juegos")
language:addWordShortcut("Linux", "Linux", "Linux")
language:addWordShortcut("Literatura", "Literature", "Literatura")
language:addWordShortcut("Moda", "Fashion", "Moda")
language:addWordShortcut("Música", "Music", "Música")
language:addWordShortcut("Negócios", "Affairs", "Negocios")
language:addWordShortcut("Política", "Policy", "Política" )
language:addWordShortcut({"Política", "Economica"}, {"Policy", "Economy"}, {"Política", "Economica"})
language:addWordShortcut("Saúde", "Health", "Salud")
language:addWordShortcut("Telecom", "Telecom", "Telecom")
language:addWordShortcut("Televisão", "Television", "Televisión ")
language:addWordShortcut("Vídeo", "Video", "Vídeo")

language:addWordControls("SAIR", "EXIT", "SALIR")
language:addWordControls("VOLTAR", "BACK", "VOLVER")
language:addWordControls("NAVEGAR", "NAVIGATE", "NAVEGAR")
language:addWordControls("ATUALIZAR", "UPDATE", "ACTUALIZAR")
language:addWordControls("SELECIONAR", "SELECT", "SELECCIONAR")
language:addWordControls("Alta","High","Alta")
language:addWordControls("Baixa","Low","Baja")
language:addWordControls("NOTÍCIAS","NEWS","NOTICIAS")
language:addWordControls("TEMPO","WEATHER","TIEMPO")
