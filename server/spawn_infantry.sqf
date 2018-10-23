pick_soldiers = {
	params ["_side", "_number"];

	private _infantry_preset = [_side, infantry] call get_units_based_on_tier;
	private _count = count _infantry_preset;

	private _squad = [];
	for "_x" from 0 to _number step 1 do {
		//private _index = [_count] call get_distribution;
		private _class_name = (selectRandom _infantry_preset) select 0;
		_squad pushBack (_class_name); 
	};

	_squad; 
};

get_distribution = {
	params ["_number"];
	private _new_number = (_number * 2) - 1;
	private _n = floor random [0, 0, _new_number];
	if (_n > (_number - 1)) exitWith { _n - (_number - 1) };
	_n;
};

spawn_infantry = {
	params ["_pos", "_side", "_number", "_dynamicSimulation"];

	private _squad = [_side, _number] call pick_soldiers;
	private _group = [_pos, _side, _squad] call BIS_fnc_spawnGroup;
    _group enableDynamicSimulation _dynamicSimulation;
	
	_group;
};