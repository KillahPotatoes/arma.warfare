spawn_infantry = {
	params ["_pos", "_side", "_number", "_dynamicSimulation"];
	private _group = [_pos, _side, _number] call BIS_fnc_spawnGroup;
    _group enableDynamicSimulation _dynamicSimulation;
	
	_group;
};