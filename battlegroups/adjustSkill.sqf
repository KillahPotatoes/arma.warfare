AdjustGroupSkill = {
	_side = _this select 0;
	_group = _this select 1;

	_current_strength = [_side] call GetFactionStrength;		
	_add_skill = (starting_strength min (abs (0 min (_current_strength - starting_strength)))) / 100;  

	{
		_x setSkill _add_skill + 0.5;
	} forEach units _group;	
};