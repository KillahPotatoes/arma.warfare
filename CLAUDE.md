# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

An Arma 3 multiplayer mission ("arma.warfare", sector control) written in SQF. The repo root *is* the mission
folder. There is no build system, package manager, linter, or test suite — the game engine is the only runtime.

## Loading scripts (most common mistake)

A new `.sqf` file does nothing until it is registered. Every script is loaded explicitly:

```sqf
[] call compileFinal preprocessFileLineNumbers "client\ui\my_script.sqf";
```

- Paths use **backslashes** and are relative to the mission root.
- Register client scripts in `init.sqf`, server scripts in `initServer.sqf`. `shared/` scripts are registered in
  **both**.
- Order matters: these lines execute the file at load time, so a script must be registered after anything it calls
  at top level. Files define global functions (`ARWA_foo = { ... }`) and may also run top-level statements.
- In **multiplayer** `initServer.sqf` runs *before* `init.sqf` (in singleplayer it is the reverse). Server setup
  cannot depend on anything `init.sqf` defines.
- Use `call` for definitions, `spawn` only for scripts that loop (see the `[] spawn ARWA_*` block at the bottom of
  the init files).

## Locality

- `server/` — runs on the server only (`initServer.sqf`). Owns faction state, sectors, battlegroups, AI.
- `client/` — runs on each player (`init.sqf`). UI, player actions, menus.
- `shared/` — loaded on both.
- Cross the boundary with `remoteExec`: `[args] remoteExec ["ARWA_fn", 2]` targets the server; omit the target to
  broadcast to clients. There is no `CfgRemoteExec` whitelist in `Description.ext`.
- Shared state uses `missionNamespace setVariable [..., true]` — the trailing `true` (public) is required or clients
  will not see it.

## Naming and state

- Every global — function, variable, constant — is prefixed `ARWA_` and uses `snake_case`.
- Object/namespace variable *keys* are constants declared in `presets/global_variables.sqf` as `ARWA_KEY_*`. Use the
  constant, never a raw string literal: `_box setVariable [ARWA_KEY_manpower, 0, true]`.
- Faction/tier/manpower state has getters and setters in `shared/access_methods.sqf` (`ARWA_get_tier`,
  `ARWA_set_strength`, `ARWA_get_hq_pos`, …). Use those instead of reading `missionNamespace` directly.
- Generic helpers live in `shared/common/common.sqf` — check there before writing a new one.

## Mission parameters

Player-facing settings are declared as a `class` inside `class Params` in `Description.ext`, then read once at load
time into an `ARWA_*` global:

```sqf
ARWA_difficulty = ["Difficulty", 0] call BIS_fnc_getParamValue;
```

The name in `Description.ext` and the string in `BIS_fnc_getParamValue` must match exactly. `values[]` and `texts[]`
must be the same length, and defaults must be whole numbers.

## Strings

All user-facing text goes in `stringtable.xml` under an `ARWA_STR_*` key (English + German) and is read with
`localize "ARWA_STR_..."`. Never hardcode display strings in SQF.

## Unit/vehicle presets

Class name lists live in `presets/army_presets/*.sqf` and `presets/civilian_presets/*.sqf` as arrays of
`[classname, cost]`, named `ARWA_<side>_<type>_tier_<n>` (side is `west`/`east`/`guer`). Adding a preset file
requires wiring it in **both** `presets/preset.sqf` (the `ARWA_pick_*_preset` index switch) and the matching
`Params` class in `Description.ext` — the numeric index must line up.

## Mission files (.sqm)

**Never edit any `.sqm` by hand** — they are Eden editor output and are frequently binarized. Each
`missions/<map>/mission.sqm` is an independently maintained layout for that map. The root `mission.sqm` is a
scratch working copy (gitignored) holding whichever map is currently loaded — swap it with
`node .claude/tools/use-map.js <map>`. Changes to layouts come from the editor, not from Claude.

There is no build step: Arma missions are folders. `use-map.js` links the repo into the Arma profile as
`arma.warfare.<WorldClass>` — the world comes from that folder name, not from the `.sqm`. See the `test-map` skill.

Eden naming conventions the scripts depend on: sector markers are `sector_<name>`; base objects are
`<prefix>_vehicle`, `<prefix>_helicopter`, `<prefix>_respawn_ground`; ammo boxes are named `HQ_<name>` or
`FOB_<name>`. Prefixes are `alpha`, `charlie`, `delta`, assigned to sides randomly at mission start.

## Vendored code

`KPGUI/` and `KPPLM/` are third-party KP framework modules (KP Player Menu / ranks) with their own header and
naming conventions. Do not refactor or restyle them.

## Style

Tabs for indentation. `params [...]` at the top of every function body, `private` on all local variables.

## Testing and etiquette

- Syntax check with `node .claude/tools/sqf-check.js` (whole mission) or `... sqf-check.js <file>`. Requires
  `npm install -g @bi-tools/sqf-parser`. It catches unbalanced brackets and malformed structures, **not** unknown
  commands, wrong argument counts, or locality mistakes — and it does not catch every missing semicolon.
- Beyond that there is no automated verification. Changes are tested by loading the mission in the Arma 3 Eden
  editor and playing it. Server-side output goes to the RPT log via `diag_log`.
- Work on a feature branch and open a PR against `master`; do not commit to `master` directly.
