ARWA_transport_will_wait_time = 300;

ARWA_update_transport_orders = {
	params ["_group", "_veh"];

	openMap true;
	[_group, _veh] onMapSingleClick {
		onMapSingleClick {}; // To remove the code triggered on map click so you cannot click twice
		openMap false;

		private _group = _this select 0;
		private _veh = _this select 1;

		if(!([_veh] call ARWA_is_transport_active)) exitWith {};

		[_group, _veh, _pos, "TRANSPORT_RECEIVED_NEW_ORDERS"] spawn ARWA_move_transport_to_pick_up;
	};
	waitUntil {
		!visibleMap;
	};
	onMapSingleClick {}; // Remove the code in map click even if you didnt trigger onMapSingleClick
};

ARWA_move_transport_to_pick_up = {
	params ["_group", "_veh", "_pos", "_msg"];

	if(!([_veh] call ARWA_is_transport_active)) exitWith {};

	_veh setVariable [ARWA_KEY_active, true];
	[_group, [_msg]] spawn ARWA_group_report_client;

	if(_veh isKindOf "Air") then {
		[_group, _veh, "GET IN", _pos] call ARWA_land_helicopter;
	} else {
		[_group, _veh, _pos] call ARWA_send_vehicle_transport;
	};

	if(!([_veh] call ARWA_is_transport_active)) exitWith {};

	[_group, ["TRANSPORT_HAS_ARRIVED"]] spawn ARWA_group_report_client;
	[_veh, _group] spawn ARWA_on_transport_idle_wait;
};

ARWA_is_driver_dead = {
	params ["_veh"];

	private _is_dead = !((alive driver _veh) || (_veh getVariable ["player_driver", false]));

	if(_is_dead) then {
		_veh lockDriver false;
	};

	_is_dead;
};

ARWA_is_transport_dead = {
	params ["_veh"];

	private _is_dead = (isNull _veh) ||  {!alive _veh} || {!canMove _veh} || {[_veh] call ARWA_is_driver_dead};

	if(_is_dead) then {
		ARWA_transport_present = false;
	};

	_is_dead;
};

ARWA_is_transport_active = {
	params ["_veh"];

	private _is_active = !([_veh] call ARWA_is_transport_dead) && {!(_veh getVariable ["is_done", false])};

	if(!_is_active) then {

		player removeAction ARWA_cancel_transport_id;
		player removeAction ARWA_update_orders_id;

		if([_veh] call ARWA_is_transport_dead) exitWith {};

		_veh lock true;
	};

	_is_active;
};

ARWA_check_status = {
	params ["_veh"];

	waitUntil {
		([_veh] call ARWA_is_transport_dead);
	};

	sleep 1;

	if(isNull _veh) exitWith {};

	[playerSide, ["TRANSPORT_DOWN"]] spawn ARWA_HQ_report_client; // TODO make classname specific
};

ARWA_cancel_on_player_death = {
	params ["_veh", "_group"];
	waituntil {!([_veh] call ARWA_is_transport_active) || !(alive player)};

	if(!([_veh] call ARWA_is_transport_active)) exitWith {};

	[_veh, _group, "CANCELING_TRANSPORT_MISSION", true] call ARWA_interrupt_transport_misson;
};

ARWA_on_transport_idle_wait = {
	params ["_veh", "_group"];

	_veh setVariable [ARWA_KEY_active, false];

	private _timer = time + ARWA_transport_will_wait_time;

	waituntil {
		!([_veh] call ARWA_is_transport_active) || {(player in _veh) || time > _timer || _veh getVariable [ARWA_KEY_active, false]}
	};

	if(!([_veh] call ARWA_is_transport_active) || {player in _veh || _veh getVariable [ARWA_KEY_active, false]}) exitWith {};

	[_veh, _group, "TRANSPORT_CANT_WAIT_ANY_LONGER", true] call ARWA_interrupt_transport_misson;
};

ARWA_interrupt_transport_misson = {
	params ["_veh", "_group", "_msg", ["_empty_vehicle", false]];

	if(!([_veh] call ARWA_is_transport_active)) exitWith {};

	_veh setVariable ["is_done", true];

	[_group, [_msg]] spawn ARWA_group_report_client;

	if(_empty_vehicle) then {
		_veh call ARWA_empty_vehicle_cargo;
	} else {
		_veh call ARWA_throw_out_players;
	};

	sleep 3;

	private _success = if(_veh isKindOf "Air") then {
		[_group, _veh] call ARWA_take_off_and_despawn;
	} else {
		[_group, _veh] call ARWA_send_to_HQ;
	};

	if(_success) then {
		[playerSide, ["TRANSPORT_ARRIVED_IN_HQ"]] spawn ARWA_HQ_report_client;
	};
};

ARWA_empty_vehicle_cargo = {
	params ["_veh"];
	{
		if(!((group _x) isEqualTo (group _veh))) then {
			moveOut _x;
		};
	} forEach crew _veh;
};

ARWA_throw_out_players = {
	params ["_veh"];
	{
		if(isPlayer _x) then {
			moveOut _x;
		};
	} forEach crew _veh;
};
