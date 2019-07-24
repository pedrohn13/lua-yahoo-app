
control = {}

function control.getSystemPreference(key)
	if (key == "currentLanguage") then
		return settings.system.language
	end
end

return control