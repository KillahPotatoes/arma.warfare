[] call compileFinal preprocessFileLineNumbers "scripts\common\common.sqf";
[] call compileFinal preprocessFileLineNumbers "presets\preset.sqf";
[] call compileFinal preprocessFileLineNumbers "factions\factionStrength.sqf";
[] spawn compileFinal preprocessFileLineNumbers "sectors\sectorController.sqf";
[] spawn compileFinal preprocessFileLineNumbers "battlegroups\spawnBattlegroups.sqf";
[] spawn compileFinal preprocessFileLineNumbers "battlegroups\battlegroupAi.sqf";

//[] spawn compileFinal preprocessFileLineNumbers "showCuratorPoints.sqf";
[] spawn compileFinal preprocessFileLineNumbers "RYD_FFE\FFE.sqf";
[] spawn compileFinal preprocessFileLineNumbers "scripts\helicopterSpawn.sqf";
[] spawn compileFinal preprocessFileLineNumbers "scripts\AIReviveScript.sqf";

[] spawn compileFinal preprocessFileLineNumbers "scripts\killTicker.sqf";
[] spawn compileFinal preprocessFileLineNumbers "scripts\addKillTickerEventToAllUnits.sqf";
//[] spawn compileFinal preprocessFileLineNumbers "Mines\alias_mines.sqf";
//[] spawn compileFinal preprocessFileLineNumbers "artillerySpawn.sqf";