---
name: test-map
description: Test a code change in Arma on a chosen map — syntax-check the mission, swap in that map's layout, link it into the Arma profile, and launch. Use when the user wants to try a change in-game, test on a specific map, or asks how to run or build the mission.
---

# Testing a change on a map

There is no build step. Arma missions are plain folders — packing a PBO is only for
shipping to a dedicated server or the Workshop, never for local testing.

## The one command

```bash
node .claude/tools/use-map.js              # list maps, show which one is loaded
node .claude/tools/use-map.js altis        # switch to Altis
node .claude/tools/use-map.js altis --sp   # link into missions/ for Eden instead of mpmissions/
node .claude/tools/use-map.js altis --launch
```

It does three things, in order:

1. **Syntax-checks every `.sqf`** and refuses to switch if anything fails to parse, so you
   never launch the game only to hit a parse error on the loading screen.
2. **Copies `missions/<map>/mission.sqm` over the root `mission.sqm`.** The root file is a
   scratch working copy — that is exactly why `/mission.sqm` is gitignored.
3. **Links the repo into the Arma profile** as `arma.warfare.<WorldClass>` — a junction on
   Windows, a directory symlink elsewhere, neither needing admin. Because it is a link and
   not a copy, editing a `.sqf` in the repo is immediately live in the game; only a mission
   *reload* is needed, not a re-copy.

Then: **Multiplayer → Host Server → LAN → "SC 12 arma.warfare"**. Add `-showScriptErrors` to
the launch options. Server-side `diag_log` output goes to `%LOCALAPPDATA%\Arma 3\*.rpt`.

## Why the world class matters

The mission folder name must be `Name.WorldClass` — **the world comes from the folder name,
not from `mission.sqm`**, which contains no world reference at all. Get it wrong and the
mission simply never appears in the browser, with no error.

Resolution order used by the tool:

| Case | Example | Certainty |
|---|---|---|
| Folder name already has a suffix | `small.Enoch` → `Enoch` | certain |
| Listed in `.claude/tools/map-worlds.json` | `altis` → `Altis` | as good as the table |
| Neither | falls back to the folder name, and says so | a guess |

Vanilla worlds (`Altis`, `Stratis`, `Malden`, `Tanoa`, `Enoch`) are confirmed. The modded
ones are marked `"confirmed": false` in the table — their folder names look like world
classes, but that is inference. **When a map is verified to work in-game, set its
`confirmed` to `true`; when one turns out wrong, fix the `world` value.** That table is the
memory of this workflow — keep it current.

## Mods

The mission code itself needs **no mods**: there are no CBA calls anywhere, `KPGUI/` and
`KPPLM/` are vendored inside the mission and included from `Description.ext`, and the only
mod check in the codebase is an optional `ace_medical` detection in `init.sqf`. The README's
"Needed Mods: CBA A3, KP Ranks" describes the public server's modlist, not a hard dependency.

Individual **maps** do need their terrain mod loaded — `map-worlds.json` names it per map.
Load it via the Arma 3 Launcher before hosting.

## Editing the layout

Objects, markers and sectors live in `mission.sqm` and are changed **only in the Eden
editor**, never by hand. Use `--sp` to link into `missions/` so Eden can open it, edit, save
— Eden writes back to the root `mission.sqm` through the link. To keep those changes, copy
the root file back over `missions/<map>/mission.sqm` and commit *that*; the root copy is
ignored by git.

Eden naming the scripts depend on: sector markers `sector_<name>`, base objects
`<prefix>_vehicle` / `<prefix>_helicopter` / `<prefix>_respawn_ground`, ammo boxes
`HQ_<name>` / `FOB_<name>`, with prefixes `alpha`, `charlie`, `delta`.

## Testing multiplayer properly

Hosting locally makes the server a player, which hides locality bugs — server-only code
still runs on a machine that has a `player`. The install includes `arma3server_x64.exe`, so
before shipping anything locality-sensitive, run a real dedicated server and connect
separately. See `references/multiplayer.md` in the `sqf-scripting` skill for the full
comparison and the `server.cfg` settings for local testing.

## If something goes wrong

| Symptom | Cause |
|---|---|
| Mission missing from the browser | wrong world class, or the map's mod is not loaded |
| "Generic error in expression" on load | run `node .claude/tools/sqf-check.js`; if it passes, it is a bad command or argument count, which the parser cannot see |
| A new script has no effect | it is not registered in `init.sqf`/`initServer.sqf` — the post-edit hook warns about this |
| Profile directory not found | set `ARMA3_PROFILE_DIR` to your `Arma 3` profile folder |
