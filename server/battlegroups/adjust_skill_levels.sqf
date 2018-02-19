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
	_skill = (starting_strength min (abs (0 min ((_side call get_strength) - starting_strength)))) / 100;  
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
		[] call adjust_skill;
		sleep 10;
	};
};
