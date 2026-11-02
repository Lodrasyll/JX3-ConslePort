# JX3CP P0 backlog / acceptance criteria

## Gate 0: permission and environment
- [ ] Confirm current official plugin author registration / certification process and usable API whitelist
- [ ] Confirm current client/build/region and installation path
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
- [ ] 8 static slot display, configurable positions
- [ ] 8+8 mapping crossbar and optional layer highlight
- [ ] Display only; **never** fire skills from Lua addon
- [ ] One radial menu demo with approved action; no automation
- [ ] Existing mouse/keyboard still work
- [ ] 30-minute test without noticeable FPS impact or UI errors
