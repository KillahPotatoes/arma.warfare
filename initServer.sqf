[] call compileFinal preprocessFileLineNumbers "presets\preset.sqf";
[] call compileFinal preprocessFileLineNumbers "presets\global_variable_names.sqf";
[] call compileFinal preprocessFileLineNumbers "server\hideRespawnMarkers.sqf";
[] call compileFinal preprocessFileLineNumbers "server\randomStartPositions.sqf";
[] call compileFinal preprocessFileLineNumbers "shared\common\common.sqf";
[] call compileFinal preprocessFileLineNumbers "server\register_kills.sqf";
[] call compileFinal preprocessFileLineNumbers "server\vehicleCleanUp.sqf";
[] call compileFinal preprocessFileLineNumbers "server\end_game_conditions.sqf";

// Shared scripts
[] call compileFinal preprocessFileLineNumbers "shared\access_methods.sqf";
[] call compileFinal preprocessFileLineNumbers "shared\spawn_infantry.sqf";


// Third party scripts
[] spawn compileFinal preprocessFileLineNumbers "server\artillery_ai\FFE.sqf";
[] call compileFinal preprocessFileLineNumbers "server\mine_fields.sqf";

// Sectors
[] call compileFinal preprocessFileLineNumbers "server\sectors\findUnitsNearby.sqf";
[] call compileFinal preprocessFileLineNumbers "server\sectors\sectors.sqf";
[] call compileFinal preprocessFileLineNumbers "server\sectors\sectorIncome.sqf";
[] call compileFinal preprocessFileLineNumbers "server\sectors\drawSector.sqf";
[] call compileFinal preprocessFileLineNumbers "server\sectors\sectorRespawn.sqf";
[] call compileFinal preprocessFileLineNumbers "server\sectors\sectorDefense.sqf";
[] call compileFinal preprocessFileLineNumbers "server\sectors\sectorController.sqf";
[] call compileFinal preprocessFileLineNumbers "server\sectors\sector_patrols.sqf";

// Faction
[] call compileFinal preprocessFileLineNumbers "server\factions\factionStrength.sqf";
[] call compileFinal preprocessFileLineNumbers "server\factions\baseVehicleSpawn.sqf";
[] call compileFinal preprocessFileLineNumbers "server\faction_relations.sqf";

// battlegroups
[] call compileFinal preprocessFileLineNumbers "server\battlegroups\battlegroups.sqf";
[] call compileFinal preprocessFileLineNumbers "server\battlegroups\spawnBattlegroups.sqf";
[] call compileFinal preprocessFileLineNumbers "server\battlegroups\battlegroupAi.sqf";
[] call compileFinal preprocessFileLineNumbers "server\battlegroups\adjust_skill_levels.sqf";

// Game setup
[] call initialize_sectors;
[] call draw_all_sectors;
[] call assign_prefixes;
[] call hide_respawn_markers;
[] call initialize_mine_fields;
[] call setup_faction_relations;
[] call initialize_faction_stats;
[] call initialize_bases;
[] call initialize_base_respawns;
[] call initialize_battle_groups;

// Game threads
[] spawn end_game_conditions_check;
[] spawn add_kill_ticker_to_all_units;
[] spawn vehicle_clean_up;
[] spawn spawn_battle_groups;
[] spawn group_ai;
[] spawn skill_balancing;
[] spawn initialize_sector_control;
[] spawn sector_income;


