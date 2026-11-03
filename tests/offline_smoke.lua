-- Run from repository root: lua tests/offline_smoke.lua
local outputs = {}
local debugBinding
Output = function(message) outputs[#outputs + 1] = message end
Hotkey = {
    AddBinding = function(name, label, group, onDown, onUp)
        assert(name == "JX3CP_P0_PING")
        debugBinding = {down = onDown, up = onUp}
    end,
    Get = function() return 0 end,
}
Station = {GetUIScale = function() return 1 end}
RegisterEvent = function() end
assert(loadfile("addon/JX3CP_P0/Main.lua"))()
assert(JX3CP_P0 and JX3CP_P0.VERSION == "0.1.1-probe")
assert(JX3CP_P0.capabilities["Hotkey.AddBinding"] == true)
assert(JX3CP_P0.capabilities["GetSkill"] == false)
assert(debugBinding)
assert(JX3CP_P0.registration.status == "call_ok_unverified")
debugBinding.down()
debugBinding.up()
assert(JX3CP_P0.events.down == 1 and JX3CP_P0.events.up == 1)
print("OFFLINE SMOKE TEST PASSED")
for _, value in ipairs(outputs) do print(value) end
