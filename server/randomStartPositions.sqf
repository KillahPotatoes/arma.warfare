prefixes = ["alpha", "bravo", "charlie"];

assign_prefix = {
	params ["_side"];	
	
	private _name = format["%1_prefix", _side];
	private _prefix = selectRandom prefixes;
	private _index = prefixes find _prefix;

	prefixes deleteAt _index;
	missionNamespace setVariable [_name, _prefix, true];
};

assign_prefixes = {
	[west] call assign_prefix;
	[east] call assign_prefix;
	[independent] call assign_prefix;
};
