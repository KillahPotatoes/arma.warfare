

ARWA_spawn_transport_vehicle = {
	params ["_side", "_class_name", "_kill_bonus"];

	private _base_marker_name = [_side, ARWA_KEY_vehicle] call ARWA_get_prefixed_name;
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
	private _pos = [_side] call ARWA_get_hq_pos;

	_group addWaypoint [_pos, 0];

	waitUntil {([_veh] call ARWA_is_transport_dead) || ((_pos distance2D (getPos _veh)) < ARWA_HQ_area) };

	if (alive _veh) exitWith
	{
		[_veh, playerSide] call ARWA_delete_vehicle;
		true;
	};

	false;
};
