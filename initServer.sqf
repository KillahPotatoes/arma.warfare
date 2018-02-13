[] call compileFinal preprocessFileLineNumbers "scripts\common\common.sqf";
[] call compileFinal preprocessFileLineNumbers "presets\preset.sqf";
[] call compileFinal preprocessFileLineNumbers "sectors\sectorController.sqf";
[] call compileFinal preprocessFileLineNumbers "factions\factionStrength.sqf";

[] spawn compileFinal preprocessFileLineNumbers "battlegroups\battlegroupsController.sqf";

[] spawn compileFinal preprocessFileLineNumbers "RYD_FFE\FFE.sqf";
[] spawn compileFinal preprocessFileLineNumbers "scripts\AIReviveScript.sqf";

[] spawn compileFinal preprocessFileLineNumbers "scripts\killTicker.sqf";
[] spawn compileFinal preprocessFileLineNumbers "scripts\addKillTickerEventToAllUnits.sqf";
[] spawn compileFinal preprocessFileLineNumbers "Mines\alias_mines.sqf";