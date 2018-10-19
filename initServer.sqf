startTime = serverTime;

seconds_since_start = {
	serverTime - startTime;
};

[] call compileFinal preprocessFileLineNumbers "presets\preset.sqf";
[] call compileFinal preprocessFileLineNumbers "presets\global_variables.sqf";
[] call compileFinal preprocessFileLineNumbers "server\hideRespawnMarkers.sqf";
[] call compileFinal preprocessFileLineNumbers "server\randomStartPositions.sqf";
[] call compileFinal preprocessFileLineNumbers "shared\common\common.sqf";
[] call compileFinal preprocessFileLineNumbers "shared\common\helicopter.sqf";
[] call compileFinal preprocessFileLineNumbers "server\register_kills.sqf";
[] call compileFinal preprocessFileLineNumbers "server\clean_up.sqf";
[] call compileFinal preprocessFileLineNumbers "server\end_game_conditions.sqf";

// Shared scripts
[] call compileFinal preprocessFileLineNumbers "shared\access_methods.sqf";

// Third party scripts
[] spawn compileFinal preprocessFileLineNumbers "server\artillery_ai\FFE.sqf";
[] call compileFinal preprocessFileLineNumbers "server\mine_fields.sqf";

[] call compileFinal preprocessFileLineNumbers "server\player_actions\show_arsenal.sqf";
[] call compileFinal preprocessFileLineNumbers "server\player_actions\halo.sqf";
[] call compileFinal preprocessFileLineNumbers "server\player_actions\manpower_actions.sqf";

// Sectors
[] call compileFinal preprocessFileLineNumbers "server\sectors\findUnitsNearby.sqf";
[] call compileFinal preprocessFileLineNumbers "server\sectors\sectors.sqf";
[] call compileFinal preprocessFileLineNumbers "server\sectors\sectorIncome.sqf";
[] call compileFinal preprocessFileLineNumbers "server\sectors\drawSector.sqf";
[] call compileFinal preprocessFileLineNumbers "server\sectors\sectorRespawn.sqf";
[] call compileFinal preprocessFileLineNumbers "server\sectors\sectorDefense.sqf";
[] call compileFinal preprocessFileLineNumbers "server\sectors\sectorController.sqf";
[] call compileFinal preprocessFileLineNumbers "server\sectors\sector_patrols.sqf";
[] call compileFinal preprocessFileLineNumbers "server\sectors\defensive_groups.sqf";

// Faction
[] call compileFinal preprocessFileLineNumbers "server\factions\factionStrength.sqf";
[] call compileFinal preprocessFileLineNumbers "server\factions\baseVehicleSpawn.sqf";
[] call compileFinal preprocessFileLineNumbers "server\faction_relations.sqf";

// battlegroups 
[] call compileFinal preprocessFileLineNumbers "server\battlegroups\battlegroups.sqf";
[] call compileFinal preprocessFileLineNumbers "server\battlegroups\helo_insertion.sqf";
[] call compileFinal preprocessFileLineNumbers "server\battlegroups\spawnBattlegroups.sqf";
[] call compileFinal preprocessFileLineNumbers "server\battlegroups\spawn_gunships.sqf";
[] call compileFinal preprocessFileLineNumbers "server\battlegroups\battlegroupAi.sqf";
[] call compileFinal preprocessFileLineNumbers "server\battlegroups\heli_insertion.sqf";
[] call compileFinal preprocessFileLineNumbers "server\spawn_infantry.sqf";
[] call compileFinal preprocessFileLineNumbers "server\random_enemy_activity\random_enemy_presence.sqf";


// Radio chatter
[] call compileFinal preprocessFileLineNumbers "server\radio_chatter_server.sqf";

private _startingTier = ["StartingTier", 0] call BIS_fnc_getParamValue;
private _manpower = ["Manpower", 500] call BIS_fnc_getParamValue;

// Game setup
[] call initialize_sectors;
[] call draw_all_sectors;
[] call assign_prefixes;
[] call hide_respawn_markers;
[] call initialize_mine_fields;
[] call setup_faction_relations;
[_manpower, _startingTier] call initialize_faction_stats;
[] call initialize_bases;
[] call initialize_base_respawns;
[] call initialize_battle_groups;
[] call initialize_defensive_groups;

// Game threads
[] spawn end_game_conditions_check;
[] spawn add_kill_ticker_to_all_units;
[] spawn add_kill_ticker_to_all_vehicles;
[] spawn clean_up;
[] spawn spawn_battle_groups;
[] spawn spawn_gunship_groups;
[] spawn group_ai;
[] spawn initialize_sector_control;
[] spawn sector_manpower_generation;
[] spawn defensive_group_chatter;
[] spawn populate_random_houses;



