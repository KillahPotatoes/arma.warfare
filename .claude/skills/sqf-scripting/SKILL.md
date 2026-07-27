---
name: sqf-scripting
description: SQF language and Arma 3 scripting reference — operator precedence, control structures, variable scoping, scheduled vs unscheduled execution, multiplayer locality, remoteExec, initialisation order, and debugging. Use when writing, reviewing, or debugging any .sqf file, or when a script errors, silently does nothing, or works in the editor but breaks in multiplayer.
---

# SQF scripting

Verified against the Bohemia Interactive Community wiki. Deeper detail lives in the reference files below —
load the one you need rather than all three.

- `references/syntax.md` — operators, the full precedence table, control structures, variables and scoping, data types
- `references/multiplayer.md` — locality, `remoteExec` targeting, public variables, JIP, initialisation order
- `references/scheduler-debugging.md` — scheduled vs unscheduled, suspension rules, debugging techniques

Canonical upstream pages when something here is insufficient:
[SQF Syntax](https://community.bistudio.com/wiki/SQF_Syntax) ·
[Order of Precedence](https://community.bistudio.com/wiki/Order_of_Precedence) ·
[Control Structures](https://community.bistudio.com/wiki/Control_Structures) ·
[Variables](https://community.bistudio.com/wiki/Variables) ·
[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting) ·
[Scheduler](https://community.bistudio.com/wiki/Scheduler) ·
[Initialisation Order](https://community.bistudio.com/wiki/Initialisation_Order) ·
[Scripting Commands](https://community.bistudio.com/wiki/Category:Scripting_Commands) (per-command syntax **and locality**)

## The shape of the language

SQF has almost no grammar. Nearly everything is an operator (a "scripting command") of one of three arities:

- **Nular** — no operands: `player`, `time`, `allUnits`. These are *computed each time*, not stored values.
  `_a = allUnits;` snapshots the array; it will not reflect units created afterwards.
- **Unary** — one operand on the right: `count _array`, `str _x`, `units _group`
- **Binary** — `_a select 0`, `_unit setPos _pos`, `_a && _b`

Statements terminate with `;`. Line breaks are meaningless. Blocks return the value of their last expression.

**Unary operators consume the first argument that occurs**, which is the classic parsing trap:

```sqf
count _arr select 2;      // parses as (count _arr) select 2  -> error
count (_arr select 2);    // correct
```

## Precedence (highest first)

| Level | Operators |
|---|---|
| 11 | nular commands, variables, values, `()` `[]` `{}` `""` |
| 10 | unary commands, `+a`, `-a`, `!`, `not` |
| 9 | `#` (select) |
| 8 | `^` |
| 7 | `*` `/` `%` `mod` `atan2`, config `/` |
| 6 | `+` `-` (numbers, arrays, strings), **`min`, `max`** |
| 5 | `else` |
| 4 | **binary commands** (`a commandName b`), `setDir`, switch `:` |
| 3 | `==` `!=` `>` `<` `>=` `<=`, config `>>` |
| 2 | `&&` `and` |
| 1 | `\|\|` `or` |

Two consequences that catch people out: `min`/`max` bind at the *same* level as `+`/`-`, and comparisons rank
*below* named binary commands — so `_a select 0 == _b` is `(_a select 0) == _b`. Equal precedence associates
left to right. Parenthesise when unsure.

## Control structures

```sqf
if (_cond) then { ... } else { ... };
if (_cond) exitWith { _value };                    // exits the enclosing scope, not just the if
private _v = if (_cond) then { "a" } else { "b" };  // returns a value

while { _cond } do { ... };                        // condition in BRACES
for [{ _i = 0 }, { _i < 10 }, { _i = _i + 1 }] do { ... };
for "_i" from 0 to 9 do { ... };
for "_i" from 10 to 0 step -1 do { ... };
{ ... } forEach _array;                            // _x, _forEachIndex
switch (_v) do { case 1: { ... }; case "x": { ... }; default { ... }; };  // no colon after default
```

- `switch (true) do { case (_dmg >= 0.9): {...}; ... }` is the idiomatic replacement for an if/else ladder.
- There is no `break` or `continue`. Use `exitWith`, a flag, or `findIf`.
- Guard clauses via `exitWith` are strongly preferred over nesting — this repo uses that style throughout.
- `forEach` runs every iteration **within a single frame**, so a heavy body over a large array will stutter.

## Variables and scoping

```sqf
private _local = 5;                                  // script/scope-local
ARWA_global = 5;                                     // missionNamespace global, this machine only
missionNamespace setVariable ["ARWA_x", 5, true];    // public: broadcast to every machine
```

- Reading an undefined variable **raises "Undefined variable in expression"** — it does not quietly yield `nil`.
  Test existence with `isNil "_name"` (the name as a *string*).
- Always declare with `private`. Without it, assignment inside a function can overwrite a caller's variable of
  the same name.
- **A `private` declared inside a control structure exists only inside that structure.** This is the most common
  scoping bug:
  ```sqf
  if (alive player) then { private _living = true; };
  hint str _living;                 // ERROR — _living never existed out here

  private _living = false;          // correct: declare in the outer scope first
  if (alive player) then { _living = true; };
  ```
- Delete a large global by assigning `nil`. Locals free themselves when their scope ends.
- A global variable can differ per machine. Broadcast with `publicVariable "NAME"` — and re-broadcast after
  *every* change, it does not auto-sync.

## call vs spawn

```sqf
private _r = [1, 2] call ARWA_add;      // synchronous, returns a value, inherits the caller's environment
private _h = [1, 2] spawn ARWA_worker;  // async, returns a Script Handle, always scheduled
```

`params` unpacks arguments and privatises them in one step — use it as the first line of every function:

```sqf
params ["_unit", ["_count", 1], ["_side", west, [west]]];   // name, name+default, name+default+type check
```

Store functions with `compileFinal preprocessFileLineNumbers "path\to\file.sqf"`. `compileFinal` makes the
function immutable, which is a **security requirement** in multiplayer — a plain global holding code can be
overwritten by a malicious `publicVariable`. `preprocessFileLineNumbers` (rather than `preprocessFile`) keeps
file and line information in error messages. This is exactly what this repo's init files do.

## Scheduled vs unscheduled

| | Scheduled | Unscheduled |
|---|---|---|
| Started by | `spawn`, `execVM`, `init.sqf`, `initServer.sqf`, `initPlayerLocal.sqf`, remote-executed **functions** | event handlers, `addAction`, triggers, object init fields, `remoteExecCall`, remote-executed **commands**, `isNil` code |
| `sleep` / `uiSleep` / `waitUntil` | allowed | **forbidden — raises an error** |
| Execution | time-sliced, 3 ms per frame across all scripts | runs to completion in one frame, blocking |

- `call` does not change environment — it inherits the caller's. Only `spawn`/`execVM` create a scheduled script.
- Check at runtime with `canSuspend`.
- Because of the 3 ms budget, `sleep 0.01` really waits at least one frame (~50 ms at 20 FPS). Never rely on
  `sleep` for precise timing.
- A `while` loop in an unscheduled context is hard-capped at 10,000 iterations.

## Multiplayer locality

Every command has documented **argument** locality (local/global) and **effect** locality (local/global) — the
icons at the top of each wiki command page. Getting this wrong is the main cause of "works in the editor, broken
on the server".

- `isServer` — server, **including singleplayer and player-hosted**. `isDedicated` — dedicated only.
  `hasInterface` — machine has a player.
- `if (isServer) then { ... } else { ... }` is an **anti-pattern**: a hosted server is also a player. Test
  `hasInterface` for player-side code.
- Editor-placed objects and empty vehicles are local to the server; a driven vehicle is local to its driver; an
  AI group led by a player is local to that player.

```sqf
[_side, _msg] remoteExec ["ARWA_report", 2];    // 2 = server
"msg" remoteExec ["hint"];                      // no target = 0 = everyone
"msg" remoteExec ["hint", -2];                  // everyone except the server
"msg" remoteExec ["hint", west];                // every machine whose player is west
"msg" remoteExec ["hint", _vehicle];            // wherever _vehicle is local
```

Targets may be a machine id, a negative id (everyone *except* that machine), an Object, a Side, a Group, a
variable-name String, or an array of these. Only **one** negative id works — `[-2, -3]` silently targets everyone.

The remote function must exist on the *receiving* machine. `remoteExec` runs functions **scheduled** but raw
commands **unscheduled**, so `[{ sleep 1 }] remoteExec ["call"]` errors. Avoid remote-executing `call`/`spawn`
directly; wrap the work in a named function and remote-exec that.

## Initialisation order (Arma 3, multiplayer)

Object init fields → `initServer.sqf` → `initPlayerLocal.sqf` → `initPlayerServer.sqf` → `postInit` functions →
**`init.sqf`**.

`init.sqf` runs **last** in multiplayer — after `initServer.sqf`. (In singleplayer it runs much earlier.) Do not
assume client-side setup in `init.sqf` has happened when server code in `initServer.sqf` runs; it has not.
All of these files are scheduled environments, so `sleep` works in them.

JIP players re-run all initialisation fields, so any global-effect command there fires again on every join.

## This repo's conventions override the wiki's

The wiki recommends `camelCase` for variables. **This codebase uses `snake_case` with an `ARWA_` prefix** —
follow the codebase, not the wiki, and do not "fix" existing names. See `CLAUDE.md` for the full set of local
conventions (script registration, `ARWA_KEY_*` constants, `shared/access_methods.sqf` accessors, stringtable
usage). The wiki's prefix-your-globals advice is already satisfied by the `ARWA_` tag.

## Debugging

- `diag_log` writes to the RPT log — the only reliable output on a dedicated server. `systemChat`/`hint` need a
  player and are useless server-side.
- Launch with `-showScriptErrors`. Use `preprocessFileLineNumbers` so errors carry file and line.
- The in-game debug console executes SQF live against the running mission — fastest way to test an expression.
- `diag_activeScripts` / `diag_activeSQFScripts` show what the scheduler is running — use these when scripts
  seem to stall or pile up.

## Common mistakes

1. Missing `;`, or a unary operator swallowing more than intended (`count _arr select 2`).
2. `sleep`/`waitUntil` in an unscheduled context — this is an **error**, not a silent no-op.
3. `private` declared inside an `if`/`for` block, then read outside it.
4. Omitting the `true` public flag on `setVariable`, or forgetting to re-`publicVariable` after a change.
5. Running a local-effect command on the wrong machine.
6. `if (isServer) ... else ...` treating "server" and "player" as mutually exclusive.
7. Assuming `init.sqf` runs before `initServer.sqf` — in multiplayer it is the other way round.
8. Assuming array assignment copies. It does not: `_b = _a` aliases, `_b = +_a` copies.
9. Reading a variable that was never set, expecting `nil` instead of an error. Use `getVariable ["k", default]`.
10. Storing code in a plain global instead of `compileFinal` — an MP security hole.
