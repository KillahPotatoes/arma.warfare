ARWA_random_people = [];
ARWA_random_vehicles = [];

ARWA_random_activity = {
	private _counter = 1;
	sleep 30;
	while {true} do {
		ARWA_random_people = [ARWA_random_people] call ARWA_remove_null;
		ARWA_random_vehicles = [ARWA_random_vehicles] call ARWA_remove_null;
		ARWA_houses_already_checked = [];

		if(ARWA_max_random_people > count ARWA_random_people || ARWA_max_random_vehicles > count ARWA_random_vehicles ) then {
			private _players = (allPlayers select { alive _x; }) call BIS_fnc_arrayShuffle;
			{
				private _player = _x;
				private _class_name = typeOf (vehicle _player);

				if(!([_class_name, ARWA_KEY_interceptor] call ARWA_is_type_of)) then {
					if(ARWA_max_random_vehicles > count ARWA_random_vehicles && {[1] call ARWA_percent_chance}) then {
						[_player] call ARWA_spawn_random_vehicle;
					};
					if(ARWA_max_random_people > count ARWA_random_people) then {
						[_player] call ARWA_check_houses_to_populate;
					};
				};
			} forEach _players;
		};

		sleep 10;
		_counter = _counter + 1;
	};
};

ARWA_remove_when_no_player_closeby = {
	params ["_group", "_distance", "_vehicle"];

	if(!isNil "_vehicle") then {
		waitUntil {!([getPos _vehicle, _distance] call ARWA_players_nearby)};
		deleteVehicle _vehicle;
	};

	waitUntil {!([getPos (vehicle leader _group), _distance] call ARWA_players_nearby)};

	{
		deleteVehicle _x;
	} forEach units _group;

	deleteGroup _group;
};