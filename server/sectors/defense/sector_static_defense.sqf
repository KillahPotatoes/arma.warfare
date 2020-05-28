ARWA_spawn_static_sector_defense = {
	params ["_sector"];

	private _spawn_positions = _sector getVariable [ARWA_KEY_static_spawn_positions, []];

	if(_spawn_positions isEqualTo []) exitWith {};

	private _initial_owner = _sector getVariable ARWA_KEY_owned_by;

	sleep 300;
	private _current_owner = _sector getVariable ARWA_KEY_owned_by;

	while {_initial_owner isEqualTo _current_owner} do {
		[_sector, _current_owner, _spawn_positions] call ARWA_spawn_static;
		sleep 1800;
		private _current_owner = _sector getVariable ARWA_KEY_owned_by;
	};
};

ARWA_spawn_static = {
	params ["_sector", "_side", "_spawn_positions"];

	private _sector_name = _sector getVariable ARWA_KEY_target_name;

	format["Spawning artillery in %1", _sector_name] spawn ARWA_debugger;

	if(!(_side call ARWA_has_manpower)) exitWith {
		format["Cannot spawn artillery in %1: No manpower", _sector_name] spawn ARWA_debugger;
	};

	private _pos = getPos _sector;
	private _enemies_nearby = [_pos, _side, ARWA_sector_size] call ARWA_any_enemies_in_area;

	if(_enemies_nearby) exitWith {
		format["Cannot spawn artillery in %1: Enemies nearby", _sector_name] spawn ARWA_debugger;
	};

	private _available_art = [_side, ARWA_KEY_static_artillery] call ARWA_get_units_based_on_tier;
	if(_available_art isEqualTo []) exitWith {};

	private _clear_spawn_positions = _spawn_positions select { !([getPos _x] call ARWA_anything_too_close); };

	if(_clear_spawn_positions isEqualTo []) exitWith {
		format["Cannot spawn artillery in %1: No available positions", _sector_name] spawn ARWA_debugger;
	};

	private _spawn_position = selectRandom _clear_spawn_positions;

	private _pos = getPos _spawn_position;
	private _dir = getDir _spawn_position;

	private _static_artillery = selectRandom (_available_art);
	private _type = _static_artillery select 0;
	private _kill_bonus = _static_artillery select 1;

	private _static = [_pos, _dir, _type, _side, _kill_bonus] call ARWA_spawn_vehicle;
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

	private _veh_name = _type call ARWA_get_vehicle_display_name;

	format["Spawned %1 at %2", _veh_name, _sector_name] spawn ARWA_debugger;

	[_veh] spawn ARWA_add_rearm_delay_event;
	[_static, _sector] spawn ARWA_remove_static;
};

ARWA_add_rearm_delay_event = {
	params ["_veh"];

	_veh setVariable[ARWA_KEY_fired_barrage, false];
	_veh addeventhandler ["fired", {
		private _veh = _this select 0;
		[_veh] spawn ARWA_rearm_delay;
	}];
};

ARWA_rearm_delay = {
	params ["_veh"];

	private _fired_barrage = _veh getVariable [ARWA_KEY_fired_barrage, false];
	if(!_fired_barrage) then {
		format["%1 fired barrage", _this select 0] spawn ARWA_debugger;
		_veh setVariable[ARWA_KEY_fired_barrage, true];
		sleep ARWA_sector_artillery_reload_time;
		(_this select 0) setVehicleAmmo 1;
		format["%1 reloaded", _this select 0] spawn ARWA_debugger;

		_veh setVariable[ARWA_KEY_fired_barrage, false];
	};
};

ARWA_remove_static = {
	params ["_static", "_sector"];

	private _sector_side = _sector getVariable ARWA_KEY_owned_by;
	private _group = _static select 2;
	private _veh = _static select 0;
	private _static_side = side _group;

	while {_sector_side isEqualTo _static_side} do {
		sleep 30;
		_sector_side = _sector getVariable ARWA_KEY_owned_by;
	};

	if(!isNil "_veh") then {
		_veh setDamage 1
	};
};



