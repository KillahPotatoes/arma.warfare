

ARWA_get_active_factions = {
	ARWA_all_sides select { _x call ARWA_has_manpower; };
};

ARWA_end_game_conditions_check = {
	[] spawn ARWA_manpower_count_down;
	[] spawn ARWA_check_winning_conditions;
};

ARWA_check_winning_conditions = {
	private _number_of_sectors = count ARWA_sectors;
	private _game = true;

	while{_game} do {
		private _owners = ARWA_sectors apply { _x getVariable ARWA_KEY_owned_by };

		{
			private _side = _x;
			private _owned_sectors = { _x isEqualTo _side; } count _owners;

			if(_owned_sectors == _number_of_sectors) then {
				private _other_factions = ARWA_all_sides - [_side];
				private _dead_factions = _other_factions select { _x call ARWA_get_strength == 0; };

				if(_dead_factions isEqualTo _other_factions) then {
					_game = false;
					_side remoteExec ["ARWA_end_mission"];
				};

			};

		} foreach ARWA_all_sides;

		sleep 2;
	};
};

ARWA_manpower_count_down = {
	waitUntil { (ARWA_start_time + 1800) < time; };

	while{true} do {
		private _owners = ARWA_sectors apply { _x getVariable ARWA_KEY_owned_by };

		{
			private _side = _x;
			if(!(_side in _owners)) then {
				private _faction_strength = _side call ARWA_get_strength;
				private _new_faction_strength = _faction_strength - 1;
				[_side, _new_faction_strength] call ARWA_set_strength;
			};

		} foreach ARWA_all_sides;

		sleep 2;
	};
};