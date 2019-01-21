create_squad = {
	params ["_preset", "_number"];

	private _count = count _preset;

	private _squad = [];
	for "_x" from 1 to _number step 1 do {
		//private _index = [_count] call get_distribution;
		private _class_name = (selectRandom _preset) select 0;
		_squad pushBack (_class_name); 
	};

	_squad; 
};

pick_soldiers = {
	params ["_side", "_number"];

	private _preset = [_side, infantry] call get_units_based_on_tier;
	[_preset, _number] call create_squad;
};

pick_sympathizers = {
	params ["_side", "_number"];

	private _preset = missionNamespace getVariable format["%1_sympathizers", _side];
	[_preset, _number] call create_squad;
};

create_group = {
	params ["_pos", "_side", "_squad", "_dynamicSimulation"];

	private _group = [_pos, _side, _squad] call BIS_fnc_spawnGroup;
    _group enableDynamicSimulation _dynamicSimulation;
	_group deleteGroupWhenEmpty true;
	
	_group;
};

spawn_infantry = {
	params ["_pos", "_side", "_number", "_dynamicSimulation"];

	private _squad = [_side, _number] call pick_soldiers;
	[_pos, _side, _squad, _dynamicSimulation] call create_group;
};

spawn_sympathizers = {
	params ["_pos", "_side", "_number"];

	private _squad = [_side, _number] call pick_sympathizers;
	[_pos, _side, _squad, true] call create_group;
};