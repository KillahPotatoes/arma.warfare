ARWA_choose_preset = {
	private _preset = ["Preset", 0] call BIS_fnc_getParamValue;

	if(_preset == 0) exitWith {
		[] call compileFinal preprocessFileLineNumbers "presets\vanilla_preset.sqf";
	};

	if(_preset == 1) exitWith {
		[] call compileFinal preprocessFileLineNumbers "presets\tanoa_preset.sqf";
	};

	if(_preset == 2) exitWith {
		[] call compileFinal preprocessFileLineNumbers "presets\rhs_preset.sqf";
	};
};

[] call ARWA_choose_preset;
