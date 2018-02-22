active_factions = [east, west, independent];

delete_playable_units = {
	params ["_side"];
	
	{
		if(side _x isEqualTo _side) then {
			deleteVehicle _x;			
		};
	} forEach playableUnits;
};

check_if_lost = {
	params ["_side"];
	private _lost = false;

	if(_side call get_strength <= 0 && _side call get_income == 0) then {

		_players = _side countSide allPlayers;

		if (_players == 0) then {
			_side call delete_playable_units;
			_lost = true;
		};
	};

	_lost;
};

check_end_game_state = {
	params ["_side"];
	
	if(_side call check_if_lost) exitWith {
		active_factions = active_factions - [_side];
	};

	active_factions pushBackUnique _side;
};

end_game_conditions_check = {
	while {count active_factions > 1} do {
		[east] call check_end_game_state; 
		[west] call check_end_game_state; 
		[independent] call check_end_game_state; 		
		
		sleep 2;
	};
	[active_factions] remoteExec ["end_mission"];
};