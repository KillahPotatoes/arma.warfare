arwa_active_factions = [east, west, independent];

lost = {
	params ["_side"];
	private _players = _side countSide (allPlayers select { alive _x });

	_side call get_strength <= 0 && _players == 0;
};

check_end_game_state = {
	params ["_side"];
	
	if(_side call lost) exitWith {
		arwa_active_factions = arwa_active_factions - [_side];
	};

	arwa_active_factions pushBackUnique _side;
};

end_game_conditions_check = {
	while {count arwa_active_factions > 1} do {
		[east] call check_end_game_state; 
		[west] call check_end_game_state; 
		[independent] call check_end_game_state; 		
		
		sleep 10;
	};
	[arwa_active_factions] remoteExec ["end_mission"];
};