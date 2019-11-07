ARWA_choose_preset = {
	private _east_preset = ["EastPreset", 0] call BIS_fnc_getParamValue;
	private _west_preset = ["WestPreset", 0] call BIS_fnc_getParamValue;
	private _guer_preset = ["GuerPreset", 0] call BIS_fnc_getParamValue;

	private _civilian_preset = ["CivilianPreset", 0] call BIS_fnc_getParamValue;
	private _sympathizers_preset = ["SympathizersPreset", 0] call BIS_fnc_getParamValue;

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

ARWA_pick_east_preset = {
	params ["_preset"];

	if(_preset == 0) exitWith {
		[] call compileFinal preprocessFileLineNumbers "east_presets\rhs_woodland_preset.sqf";
	};
};
ARWA_pick_west_preset = {
	params ["_preset"];

	if(_preset == 0) exitWith {
		[] call compileFinal preprocessFileLineNumbers "west_presets\rhs_woodland_preset.sqf";
	};

};
ARWA_pick_guer_preset = {
	params ["_preset"];

	if(_preset == 0) exitWith {
		[] call compileFinal preprocessFileLineNumbers "west_presets\rhs_woodland_preset.sqf";
	};
};

ARWA_pick_civil_preset = {
	params ["_preset"];

};
ARWA_pick_sympathizers_preset = {
	params ["_preset"];

};


[] call ARWA_choose_preset;
