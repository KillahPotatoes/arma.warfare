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
		private params [_victim, _killer];
		
		[_victim,_killer] call register_kill;
		}
	];
};

register_kill = {
	private params [_victim, _killer];

	private _killer_side = side group _killer;
	private _victim_side = side group _victim;
    
	if (!(_victim_side isEqualTo _killer_side)) then {
		_kill_point = if(isPlayer _killer) then { 0.2; } else { 1; };
		[_killer_side, _kill_point] call IncrementFactionKillCounter;
	};

	_faction_strength = [_victim_side] call GetFactionStrength;
	_new_faction_strength = if(isPlayer _victim) then { _faction_strength - (1 max (_faction_strength / 5)); } else { _faction_strength - 1; };		
	[_victim_side, _new_faction_strength] call SetFactionStrength;
};
