
ARWA_vehicle_create_waypoint = {
	params ["_target", "_group"];
	private _pos = _target getVariable ARWA_KEY_pos;

	_group call ARWA_delete_all_waypoints;
	_w = _group addWaypoint [_pos, 0];
	_w setWaypointCompletionRadius 10;
	_w setWaypointStatements ["true","[group this] call ARWA_delete_all_waypoints"];

	if([_pos, side _group, ARWA_sector_size] call ARWA_any_enemies_in_area) then {
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

	if ([_group, _new_target] call ARWA_should_change_target || [_group] call ARWA_needs_new_waypoint) then {
		private _target_name = _new_target getVariable ARWA_KEY_target_name;
		format["Vehicle %1 moving to %2", _group, _target_name] spawn ARWA_debugger;
		[_new_target, _group] call ARWA_vehicle_create_waypoint;
	};

	if ([_group] call ARWA_approaching_target) then {
		private _target = _group getVariable ARWA_KEY_target;
		private _pos = _target getVariable ARWA_KEY_pos;

		private _target_name = _target getVariable ARWA_KEY_target_name;
		format["Vehicle %1 approaching %2", _group, _target_name] spawn ARWA_debugger;

		if([_pos, side _group, ARWA_sector_size] call ARWA_any_enemies_in_area) then {
			_group setBehaviour "AWARE";
			_group setCombatMode "RED";
		};

		_group setSpeedMode "LIMITED";
	};
};

ARWA_vehicle_group_ai = {
	params ["_group", "_side"];

	private _pos = getPosWorld (leader _group);

	private _target = if([_group, _side] call ARWA_check_if_has_priority_target) then {
		_group getVariable ARWA_KEY_priority_target;
	} else {
		_group setVariable [ARWA_KEY_priority_target, nil];
		[_side, _pos] call ARWA_get_vehicle_target;
	};

	[_target, _group] spawn ARWA_vehicle_move_to_sector;
	[_group] spawn ARWA_report_casualities_over_radio;
};

ARWA_get_vehicle_target = {
	params ["_side", "_pos"];

	private _sectors = [_side] call ARWA_get_other_sectors;
	private _unsafe_sectors = [_side] call ARWA_get_unsafe_sectors;
	private _targets = _sectors + _unsafe_sectors;

	if((count _targets) > 0) exitWith {
		[_targets, _pos] call ARWA_find_closest_sector_connected_by_road;
	};

	[ARWA_sectors, _pos] call ARWA_find_closest_sector_connected_by_road;
};