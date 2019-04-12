// Deactivate BI Revive when ACE Medical is running
if (isClass (configfile >> "CfgPatches" >> "ace_medical")) then {
    bis_reviveParam_mode = 0;
    if (isServer) then {diag_log "[arma.warfare] ACE Medical detected. Deactivating BI Revive System.";};
} else {
    bis_reviveParam_mode = ["ReviveMode", 1] call BIS_fnc_getParamValue;
};

bis_reviveParam_duration = ["ReviveDuration", 6] call BIS_fnc_getParamValue;
bis_reviveParam_requiredTrait = ["ReviveRequiredTrait", 1] call BIS_fnc_getParamValue;
bis_reviveParam_medicSpeedMultiplier = ["ReviveMedicSpeedMultiplier", 1] call BIS_fnc_getParamValue;
bis_reviveParam_requiredItems = ["ReviveRequiredItems", 1] call BIS_fnc_getParamValue;
bis_reviveParam_unconsciousStateMode = ["UnconsciousStateMode", 0] call BIS_fnc_getParamValue;
bis_reviveParam_bleedOutDuration = ["ReviveBleedOutDuration", 180] call BIS_fnc_getParamValue;
bis_reviveParam_forceRespawnDuration = ["ReviveForceRespawnDuration", 10] call BIS_fnc_getParamValue;

// Execute fnc_reviveInit again (by default it executes in postInit)
if ((isNil {player getVariable "bis_revive_ehHandleHeal"} || isDedicated) && !(bis_reviveParam_mode == 0)) then {
    [] call bis_fnc_reviveInit;
};

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
[] call compileFinal preprocessFileLineNumbers "client\transport\order_transport_menu.sqf";
[] call compileFinal preprocessFileLineNumbers "client\drone\order_drone_menu.sqf";


[] call compileFinal preprocessFileLineNumbers "shared\common\find_units_in_area.sqf";
[] call compileFinal preprocessFileLineNumbers "shared\common\find_units_in_sector.sqf";

[] call compileFinal preprocessFileLineNumbers "client\player_actions\manpower_actions.sqf";
[] call compileFinal preprocessFileLineNumbers "client\player_actions\get_units_menu.sqf";

[] call compileFinal preprocessFileLineNumbers "client\ui\manpower_boxes.sqf";
[] call compileFinal preprocessFileLineNumbers "client\squad_markers\squad_markers.sqf";
[] call compileFinal preprocessFileLineNumbers "client\player_rank\player_rank.sqf";
[] call compileFinal preprocessFileLineNumbers "client\remove_vehicle.sqf";
[] call compileFinal preprocessFileLineNumbers "client\create_briefing.sqf";

player setVariable [manpower, 0];
player setVariable ["rank", 0, true];
player setVariable ["kills", 0];

[group player] remoteExec ["add_battle_group", 2];

[] call compileFinal preprocessFileLineNumbers "client\ui\faction_stat_ui.sqf";

[] spawn show_friendly_markers;
[] spawn show_manpower_markers;
[] spawn show_ui;
[] spawn calculate_rank_and_skill;
[] spawn initialize_ammo_boxes;
[] spawn create_briefing;

loaded_event = addMissionEventHandler ["Loaded",{ [] spawn show_ui; }];
show_diary_hint = true;
