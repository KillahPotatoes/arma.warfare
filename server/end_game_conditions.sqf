

ARWA_get_active_factions = {
	ARWA_all_sides select { _x call ARWA_has_manpower; };
};

ARWA_get_alive_factions = {
	ARWA_all_sides select {
		private _side = _x;
		[_side] call ARWA_has_manpower || (_side countSide (
			allPlayers select { alive _x }
		)) > 0;
	};
};

ARWA_end_game_conditions_check = {
	private _alive_faction = ARWA_all_sides;
	while {count (_alive_faction) > 1} do {
		sleep 10;
		_alive_faction = [] call ARWA_get_alive_factions;
	};
	[_alive_faction] remoteExec ["ARWA_end_mission"]; // win by having all sectors and enemies reduced to 0
};
