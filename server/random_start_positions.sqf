ARWA_prefixes = ["alpha", "bravo", "charlie"];

ARWA_assign_prefix = {
	params ["_side"];

	private _name = format["ARWA_%1_prefix", _side];
	private _prefix = selectRandom ARWA_prefixes;
	private _index = ARWA_prefixes find _prefix;

	ARWA_prefixes deleteAt _index;
	missionNamespace setVariable [_name, _prefix, true];
};

ARWA_assign_prefixes = {
	{
		[_x] call ARWA_assign_prefix;
	} foreach ARWA_all_sides;
};
