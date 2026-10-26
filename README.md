# Hoho Free

Key-free local loader chain for HoHo Hub. No luarmor key system, no HTTP fetches for the loader — everything loads from the local filesystem.

## Injectable Link

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/ctrlaltf4XC/hoho-free/master/hoho_inject.lua"))()
```

## How It Works

1. `hoho_inject.lua` — injectable entry point. Fetches the loader chain from disk and re-queues on teleport.
2. `Loading_UI.lua` — loads `ScriptLoad.lua` locally.
3. `ScriptLoad.lua` — waits for game, loads `ScriptLoadButOlder.lua` locally.
4. `ScriptLoadButOlder.lua` — runs the game-specific script from `list[]`, or loads `Loading_UI.lua` locally for unsupported games.

## Files

| File | Purpose |
|------|---------|
| `hoho_inject.lua` | Paste into executor (Synapse/Xeno/Script-Ware/etc.) |
| `Loading_UI.lua` | Local loader entry |
| `ScriptLoad.lua` | Key-free main loader |
| `ScriptLoadButOlder.lua` | Game-script loader (unchanged) |