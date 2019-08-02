ARWA_air_create_waypoint = {
	params ["_target_pos", "_group"];

	_group call ARWA_delete_all_waypoints;
	_w = _group addWaypoint [_target_pos, 5];
	_w setWaypointStatements ["true","[group this] call ARWA_delete_all_waypoints"];

	_w setWaypointType "SAD";
	_group setBehaviour "AWARE";

	_group setCombatMode "YELLOW";
	_group setVariable [ARWA_KEY_target, _target_pos];
};

ARWA_air_move_to_sector = {
	params ["_new_target_pos", "_group"];

	if ([_group, _new_target_pos] call ARWA_should_change_target) then {
		[_new_target_pos, _group] call ARWA_air_create_waypoint;
	};

	if ([_group] call ARWA_needs_new_waypoint) then {
		[_new_target_pos, _group] call ARWA_air_create_waypoint;
	};

	if ([_group] call ARWA_approaching_target) then {
		_group setCombatMode "RED";
	};
};

ARWA_initialize_air_group_ai = {
	params ["_group", "_veh"];

	private _side = side _group;

	while{[_group] call ARWA_group_is_alive} do {

		if(!(someAmmo _veh)) exitWith {
			[_group, _veh] spawn ARWA_take_off_and_despawn;
		};

		if([_group] call ARWA_group_should_be_commanded) then {
			private _target_pos = [_group, _side] call ARWA_find_air_target;
			[_target_pos, _group] spawn ARWA_air_move_to_sector;
		};

		sleep 10;
	};
};

ARWA_find_air_target = {
	params ["_group", "_side"];

	private _pos = getPosWorld (leader _group);
	private _unsafe_sectors = [_side] call ARWA_get_unsafe_sectors;

	if ((count _unsafe_sectors) > 0) exitWith {
		private _target = [_unsafe_sectors, _pos] call ARWA_find_closest_sector;
		_target getVariable ARWA_KEY_pos;
	};

	private _enemy_sectors = [_side] call ARWA_find_enemy_sectors;

	if((count _enemy_sectors) > 0) exitWith {
		private _target = [_enemy_sectors, _pos] call ARWA_find_closest_sector;
		_target getVariable ARWA_KEY_pos;
	};

	private _target = [ARWA_sectors, _pos] call ARWA_find_closest_sector;
	_target getVariable ARWA_KEY_pos;
};