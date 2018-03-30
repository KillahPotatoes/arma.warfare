set_skill = {
	params ["_side", "_value"];
	missionNamespace setVariable [format["%1_skill", _side], _value];
}; 

get_skill = {
	params ["_side"];
	missionNamespace getVariable [format ["%1_skill",  _side], initial_skill];
};

calc_skill = {
	params ["_side"];

	_half = starting_strength / 2;
	_skill = (0 max (0.5 min ((_half - ((_side call get_strength) - _half)) / starting_strength)));   
	[_side, _skill] call set_skill;
};

adjust_skill = {
	west call calc_skill;
	east call calc_skill;
	independent call calc_skill;

	{
		private _skill = (side _x) call get_skill;
		_x setSkill _skill + initial_skill;
	} forEach allUnits;	
};

skill_balancing = {
	while {true} do {
		//_t4 = diag_tickTime;
		[] call adjust_skill;
		//[_t4, "skill_balancing"] spawn report_time;			
		sleep 10;
	};
};
