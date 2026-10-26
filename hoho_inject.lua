-- Hoho Hub - Injectable Entry Point
-- Paste this entire script into your executor (Synapse/Xeno/Script-Ware/etc.)
-- It loads the full loader chain from the local filesystem (no key system,
-- no HTTP fetches) and re-runs itself after every teleport.
--
-- Drop the three loader files next to this script (or in hoho_scripts/):
--   Loading_UI.lua, ScriptLoad.lua, ScriptLoadButOlder.lua

local function findFile(name)
	-- Try a few candidate locations so it works regardless of where the
	-- executor's working directory is.
	for _, path in ipairs({
		name,
		"hoho_scripts/" .. name,
		"/home/yu/hoho_scripts/" .. name,
	}) do
		if isfile(path) then
			return path, readfile(path)
		end
	end
	return nil, nil
end

local function loadLocal(name)
	local path, src = findFile(name)
	if not src then
		warn("[Hoho] Could not find local file: " .. name)
		return nil
	end
	return loadstring(src)
end

local function run()
	-- Load the loader chain locally. Each step falls back to the next
	-- file in the chain, all from disk.
	local loadUI = loadLocal("Loading_UI.lua")
	if loadUI then
		pcall(loadUI)
		return
	end

	local loadMain = loadLocal("ScriptLoad.lua")
	if loadMain then
		pcall(loadMain)
		return
	end

	local loadOld = loadLocal("ScriptLoadButOlder.lua")
	if loadOld then
		pcall(loadOld)
		return
	end

	warn("[Hoho] No loader files found locally.")
end

-- Re-queue on teleport so the script survives server hops.
local function queueOnTeleport(src)
	local q = (syn and syn.queue_on_teleport) or queue_on_teleport
	if q then
		q(src)
	end
end

-- Capture this script's source so it can be re-queued verbatim.
local selfSrc = debug.info(1, "s") or ""

-- Execute the loader chain now.
run()

-- If we have the raw source available, re-queue it on teleport.
if selfSrc ~= "" then
	queueOnTeleport(selfSrc)
end