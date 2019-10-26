ARWA_spawn_interceptors = {
	private _spawned_interceptor = false;
	while {true} do {
		{
			private _player = _x;
			private _class_name = typeOf (vehicle _player);

			if([_class_name, ARWA_KEY_interceptor] call ARWA_is_type_of) then {
				private _enemies = ARWA_active_factions - [side group _player];
				private _interceptor_side = selectRandom _enemies;

				private _number = ceil(random 3);

				[_interceptor_side, _number] call ARWA_spawn_ai_interceptors;
				_spawned_interceptor = true;
			};

		} forEach allPlayers;
		sleep (if(_spawned_interceptor) then { 300 + random 900; } else { random 300; });
		_spawned_interceptor = false;
	};
};

ARWA_spawn_ai_interceptors = {
	params ["_side", "_number"];

	private _options = [_side, ARWA_KEY_interceptor] call ARWA_get_units_based_on_tier;

	if(_options isEqualTo []) exitWith {};

	private _random_selection = selectRandom _options;
	private _interceptor = _random_selection select 0;
	private _kill_bonus = _random_selection select 1;
	private _interceptor_name = _interceptor call ARWA_get_vehicle_display_name;
	private _arr = [_side] call ARWA_find_spawn_pos_and_direction;

	private _pos = _arr select 0;
	private _heading = _arr select 1;

	for "_x" from 1 to _number step 1 do {
		private _new_pos = _pos getPos [100 * _x ,_heading - 90];
		diag_log format ["%1: Spawn interceptor: %2", _side, _interceptor_name];
		private _veh_arr = [_interceptor, _kill_bonus, _side,  [_new_pos, _heading]] call ARWA_spawn_interceptor;
		private _group = _veh_arr select 2;
		[_group] spawn ARWA_add_battle_group;
	};

	[_interceptor_side, ["ARWA_STR_SENDING_VEHICLE_YOUR_WAY", _interceptor_name]] remoteExec ["ARWA_HQ_report_client"];
};