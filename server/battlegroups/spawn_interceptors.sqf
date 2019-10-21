ARWA_spawn_interceptors = {
	params ["_side"];

	while {true} do {

		{
			private _player = _x;
			private _interceptors = [ARWA_KEY_interceptors, side _player] call ARWA_get_all_units_side;

			if(vehicle _player in _interceptors) then {
				private _enemies = ARWA_all_sides - [side _player];
				private _interceptor_side = selectRandom[_enemies];
				private _interceptor = [_interceptor_side] call ARWA_spawn_interceptor;

				[_interceptor, _player] spawn ARWA_interceptor_ai;
			};

		} forEach allPlayers;
		sleep random[300, 600, 900];
	};
};

ARWA_spawn_interceptor = {
	params ["_side"];

	private _interceptors = [ARWA_KEY_interceptors, _side] call ARWA_get_units_based_on_tier;
	private _interceptor = selectRandom[_interceptors];

	[_interceptor] call ARWA_spawn_vehicle;
};