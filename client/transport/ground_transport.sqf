ARWA_send_vehicle_transport = {
	params ["_group", "_veh", "_pos"];

	_group move _pos;

	sleep 3;

	waitUntil {!([_veh] call ARWA_is_transport_active) || (unitReady _veh) };
};

ARWA_spawn_transport_vehicle = {
	params ["_side", "_class_name", "_kill_bonus"];

	private _base_marker_name = [_side, vehicle1] call ARWA_get_prefixed_name;
	private _base_marker = missionNamespace getVariable _base_marker_name;

	private _pos = getPos _base_marker;

	waitUntil { !([_pos] call ARWA_any_units_too_close); };

	private _veh_arr = [_pos, getDir _base_marker, _class_name, _side, _kill_bonus] call ARWA_spawn_vehicle;
	private _veh = _veh_arr select 0;
	_veh setVariable [ARWA_KEY_owned_by, playerSide];

	_veh lockDriver true;
	_veh_arr;
};

ARWA_send_to_HQ = {
	params ["_group", "_veh"];

	private _side = side _group;
	private _pos = getMarkerPos ([_side, respawn_ground] call ARWA_get_prefixed_name);

	_group addWaypoint [_pos, 0];

	waitUntil {([_veh] call ARWA_is_transport_dead) || ((_pos distance2D (getPos _veh)) < 100) };

	if (alive _veh) exitWith
	{
		private _manpower = (_veh call ARWA_get_manpower) + (_veh call ARWA_remove_soldiers);
		_veh setVariable [manpower, 0];

		if(_manpower > 0) then {
			[playerSide, _manpower] remoteExec ["ARWA_buy_manpower_server", 2];
			systemChat format[localize "YOU_ADDED_MANPOWER", _manpower];
		};

		deleteVehicle _veh;
		true;
	};

	false;
};