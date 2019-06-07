ARWA_uav_options = [];
ARWA_cancel_uav_id = nil;
ARWA_uav_active = false;
ARWA_uav_recharge_time = (["DroneRechargeTime", 30] call BIS_fnc_getParamValue) * 60;
ARWA_uav_timer = time + ARWA_uav_recharge_time;

ARWA_remove_all_uav_options = {
	{
		player removeAction _x;
	} forEach ARWA_uav_options;

	ARWA_uav_options = [];
};

ARWA_has_uav_terminal = {
	private _uav_terminal_class_name = missionNameSpace getVariable format["ARWA_%1_uav_terminal_class_name", playerSide];

	if(isNil "_uav_terminal_class_name") exitWith { false; };

	_uav_terminal_class_name in assignedItems player;
};

ARWA_show_order_uav = {
	missionNameSpace setVariable ["ARWA_uav_menu", false];

	player addAction [[localize "ARWA_STR_REQUEST_DRONE", 0] call ARWA_add_action_text, {
		params ["_target", "_caller", "_actionId", "_arguments"];

		if(ARWA_uav_timer > time) exitWith {

			private _time_left = ARWA_uav_timer - time;
			private _wait_minutes = ((_time_left - (_time_left mod 60)) / 60) + 1;
			systemChat format[localize "ARWA_STR_DRONE_UNAVAILABLE", _wait_minutes];
		};

		private _open = missionNameSpace getVariable ["ARWA_uav_menu", false];

		[player] call ARWA_remove_all_uav_options;
		if(!_open) then {
			missionNameSpace setVariable ["ARWA_uav_menu", true];
			[] call ARWA_show_uav_options;
		} else {
			missionNameSpace setVariable ["ARWA_uav_menu", false];
		};
		}, [], ARWA_active_uav_actions, false, false, "",
		'[player] call ARWA_is_leader && !ARWA_uav_active && [] call ARWA_has_uav_terminal'
	];
};

ARWA_show_uav_options = {
	private _side = playerSide;
	private _options = missionNamespace getVariable format["ARWA_%1_uavs", _side];

	if(isNil "_options" || _options isEqualTo []) exitWith {};

	{
		private _class_name = _x select 0;
		private _penalty = _x select 1;
		private _name = _class_name call ARWA_get_vehicle_display_name;

		ARWA_uav_options pushBack (player addAction [[_name, 2] call ARWA_add_action_text, {
			private _params = _this select 3;
			private _class_name = _params select 0;
			private _penalty = _params select 1;

			[player] call ARWA_remove_all_uav_options;
			[_class_name, _penalty] call ARWA_order_uav;
		}, [_class_name, _penalty], (ARWA_active_uav_actions - 1), false, true, "",
		'[player] call ARWA_is_leader && !ARWA_uav_active && [] call ARWA_has_uav_terminal']);
	} forEach _options;
};

ARWA_order_uav = {
	params ["_class_name", "_penalty"];

	private _arr = [playerSide, _class_name, _penalty] call ARWA_spawn_uav;
	private _uav = _arr select 0;
	private _group = _arr select 2;
	private _name = (typeOf _uav) call ARWA_get_vehicle_display_name;

	[_uav, _group] spawn ARWA_cancel_uav_on_player_death;
	[_uav] call ARWA_show_cancel_uav_action;
	[_uav] spawn ARWA_check_uav_status;

	_uav lockCameraTo [player,[0]];

	[_group, _uav, "ARWA_STR_DRONE_ON_ITS_WAY"] spawn ARWA_move_uav_to_player;
};

ARWA_move_uav_to_player = {
	params ["_group", "_uav", "_msg"];

	if(!([_uav] call ARWA_is_uav_active)) exitWith {};

	[_group, [_msg]] spawn ARWA_group_report_client;

	_w = _group addWaypoint [getPos player, 5];

	_w setWaypointType "LOITER";
	_w setWaypointLoiterType "CIRCLE";
	_w setWaypointLoiterRadius 200;

	_uav flyInHeight ARWA_uav_flight_height;
};

