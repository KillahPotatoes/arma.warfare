[] call compileFinal preprocessFileLineNumbers "presets\preset.sqf";
[] call compileFinal preprocessFileLineNumbers "presets\global_variable_names.sqf";
[] call compileFinal preprocessFileLineNumbers "shared\spawn_infantry.sqf";
[] call compileFinal preprocessFileLineNumbers "shared\access_methods.sqf";
[] call compileFinal preprocessFileLineNumbers "client\end_mission.sqf";

// Player actions
[] call compileFinal preprocessFileLineNumbers "client\playerActions\playerActions.sqf";
[] call compileFinal preprocessFileLineNumbers "client\playerActions\halo.sqf";
[] call compileFinal preprocessFileLineNumbers "client\playerActions\showArsenal.sqf";
[] call compileFinal preprocessFileLineNumbers "client\playerActions\redeploy.sqf";
[] call compileFinal preprocessFileLineNumbers "client\playerActions\cash_actions.sqf";

[] call compileFinal preprocessFileLineNumbers "client\buy_menu\buy_infantry_menu.sqf";
[] call compileFinal preprocessFileLineNumbers "client\buy_menu\buy_vehicle_menu.sqf";
[] call compileFinal preprocessFileLineNumbers "client\buy_menu\buy_menu_controller.sqf";
[] call compileFinal preprocessFileLineNumbers "client\ui\cash_boxes.sqf";
[] call compileFinal preprocessFileLineNumbers "client\grid\hostileGrid.sqf";

player setVariable [cash, 0];

[] spawn compileFinal preprocessFileLineNumbers "client\ui\factionKillCounter.sqf";

[] spawn show_enemy_markers;
[] spawn show_cash_markers;


