# JX3CP P0 - API validation matrix

Source code appearance != approved whitelist != accessible in current client != correct behavior.

## Evidence update: 2026-11-02

- Local `bin/zhcn_hd/interface` and installed MY manifests confirm the presence of `version=1.0` and `lua_0` fields. Discovery/execution of a new standalone addon remains unverified.
- [MY System.Hotkey.lua](https://github.com/tinymins/JX3MY/blob/master/MY_%21Base/src/lib/System.Hotkey.lua) distinguishes framework wrapper `MY.RegisterHotKey` from global calls to `Hotkey.AddBinding(name, title, group, down, up)` and `Hotkey.Get`. This is source evidence, not current API permission.
- [EasyTestAddon.lua](https://github.com/kiethen/EasyUI/blob/master/EasyTestAddon.lua) demonstrates `Output`, frame-bound `this:RegisterEvent`, and `OnFrameKeyDown`. It does not prove a global `RegisterEvent` is usable. Those forms must be verified separately.
- `Log` is an unverified fallback in the probe, not a confirmed official logging API.
- Stock Lua 5.1/5.4 mocks verify the probe's contract/error behavior only. All **current-client** statuses in the table below remain untested. Probe presence checks invoke no skill, storage, scale, or player API.
- `call_ok_unverified` means only that registration did not throw or explicitly return false; manager visibility, permission and actual callbacks need separate live evidence.
- Installed MY entry files are not plain text; no decompilation or claim about their runtime internals was made.

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
