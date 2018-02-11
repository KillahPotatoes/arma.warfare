InitializeFactionStats = {
	[West, 50] call SetInitialFactionStrength;
	[East, 50] call SetInitialFactionStrength;
	[independent, 50] call SetInitialFactionStrength;

	[West, 0] call SetFactionSectorIncome;
	[East, 0] call SetFactionSectorIncome;
	[independent, 0] call SetFactionSectorIncome;

	WEST_kill_counter = 0;
	EAST_kill_counter = 0;
	GUER_kill_counter = 0;

	WEST_tier = 0;
	EAST_tier = 0;
	GUER_tier = 0;	
};

IncrementFactionKillCounter = {
	_side = _this select 0;

	_kill_counter = format ["%1_kill_counter", _side];
	_kill_count = missionNamespace getVariable _kill_counter;
	_new_kill_count = _kill_count + 1;

	missionNamespace setVariable [_kill_counter, _new_kill_count, true];

	_tier =  missionNamespace getVariable (format ["%1_tier", _side]);

	if(_tier < 3) then {
		if(_new_kill_count > tier_3 && _tier < 3) exitWith {
			systemChat format["%1 advanced to tier 3", _side];
			missionNamespace setVariable [format ["%1_tier", _side], 3, true];
		};
		
		if(_new_kill_count > tier_2 && _tier < 2) exitWith {
			systemChat format["%1 advanced to tier 2", _side];    
			missionNamespace setVariable [format ["%1_tier", _side], 2, true];
		};
		
		if(_new_kill_count > tier_1 && _tier < 1) exitWith {
			systemChat format["%1 advanced to tier 1", _side];
			missionNamespace setVariable [format ["%1_tier", _side], 1, true];
		};
	}
}; 

SetInitialFactionStrength = {
	_side = _this select 0;
	_value = _this select 1;

	_initial_strength_var = format ["%1_initial_strength", _side];
	_total_strength_var = format ["%1_strength", _side];
	missionNamespace setVariable [_initial_strength_var, _value, true];
	missionNamespace setVariable [_total_strength_var, _value, true];
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
	tier_1 = 30;
	tier_2 = 60;
	tier_3 = 90;
};

[] call InitializeFactionStats;
[] call CalculateTierBoundaries;