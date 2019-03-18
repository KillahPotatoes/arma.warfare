arwa_transport_will_wait_time = 300;

in_transport = {
	(vehicle player) getVariable ["transport", false];
};

update_transport_orders = {
	params ["_group", "_veh"];

	openMap true;
	[_group, _veh] onMapSingleClick {
		onMapSingleClick {}; // To remove the code triggered on map click so you cannot click twice
		openMap false;

		private _group = _this select 0;
		private _veh = _this select 1;

		if(!([_veh] call is_transport_active)) exitWith {};

		[_group, _veh, _pos, "TRANSPORT_RECEIVED_NEW_ORDERS"] spawn move_transport_to_pick_up;
	};
	waitUntil {
		!visibleMap;
	};
	onMapSingleClick {}; // Remove the code in map click even if you didnt trigger onMapSingleClick
};

move_transport_to_pick_up = {
	params ["_group", "_veh", "_pos", "_msg"];

	if(!([_veh] call is_transport_active)) exitWith {};

	_veh setVariable ["active", true];
	[_group, [_msg]] spawn group_report_client;

	if(_veh isKindOf "Air") then {
		[_group, _veh, "GET IN", _pos] call land_helicopter;
	} else {
		[_group, _veh, _pos] call send_vehicle_transport;
	};

	if(!([_veh] call is_transport_active)) exitWith {};

	[_group, ["TRANSPORT_HAS_ARRIVED"]] spawn group_report_client;
	[_veh, _group] spawn on_transport_idle_wait;
};

is_driver_dead = {
	params ["_veh"];

	private _is_dead = !((alive driver _veh) || (_veh getVariable ["player_driver", false]));

	if(_is_dead) then {
		_veh lockDriver false;
	};

	_is_dead;
};

is_transport_dead = {
	params ["_veh"];

	private _is_dead = (isNull _veh) ||  {!alive _veh} || {!canMove _veh} || {[_veh] call is_driver_dead};

	if(_is_dead) then {
		arwa_transport_present = false;
	};

	_is_dead;
};

is_transport_active = {
	params ["_veh"];

	private _is_active = !([_veh] call is_transport_dead) && {!(_veh getVariable ["is_done", false])};

	if(!_is_active) then {
		_veh lock true;
		player removeAction arwa_cancel_transport_id;
		player removeAction arwa_update_orders_id;
	};

	_is_active;
};

check_status = {
	params ["_veh"];

	waitUntil {
		([_veh] call is_transport_dead);
	};

	if(isNull _veh) exitWith {};

	[playerSide, ["TRANSPORT_DOWN"]] spawn HQ_report_client; // TODO make classname specific
};

cancel_on_player_death = {
	params ["_veh", "_group"];
	waituntil {!([_veh] call is_transport_active) || !(alive player)};

	if(!([_veh] call is_transport_active)) exitWith {};

	[_veh, _group, "CANCELING_TRANSPORT_MISSION", true] call interrupt_transport_misson;
};

on_transport_idle_wait = {
	params ["_veh", "_group"];

	_veh setVariable ["active", false];

	private _timer = time + arwa_transport_will_wait_time;

	waituntil {
		!([_veh] call is_transport_active) || {(player in _veh) || time > _timer || _veh getVariable ["active", false]}
	};

	if(!([_veh] call is_transport_active) || {player in _veh || _veh getVariable ["active", false]}) exitWith {};

	[_veh, _group, "TRANSPORT_CANT_WAIT_ANY_LONGER", true] call interrupt_transport_misson;
};

interrupt_transport_misson = {
	params ["_veh", "_group", "_msg", ["_empty_vehicle", false]];

	if(!([_veh] call is_transport_active)) exitWith {};

	_veh setVariable ["is_done", true];

	[_group, [_msg]] spawn group_report_client;

	if(_empty_vehicle) then {
		_veh call empty_vehicle_cargo;
	} else {
		_veh call throw_out_players;
	};

	sleep 3;

	private _success = if(_veh isKindOf "Air") then {
		[_group, _veh] call take_off_and_despawn;
	} else {
		[_group, _veh] call send_to_HQ;
	};

	if(_success) then {
		[playerSide, ["TRANSPORT_ARRIVED_IN_HQ"]] spawn HQ_report_client;
	};
};

empty_vehicle_cargo = {
	params ["_veh"];
	{
		if(!((group _x) isEqualTo (group _veh))) then {
			moveOut _x;
		};
	} forEach crew _veh;
};

throw_out_players = {
	params ["_veh"];
	{
		if(isPlayer _x) then {
			moveOut _x;
		};
	} forEach crew _veh;
};
