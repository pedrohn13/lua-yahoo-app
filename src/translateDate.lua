--@class TranslateDate

---remove elements unimportant of date
--@param String
--@return String
function filterDate(data)
	local dayOfMonth = string.sub(data,6,17)
	local hours = string.sub(data,18,22)
	
	if(currentIdiom == "pt" or currentIdiom == "sp")then
		return hours .. "     " .. translateDayOfMonth(dayOfMonth)
	
	elseif(currentIdiom == "en")then
		return hours .. "     " .. dayOfMonth
	end
end

---translate day of month to portuguese
--@param String
--@return String
function translateDayOfMonth (dayOfMonth)
	
	monthInPortuguese = {" Jan ", " Fev ", " Mar ", " Abr ",
	" Mai ", " Jun ", " Jul ", " Ago ", " Set ", " Out ",
	" Nov ", " Dez "}
	
	monthInEnglish = {"Jan", "Feb", "Mar","Apr","May","Jun", "Jul", "Aug",
	"Sep", "Oct", "Nov", "Dec"}
	
	monthInSpanish = {" Ene ", " Feb ", " Mar ", " Abr ",
	" May ", " Jun ", " Jul ", " Ago ", " Set ", " Oct ",
	" Nov ", " Dic "}
	
	if(currentIdiom == "sp")then
		for i,v in ipairs(monthInSpanish) do
			if(string.sub(dayOfMonth,4,6) == v) then
				dayOfMonth = string.sub(dayOfMonth,1,2) .. monthInPortuguese[i] .. string.sub(dayOfMonth,8,11) 
				return dayOfMonth
			end
		end
	end
	
	for i,v in ipairs(monthInEnglish) do
		if(string.sub(dayOfMonth,4,6) == v) then
				dayOfMonth = string.sub(dayOfMonth,1,2) .. monthInPortuguese[i] .. string.sub(dayOfMonth,8,11) 
				return dayOfMonth
		end
	end
end
