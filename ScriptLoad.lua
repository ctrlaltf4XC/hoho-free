-- ScriptLoad.lua
-- Key-free local loader.
-- The key system (luarmor validation, HOHO_Passcheck GUI, do_check_key)
-- has been removed. Game scripts are loaded via ScriptLoadButOlder.lua
-- which is loaded from the local filesystem.

local Players = game:GetService("Players")

repeat task.wait() until game:IsLoaded() and Players.LocalPlayer

local function loadLocal(name)
	-- Prefer loading from the local filesystem; fall back to HTTP for the
	-- loader chain itself so it still works if a file is missing.
	for _, path in ipairs({name, "hoho_scripts/" .. name, "/home/yu/hoho_scripts/" .. name}) do
		if isfile(path) then
			return loadstring(readfile(path))
		end
	end
	return loadstring(game:HttpGet("https://raw.githubusercontent.com/acsu123/HohoV2/refs/heads/main/" .. name))
end

-- Load the game-script loader locally. No key system is required.
loadLocal("ScriptLoadButOlder.lua")()