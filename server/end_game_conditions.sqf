ARWA_active_factions = ARWA_all_sides;

ARWA_lost = {
	params ["_side"];
	private _players = _side countSide (allPlayers select { alive _x });

	_side call ARWA_get_strength <= 0 && _players == 0;
};

ARWA_check_end_game_state = {
	params ["_side"];

	if(_side call ARWA_lost) exitWith {
		ARWA_active_factions = ARWA_active_factions - [_side];
	};

	ARWA_active_factions pushBackUnique _side;
};

ARWA_end_game_conditions_check = {
	while {count ARWA_active_factions > 1} do {
		{
			[_x] call ARWA_check_end_game_state;
		} foreach ARWA_all_sides;

		sleep 10;
	};
	[ARWA_active_factions] remoteExec ["ARWA_end_mission"];
};

