# Multiplayer, locality and initialisation

Sources: [Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting),
[Arma 3: Remote Execution](https://community.bistudio.com/wiki/Arma_3:_Remote_Execution),
[remoteExec](https://community.bistudio.com/wiki/remoteExec),
[Initialisation Order](https://community.bistudio.com/wiki/Initialisation_Order).

## Locality

**Local** means "on the machine executing this / where this AI is calculated". **Remote** means anywhere else.
Test with `local _obj` and `!local _obj`.

Every command page on the wiki carries icons describing two independent properties:

| Icon | Meaning |
|---|---|
| **LA** local argument | the argument must be local to the executing machine |
| **GA** global argument | any argument works, including remote ones |
| **LE** local effect | the effect happens only on the executing machine |
| **GE** global effect | every machine sees the effect |
| **SE** server exec | must be run on the server |

Examples:

```sqf
remoteUnit setDamage 1;                              // GA + GE — works on anyone, everyone sees it
localUnit addMagazine "30Rnd_556x45_STANAG";         // LA + GE — unit must be local, but all machines learn of it
remoteUnit setFace "Miller";                         // GA + LE — works on anyone, only THIS machine sees it
localCamera cameraEffect ["Internal", "Back"];       // LA + LE
```

For an LE command that everyone should see, remote-execute it everywhere:
`[remoteUnit, "Miller"] remoteExec ["setFace", 0, true];`

## Which machine am I?

| Check | True on |
|---|---|
| `isServer` | dedicated server, player-hosted server, **and singleplayer** |
| `isDedicated` | dedicated server only |
| `hasInterface` | any machine with a player, including a hosted server |
| `!hasInterface` | headless clients and dedicated servers |
| `hasInterface && isServer` | player-hosted server |
| `!hasInterface && !isDedicated` | headless client |

`BIS_fnc_getNetMode` returns one of `"DedicatedServer"`, `"Server"`, `"HeadlessClient"`, `"Client"`,
`"SinglePlayer"`. It does not distinguish JIP — combine with `didJIP`.

**The `isServer`/`else` anti-pattern.** A hosted server is also a player, so this is wrong:

```sqf
if (isServer) then { /* server work */ } else { /* player work */ };   // WRONG
```

Use `if (isServer) then { ... };` and a separate `if (hasInterface) then { ... };`.

A dedicated server has no player unit — `isNull player` is true there. Server code must never assume `player`
exists; use `allPlayers`, `playableUnits`, or `BIS_fnc_listPlayers`.

## What is local where

- A player's unit is always local to that player's machine.
- An AI group led by a player is local to that player's machine; a player subordinate stays local to their own.
- A driven vehicle is local to its **driver** — not the commander or gunner.
- Terrain objects (buildings, roads, vegetation) are local everywhere.
- Editor-placed objects and empty vehicles are local to the server.
- Editor-placed triggers are created on every machine unless "Server Only" is ticked.
- Units from `createUnit` / `createVehicle` are local to the machine that created them.

Locality **changes**: when a player-leader dies, AI transfers to the new leader's machine; a player entering an
empty vehicle takes locality of it from the server. The `"Local"` event handler fires when this happens.

## remoteExec

```sqf
params remoteExec [order, targets, JIP]
```

`order` is the *name* of a function or command as a String. Argument shape mirrors the original call:

```sqf
hint "Hello";                    ->  "Hello" remoteExec ["hint"];
unit1 setFace "Miller";          ->  [unit1, "Miller"] remoteExec ["setFace"];
cutRsc ["", "BLACK OUT"];        ->  [["", "BLACK OUT"]] remoteExec ["cutRsc"];   // double brackets: unary cmd taking an array
["l1", "l2"] spawn BIS_fnc_x;    ->  ["l1", "l2"] remoteExec ["BIS_fnc_x"];       // functions need no extra nesting
```

### Targets

| Value | Meaning |
|---|---|
| `0` (default) | everyone: server and every client, including the originating machine |
| `2` | the server (dedicated or hosted) |
| other number | the machine whose `clientOwner` equals it |
| negative number | inverted — `-2` is everyone *but* the server, `-clientOwner` is everyone but me |
| Object | wherever that object is local |
| String | variable name; wherever the named object/group is local |
| Side | machines whose player is on that side |
| Group | machines whose player is in that group (not where the group is local) |
| Array | any combination of the above |

Only **one** negative id is honoured — `[-2, -3]` executes on every client instead of excluding both.

The "all players, skipping a dedicated server" idiom:

```sqf
private _allPlayers = [0, -2] select isDedicated;
["message"] remoteExec ["hint", _allPlayers];
```

### Environment

**Functions run scheduled** (suspension allowed); **raw script commands run unscheduled** (suspension forbidden).
So `[{ sleep 1 }] remoteExec ["call"];` errors. Avoid remote-executing `call`/`spawn` at all — `CfgRemoteExec` may
block them. Wrap the work in a named function and remote-exec that instead.

The function only has to exist on the **target** machine, which is useful when the server runs a mod clients lack.

Beware capturing local objects: `[player, ...] remoteExec [..., MyGroup]` sends *your* player object. To act on
each recipient's own player, send code that resolves `player` remotely.

Remote executions are queued and arrive in submission order.

### JIP queue

Passing a third argument stores the statement for join-in-progress players:

```sqf
private _id = ["car is broken"] remoteExec ["systemChat", 0, true];   // returns a generated JIP id
["car is repaired"] remoteExec ["systemChat", 0, "MY_ID"];            // custom id; replaces any statement with that id
remoteExec ["", _id];                                                  // remove from the queue
```

JIP is only valid when `targets` is `0` or negative — `remoteExec ["x", 2, true]` fails. Attaching the id to an
Object or Group auto-removes the entry when that object is deleted. Ordering across multiple JIP statements is
not guaranteed.

### Security

`CfgRemoteExec` gates what may be remote-executed: fully open (`mode = 2`), whitelist (`mode = 1`), or blocked.
JIP additionally needs `jip = 1`. Requests are validated when issued by a client and again before the server
broadcasts. This repo defines no `CfgRemoteExec`.

## Sharing state

### publicVariable

```sqf
ABC_Score = 5;
publicVariable "ABC_Score";     // note the quotes — the NAME is published
```

- `publicVariable` — from this machine to all others, including the server.
- `publicVariableServer` — from a client to the server only.
- `publicVariableClient` — from this machine to one specific client.

Delivery is guaranteed. Values do **not** auto-sync: change the variable and you must publish it again. Keep
names short — they go over the wire. JIP players receive `publicVariable`-sent values before `init.sqf` runs, but
values sent with `publicVariableClient` are lost across a reconnect.

### setVariable

`obj setVariable ["key", value, true]` stores on an object and broadcasts. The public flag is what makes it
visible elsewhere; without it the value stays on the local machine. Broadcasting `nil` deletes the variable on
targets.

## Initialisation order (Arma 3)

From first to last. Entries marked MP-only differ in singleplayer.

1. Functions with `recompile`
2. Functions with `preInit` — *unscheduled*
3. Object init event handlers — *unscheduled*
4. Eden entity attribute expressions (server) — *unscheduled*
5. Object initialisation fields — *unscheduled*
6. `init.sqf` — **singleplayer only** at this position, *scheduled*
7. Eden scenario attribute expressions — `player` not yet available
8. Persistent (JIP-queued) functions — clients
9. Modules
10. **`initServer.sqf`** — server, *scheduled*
11. `initPlayerLocal.sqf` — client, *scheduled*
12. `initPlayerServer.sqf` — on the server per client, *scheduled*
13. Functions with `postInit` — *scheduled*
14. **`init.sqf`** — **multiplayer**, *scheduled*

The headline: **in multiplayer `init.sqf` runs last, after `initServer.sqf`**; in singleplayer it runs near the
start. Never assume one has finished when the other begins.

All the init files are scheduled, so `sleep` and `waitUntil` are legal in them. In singleplayer, though, the
engine effectively waits for `init.sqf` and `postInit` to finish — an infinite loop or long suspension there
freezes mission loading.

Every initialisation field re-runs for each JIP player, so global-effect commands placed in them fire again on
each join.

## Testing multiplayer locally

A mission should work in singleplayer, player-hosted MP, and dedicated MP.

- **Dedicated** catches nearly everything. In `server.cfg` set `loopback = true;` and `kickDuplicate = 0;`, run
  the game twice with `-showScriptErrors`, and add `-noPause -window` for two-screen work. Disable BattlEye or
  extra instances get closed. Check both client and server RPT files. Blind spot: code using `isDedicated`
  where `isServer` was meant.
- **Player-hosted** is faster to set up and specifically exposes `isDedicated`-vs-`isServer` confusion, but can
  hide locality bugs because server code happens to run on a machine that also has a player.
