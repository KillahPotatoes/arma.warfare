ARWA_choose_preset = {
	private _army_preset = ["ArmyPreset", 0] call BIS_fnc_getParamValue;
	private _civilian_preset = ["CivilianPreset", 0] call BIS_fnc_getParamValue;

	[_army_preset] call ARWA_pick_army_preset;
	[_civilian_preset] call ARWA_pick_civilian_preset;
};

ARWA_pick_army_preset = {
	params ["_preset"];

	if(_preset == 0) exitWith {
		[] call compileFinal preprocessFileLineNumbers "presets\altis_preset.sqf";
	};

	if(_preset == 1) exitWith {
		[] call compileFinal preprocessFileLineNumbers "presets\apex_preset.sqf";
	};

	if(_preset == 2) exitWith {
		[] call compileFinal preprocessFileLineNumbers "presets\contact_preset.sqf";
	};


	if(_preset == 3) exitWith {
		[] call compileFinal preprocessFileLineNumbers "presets\rhs_woodland_preset.sqf";
	};
};


ARWA_pick_civilian_preset = {
	params ["_preset"];

};


[] call ARWA_choose_preset;
