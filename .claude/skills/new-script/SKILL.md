---
name: new-script
description: Add a new .sqf script to the arma.warfare mission — pick the right locality folder, follow ARWA_ naming, register it in init.sqf/initServer.sqf so it actually loads, and wire remoteExec if it crosses the client/server boundary. Use whenever creating a new script file in this repo.
---

# Adding a new .sqf script

A new script does nothing until it is registered. Work through these steps in order. For language rules
(precedence, scoping, scheduled vs unscheduled, locality), see the `sqf-scripting` skill.

## 1. Pick the folder by locality

| Where the code must run | Folder | Registered in |
|---|---|---|
| Server only — world state, AI, sectors, factions, spawning | `server/` | `initServer.sqf` |
| Each player — UI, actions, menus, markers | `client/` | `init.sqf` |
| Both — helpers, getters, shared calculations | `shared/` | **both** files |

If you are unsure, ask: does this mutate authoritative mission state (manpower, tier, sector ownership, spawned
units)? That is server. Does it draw, listen for player input, or read `player`? That is client.

## 2. Write the file

- Define global functions, do not execute work at load time unless that is deliberate:
  ```sqf
  ARWA_do_the_thing = {
      params ["_side", ["_amount", 0]];
      private _current = [_side] call ARWA_get_strength;
      [_side, _current + _amount] call ARWA_set_strength;
  };
  ```
- Names: `ARWA_` prefix, `snake_case`, descriptive verb-first for functions.
- `params [...]` first line of every function; `private` on every local.
- Read and write shared state through `shared/access_methods.sqf` getters/setters, not raw `missionNamespace`.
- Object variable keys come from the `ARWA_KEY_*` constants in `presets/global_variables.sqf`. If you need a new
  key, add the constant there first.
- Check `shared/common/common.sqf` before writing a helper — it probably exists.
- User-facing text goes in `stringtable.xml` as an `ARWA_STR_*` key and is read with `localize`.

## 3. Register it

Add a line to the load block of the appropriate init file, using **backslash** paths relative to the mission root:

```sqf
[] call compileFinal preprocessFileLineNumbers "client\ui\my_script.sqf";
```

Placement matters — these lines execute the file. Put it:
- after anything it calls at top level (in practice: after `presets\global_variables.sqf`,
  `shared\common\common.sqf`, and `shared\access_methods.sqf`);
- inside the existing grouped section for its subsystem (the init files are organised by comment headers);
- use `[] spawn` instead of `[] call` only for scripts that are themselves a running loop — those go in the
  `// Game threads` / `[] spawn ARWA_*` block near the bottom.

For a `shared/` script, register it in **both** `init.sqf` and `initServer.sqf`.

## 4. Cross the boundary if needed

Client code that must change authoritative state calls the server:

```sqf
[side player, _manpower] remoteExec ["ARWA_increase_manpower_server", 2];
```

Server code that must reach players omits the target (broadcast):

```sqf
[_side, ["ARWA_STR_SENDING_VEHICLE_YOUR_WAY", _name]] remoteExec ["ARWA_HQ_report_client"];
```

The remote function must be defined on the receiving machine — i.e. a function called with `remoteExec [..., 2]`
has to live in `server/` or `shared/` and be registered in `initServer.sqf`.

State the server writes for clients to read needs the public flag:

```sqf
missionNamespace setVariable ["ARWA_thing", _value, true];
```

## 5. Verify

There is no automated check. Confirm by hand:
- the registration line exists, path spelled with backslashes, file actually at that path;
- `grep` the function name to confirm every call site matches the definition's `params` arity;
- load the mission in the Eden editor and play it; server-side output goes to the RPT log via `diag_log`.

Never edit `.sqm` files to support a new script — mission object/marker changes are made in the Eden editor.
