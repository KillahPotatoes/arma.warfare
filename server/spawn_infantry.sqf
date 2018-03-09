pick_soldiers = {
	params ["_side", "_number"];

	private _infantry_preset = missionNamespace getVariable format["%1_infantry", _side];
	private _squad_preset = selectRandom _infantry_preset;

	private _squad = [];
	for "_x" from 0 to _number step 1 do {
		_squad pushBack (selectRandom _squad_preset); 
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