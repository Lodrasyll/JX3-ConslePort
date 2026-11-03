# JX3CP P0 backlog / acceptance criteria

## Current verification: 2026-11-02

Goal status: **blocked, not complete** after the same app-control initialization failure recurred across three goal turns. No running JX3 client or new live logs were observed in the final check. Resume when app control recovers or actual client test results become available.

- [ ] Official self-made addon testing/certification permission: researched, unconfirmed; user requested proceeding with ordinary checks.
- [x] Actual flagship Interface: `E:\SeasunGame\Game\JX3\bin\zhcn_hd\interface`.
- [x] Offline Lua syntax and mocked API tests: Lua 5.1 + 5.4, smoke and 13 regression cases per runtime.
- [x] Probe `0.1.1-probe` staged disabled in its own new directory; source/destination SHA-256 match.
- [ ] Plugin Manager discovers JX3CP_P0: no live observation.
- [ ] Main.lua executes and produces visible game debug output: offline only.
- [ ] JX3CP Debug Ping appears in game keybindings.
- [ ] Real key press/release fires exactly one callback each: offline only.
- [x] Local config version, addon version, hashes and offline results recorded.
- [ ] Game-screen build, server/test environment, device and live test results recorded.

Windows app control failed to start (`helper_unknown_error: setup refresh had errors`); no live client acceptance/rejection was observed. See [LOAD_TEST_REPORT.md](LOAD_TEST_REPORT.md), [IMPLEMENTATION_PLAN.md](IMPLEMENTATION_PLAN.md), and [TEST_CASES.md](TEST_CASES.md). Historical checklist below remains open where it requires live evidence.

## Gate 0: permission and environment
- [ ] Confirm current official plugin author registration / certification process and usable API whitelist
- [x] Record installed config version/region and actual path (game-screen build still pending)
- [ ] Confirm approved test method for an unsigned new addon; stop if unsigned addons are blocked
- [ ] Preserve a clean copy of game config and addon folder

## P0: loading
- [ ] Validate `JX3CP_P0/info.ini` discovery on login addon manager
- [ ] Confirm `Main.lua` executed (visible output or approved log)
- [ ] Record whether `version=1.0` is accepted
- [ ] Record error location, screenshots, and client build

## P1: input keyboard mapping
- [ ] Steam Input or approved alternative: no game modification
- [ ] Left-stick digital movement in 8 directions
- [ ] Right-stick camera mode with relative mouse input
- [ ] RT/LT keyboard modifier held state verified
- [ ] Four face buttons, four D-pad buttons; no duplicated key events
- [ ] All inputs stop on disconnection and focus loss

## P2: Lua hotkey & read-only skill data
- [ ] Debug Ping binding appears and fires once on down/up
- [ ] Verify whether plugin can read Ctrl/Alt/Shift state
- [ ] Verify skill icon and cooldown display from whitelist API
- [ ] Verify UI scaling + visibility without covering standard HUD

## P3: first UI prototype
- [ ] 16 static slots (RT 8 + LT 8), configurable positions
- [ ] 8+8 mapping crossbar and optional layer highlight
- [ ] Display only; **never** fire skills from Lua addon
- [ ] One radial menu demo with approved action; no automation
- [ ] Existing mouse/keyboard still work
- [ ] 30-minute test without noticeable FPS impact or UI errors
