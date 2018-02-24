add_kill_ticker_to_all_units = {
	while {true} do {
		sleep 2;
		{
			if !(_x getVariable ["killTickerEventAdded",false]) then {
				_x spawn kill_ticker;
				_x setVariable ["killTickerEventAdded",true]
			};
		} count allUnits;
	};
};

kill_ticker = {
	_this addMPEventHandler ['MPKilled',{
			params ["_victim", "_killer"];
			[_victim, _killer] call register_kill;
		}
	];
};

calculate_kill_points = {
	params ["_side"];

	_players = _side countSide allPlayers;

	if(_players == 0) exitWith {
		1;
	};

	1 / (_players * 2);
};

register_kill = {
	params ["_victim", "_killer"];

	private _killer_side = side group _killer;
	private _victim_side = side group _victim;
    
	_kill_point = _killer_side call calculate_kill_points;

	if (!(_victim_side isEqualTo _killer_side)) then {
		[_killer_side, _kill_point] call increment_kill_counter;
	};

	_faction_strength = _victim_side call get_strength;
	_new_faction_strength = if(isPlayer _victim) then { _faction_strength - (5 max (_faction_strength / 5)); } else { _faction_strength - _kill_point };		
	[_victim_side, _new_faction_strength] call set_strength;
};
