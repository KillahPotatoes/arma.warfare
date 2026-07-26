---
name: add-param
description: Add a player-selectable mission parameter to arma.warfare end to end — the class in Description.ext, the BIS_fnc_getParamValue read in init.sqf/initServer.sqf, and the ARWA_ global it feeds. Use when adding or changing a mission lobby setting.
---

# Adding a mission parameter

Mission parameters are the settings players pick in the multiplayer lobby. Three places must agree.

## 1. Declare it in `Description.ext`

Add a class inside `class Params`:

```cpp
class MyNewSetting
{
    title = "Human readable label shown in the lobby";
    values[] = {0,1,2};
    texts[] = {"Off","Normal","High"};
    default = 1;
};
```

Rules:
- `values[]` and `texts[]` must have the **same number of elements**.
- Values must be integers. A non-whole `default` silently falls back to 0.
- `default` must appear in `values[]`.
- The class name is the lookup key — it is what you pass to `BIS_fnc_getParamValue`.
- Keep the class near related settings; the lobby lists them in declaration order.

## 2. Read it once at load time

Add the read to `initServer.sqf` (server-authoritative settings), `init.sqf` (client-side settings), or both if
both sides need the value. Both files already have a block of these near the bottom — put it there.

```sqf
ARWA_my_new_setting = ["MyNewSetting", 1] call BIS_fnc_getParamValue;
```

- The string must match the `Description.ext` class name **exactly**, including case.
- The second argument is the fallback used when the param is missing — keep it equal to `default`.
- Coerce to the shape the code wants at the read site, matching the existing style:
  ```sqf
  ARWA_feature_enabled = (["MyNewSetting", 0] call BIS_fnc_getParamValue) > 0;   // to boolean
  ARWA_reload_time    = ["SectorArtilleryReloadTime", 900] call BIS_fnc_getParamValue;
  ```
- Read it **once** into an `ARWA_` global. Do not call `BIS_fnc_getParamValue` from inside game logic.

## 3. Use the global

Reference `ARWA_my_new_setting` from the scripts that need it. If a client-side script needs a server-read value,
either read the param on both machines (cheapest — it is identical everywhere) or broadcast it:

```sqf
missionNamespace setVariable ["ARWA_my_new_setting", _value, true];
```

Note that some params gate whether a whole script is even loaded — see how `ARWA_drone_feature` in `init.sqf`
conditionally compiles `client\drone\order_drone_menu.sqf`. If your param disables a subsystem, that pattern is
usually better than checking the flag at every call site.

## 4. Special case: preset selectors

Params like `ArmyPreset` / `CivilianPreset` are index switches. Adding a preset option means changing **three**
things and keeping the indices aligned:

1. the new file under `presets/army_presets/` or `presets/civilian_presets/`;
2. a matching `if(_preset == N) exitWith { ... }` branch in `presets/preset.sqf`;
3. the `values[]` / `texts[]` arrays of the corresponding `Params` class in `Description.ext`.

A mismatch here fails silently — the preset simply never loads and unit lists come up empty.

## 5. Verify

No automated check exists. Confirm the class name string matches in both files, then load the mission in the Eden
editor, open the multiplayer parameter screen, and check the setting appears with the right options and takes
effect.
