-- JX3 ConsolePort P0 -- historical API compatibility probe.
-- No skill casts, movement, memory reads, hooks or automated actions.
-- IMPORTANT: run inside the live client only when officially permitted.
JX3CP_P0 = JX3CP_P0 or {}
local M = JX3CP_P0
M.VERSION = "0.1.0-probe"
M.capabilities = {}
M.events = { down = 0, up = 0 }

local function output(msg)
    local line = "[JX3CP-P0] " .. tostring(msg)
    if type(Output) == "function" then
        local ok = pcall(Output, line)
        if ok then return true end
    end
    if type(Log) == "function" then
        local ok = pcall(Log, line)
        if ok then return true end
    end
    return false
end
M.output = output

local probes = {
    "RegisterEvent", "IsKeyDown", "UI_GetClientPlayerID",
    "GetSkill", "Table_GetSkillName", "Table_GetSkillIconID",
    "GetKeyShow", "LoadLUAData", "SaveLUAData",
}

function M.Probe()
    for _, name in ipairs(probes) do
        M.capabilities[name] = type(_G[name]) == "function"
    end
    -- Presence is NOT proof of whitelist permission or correct runtime behavior.
    M.capabilities["Hotkey.AddBinding"] =
        Hotkey ~= nil and type(Hotkey.AddBinding) == "function" or false
    M.capabilities["Hotkey.Get"] =
        Hotkey ~= nil and type(Hotkey.Get) == "function" or false
    M.capabilities["Station.GetUIScale"] =
        Station ~= nil and type(Station.GetUIScale) == "function" or false
    return M.capabilities
end

function M.OnPingDown()
    M.events.down = M.events.down + 1
    output("debug hotkey DOWN (count=" .. M.events.down .. ")")
end

function M.OnPingUp()
    M.events.up = M.events.up + 1
    output("debug hotkey UP (count=" .. M.events.up .. ")")
end

function M.TryRegisterDebugHotkey()
    if not M.capabilities["Hotkey.AddBinding"] then
        output("Hotkey.AddBinding unavailable; skip debug key registration")
        return false
    end
    local ok, err = pcall(function()
        -- User must assign a key from the in-game Keybinding UI, if supported.
        Hotkey.AddBinding(
            "JX3CP_P0_PING", "JX3CP Debug Ping", "JX3CP",
            M.OnPingDown, M.OnPingUp
        )
    end)
    if not ok then
        output("hotkey registration error: " .. tostring(err))
    end
    return ok
end

function M.Start()
    M.Probe()
    output("Lua entry executed; version=" .. M.VERSION)
    for _, name in ipairs(probes) do
        output(name .. " = " .. tostring(M.capabilities[name]))
    end
    output("Hotkey.AddBinding = " .. tostring(M.capabilities["Hotkey.AddBinding"]))
    output("Station.GetUIScale = " .. tostring(M.capabilities["Station.GetUIScale"]))
    M.TryRegisterDebugHotkey()
end

M.Start()
