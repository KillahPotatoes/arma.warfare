ARWA_spawn_static = {
	params ["_pos", "_side"];

	private _orientation = random 360;

	private _available_art = [_side, ARWA_KEY_static_artillery] call ARWA_get_units_based_on_tier;

	if(_available_art isEqualTo []) exitWith {};

	private _type = selectRandom (_available_art);
	private _static_pos = _pos;
	private _maxDist = 25;

	while{_static_pos isEqualTo _pos && _maxDist < ARWA_sector_size} do {
		_static_pos = [_pos, 5, _maxDist, 10, 0, 0, 0, [], [_pos, _pos]] call BIS_fnc_findSafePos;
		_maxDist = _maxDist + 25;
	};

	if(!(_static_pos isEqualTo _pos)) exitWith {
		private _static = [_static_pos, _orientation, _type, _side] call ARWA_spawn_vehicle;
		private _group = _static select 2;
		_group deleteGroupWhenEmpty true;
		_group enableDynamicSimulation false;
		_group setVariable [ARWA_KEY_defense, true];
		[_group] call ARWA_remove_nvg_and_add_flash_light;

		{
			_x disableAI "TARGET";
			_x disableAI "AUTOTARGET";
			_x disableAI "MOVE";
			_x disableAI "AIMINGERROR";
			_x disableAI "SUPPRESSION";
			_x disableAI "CHECKVISIBLE";
			_x disableAI "COVER";
			_x disableAI "AUTOCOMBAT";
			_x disableAI "PATH";
			_x disableAI "MINEDETECTION";
		} forEach units _group;

		private _veh = _static select 0;
		[_veh] spawn ARWA_add_rearm_delay_event;

		_static;
	};
};

ARWA_add_rearm_delay_event = {
	params ["_veh"];

	_veh setVariable["fired_barrage", false];
	_veh addeventhandler ["fired", {
		private _veh = _this select 0;
		[_veh] spawn ARWA_rearm_delay;
	}];
};

ARWA_rearm_delay = {
	params ["_veh"];

	private _fired_barrage = _veh getVariable ["fired_barrage", false];
	if(!_fired_barrage) then {
		diag_log format["%1 fired barrage", _this select 0];
		_veh setVariable["fired_barrage", true];
		sleep ARWA_sector_artillery_reload_time;
		(_this select 0) setvehicleammo 1;
		diag_log format["%1 reloaded", _this select 0];

		_veh setVariable["fired_barrage", false];
	};
};

ARWA_remove_static = {
	params ["_static"];
	private _group = _static select 2;

	{
		_x setDamage 1;
	} forEach units _group;

	deleteVehicle (_static select 0);
};

ARWA_static_alive = {
	params ["_static"];

	private _group = _static select 2;
	private _veh = _static select 0;

	(({alive _x} count units _group) > 0 && (damage _veh < 1));
};
