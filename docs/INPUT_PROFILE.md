# Controller input profile - DESIGN, NOT AN IMPORTABLE STEAM INPUT PROFILE

Current execution decision (2026-11-02): retain 16 slots (RT 8 + LT 8). Treat simultaneous LT+RT as no new skill action, while still requiring all already-held keys to release; this behavior must be proven in the chosen input tool, not assumed from the design. Stick deadzones, camera sensitivity and action-layer configuration belong to that tool. A Lua Profile can record the intended mapping but cannot configure Steam Input without a separately verified integration. Device and game-side mapping remain untested. See [IMPLEMENTATION_PLAN.md](IMPLEMENTATION_PLAN.md).

## Recommended Steam Input model
Use a **Keyboard + Mouse (legacy mode)** base layout and **Mode Shifting / Action Set Layers** for trigger-held skill actions. Valve documents mode-shift and layer support; test exact editor behavior on the installed Steam version. Non-Steam applications may require launcher/focus testing. Use only where current game policy permits.

Do **not** map plain A to Jump AND `RT + A` to a skill without overriding the base action in the RT layer. Otherwise both actions may fire. Trigger state remains in Steam Input: the JX3 addon may have no way to observe it.

| Physical gesture | Proposed output | Remarks |
|---|---|---|
| Left stick | W/A/S/D | DIGITAL movement; not true analog |
| Right stick | Relative mouse movement | Camera may require a game-supported right-mouse camera mode |
| A without trigger | Space | Jump |
| RT held + A/X/Y/B | 1/2/3/4 | Overridden by RT action layer; no Jump |
| RT held + D-pad Up/Left/Right/Down | 5/6/7/8 | First group, 8 actions total |
| LT held + A/X/Y/B | Ctrl+1/2/3/4 | Second group (game bindings must match) |
| LT held + D-pad Up/Left/Right/Down | Ctrl+5/6/7/8 | Second group, 8 actions total |
| LT+RT held simultaneously | Not assigned in P0 | Add a distinct third layer only after layer-priority tests |
| LB/RB no trigger | Game's bound target commands | Manual, no target automation |
| Menu | Approved in-game keybinding, if present | Intended for a future radial menu |

Alternative implementation: RT outputs held Alt, LT outputs held Ctrl and face buttons output 1-8; in this case unmodified A cannot simultaneously be used for Jump. Prefer dedicated action layers for the P0 base/skill distinction.

## Key collision and state tests
Check: trigger-first vs face-first; release trigger before face release; accidental double output; simultaneous LT/RT; movement while camera turning; chat entry; alt-tab; overlay focus; unplug/reconnect; UI remapping; combat/no combat. Steam Input mapping must never send timed attack sequences or automated rotations.

## HUD synchronization strategies
A: if approved IsKeyDown can read the same keyboard modifier keys, it may show the active skill layer.
B: if approved plugin hotkeys deliver both key-down/up callbacks, show short-lived feedback tied to key events.
C: with no input observability, display both static groups without dynamic RT/LT highlights.
Since Steam action layers need not send keyboard modifier keys, strategy A does NOT automatically work with action-layer mapping. Do not assume an IPC connection between Steam Input and JX3 Lua.
