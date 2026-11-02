# JX3CP P0 - API validation matrix

Source code appearance != approved whitelist != accessible in current client != correct behavior.

| Candidate | Source evidence | Test | Expected result | Status |
|---|---|---|---|---|
| info.ini lua_0=Main.lua | JX3MY / MY_Target / info.ini | Plugin visible / entry log | Visible AND executed | Not tested in current client |
| Output | EasyUI EasyTestAddon.lua | Entry message | Debug log / output shown | Not tested |
| Hotkey.AddBinding | JX3MY System.Hotkey.lua | Assign Debug Ping; press/release | Exactly one down and one up | Not tested |
| Hotkey.Get | JX3MY System.Hotkey.lua | Read existing mapped key | Matches game UI | Not tested |
| IsKeyDown | historical LuaJx3.api | Query on permitted event | Correct key state | Not tested |
| OnFrameKeyDown | EasyUI EasyTestAddon.lua | UI-focused frame only | Event observed without capturing game keys | Not tested |
| RegisterEvent | JX3MY Game.Skill.lua | Read-only event subscription | Correct firing, clean unsubscribe | Not tested |
| UI_GetClientPlayerID | historical / EasyUI | Read own ID | Non-nil in world | Not tested |
| GetSkill / Table_GetSkillIconID | JX3MY Game.Skill.lua | Read known skill metadata | Correct icon | Not tested |
| GetSkillCDProgress | JX3MY Game.Skill.lua player method | Read own cooldown state | Correct cooldown | Not tested |
| Station.GetUIScale | JX3MY System.UI.lua | Read scale | Matches current UI scale | Not tested |
| LoadLUAData/SaveLUAData | historical LuaJx3.api | Test only approved addon-local storage | Roundtrip correct | Not tested |

Do not test gameplay-affecting API calls or inject inputs in the Lua addon.
First verify current official developer guidance and availability of an approved test environment.
