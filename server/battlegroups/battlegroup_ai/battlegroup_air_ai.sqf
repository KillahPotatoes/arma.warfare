ARWA_air_create_waypoint = {
	params ["_target", "_group"];
	private _pos = _target getVariable ARWA_KEY_pos;

	_group call ARWA_delete_all_waypoints;
	_w = _group addWaypoint [_pos, 5];
	_w setWaypointStatements ["true","[group this] call ARWA_delete_all_waypoints"];

	_w setWaypointType "SAD";
	_group setBehaviour "AWARE";

	_group setCombatMode "YELLOW";
	_group setVariable [ARWA_KEY_target, _target];
};

ARWA_air_move_to_sector = {
	params ["_new_target", "_group"];

	if ([_group, _new_target] call ARWA_should_change_target || [_group] call ARWA_needs_new_waypoint) then {
		[_new_target, _group] call ARWA_air_create_waypoint;
	};

	if ([_group] call ARWA_approaching_target) then {
		_group setCombatMode "RED";
	};
};

ARWA_initialize_helicopter_group_ai = {
	params ["_group", "_veh"];

	private _side = side _group;

	while{[_group] call ARWA_group_is_alive} do {

		if(!(someAmmo _veh)) exitWith {
			diag_log format["Out of ammo: Despawn %1 %2", _veh, _side];
			[_group, _veh] spawn ARWA_despawn_air;
		};

		if([_group] call ARWA_group_should_be_commanded) then {
			private _target = [_group, _side] call ARWA_find_air_target;
			[_target, _group] spawn ARWA_air_move_to_sector;
		};

		sleep 10;
	};
};

ARWA_players_in_interceptors = {
	private _players_in_planes = [];
	{
		private _player = _x;
		private _class_name = typeOf (vehicle _player);
		if([_class_name, ARWA_KEY_interceptor] call ARWA_is_type_of) then {
			_players_in_planes append _player;
		};
	} forEach allPlayers;

	_players_in_planes
};

ARWA_initialize_interceptor_group_ai = {
	params ["_group", "_veh"];

	private _side = side _group;

	while{[_group] call ARWA_group_is_alive} do {

		if(!(someAmmo _veh)) exitWith {
			diag_log format["Out of ammo: Despawn %1 %2", _veh, _side];
			[_group, _veh] spawn ARWA_despawn_air;
		};

		if([_group] call ARWA_group_should_be_commanded) then {
			private _players_in_interceptors = [] call ARWA_players_in_interceptors;

			diag_log format["Players in interceptors: %1", count _players_in_interceptors];
			diag_log format["Assigned target: %1", assignedTarget _veh];

			if(!(_players_in_interceptors isEqualTo []) && isNull (assignedTarget _veh)) exitWith {

				private _player_veh = vehicle (selectRandom _players_in_interceptors);
				_group commandTarget _player_veh;
				diag_log format["%1 targeting %2", _veh, _player_veh];
			};

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