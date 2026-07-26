# Scheduler, execution environments and debugging

Sources: [Scheduler](https://community.bistudio.com/wiki/Scheduler),
[Code Best Practices](https://community.bistudio.com/wiki/Code_Best_Practices),
[Introduction to Arma Scripting](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting).

## What the scheduler does

The scheduler decides which script runs when. It can pause a running script, move it to the back of the queue,
and start another. `spawn`, `execVM`, `exec` and `execFSM` add scripts to it; priority goes to whichever script
has waited longest since its last suspension.

**All scheduled scripts share a 3 ms budget per frame** (50 ms during a loading screen). Once the frame's budget
is spent, the currently running script is paused mid-execution and the engine gets on with rendering, sound and
simulation. Next frame the scheduler starts again with the longest-waiting script.

Consequences:

- A script may be suspended at *any* statement boundary, and may not resume for several frames.
- `sleep` durations are minimums, not guarantees. At 20 FPS a frame is ~50 ms, so `sleep 0.01` waits at least
  50 ms. Under scheduler load it is worse. Never build precise timing on `sleep`.
- A newly spawned script does not begin until the next frame.
- Heavy work belongs in scheduled scripts precisely *because* it gets spread over frames.

## Scheduled environment

Starting scheduled code begins a new script. The caller does not wait and **cannot receive a return value** — it
gets a Script Handle instead. Use `scriptDone _handle` to poll completion and `terminate _handle` to abort.

Code starts scheduled in:

- `init.sqf`, `initServer.sqf`, `initPlayerLocal.sqf`, `initPlayerServer.sqf`
- functions with the `postInit` attribute
- `spawn`, `execVM`, `exec`
- `call` **from an already-scheduled environment**
- remote-executed *functions*

## Unscheduled environment

Unscheduled code runs inside the calling instance, which waits for it to finish. This guarantees execution order
and is the fastest way to run code — but a heavy body stalls the frame.

Code starts unscheduled in:

- the debug console
- triggers, waypoints (condition and activation)
- all pre-init code, including `preInit` functions
- FSM actions and conditions
- unit and GUI event handlers
- each-frame handlers (`onEachFrame`, `EachFrame` EH)
- object initialisation fields
- Eden entity/scenario attribute expressions
- `call` **from an already-unscheduled environment**
- `remoteExecCall`, and remote-executed raw *commands*
- code inside `isNil`
- SQF called from SQS

Note that `call` does not itself choose an environment — it inherits the caller's.

## Suspension rules

`sleep`, `uiSleep` and `waitUntil` suspend. **Suspension is forbidden in an unscheduled environment and raises an
error** — it does not silently no-op. Check with `canSuspend` when the context is not obvious, and wrap in
`spawn` when you need to wait from an event handler:

```sqf
_unit addEventHandler ["Killed", {
    params ["_unit"];
    [_unit] spawn { params ["_u"]; sleep 5; deleteVehicle _u; };   // sleep needs a scheduled context
}];
```

A `while` loop in an unscheduled context is hard-capped at **10,000 iterations**.

## Scheduler diagnostics

| Command | Shows |
|---|---|
| `diag_activeScripts` | all scripts in the scheduler |
| `diag_activeSQFScripts` | `execVM`-ed and `spawn`-ed scripts |
| `diag_activeSQSScripts` | `exec`-ed scripts |
| `diag_activeMissionFSMs` | `execFSM`-ed scripts |

Use these when scripts appear to stall, or when you suspect a spawn is being created repeatedly and piling up.

## Debugging

- **`diag_log`** writes to the RPT file. On a dedicated server this is the only output you get. RPT lives under
  `%LOCALAPPDATA%\Arma 3\` for clients, and in the server profile directory for servers.
- **`systemChat` / `hint` / `hintSilent`** are client-side and need a player — invisible on a dedicated server.
- **`-showScriptErrors`** launch parameter surfaces errors on screen.
- **`preprocessFileLineNumbers`** (never plain `preprocessFile`) keeps file and line numbers in error messages.
- **Debug console** (Eden editor, or the pause menu in singleplayer) executes SQF live against the running
  mission — the fastest way to test an expression. It runs *unscheduled*, so no `sleep` there.
- `str`, `typeName`, and `format ["%1 %2", _a, _b]` for inspection. `format` indices are **1-based**.
- Use a syntax-highlighting editor (VS Code or Notepad++ with an SQF plugin). Most "Generic error in expression"
  reports are a missing semicolon or bracket that highlighting makes obvious.

## Style guidance from the wiki

The wiki's advice, with this repo's deviations noted:

- **Consistency beats any individual rule.** Pick an indentation style and never mix tabs and spaces.
  *This repo uses tabs.*
- Name variables meaningfully — `_bluforUnits`, not `_uB`. `_i` is acceptable for loop counters.
- The wiki recommends `camelCase`. **This repo uses `snake_case` with an `ARWA_` prefix — follow the repo.**
- Prefix every public variable and `setVariable` key with a tag to avoid collisions with mods and other missions.
  *`ARWA_` and the `ARWA_KEY_*` constants already satisfy this.*
- Constants are `UPPERCASE_WITH_UNDERSCORES`.
- Make locals `private`, or declare them via `params`.
- **DRY** — repeated logic becomes a function with parameters.
- **Prefer guard clauses to nesting.** Deeply nested `if`s ("hadouken code") should become a sequence of
  `if (!_cond) exitWith { ... };`. *This is already the dominant style in this codebase.*
- Prefer `switch (true) do { case (...): {...}; }` over long if/else ladders.
- Do not use macros as functions — use functions.
- Comments should explain **why**, not what; good names and structure cover the what.
- `0 = myCommand ...` is a legacy workaround for old editor fields. It is unnecessary in script files.
- Do not put code in a unit's init box beyond local commands for that unit — init boxes run client-side for every
  connecting player.
