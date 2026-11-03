-- JX3 ConsolePort P0 -- historical API compatibility probe.
-- No skill casts, movement, memory reads, hooks or automated actions.
-- IMPORTANT: run inside the live client only when officially permitted.
-- Repeated entry execution in the same Lua VM must not add another binding.
if type(JX3CP_P0) == "table" and JX3CP_P0.started then
    return
end
JX3CP_P0 = {}
local M = JX3CP_P0
M.VERSION = "0.1.1-probe"
M.capabilities = {}
M.events = { down = 0, up = 0 }
M.messages = {}
M.registration = { status = "not_attempted" }
M.runtime = _VERSION

-- Some client namespaces may be userdata or expose throwing __index methods.
local function member(namespace, name)
    local kind = type(namespace)
    if kind ~= "table" and kind ~= "userdata" then return nil end
    local ok, value = pcall(function() return namespace[name] end)
    if ok and type(value) == "function" then return value end
    return nil
end

local function output(msg)
    local line = "[JX3CP-P0] " .. tostring(msg)
    M.messages[#M.messages + 1] = line
    if #M.messages > 80 then table.remove(M.messages, 1) end
    if type(Output) == "function" then
        local ok, result = pcall(Output, line)
        if ok and result ~= false then return true end
    end
    if type(Log) == "function" then
        local ok, result = pcall(Log, line)
        if ok and result ~= false then return true end
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
        member(Hotkey, "AddBinding") ~= nil
    M.capabilities["Hotkey.Get"] =
        member(Hotkey, "Get") ~= nil
    M.capabilities["Station.GetUIScale"] =
        member(Station, "GetUIScale") ~= nil
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
    if M.registration.status == "call_ok_unverified" then return true end
    local addBinding = member(Hotkey, "AddBinding")
    if not addBinding then
        M.registration.status = "unavailable"
        output("Hotkey.AddBinding unavailable; skip debug key registration")
        return false
    end
    local ok, result = pcall(function()
        -- User must assign a key from the in-game Keybinding UI, if supported.
        return addBinding(
            "JX3CP_P0_PING", "JX3CP Debug Ping", "JX3CP",
            M.OnPingDown, M.OnPingUp
        )
    end)
    if not ok then
        M.registration.status = "error"
        M.registration.error = tostring(result)
        output("hotkey registration error: " .. M.registration.error)
        return false
    end
    if result == false then
        M.registration.status = "rejected"
        output("hotkey registration returned false")
        return false
    end
    -- A nil/true return only means the call did not fail. Confirm in game UI.
    M.registration = { status = "call_ok_unverified" }
    output("debug binding call completed; visibility and callbacks unverified")
    return true
end

function M.Start()
    if M.started then return false end
    M.Probe()
    M.started = true
    output("Lua entry executed; version=" .. M.VERSION .. "; runtime=" .. tostring(M.runtime))
    for _, name in ipairs(probes) do
        output(name .. " = " .. tostring(M.capabilities[name]))
    end
    output("Hotkey.AddBinding = " .. tostring(M.capabilities["Hotkey.AddBinding"]))
    output("Station.GetUIScale = " .. tostring(M.capabilities["Station.GetUIScale"]))
    M.TryRegisterDebugHotkey()
    return true
end

M.Start()
