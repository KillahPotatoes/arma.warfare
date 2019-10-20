ARWA_create_squad = {
	params ["_preset", "_number"];

	private _squad = [];
	for "_x" from 1 to _number step 1 do {
		private _class_name = (selectRandom _preset) select 0;
		_squad pushBack (_class_name);
	};

	_squad;
};

ARWA_pick_soldiers = {
	params ["_side", "_number"];

	private _preset = [_side, ARWA_KEY_infantry] call ARWA_get_units_based_on_tier;
	[_preset, _number] call ARWA_create_squad;
};

ARWA_pick_sympathizers = {
	params ["_side", "_number"];

	private _preset = missionNamespace getVariable format["ARWA_%1_sympathizers", _side];
	[_preset, _number] call ARWA_create_squad;
};

ARWA_create_group = {
	params ["_pos", "_side", "_squad", "_dynamicSimulation"];

	private _group = [_pos, _side, _squad] call BIS_fnc_spawnGroup;
    _group enableDynamicSimulation _dynamicSimulation;
	_group deleteGroupWhenEmpty true;

	_group;
};

ARWA_spawn_infantry = {
	params ["_pos", "_side", "_number", "_dynamicSimulation"];

	private _squad = [_side, _number] call ARWA_pick_soldiers;
	[_pos, _side, _squad, _dynamicSimulation] call ARWA_create_group;
};

ARWA_spawn_sympathizers = {
	params ["_pos", "_side", "_number", "_commander"];

	private _squad = [_side, _number] call ARWA_pick_sympathizers;
	private _group = [_pos, _side, _squad, true] call ARWA_create_group;

	{ 
		_x setVariable [ARWA_KEY_sympathizers, true, true];
	} forEach units _group;

	if(_commander) then {
		private _commander = selectRandom units _group;
		private _commander_manpower = floor random[ARWA_min_commander_manpower, ARWA_min_commander_manpower, ARWA_max_commander_manpower];

		diag_log format["Spawn %1 sympathizer commander with %2 manpower", _side, _commander_manpower];
 		_commander setVariable [ARWA_KEY_manpower, _commander_manpower, true];
		_commander addHeadgear "H_Beret_Colonel";
	};

	_group;
};

ARWA_spawn_civilians = {
	params ["_pos", "_number"];

	private _squad = [ARWA_civilians, _number] call ARWA_create_squad;
	[_pos, civilian, _squad, true] call ARWA_create_group;
};