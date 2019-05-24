
ARWA_vehicle_create_waypoint = {
	params ["_target", "_group"];
	private _pos = [(_target getVariable ARWA_KEY_pos), 0, 25, 5, 0, 0, 0] call BIS_fnc_findSafePos;

	// TODO if in sector, its not safe. Change to waypoint type SAD
	_group call ARWA_delete_all_waypoints;
	_w = _group addWaypoint [_pos, 20];
	_w setWaypointStatements ["true","[group this] call ARWA_delete_all_waypoints"];

	if{[_pos, side _group, ARWA_sector_size] call ARWA_any_enemies_in_area} then {
		_w setWaypointType "SAD";
	} else {
		_w setWaypointType "MOVE";
	};

	_group setBehaviour "SAFE";

	_group setSpeedMode "NORMAL";
	_group setCombatMode "YELLOW";
	_group setVariable [ARWA_KEY_target, _target];
};

ARWA_initialize_vehicle_group_ai = {
	params ["_group"];

	private _side = side _group;

	while{[_group] call ARWA_group_is_alive} do {

		if([_group] call ARWA_group_should_be_commanded) then {
			[_group, _side] spawn ARWA_vehicle_group_ai;
		};

		sleep 10;
	};
};

ARWA_vehicle_move_to_sector = {
	params ["_new_target", "_group"];

	if ([_group, _new_target] call ARWA_should_change_target) then {
		[_new_target, _group] call ARWA_vehicle_create_waypoint;
	};

	if ([_group] call ARWA_needs_new_waypoint) then {
		private _target = _group getVariable ARWA_KEY_target;
		[_target, _group] call ARWA_vehicle_create_waypoint;
	};

	if ([_group] call ARWA_approaching_target) then {
		_group setSpeedMode "LIMITED";
		_group setBehaviour "AWARE";
		_group setCombatMode "RED";
	};
};

ARWA_vehicle_group_ai = {
	params ["_group", "_side"];

	private _pos = getPosWorld (leader _group);

	private _target = if([_group, _side] call ARWA_check_if_has_priority_target) then {
		_group getVariable ARWA_KEY_priority_target;
	} else {
		_group setVariable [ARWA_KEY_priority_target, nil];
		[_side, _pos] call ARWA_get_ground_target;
	};

	[_target, _group] spawn ARWA_vehicle_move_to_sector;
	[_group] spawn ARWA_report_casualities_over_radio;
};
