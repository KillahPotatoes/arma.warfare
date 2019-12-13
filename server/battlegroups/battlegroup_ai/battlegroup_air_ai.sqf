ARWA_air_create_waypoint = {
	params ["_target", "_group"];
	private _pos = getPosWorld _target;

	_group call ARWA_delete_all_waypoints;
	_w = _group addWaypoint [_pos, 0];
	_w setWaypointStatements ["true","[group this] call ARWA_delete_all_waypoints"];

	_w setWaypointType "SAD";
	_group setBehaviour "AWARE";

	_group setCombatMode "YELLOW";
	_group setVariable [ARWA_KEY_target, _target];
};

ARWA_air_move_to_sector = {
	params ["_new_target", "_group"];

	if ([_group, _new_target] call ARWA_should_change_target || [_group] call ARWA_needs_new_waypoint) then {
		private _target_name = _new_target getVariable ARWA_KEY_target_name;
		format["Air %1 moving to %2", _group, _target_name] spawn ARWA_debugger;
		[_new_target, _group] call ARWA_air_create_waypoint;
	};

	if ([_group] call ARWA_approaching_target) then {
		private _target = _group getVariable ARWA_KEY_target;
		private _target_name = _target getVariable ARWA_KEY_target_name;
		format["Air %1 approaching %2", _group, _target_name] spawn ARWA_debugger;
		_group setCombatMode "RED";
	};
};

ARWA_initialize_air_group_ai = {
	params ["_group", "_veh"];

	private _side = side _group;
	private _class_name = typeOf _veh;

	while{[_group] call ARWA_group_is_alive} do {
		if(!(someAmmo _veh)) exitWith {
			format["Out of ammo: Despawn %1 %2", _veh, _side] spawn ARWA_debugger;

			if([_class_name, ARWA_KEY_interceptor] call ARWA_is_type_of) then {
				[_group, _veh, ARWA_interceptor_safe_distance] spawn ARWA_despawn_air;
			} else {
				[_group, _veh, ARWA_helicopter_safe_distance] spawn ARWA_despawn_air;
			};
		};

		if([_group] call ARWA_group_should_be_commanded) then {
			private _target = [_group, _side] call ARWA_find_air_target;
			[_target, _group] spawn ARWA_air_move_to_sector;
		};

		sleep 10;
	};
};

ARWA_find_air_target = {
	params ["_group", "_side"];

	private _pos = getPosWorld (leader _group);

	private _unsafe_sectors = [_side] call ARWA_get_unsafe_sectors;

	if ((count _unsafe_sectors) > 0) exitWith {
		[_unsafe_sectors, _pos] call ARWA_find_closest_sector;
	};

	private _enemy_sectors = [_side] call ARWA_find_enemy_sectors;

	if((count _enemy_sectors) > 0) exitWith {
		[_enemy_sectors, _pos] call ARWA_find_closest_sector;
	};

	[ARWA_sectors, _pos] call ARWA_find_closest_sector;
};