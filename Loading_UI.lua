-- Loads the main loader from the local filesystem instead of fetching it over HTTP.
local function loadLocal(name)
	for _, path in ipairs({name, "hoho_scripts/" .. name, "/home/yu/hoho_scripts/" .. name}) do
		if isfile(path) then
			return loadstring(readfile(path))
		end
	end
	error("Could not load local file: " .. name)
end

loadLocal("ScriptLoad.lua")()