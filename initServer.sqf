enableSaving [!isDedicated, false];

[] call compileFinal preprocessFileLineNumbers "presets\preset.sqf";
[] call compileFinal preprocessFileLineNumbers "presets\global_variables.sqf";
[] call compileFinal preprocessFileLineNumbers "server\hide_respawn_markers.sqf";
[] call compileFinal preprocessFileLineNumbers "server\random_start_positions.sqf";
[] call compileFinal preprocessFileLineNumbers "shared\common\common.sqf";
[] call compileFinal preprocessFileLineNumbers "shared\common\helicopter.sqf";
[] call compileFinal preprocessFileLineNumbers "server\register_kills.sqf";
[] call compileFinal preprocessFileLineNumbers "server\clean_up.sqf";
[] call compileFinal preprocessFileLineNumbers "server\end_game_conditions.sqf";
[] call compileFinal preprocessFileLineNumbers "shared\common\find_units_in_area.sqf";
[] call compileFinal preprocessFileLineNumbers "shared\common\find_units_in_sector.sqf";

// Shared scripts
[] call compileFinal preprocessFileLineNumbers "shared\access_methods.sqf";

// Third party scripts
[] spawn compileFinal preprocessFileLineNumbers "server\artillery_ai\FFE.sqf";
[] call compileFinal preprocessFileLineNumbers "server\mine_fields.sqf";

// Sectors
[] call compileFinal preprocessFileLineNumbers "server\sectors\sectors.sqf";
[] call compileFinal preprocessFileLineNumbers "server\sectors\sector_income.sqf";
[] call compileFinal preprocessFileLineNumbers "server\sectors\draw_sector.sqf";
[] call compileFinal preprocessFileLineNumbers "server\sectors\sector_respawn.sqf";
[] call compileFinal preprocessFileLineNumbers "server\sectors\sector_controller.sqf";

// Sector defense
[] call compileFinal preprocessFileLineNumbers "server\sectors\defense\sector_defense.sqf";
[] call compileFinal preprocessFileLineNumbers "server\sectors\defense\sector_vehicle_defense.sqf";
[] call compileFinal preprocessFileLineNumbers "server\sectors\defense\sector_squad_defense.sqf";
[] call compileFinal preprocessFileLineNumbers "server\sectors\defense\sector_static_defense.sqf";
[] call compileFinal preprocessFileLineNumbers "server\sectors\defense\sector_reinforcements.sqf";

// Faction
[] call compileFinal preprocessFileLineNumbers "server\factions\faction_strength.sqf";
[] call compileFinal preprocessFileLineNumbers "server\factions\base_vehicle_spawn.sqf";
[] call compileFinal preprocessFileLineNumbers "server\faction_relations.sqf";

// battlegroups
[] call compileFinal preprocessFileLineNumbers "server\battlegroups\battlegroups.sqf";
[] call compileFinal preprocessFileLineNumbers "server\battlegroups\deploy_ground_troops\spawn_battlegroups.sqf";
[] call compileFinal preprocessFileLineNumbers "server\battlegroups\deploy_ground_troops\spawn_infantry_groups.sqf";
[] call compileFinal preprocessFileLineNumbers "server\battlegroups\deploy_ground_troops\spawn_vehicle_groups.sqf";
[] call compileFinal preprocessFileLineNumbers "server\battlegroups\spawn_gunships.sqf";
[] call compileFinal preprocessFileLineNumbers "server\battlegroups\battlegroup_ai\battlegroup_ai.sqf";
[] call compileFinal preprocessFileLineNumbers "server\battlegroups\battlegroup_ai\battlegroup_air_ai.sqf";
[] call compileFinal preprocessFileLineNumbers "server\battlegroups\battlegroup_ai\battlegroup_vehicle_ai.sqf";
[] call compileFinal preprocessFileLineNumbers "server\battlegroups\battlegroup_ai\battlegroup_infantry_ai.sqf";
[] call compileFinal preprocessFileLineNumbers "server\battlegroups\heli_insertion.sqf";
[] call compileFinal preprocessFileLineNumbers "server\spawn_infantry.sqf";
[] call compileFinal preprocessFileLineNumbers "server\random_enemy_activity\random_enemy_presence.sqf";


// Radio chatter
[] call compileFinal preprocessFileLineNumbers "server\radio_chatter_server.sqf";

private _startingTier = ["StartingTier", 0] call BIS_fnc_getParamValue;
ARWA_starting_strength = ["Manpower", ARWA_starting_strength] call BIS_fnc_getParamValue;
ARWA_mine_fields = (["Mines", 1] call BIS_fnc_getParamValue) == 1;
ARWA_sector_artillery = (["SectorArtilleryReloadTime", 900] call BIS_fnc_getParamValue) > 0;
ARWA_sector_artillery_reload_time = ["SectorArtilleryReloadTime", 900] call BIS_fnc_getParamValue;
ARWA_dropped_manpower_deterioration_time = ["DroppedManpowerDeteriorationTime", 180] call BIS_fnc_getParamValue;

ARWA_vehicleKillBonus = ["VehicleKillBonus", 0] call BIS_fnc_getParamValue;
setTimeMultiplier (["TimeAcceleration", 6] call BIS_fnc_getParamValue);

// Game setup
[] call initialize_sectors;
[] call draw_all_sectors;
[] call assign_prefixes;
[] call hide_respawn_markers;

if(ARWA_mine_fields) then {
	[] call initialize_mine_fields;
};

[] call setup_faction_relations;
[ARWA_starting_strength, _startingTier] call initialize_faction_stats;
[] call initialize_bases;
[] call initialize_base_respawns;
[] call initialize_battle_groups;
[] call initialize_sector_defense;
 [] call calculate_mission_size;

// Game threads
[] spawn end_game_conditions_check;
[] spawn add_kill_ticker_to_all_units;
[] spawn add_kill_ticker_to_all_vehicles;
[] spawn clean_up;
[] spawn initialize_spawn_battle_groups;
[] spawn spawn_gunship_groups;
[] spawn sector_manpower_generation;
[] spawn populate_random_houses;



