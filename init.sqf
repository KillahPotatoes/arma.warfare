[] call compileFinal preprocessFileLineNumbers "presets\preset.sqf";
[] call compileFinal preprocessFileLineNumbers "shared\common\common.sqf";
[] call compileFinal preprocessFileLineNumbers "shared\common\helicopter.sqf";
[] call compileFinal preprocessFileLineNumbers "presets\global_variables.sqf";
[] call compileFinal preprocessFileLineNumbers "shared\access_methods.sqf";
[] call compileFinal preprocessFileLineNumbers "client\radio_chatter.sqf";
[] call compileFinal preprocessFileLineNumbers "client\end_mission.sqf";

// Player actions
[] call compileFinal preprocessFileLineNumbers "client\player_actions\player_actions.sqf";
[] call compileFinal preprocessFileLineNumbers "client\player_actions\squad_actions.sqf";
[] call compileFinal preprocessFileLineNumbers "client\player_actions\vehicle_taxi.sqf";

[] call compileFinal preprocessFileLineNumbers "client\player_actions\show_arsenal.sqf";
[] call compileFinal preprocessFileLineNumbers "client\player_actions\manpower_actions.sqf";
[] call compileFinal preprocessFileLineNumbers "client\player_actions\get_units_menu.sqf";

[] call compileFinal preprocessFileLineNumbers "client\ui\manpower_boxes.sqf";
[] call compileFinal preprocessFileLineNumbers "client\squad_markers\squad_markers.sqf";
[] call compileFinal preprocessFileLineNumbers "client\player_rank\player_rank.sqf";
[] call compileFinal preprocessFileLineNumbers "client\remove_vehicle.sqf";

player setVariable [manpower, 0];
player setVariable ["rank", 0, true];
player setVariable ["kills", 0];

[] call compileFinal preprocessFileLineNumbers "client\ui\faction_stat_ui.sqf";

[] spawn show_friendly_markers;
[] spawn show_manpower_markers;
[] spawn show_ui;
[] spawn calculate_rank_and_skill;
[] spawn initialize_ammo_boxes;

loaded_event = addMissionEventHandler ["Loaded",{ [] spawn show_ui; }];

