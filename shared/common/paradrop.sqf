ARWA_do_paradrop = {
	params ["_drop_pos", "_units", "_side"];

	private _pos = [_side, ARWA_interceptor_safe_distance, ARWA_paradrop_plane_flight_height] call ARWA_find_spawn_pos_air;
	private _dir = [_pos, _drop_pos] call ARWA_find_spawn_dir_air;

	private _plane_obj = missionNamespace getVariable format["ARWA_%1_paradrop_plane", _side]; // TODO Add planes

	private _class_name = _plane_obj select 0;

	private _kill_bonus = _plane_obj select 1;
	private _interceptor_name = _class_name call ARWA_get_vehicle_display_name;
	private _veh_arr = [_class_name, _kill_bonus, _side, _pos, _dir] call ARWA_spawn_plane;

	private _vehicle = _veh_arr select 0;
	_vehicle flyInHeight ARWA_paradrop_plane_flight_height;
	(driver _vehicle) disableAI "LIGHTS";
	_vehicle lockDriver true;

	[_vehicle, _units] call ARWA_add_soldiers_to_paradrop_cargo;
	[_vehicle, _units, _drop_pos] spawn ARWA_paradrop_on_location;

	private _group = _veh_arr select 2;

	private _w1 = _group addWaypoint [_drop_pos, 0];
	_w1 setWaypointType "MOVE";
	_w1 setWaypointCompletionRadius 100;
	_w1 setWaypointStatements ["true","[group this] call ARWA_despawn_plane"];

	_group setBehaviour "CARELESS";
};

ARWA_despawn_plane = {
	params ["_group"];

	[_group, vehicle (leader _group), ARWA_interceptor_safe_distance] spawn ARWA_despawn_air;
};

ARWA_paradrop_on_location = {
	params ["_vehicle", "_units", "_pos"];

	private _paradrop_distance = (count _units) * 30;
	private _group = group (_units select 0);


	waitUntil { _vehicle distance2D _pos < (_paradrop_distance + 2000); };

	_vehicle limitSpeed 200;

	waitUntil { _vehicle distance2D _pos < (_paradrop_distance + 500); };

	[leader _group, ["ARWA_STR_GET_READY_TO_JUMP"]] remoteExec ["ARWA_group_chat"];

	private _speed = speed _vehicle;
	_paradrop_distance = (_speed * 1000 / 7200) *  (count _units);

	waitUntil { _vehicle distance2D _pos < _paradrop_distance; };

	{
		removeBackpack _x;
		_x addBackpack "B_Parachute";
		_x action ["Eject", vehicle _x];
		sleep 0.5;
	} forEach _units;

	_vehicle limitSpeed 1000;
};

ARWA_add_soldiers_to_paradrop_cargo = {
	params ["_vehicle", "_units"];

	private _players = _units select { isPlayer _x; };

	{
		_x moveInCargo _vehicle;
	} forEach _players;

	_units = _units - _players;

	{
		if(_vehicle emptyPositions "cargo" > 0) then {
			_x moveInCargo _vehicle;
		} else {
			deleteVehicle _x;
		}
	} forEach _units;
};
