
ARWA_infantry_create_waypoint = {
	params ["_target", "_group"];
	private _pos = _target getVariable ARWA_KEY_pos;

	_group call ARWA_delete_all_waypoints;
	_w = _group addWaypoint [_pos, 0];
	_w setWaypointCompletionRadius 5;
	_w setWaypointStatements ["true","[group this] call ARWA_delete_all_waypoints"];

	_w setWaypointType "SAD";
	_group setBehaviour "AWARE";

	_group setSpeedMode "NORMAL";
	_group setCombatMode "YELLOW";
	_group setVariable [ARWA_KEY_target, _target];
};

ARWA_get_smallest_group = {
	params ["_groups"];

	_groups = _groups apply { [count units _x, _x] };
	_groups sort true;

	(_groups select 0) select 1;
};

ARWA_join_nearby_group = {
	params ["_group"];

	private _group_count = { alive _x } count units _group;

	if(isPlayer leader _group || {_group_count >= ARWA_squad_cap / 2} || {_group_count == 0} || {[_group] call ARWA_in_vehicle}) exitWith { false; };

	private _groups = ([side _group] call ARWA_get_battlegroups) - [_group];
	private _pos = getPos leader _group;
	private _nearby_groups = _groups select { [_x, _pos, 100] call ARWA_group_nearby && !([_x] call ARWA_in_vehicle) && !(isPlayer leader _x)};

	if(_nearby_groups isEqualTo []) exitWith { false; };

	private _smallest_group = [_nearby_groups] call ARWA_get_smallest_group;
	format ["%4:%1 of %2 joins %3", _group, _group_count, _smallest_group, side _group] spawn ARWA_debugger;

	(units _group) join _smallest_group;
	deleteGroup _group;

	private _new_count = { alive _x } count units _smallest_group;
	_smallest_group setVariable [ARWA_KEY_soldier_count, _new_count];
	true;
};

ARWA_infantry_move_to_target = {
	params ["_new_target", "_group"];

	if ([_group, _new_target] call ARWA_should_change_target || [_group] call ARWA_needs_new_waypoint) then {
		private _target_name = _new_target getVariable ARWA_KEY_target_name;
		format["Squad %1 moving to %2", _group, _target_name] spawn ARWA_debugger;
		[_new_target, _group] call ARWA_infantry_create_waypoint;
	};

	if ([_group] call ARWA_approaching_target) then {
		private _target = _group getVariable ARWA_KEY_target;
		private _target_name = _target getVariable ARWA_KEY_target_name;
		format["Squad %1 approaching %2", _group, _target_name] spawn ARWA_debugger;
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

	if([_group] call ARWA_join_nearby_group) exitWith {};

	private _target = if([_group, _side] call ARWA_check_if_has_priority_target) then {
		_group getVariable ARWA_KEY_priority_target;
	} else {
		_group setVariable [ARWA_KEY_priority_target, nil];
		[_side, _pos] call ARWA_get_infantry_target;
	};

	[_target, _group] spawn ARWA_infantry_move_to_target;
	[_group] spawn ARWA_report_casualities_over_radio;
};

ARWA_get_infantry_target = {
	params ["_side", "_pos"];

	private _sectors = [_side] call ARWA_get_other_sectors;
	private _unsafe_sectors = [_side] call ARWA_get_unsafe_sectors;
	private _targets = _sectors + _unsafe_sectors;

	if((count _targets) > 0) exitWith {
		[_targets, _pos] call ARWA_find_closest_sector;
	};

	[ARWA_sectors, _pos] call ARWA_find_closest_sector;
};