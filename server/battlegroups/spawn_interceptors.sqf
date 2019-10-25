ARWA_spawn_interceptors = {
	params ["_side"];

	while {true} do {

		{
			private _player = _x;
			private _class_name = typeOf (vehicle _player);

			if([_class_name, ARWA_KEY_interceptor] call ARWA_is_type_of) then {
				private _enemies = ARWA_all_sides - [side _player];
				private _interceptor_side = selectRandom[_enemies];

				private _options = [_interceptor_side, ARWA_KEY_interceptor] call ARWA_get_units_based_on_tier;

				if((_options isEqualTo [])) exitWith {};

				private _random_selection = selectRandom _options;
				private _interceptor = _random_selection select 0;
				private _kill_bonus = _random_selection select 1;
				private _interceptor_name = _interceptor call ARWA_get_vehicle_display_name;
				private _interceptor = [_interceptor, _kill_bonus, _interceptor_side] call ARWA_spawn_interceptor;

				diag_log format ["%1: Spawn interceptor: %2", _side, _interceptor_name];
				diag_log format["%1 manpower: %2", _side, [_side] call ARWA_get_strength];

				[_side, ["ARWA_STR_SENDING_VEHICLE_YOUR_WAY", _interceptor_name]] remoteExec ["ARWA_HQ_report_client"];

				[_interceptor] spawn ARWA_add_battle_group;
			};

		} forEach allPlayers;
		sleep random[300, 600, 900];
	};
};
