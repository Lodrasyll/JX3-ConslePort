-- Contract and failure tests; these mocks do not certify any game API.
local passed = 0
local function reset()
    for _, name in ipairs({
        "JX3CP_P0", "Output", "Log", "Hotkey", "Station", "RegisterEvent",
        "IsKeyDown", "UI_GetClientPlayerID", "GetSkill", "Table_GetSkillName",
        "Table_GetSkillIconID", "GetKeyShow", "LoadLUAData", "SaveLUAData",
    }) do _G[name] = nil end
end
local function loadAddon()
    assert(loadfile("addon/JX3CP_P0/Main.lua"))()
    return JX3CP_P0
end
local function test(name, fn)
    reset()
    local ok, err = pcall(fn)
    assert(ok, name .. ": " .. tostring(err))
    passed = passed + 1
    print("PASS " .. name)
end

test("binding contract and one press/release", function()
    local callbacks, calls = nil, 0
    Hotkey = { AddBinding = function(id, label, group, down, up)
        assert(id == "JX3CP_P0_PING" and label == "JX3CP Debug Ping")
        assert(group == "JX3CP" and type(down) == "function" and type(up) == "function")
        callbacks = { down = down, up = up }
        calls = calls + 1
    end }
    local m = loadAddon()
    callbacks.down(); callbacks.up()
    assert(m.events.down == 1 and m.events.up == 1 and calls == 1)
    assert(m.registration.status == "call_ok_unverified")
end)

test("raw callbacks remain observable", function()
    local m = loadAddon()
    m.OnPingDown(); m.OnPingDown(); m.OnPingUp()
    assert(m.events.down == 2 and m.events.up == 1)
    -- Never hide a duplicate client callback with software deduplication.
end)

test("no optional APIs or loggers", function()
    local m = loadAddon()
    assert(m.started and not m.capabilities["Hotkey.AddBinding"])
    assert(m.registration.status == "unavailable")
    assert(m.output("no logger") == false)
    assert(string.find(m.messages[1], "Lua entry executed", 1, true))
end)

test("unexpected namespace types", function()
    Hotkey = 17; Station = true
    local m = loadAddon()
    assert(not m.capabilities["Hotkey.AddBinding"])
    assert(not m.capabilities["Station.GetUIScale"])
end)

test("throwing namespace lookup", function()
    Hotkey = setmetatable({}, { __index = function() error("blocked lookup") end })
    Station = Hotkey
    local m = loadAddon()
    assert(m.registration.status == "unavailable")
end)

test("Output exception falls back to Log", function()
    local lines = {}
    Output = function() error("Output unavailable") end
    Log = function(line) lines[#lines + 1] = line end
    local m = loadAddon()
    assert(#lines > 0 and m.output("fallback"))
    assert(string.find(lines[#lines], "fallback", 1, true))
end)

test("Output false falls back to Log", function()
    local calls = 0
    Output = function() return false end
    Log = function() calls = calls + 1 end
    local m = loadAddon()
    local before = calls
    assert(m.output("fallback") and calls == before + 1)
end)

test("both loggers throw and buffer is bounded", function()
    Output = function() error("Output failure") end
    Log = function() error("Log failure") end
    local m = loadAddon()
    for i = 1, 100 do assert(not m.output("message " .. i)) end
    assert(#m.messages == 80)
    assert(string.find(m.messages[80], "message 100", 1, true))
end)

test("registration exception", function()
    Hotkey = { AddBinding = function() error("API blocked") end }
    local m = loadAddon()
    assert(m.registration.status == "error")
    assert(string.find(m.registration.error, "API blocked", 1, true))
end)

test("registration false is rejection", function()
    Hotkey = { AddBinding = function() return false end }
    local m = loadAddon()
    assert(m.registration.status == "rejected")
    assert(not m.TryRegisterDebugHotkey())
end)

test("missing API may be retried after availability", function()
    local m, calls = loadAddon(), 0
    Hotkey = { AddBinding = function() calls = calls + 1; return true end }
    m.Probe()
    assert(m.TryRegisterDebugHotkey() and calls == 1)
    assert(m.TryRegisterDebugHotkey() and calls == 1)
end)

test("repeat Start and file execution do not double register", function()
    local calls, down, up = 0
    Hotkey = { AddBinding = function(_, _, _, d, u)
        calls = calls + 1; down = d; up = u
    end }
    local m = loadAddon()
    assert(not m.Start())
    assert(loadAddon() == m and calls == 1)
    for _ = 1, 3 do down(); up() end
    assert(m.events.down == 3 and m.events.up == 3)
end)

test("presence probe never invokes read-only candidates", function()
    local function forbidden() error("probe must only inspect types") end
    RegisterEvent = forbidden; GetSkill = forbidden; SaveLUAData = forbidden
    Station = { GetUIScale = forbidden }
    local m = loadAddon()
    assert(m.capabilities.GetSkill and m.capabilities.SaveLUAData)
    assert(m.capabilities["Station.GetUIScale"])
end)

print("OFFLINE REGRESSION TESTS PASSED (" .. passed .. ")")
return passed
