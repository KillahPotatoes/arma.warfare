// Deactivate BI Revive when ACE Medical is running
if (isClass (configfile >> "CfgPatches" >> "ace_medical")) then {
    bis_reviveParam_mode = 0;
    if (isServer) then {diag_log "[arma.warfare] ACE Medical detected. Deactivating BI Revive System.";};
} else {
    bis_reviveParam_mode = ["ReviveMode", 1] call BIS_fnc_getParamValue;
};

[] call compileFinal preprocessFileLineNumbers "presets\preset.sqf";

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

[] call compileFinal preprocessFileLineNumbers "shared\common\common.sqf";
[] call compileFinal preprocessFileLineNumbers "shared\common\helicopter.sqf";
[] call compileFinal preprocessFileLineNumbers "shared\common\interceptor.sqf";
[] call compileFinal preprocessFileLineNumbers "presets\global_variables.sqf";
[] call compileFinal preprocessFileLineNumbers "shared\access_methods.sqf";
[] call compileFinal preprocessFileLineNumbers "client\radio_chatter.sqf";
[] call compileFinal preprocessFileLineNumbers "client\end_mission.sqf";
[] call compileFinal preprocessFileLineNumbers "shared\common\find_units_in_area.sqf";
[] call compileFinal preprocessFileLineNumbers "shared\common\find_units_in_sector.sqf";

// Player actions
[] call compileFinal preprocessFileLineNumbers "client\player_actions\player_actions.sqf";
[] call compileFinal preprocessFileLineNumbers "client\player_actions\squad_actions.sqf";
[] call compileFinal preprocessFileLineNumbers "client\transport\order_transport_menu.sqf";

ARWA_drone_feature = (["DroneRechargeTime", 30] call BIS_fnc_getParamValue) > 0;
if(ARWA_drone_feature) then {
    ARWA_required_drone_rank = ["requiredDroneRank", 4] call BIS_fnc_getParamValue;

    [] call compileFinal preprocessFileLineNumbers "client\drone\order_drone_menu.sqf";
};

ARWA_required_rank_take_lead = ["requiredTakeLeadRank", 2] call BIS_fnc_getParamValue;

[] call compileFinal preprocessFileLineNumbers "client\player_actions\manpower_actions.sqf";
[] call compileFinal preprocessFileLineNumbers "client\player_actions\get_units_menu.sqf";
[] call compileFinal preprocessFileLineNumbers "client\player_actions\get_intel_action.sqf";
[] call compileFinal preprocessFileLineNumbers "client\player_actions\interceptor_actions.sqf";
[] call compileFinal preprocessFileLineNumbers "client\player_actions\get_custom_units.sqf";

[] call compileFinal preprocessFileLineNumbers "client\ui\manpower_boxes.sqf";
[] call compileFinal preprocessFileLineNumbers "client\squad_markers\squad_markers.sqf";
[] call compileFinal preprocessFileLineNumbers "client\player_rank\player_rank.sqf";
[] call compileFinal preprocessFileLineNumbers "client\remove_vehicle.sqf";
[] call compileFinal preprocessFileLineNumbers "client\create_briefing.sqf";


player setVariable [ARWA_KEY_manpower, 0];
player setVariable ["rank", 0, true];
player setVariable ["kills", 0, true];

[group player] remoteExec ["ARWA_add_battle_group", 2];

[] call compileFinal preprocessFileLineNumbers "client\ui\faction_stat_ui.sqf";
[] call compileFinal preprocessFileLineNumbers "client\ui\enemy_commander_ui.sqf";

[] spawn ARWA_show_friendly_markers;
[] spawn ARWA_show_manpower_markers;
[] spawn ARWA_show_ui;
[] spawn ARWA_calculate_rank_and_skill;
[] spawn ARWA_initialize_ammo_boxes;
[] spawn ARWA_create_briefing;

ARWA_loaded_event = addMissionEventHandler ["Loaded",{ [] spawn ARWA_show_ui; }];
ARWA_show_diary_hint = true;
