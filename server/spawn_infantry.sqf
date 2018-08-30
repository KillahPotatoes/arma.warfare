pick_soldiers = {
	params ["_side", "_number"];

	private _infantry_preset = missionNamespace getVariable format["%1_infantry", _side];
	private _count = count _infantry_preset;

	private _squad = [];
	for "_x" from 0 to _number step 1 do {
		private _index = floor random [0, 0, _count]; // CHECK
		_squad pushBack (_infantry_preset select _index); 
	};

	_squad; 
};

spawn_infantry = {
	params ["_pos", "_side", "_number", "_dynamicSimulation"];

	private _squad = [_side, _number] call pick_soldiers;
	private _group = [_pos, _side, _squad] call BIS_fnc_spawnGroup;
    _group enableDynamicSimulation _dynamicSimulation;
	
	_group;
};