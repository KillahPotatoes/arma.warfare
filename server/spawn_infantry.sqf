pick_soldiers = {
	params ["_side", "_number"];

	private _infantry_preset = [_side, infantry] call get_units_based_on_tier;
	private _count = count _infantry_preset;

	private _squad = [];
	for "_x" from 1 to _number step 1 do {
		//private _index = [_count] call get_distribution;
		private _class_name = (selectRandom _infantry_preset) select 0;
		_squad pushBack (_class_name); 
	};

	_squad; 
};

spawn_infantry = {
	params ["_pos", "_side", "_number", "_dynamicSimulation"];

	private _squad = [_side, _number] call pick_soldiers;
	private _group = [_pos, _side, _squad] call BIS_fnc_spawnGroup;
    _group enableDynamicSimulation _dynamicSimulation;
	_group deleteGroupWhenEmpty true;
	
	_group;
};