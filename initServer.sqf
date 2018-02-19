


[] call compileFinal preprocessFileLineNumbers "server\hideRespawnMarkers.sqf";
[] call compileFinal preprocessFileLineNumbers "server\faction_relations.sqf";
[] call compileFinal preprocessFileLineNumbers "server\randomStartPositions.sqf";
[] call compileFinal preprocessFileLineNumbers "server\common\common.sqf";
[] call compileFinal preprocessFileLineNumbers "presets\preset.sqf";
[] call compileFinal preprocessFileLineNumbers "server\sectors\sectorController.sqf";
[] call compileFinal preprocessFileLineNumbers "server\factions\factionStrength.sqf";
[] call compileFinal preprocessFileLineNumbers "server\vehicleCleanUp.sqf";

[] spawn compileFinal preprocessFileLineNumbers "server\battlegroups\battlegroupsController.sqf";
[] spawn compileFinal preprocessFileLineNumbers "server\artillery_ai\FFE.sqf";

[] spawn compileFinal preprocessFileLineNumbers "server\register_kills.sqf";
[] spawn compileFinal preprocessFileLineNumbers "server\mine_fields.sqf";
[] spawn compileFinal preprocessFileLineNumbers "server\factions\baseVehicleSpawn.sqf";

// Methods
[] call initialize_mine_fields;
[] call setup_faction_relations;