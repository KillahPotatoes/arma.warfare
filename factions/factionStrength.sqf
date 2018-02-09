InitializeFactionStats = {
	[West, 50] call SetFactionStrength;
	[East, 50] call SetFactionStrength;
	[independent, 50] call SetFactionStrength;

	[West, 0] call SetFactionSectorIncome;
	[East, 0] call SetFactionSectorIncome;
	[independent, 0] call SetFactionSectorIncome;
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

[] call InitializeFactionStats;