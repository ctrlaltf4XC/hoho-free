-- Hoho Hub - Sober Executor Wrapper
-- Paste this into Sober (or any UNC-compatible executor).
-- Loads the key-free hoho chain from the local filesystem and
-- re-queues itself on teleport.
--
-- Requires the loader files to exist locally (see hoho_inject.lua):
--   Loading_UI.lua, ScriptLoad.lua, ScriptLoadButOlder.lua

local function getExecutorName()
	local name
	pcall(function()
		name = (identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname())
	end)
	return name or ""
end

local function isSober()
	return getExecutorName():lower():find("sober") ~= nil
end

-- Resolve a local file across common working directories.
local function findLocal(name)
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
	local path, src = findLocal(name)
	if not src then
		warn("[Hoho] Local file not found: " .. name)
		return nil
	end
	return loadstring(src)
end

local function queueOnTeleport(src)
	local q
	pcall(function()
		q = (syn and syn.queue_on_teleport) or queue_on_teleport
	end)
	if q then
		q(src)
		return true
	end
	-- Sober may expose a different teleport-queue global; try a few.
	for _, key in ipairs({ "sober_queue_on_teleport", "queue_on_teleport", "queueonteleport" }) do
		local fn = getgenv()[key] or _G[key]
		if type(fn) == "function" then
			pcall(function() fn(src) end)
			return true
		end
	end
	return false
end

-- Load the chain. Try Loading_UI first (full entry), then fall back to
-- ScriptLoad and ScriptLoadButOlder directly.
local function run()
	local loaded = false

	local loadUI = loadLocal("Loading_UI.lua")
	if loadUI then
		local ok = pcall(loadUI)
		if ok then loaded = true end
	end

	if not loaded then
		local loadMain = loadLocal("ScriptLoad.lua")
		if loadMain then
			local ok = pcall(loadMain)
			if ok then loaded = true end
		end
	end

	if not loaded then
		local loadOld = loadLocal("ScriptLoadButOlder.lua")
		if loadOld then
			local ok = pcall(loadOld)
			if ok then loaded = true end
		end
	end

	if not loaded then
		warn("[Hoho] No loader files found locally.")
	end
end

-- Re-queue this script's source on teleport.
local selfSrc = debug.info(1, "s") or ""
if selfSrc ~= "" then
	queueOnTeleport(selfSrc)
end

run()

if isSober() then
	print("[Hoho] Loaded via Sober executor.")
end