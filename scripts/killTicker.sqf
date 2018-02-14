killTicker = {
	_this addMPEventHandler ['MPKilled',{
		_unit = _this select 0;
		_killer = _this select 1;

		[_unit,_killer] call register_kill;
		}
	];
};

register_kill = {
	_victim = _this select 0;
	_killer = _this select 1;

	_killer_side = side group _killer;
	_victim_side = side group _victim;
    
	if (!(_victim_side isEqualTo _killer_side)) then {
		_kill_point = if(isPlayer _killer) then { 0.2; } else { 1; };
		[_killer_side, _kill_point] call IncrementFactionKillCounter;
	};

	_faction_strength = [_victim_side] call GetFactionStrength;
	_new_faction_strength = if(isPlayer _victim) then { _faction_strength - 10; } else { _faction_strength - 1; };		
	[_victim_side, _new_faction_strength] call SetFactionStrength;
};
