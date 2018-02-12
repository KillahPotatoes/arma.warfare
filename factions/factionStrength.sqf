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

	WEST_percentage = 0;
	EAST_percentage = 0;
	GUER_percentage = 0;	

	publicVariable "WEST_percentage";
	publicVariable "EAST_percentage";
	publicVariable "GUER_percentage";

	publicVariable "WEST_tier";
	publicVariable "EAST_tier";
	publicVariable "GUER_tier";
};

CalculatePercentageTilNextTier = {
		_side = _this select 0;

		_kill_count = missionNamespace getVariable (format ["%1_kill_counter", _side]);
		_tier =  missionNamespace getVariable (format ["%1_tier", _side]);

		if (_tier == 3) exitWith { ""; };

		_tier_bound =  if(_tier == 0) then { 0 } else { missionNamespace getVariable (format ["tier_%1", _tier]); };
		_next_tier_bound =  missionNamespace getVariable (format ["tier_%1", _tier + 1]);

		_percentage = floor(((_kill_count - _tier_bound) / (_next_tier_bound - _tier_bound)) * 100);

		_var_name = format["%1_percentage", _side];	

		missionNamespace setVariable [_var_name, _percentage, true];
		publicVariable _var_name;		
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
			_msg = format["%1 advanced to tier 3", _side];
			_msg remoteExec ["hint"]; 
			missionNamespace setVariable [format ["%1_tier", _side], 3, true];
		};
		
		if(_new_kill_count > tier_2 && _tier < 2) exitWith {
			_msg = format["%1 advanced to tier 2", _side];  
			_msg remoteExec ["hint"];   
			missionNamespace setVariable [format ["%1_tier", _side], 2, true];
		};
		
		if(_new_kill_count > tier_1 && _tier < 1) exitWith {
			_msg = format["%1 advanced to tier 1", _side];
			_msg remoteExec ["hint"]; 
			missionNamespace setVariable [format ["%1_tier", _side], 1, true];
		};
	};

	[_side] call CalculatePercentageTilNextTier;
}; 

SetInitialFactionStrength = {
	_side = _this select 0;
	_value = _this select 1;

	_initial_strength_var = format ["%1_initial_strength", _side];
	_total_strength_var = format ["%1_strength", _side];
	missionNamespace setVariable [_initial_strength_var, _value, true];
	missionNamespace setVariable [_total_strength_var, _value, true];

	publicVariable _total_strength_var;
}; 

SetFactionStrength = {
	_side = _this select 0;
	_value = _this select 1;

	_name = format ["%1_strength", _side];
	missionNamespace setVariable [_name, _value, true];

	publicVariable _name;	
}; 

GetFactionStrength = {
	_side = _this select 0;

	_name = format ["%1_strength", _side];
	missionNamespace getVariable _name;
};

SetFactionSectorIncome = {
	_side = _this select 0;
	_value = _this select 1;

	_name = format ["%1_sector_income", _side];
	missionNamespace setVariable [_name, _value, true];

	publicVariable _name;
}; 

GetFactionSectorIncome = {
	_side = _this select 0;

	_name = format ["%1_sector_income", _side];
	missionNamespace getVariable _name;	
};

CalculateTierBoundaries = {
	tier_1 = 30;
	tier_2 = 60;
	tier_3 = 90;
};

[] call InitializeFactionStats;
[] call CalculateTierBoundaries;