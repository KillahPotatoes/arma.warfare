
ARWA_infantry_create_waypoint = {
	params ["_target", "_group"];
	private _pos = [(_target getVariable pos), 0, 25, 5, 0, 0, 0] call BIS_fnc_findSafePos;

	_group call ARWA_delete_all_waypoints;
	_w = _group addWaypoint [_pos, 5];
	_w setWaypointStatements ["true","[group this] call ARWA_delete_all_waypoints"];

	_w setWaypointType "SAD";
	_group setBehaviour "AWARE";

	_group setSpeedMode "NORMAL";
	_group setCombatMode "YELLOW";
	_group setVariable ["target", _target];
};

ARWA_get_smallest_group = {
	params ["_groups"];

	_current_group = _groups select 0;
	_smallest_count = 999999;

	{
		private _g = _x;
		_count = { alive _x } count units _g;

		if (_smallest_count > _count && _count != 0 && !(isPlayer leader _g)) then {
			_smallest_count = _count;
			_current_group = _g;
		};

	} forEach _groups;

	_current_group;
};

ARWA_join_nearby_group = {
	params ["_group"];

	private _joined_other_group = false;
	private _group_count = { alive _x } count units _group;

	if (!(isPlayer leader _group) && {_group_count < 3} && {_group_count > 0} && {!([_group] call ARWA_in_vehicle)}) then {
		private _groups = ([side _group] call ARWA_get_battlegroups) - [_group];
		private _pos = getPos leader _group;
		private _nearby_groups = _groups select { [_x, _pos, 100] call ARWA_group_nearby && !([_x] call ARWA_in_vehicle) && !(isPlayer leader _x)};

		if(!(_nearby_groups isEqualTo [])) then {
			private _smallest_group = [_nearby_groups] call ARWA_get_smallest_group;
			diag_log format ["%4:%1 of %2 joins %3", _group, _group_count, _smallest_group, side _group];
			{
				[_x] joinSilent _smallest_group;
			} forEach units _group;


			deleteGroup _group;

			private _new_count = { alive _x } count units _smallest_group;
			_smallest_group setVariable [soldier_count, _new_count];
			_joined_other_group = true;
		};
	};

	_joined_other_group;
};

ARWA_infantry_move_to_sector = {
	params ["_new_target", "_group"];

	if ([_group, _new_target] call ARWA_should_change_target && !([_group] call ARWA_join_nearby_group)) then {
		[_new_target, _group] call ARWA_infantry_create_waypoint;
	};

	if ([_group] call ARWA_needs_new_waypoint) then {
		private _target = _group getVariable "target";
		[_new_target, _group] call ARWA_infantry_create_waypoint;
	};

	if ([_group] call ARWA_approaching_target) then {
		_group setBehaviour "AWARE";
		_group setCombatMode "RED";
	};
};

ARWA_initialize_infantry_group_ai = {
	params ["_group"];

	private _side = side _group;

	while{[_group] call ARWA_group_is_alive} do {

		if([_group] call ARWA_group_should_be_commanded) then {
			[_group, _side] spawn ARWA_infantry_group_ai;
		};

		sleep 10;
	};
};

ARWA_infantry_group_ai = {
	params ["_group", "_side"];

	private _pos = getPosWorld (leader _group);

	private _target = if([_group, _side] call ARWA_check_if_has_priority_target) then {
		_group getVariable priority_target;
	} else {
		_group setVariable [priority_target, nil];
		[_side, _pos] call ARWA_get_ground_target;
	};

	[_target, _group] spawn ARWA_infantry_move_to_sector;
	[_group] spawn ARWA_report_casualities_over_radio;
};
