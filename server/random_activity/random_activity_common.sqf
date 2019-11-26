ARWA_random_enemies = [];

ARWA_random_activity = {
	private _counter = 1;
	while {true} do {
		ARWA_random_enemies = [ARWA_random_enemies] call ARWA_remove_null;

		if(ARWA_max_random_enemies > (count ARWA_random_enemies)) then {
			private _players = allPlayers call BIS_fnc_arrayShuffle;
			{
				private _player = _x;
				private _class_name = typeOf (vehicle _player);

				if(!([_class_name, ARWA_KEY_interceptor] call ARWA_is_type_of)) then {
					if((_counter mod 30) == 0) then {
						[_player] call ARWA_spawn_random_vehicle;
					};

					[_player] call ARWA_check_houses_to_populate;
				};
			} forEach (_players select { alive _x; });

			ARWA_houses_already_checked = [];
		};

		sleep 10;
		_counter = _counter + 1;
	};
};

ARWA_remove_when_no_player_closeby = {
	params ["_group", "_distance", "_vehicle"];

	waitUntil {!([getPos (leader _group), _distance] call ARWA_players_nearby)};

	{
		deleteVehicle _x;
	} forEach units _group;

	if(!isNil "_vehicle") then {
		deleteVehicle _vehicle;
		["Deleted vehicle"] call ARWA_debugger;
	};

	deleteGroup _group;
};