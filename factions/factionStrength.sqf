InitializeFactionStats = {
	[West, 50] call SetInitialFactionStrength;
	[East, 50] call SetInitialFactionStrength;
	[independent, 50] call SetInitialFactionStrength;

	[West, 0] call SetFactionSectorIncome;
	[East, 0] call SetFactionSectorIncome;
	[independent, 0] call SetFactionSectorIncome;
};

SetInitialFactionStrength = {
	_side = _this select 0;
	_value = _this select 1;

	_initial_strength_var = format ["%1_initial_strength", _side];
	_total_strength_var = format ["%1_strength", _side];
	missionNamespace setVariable [_initial_strength_var, _value, true];
	missionNamespace setVariable [_total_strength_var, _value, true];
}; 

GetInitialFactionStrength = {
	_side = _this select 0;
	missionNamespace getVariable (format ["%1_initial_strength", _side]);
};

GetAccumulatedStrength = {
	_side = _this select 0;

	_initial_strength = missionNamespace getVariable (format ["%1_initial_strength", _side]);
	_total_strength = missionNamespace getVariable (format ["%1_strength", _side]);
	
	_total_strength - _initial_strength;	
};

SetFactionStrength = {
	_side = _this select 0;
	_value = _this select 1;

	_name = format ["%1_strength", _side];
	missionNamespace setVariable [_name, _value, true]
}; 

GetFactionStrength = {
	_side = _this select 0;

	_name = format ["%1_strength", _side];
	_value = missionNamespace getVariable _name;
	_value;
};

SetFactionSectorIncome = {
	_side = _this select 0;
	_value = _this select 1;

	_name = format ["%1_sector_income", _side];
	missionNamespace setVariable [_name, _value, true]
}; 

GetFactionSectorIncome = {
	_side = _this select 0;

	_name = format ["%1_sector_income", _side];
	_value = missionNamespace getVariable _name;
	_value;	
};

CalculateTierBoundaries = {
	_sector_count = count sectors;

	tier_one = _sector_count * 2;
	tier_two = _sector_count * 3;
	tier_three = _sector_count * 4;
};

[] call InitializeFactionStats;
[] call CalculateTierBoundaries;