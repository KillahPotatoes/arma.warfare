_prefixes = ["alpha", "bravo", "charlie"];

guer_prefix = selectRandom _prefixes;
_prefixes deleteAt (_prefixes find guer_prefix);

east_prefix = selectRandom _prefixes;
_prefixes deleteAt (_prefixes find east_prefix);

west_prefix = selectRandom _prefixes;

GetPrefix = {
	_side = _this select 0;

	if(_side isEqualTo west) exitWith {
		west_prefix;
	};

	if(_side isEqualTo east) exitWith {
		east_prefix;
	};

	if(_side isEqualTo independent) exitWith {
		guer_prefix;
	};
};
