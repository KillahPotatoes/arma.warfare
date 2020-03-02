ARWA_random_people = [];
ARWA_random_vehicles = [];

ARWA_random_activity = {
	sleep 30;
	while {true} do {
		ARWA_random_people = [ARWA_random_people] call ARWA_remove_null;
		ARWA_random_vehicles = [ARWA_random_vehicles] call ARWA_remove_null;

		if(ARWA_max_random_people > count ARWA_random_people || ARWA_max_random_vehicles > count ARWA_random_vehicles ) then {
			private _alive_players = allPlayers select { alive _x; };

			if(_alive_players isEqualTo []) exitWith {};

			private _player = selectRandom _alive_players;
			private _class_name = typeOf (vehicle _player);

			if(!([_class_name, ARWA_KEY_interceptor] call ARWA_is_type_of)) then {
				if(ARWA_max_random_vehicles > count ARWA_random_vehicles && {[1] call ARWA_percent_chance}) then {
					[_player] call ARWA_spawn_random_vehicle;
				};
				if(ARWA_max_random_people > count ARWA_random_people) then {
					[_player] call ARWA_check_houses_to_populate;
				};
			};
		};

		sleep 10;
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