# JX3CP P0 - PC flagship prototype starter

This archive contains an unapproved **development sample**, NOT an official JX3 plugin.
Do not install or run it in the production client unless current official rules explicitly permit your own test addon. Game-side loading and API availability have NOT been verified by the author of this archive.

## Layout
- `addon/JX3CP_P0/` historical JX3 addon layout (`info.ini`, `Main.lua`).
- `docs/API_MATRIX.md` candidate API read-only validation plan.
- `docs/INPUT_PROFILE.md` controller-to-keyboard proposal, not Steam Input import format.
- `docs/TASKS.md` P0 sprint backlog.
- `tests/offline_smoke.lua` standard Lua smoke test with mocked game API (no live client).

## Offline test
From this directory run `lua tests/offline_smoke.lua` in an installed Lua interpreter.
Expected: `OFFLINE SMOKE TEST PASSED`.

## Controlled live loading (ONLY if official permission is confirmed)
1. Locate the current PC flagship install `bin/zhcn/interface/` directory (may vary by launcher).
2. Copy ONLY `addon/JX3CP_P0` into that directory, preserving the single folder level.
3. Re-enter character selection screen, select Plugin Manager, locate `JX3CP Prototype P0`.
4. If not listed / denied for certification, STOP. Do not patch or bypass protections.
5. If permitted to load, inspect approved output logs for `[JX3CP-P0]`.
6. If `JX3CP Debug Ping` appears under keybindings, bind a test key that does not conflict with combat; test down/up in a safe non-combat area.
7. Uninstall by removing only the `JX3CP_P0` folder after closing the client.

`version=1.0` and `lua_0=Main.lua` follow historical JX3MY examples; adapt only per current authoritative developer guidance. Addon title and file content intentionally use ASCII to avoid legacy INI encoding problems.

## Sources to independently recheck
- https://github.com/tinymins/JX3MY/blob/master/MY_Target/info.ini
- https://github.com/tinymins/JX3MY/blob/master/MY_%21Base/src/lib/System.Hotkey.lua
- https://github.com/tinymins/JX3MY/blob/master/MY_%21Base/src/lib/Game.Skill.lua
- https://github.com/kiethen/EasyUI/blob/master/EasyTestAddon.lua
- https://partner.steamgames.com/doc/features/steam_controller/concepts
