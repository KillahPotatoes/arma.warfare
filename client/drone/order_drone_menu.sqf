arwa_uav_options = [];
arwa_cancel_uav_id = nil;
arwa_uav_active = false;
arwa_uav_recharge_time = (["DroneRechargeTime", 30] call BIS_fnc_getParamValue) * 60;
arwa_uav_timer = time + arwa_uav_recharge_time;

remove_all_uav_options = {
	{
		player removeAction _x;
	} forEach arwa_uav_options;

	arwa_uav_options = [];
};

has_uav_terminal = {
	private _uav_terminal_class_name = missionNameSpace getVariable format["%1_uav_terminal_class_name", playerSide];

	_uav_terminal_class_name in assignedItems player;
};

show_order_uav = {	
	missionNameSpace setVariable ["uav_menu", false];

	player addAction [[localize "REQUEST_DRONE", 0] call addActionText, {
		params ["_target", "_caller", "_actionId", "_arguments"];

		if(arwa_uav_timer > time) exitWith { 
			
			private _time_left = arwa_uav_timer - time;
			private _wait_minutes = ((_time_left - (_time_left mod 60)) / 60) + 1;	
			systemChat format[localize "DRONE_UNAVAILABLE", _wait_minutes];			
		}; 

		private _open = missionNameSpace getVariable ["uav_menu", false];

		[player] call remove_all_uav_options;
		if(!_open) then {
			missionNameSpace setVariable ["uav_menu", true];
			[] call show_uav_options;
		} else {
			missionNameSpace setVariable ["uav_menu", false];
		};
		}, [], arwa_active_uav_actions, false, false, "",
		'[player] call is_leader && !arwa_uav_active && [] call has_uav_terminal'
	];
};

show_uav_options = {
	private _side = playerSide;
	private _options = missionNamespace getVariable format["%1_uavs", _side];

	{
		private _class_name = _x select 0;
		private _penalty = _x select 1;
		private _name = _class_name call get_vehicle_display_name;

		arwa_uav_options pushBack (player addAction [[_name, 2] call addActionText, {
			private _params = _this select 3;
			private _class_name = _params select 0;
			private _penalty = _params select 1;

			[player] call remove_all_uav_options;
			[_class_name, _penalty] call order_uav;
		}, [_class_name, _penalty], (arwa_active_uav_actions - 1), false, true, "",
		'[player] call is_leader && !arwa_uav_active && [] call has_uav_terminal']);
	} forEach _options;
};

order_uav = {
	params ["_class_name", "_penalty"];

	private _arr = [playerSide, _class_name, _penalty] call spawn_uav;
	private _uav = _arr select 0;
	private _group = _arr select 2;
	private _name = (typeOf _uav) call get_vehicle_display_name;

	[_uav, _group] spawn cancel_uav_on_player_death;
	[_uav] call show_cancel_uav_action;
	[_uav] spawn check_uav_status;

	_uav lockCameraTo [player,[0]];

	[_group, _uav, "DRONE_ON_ITS_WAY"] spawn move_uav_to_player;
};

move_uav_to_player = {
	params ["_group", "_uav", "_msg"];

	if(!([_uav] call is_uav_active)) exitWith {};

	[_group, [_msg]] spawn group_report_client;

	_w = _group addWaypoint [getPos player, 5];

	_w setWaypointType "LOITER";
	_w setWaypointLoiterType "CIRCLE";
	_w setWaypointLoiterRadius 200;

	_uav flyInHeight arwa_uav_flight_height;
};

is_uav_dead = {
	params ["_uav"];

	private _is_dead = (isNull _uav) ||  {!alive _uav} || {!canMove _uav};

	if(_is_dead) then {
		[_uav] call set_uav_to_inactive;		
	};

	_is_dead;
};

set_uav_to_inactive = {
	params ["_uav"];

	arwa_uav_active = false;
	player removeAction arwa_cancel_uav_id;
	arwa_uav_timer = time + arwa_uav_recharge_time;
	
	if(isNull _uav) exitWith {};
	
	player connectTerminalToUAV objNull;
	player disableUAVConnectability [_uav, true];
};

is_uav_active = {
	params ["_uav"];

	private _is_active = !([_uav] call is_uav_dead) && {arwa_uav_active};

	if(!_is_active) then {
		[_uav] call set_uav_to_inactive;	
	};

	_is_active;
};

check_uav_status = {
	params ["_uav"];

	waitUntil {
		([_uav] call is_uav_dead);
	};

	sleep 1;

	if(isNull _uav) exitWith {};

	[playerSide, ["DRONE_DOWN"]] spawn HQ_report_client; // TODO make classname specific
};

cancel_uav_on_player_death = {
	params ["_uav", "_group"];
	waituntil {!([_uav] call is_uav_active) || !(alive player)};

	if(!([_uav] call is_uav_active)) exitWith {};

	[_uav, _group, "CANCELING_DRONE_MISSION", true] call interrupt_uav_misson;
};

show_cancel_uav_action = {
	params ["_uav"];

	arwa_cancel_uav_id = player addAction [[localize "SEND_DRONE_TO_HQ", 0] call addActionText, {
		params ["_target", "_caller", "_actionId", "_arguments"];

		private _uav = _arguments select 0;
		private _group = group driver _uav;

		[_uav, _group, "HEAD_TO_HQ"] call interrupt_uav_misson;
    }, [_uav], arwa_active_uav_actions, true, false, "",
    'true'];
};

spawn_uav = {
	params ["_side", "_class_name", "_penalty"];

	private _pos = getMarkerPos ([_side, respawn_air] call get_prefixed_name);
	private _base_pos = getMarkerPos ([_side, respawn_ground] call get_prefixed_name);
	private _dir = _pos getDir _base_pos;
	private _pos = [_pos select 0, _pos select 1, (_pos select 2) + arwa_uav_flight_height];

	waitUntil { [_pos] call is_air_space_clear; };

    private _uav_arr = [_pos, _dir, _class_name, _side, _penalty] call spawn_vehicle;


	arwa_uav_active = true;

	private _uav = _uav_arr select 0;
	player connectTerminalToUAV _uav;

	_uav setVariable [arwa_penalty, _penalty, true];	

	_uav_arr;
};

interrupt_uav_misson = {
	params ["_uav", "_group", "_msg"];

	[_uav] call set_uav_to_inactive;	

	[_group, [_msg]] spawn group_report_client;

	[_group] call delete_all_waypoints;

	private _pos = getMarkerPos ([playerSide, respawn_air] call get_prefixed_name);

	_w = _group addWaypoint [_pos, 0];	
	_w setWaypointType "MOVE";

	waitUntil { [_uav] call is_uav_dead || ((_pos distance2D (getPos _uav)) < 200) };

	if (!([_uav] call is_uav_dead) && ((_pos distance2D (getPos _uav)) < 200)) exitWith {
		deleteVehicle _uav;		
		[playerSide, ["DRONE_ARRIVED_IN_HQ"]] spawn HQ_report_client;
	};
};
