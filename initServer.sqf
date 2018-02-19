EAST setFriend [WEST, 0];
WEST setFriend [EAST, 0];

independent setFriend [west, 0];
west setFriend [independent, 0];

east setFriend [independent, 0];
independent setFriend [east, 0];


[] call compileFinal preprocessFileLineNumbers "scripts\hideRespawnMarkers.sqf";
[] call compileFinal preprocessFileLineNumbers "scripts\randomStartPositions.sqf";
[] call compileFinal preprocessFileLineNumbers "scripts\common\common.sqf";
[] call compileFinal preprocessFileLineNumbers "presets\preset.sqf";
[] call compileFinal preprocessFileLineNumbers "server\sectors\sectorController.sqf";
[] call compileFinal preprocessFileLineNumbers "server\factions\factionStrength.sqf";
[] call compileFinal preprocessFileLineNumbers "scripts\vehicleCleanUp.sqf";

[] spawn compileFinal preprocessFileLineNumbers "server\battlegroups\battlegroupsController.sqf";
[] spawn compileFinal preprocessFileLineNumbers "RYD_FFE\FFE.sqf";

[] spawn compileFinal preprocessFileLineNumbers "scripts\killTicker.sqf";
[] spawn compileFinal preprocessFileLineNumbers "scripts\addKillTickerEventToAllUnits.sqf";
[] spawn compileFinal preprocessFileLineNumbers "Mines\alias_mines.sqf";
[] spawn compileFinal preprocessFileLineNumbers "factions\baseVehicleSpawn.sqf";