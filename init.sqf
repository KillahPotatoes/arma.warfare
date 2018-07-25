[] call compileFinal preprocessFileLineNumbers "presets\preset.sqf";
[] call compileFinal preprocessFileLineNumbers "shared\common\common.sqf";
[] call compileFinal preprocessFileLineNumbers "shared\common\helicopter.sqf";
[] call compileFinal preprocessFileLineNumbers "presets\global_variable_names.sqf";
[] call compileFinal preprocessFileLineNumbers "shared\access_methods.sqf";
[] call compileFinal preprocessFileLineNumbers "client\radio_chatter.sqf";
[] call compileFinal preprocessFileLineNumbers "client\end_mission.sqf";

// Player actions
[] call compileFinal preprocessFileLineNumbers "client\playerActions\playerActions.sqf";
[] call compileFinal preprocessFileLineNumbers "client\playerActions\halo.sqf";
[] call compileFinal preprocessFileLineNumbers "client\playerActions\showArsenal.sqf";
[] call compileFinal preprocessFileLineNumbers "client\playerActions\redeploy.sqf";
[] call compileFinal preprocessFileLineNumbers "client\playerActions\cash_actions.sqf";
[] call compileFinal preprocessFileLineNumbers "client\playerActions\squad_actions.sqf";
[] call compileFinal preprocessFileLineNumbers "client\playerActions\heli_taxi.sqf";

[] call compileFinal preprocessFileLineNumbers "client\buy_menu\buy_infantry_menu.sqf";
[] call compileFinal preprocessFileLineNumbers "client\buy_menu\buy_vehicle_menu.sqf";
[] call compileFinal preprocessFileLineNumbers "client\buy_menu\buy_menu_controller.sqf";
[] call compileFinal preprocessFileLineNumbers "client\buy_menu\buy_manpower_menu.sqf";
[] call compileFinal preprocessFileLineNumbers "client\ui\cash_boxes.sqf";
[] call compileFinal preprocessFileLineNumbers "client\squad_markers\squad_markers.sqf";
[] call compileFinal preprocessFileLineNumbers "client\player_rank\player_rank.sqf";

player setVariable [cash, 0];
player setVariable ["rank", 0, true];
player setVariable ["kills", 0];

[] call compileFinal preprocessFileLineNumbers "client\ui\faction_stat_ui.sqf";

[] spawn show_enemy_markers;
[] spawn show_friendly_markers;
[] spawn show_cash_markers;
[] spawn show_ui;
[] spawn calculate_rank_and_skill;

loaded_event = addMissionEventHandler ["Loaded",{ [] spawn show_ui; }];

