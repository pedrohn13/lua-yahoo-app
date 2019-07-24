applicationManager = {}

function applicationManager.getRunningApplication(applicationType)
	local app = {["id"] = 1, ["name"] = "AppName", ["description"] = "AppDescription",
					["entrypoint"] = "AppEntryPoint", ["icon"] = "AppIconPath"}
	return app
end

function applicationManager.stopApplication(appId)
	if (tonumber(appId) ~= nil) then
		canvas:clear()
		canvas:flush()
	end
end

return applicationManager