ARWA_is_uav_dead = {
	params ["_uav"];

	private _is_dead = (isNull _uav) ||  {!alive _uav} || {!canMove _uav};

	if(_is_dead) then {
		[_uav] call ARWA_set_uav_to_inactive;
	};

	_is_dead;
};

ARWA_set_uav_to_inactive = {
	params ["_uav"];

	ARWA_uav_active = false;
	player removeAction ARWA_cancel_uav_id;
	ARWA_uav_timer = time + ARWA_uav_recharge_time;

	if(isNull _uav) exitWith {};

	player connectTerminalToUAV objNull;
	player disableUAVConnectability [_uav, true];
};

ARWA_is_uav_active = {
	params ["_uav"];

	private _is_active = !([_uav] call ARWA_is_uav_dead) && {ARWA_uav_active};

	if(!_is_active) then {
		[_uav] call ARWA_set_uav_to_inactive;
	};

	_is_active;
};

ARWA_check_uav_status = {
	params ["_uav"];

	waitUntil {
		([_uav] call ARWA_is_uav_dead);
	};

	sleep 1;

	if(isNull _uav) exitWith {};

	[playerSide, ["DRONE_DOWN"]] spawn ARWA_HQ_report_client; // TODO make classname specific
};

ARWA_cancel_uav_on_player_death = {
	params ["_uav", "_group"];
	waituntil {!([_uav] call ARWA_is_uav_active) || !(alive player)};

	if(!([_uav] call ARWA_is_uav_active)) exitWith {};

	[_uav, _group, "ARWA_STR_CANCELING_DRONE_MISSION", true] call ARWA_interrupt_uav_misson;
};

ARWA_show_cancel_uav_action = {
	params ["_uav"];

	ARWA_cancel_uav_id = player addAction [[localize "ARWA_STR_SEND_DRONE_TO_HQ", 0] call ARWA_add_action_text, {
		params ["_target", "_caller", "_actionId", "_arguments"];

		private _uav = _arguments select 0;
		private _group = group driver _uav;

		[_uav, _group, "HEAD_TO_HQ"] call ARWA_interrupt_uav_misson;
    }, [_uav], ARWA_active_uav_actions, true, false, "",
    'true'];
};

ARWA_spawn_uav = {
	params ["_side", "_class_name", "_penalty"];

	private _pos = getMarkerPos ([_side, ARWA_KEY_respawn_air] call ARWA_get_prefixed_name);
	private _base_pos = getMarkerPos ([_side, ARWA_KEY_respawn_ground] call ARWA_get_prefixed_name);
	private _dir = _pos getDir _base_pos;
	private _pos = [_pos select 0, _pos select 1, (_pos select 2) + ARWA_uav_flight_height];

	waitUntil { [_pos] call ARWA_is_air_space_clear; };

    private _uav_arr = [_pos, _dir, _class_name, _side, _penalty] call ARWA_spawn_vehicle;


	ARWA_uav_active = true;

	private _uav = _uav_arr select 0;
	player connectTerminalToUAV _uav;

	_uav setVariable [ARWA_penalty, _penalty, true];

	_uav_arr;
};

ARWA_interrupt_uav_misson = {
	params ["_uav", "_group", "_msg"];

	[_uav] call ARWA_set_uav_to_inactive;

	[_group, [_msg]] spawn ARWA_group_report_client;

	[_group] call ARWA_delete_all_waypoints;

	private _pos = getMarkerPos ([playerSide, ARWA_KEY_respawn_air] call ARWA_get_prefixed_name);

	_w = _group addWaypoint [_pos, 0];
	_w setWaypointType "MOVE";

	waitUntil { [_uav] call ARWA_is_uav_dead || ((_pos distance2D (getPos _uav)) < 200) };

	if (!([_uav] call ARWA_is_uav_dead) && ((_pos distance2D (getPos _uav)) < 200)) exitWith {
		deleteVehicle _uav;
		[playerSide, ["DRONE_ARRIVED_IN_HQ"]] spawn ARWA_HQ_report_client;
	};
};
