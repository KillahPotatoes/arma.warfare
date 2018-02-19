


[] call compileFinal preprocessFileLineNumbers "server\hideRespawnMarkers.sqf";
[] call compileFinal preprocessFileLineNumbers "server\faction_relations.sqf";
[] call compileFinal preprocessFileLineNumbers "server\randomStartPositions.sqf";

[] call assign_prefixes; // Should be moved when other scripts are arranged correctly

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

// Game setup
[] call hide_respawn_markers;
[] call initialize_mine_fields;
[] call setup_faction_relations;

// Game threads
[] spawn add_kill_ticker_to_all_units;
[] spawn vehicle_clean_up;