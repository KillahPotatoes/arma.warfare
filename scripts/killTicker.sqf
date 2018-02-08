killTicker = {
	_this addMPEventHandler ['MPKilled',{
		_unit = _this select 0;

		_newKill = [_unit,_killer];
		_newKill call register_kill;
		}
	];
};

register_kill = {
	_victim = _this select 0;
	_side = side group _victim;

	_faction_strength = [_side] call GetFactionStrength;
	_new_faction_strength = _faction_strength - 1;
	[_side, _new_faction_strength] call SetFactionStrength;
};
