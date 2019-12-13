ARWA_spawn_static_sector_defense = {
	params ["_sector"];

	private _pos = getPos _sector;
	private _owner = _sector getVariable ARWA_KEY_owned_by;

	private _static_defense = [_pos, _owner] call ARWA_spawn_static;

	if(isNil "_static_defense") exitWith {};

	_sector setVariable [ARWA_KEY_static_defense, _static_defense];
	[_sector, _pos] spawn ARWA_reinforce_static_defense;
};

ARWA_spawn_static = {
	params ["_pos", "_side"];

	if(!(_side call ARWA_has_manpower)) exitWith {};

	private _available_art = [_side, ARWA_KEY_static_artillery] call ARWA_get_units_based_on_tier;
	if(_available_art isEqualTo []) exitWith {};

	private _static_pos = _pos;
	private _maxDist = 25;

	while{_static_pos isEqualTo _pos && _maxDist < ARWA_sector_size} do {
		private _new_pos = [_pos, 5, _maxDist, 10, 0, 0, 0, [], [_pos, _pos]] call BIS_fnc_findSafePos;
		_static_pos = if(isOnRoad _new_pos) then { _pos; } else { _new_pos; };
		_maxDist = _maxDist + 25;
	};

	if(_static_pos isEqualTo _pos) exitWith {};

	private _static_artillery = selectRandom (_available_art);
	private _type = _static_artillery select 0;
	private _kill_bonus = _static_artillery select 1;

	private _orientation = random 360;
	private _static = [_static_pos, _orientation, _type, _side, _kill_bonus] call ARWA_spawn_vehicle;
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
	params ["_static"];
	private _group = _static select 2;

	{
		_x setDamage 1;
	} forEach units _group;

	(_static select 0) setDamage 1
};

ARWA_reinforce_static_defense = {
	params ["_sector", "_pos"];

	private _static_defense = _sector getVariable ARWA_KEY_static_defense;
	private _initial_owner = side (_static_defense select 2);
	private _current_owner = _initial_owner;
	private _timer = time;
	private _reinforce = false;

	while {_current_owner isEqualTo _initial_owner} do {
		private _enemies_nearby = [_pos, _current_owner, ARWA_sector_size] call ARWA_any_enemies_in_area;

		if(!_enemies_nearby && {!([_static_defense] call ARWA_static_fully_alive)}) then {
			if(time > _timer) then {

				if(_reinforce) exitWith {
					format["Reinforcing static at sector %1 for %2", _sector getVariable ARWA_KEY_target_name, _initial_owner] spawn ARWA_debugger;
					[_static_defense] spawn ARWA_remove_static;
					private _new_static_defense = [_pos, _current_owner] call ARWA_spawn_static;

					if(isNil "_new_static_defense") exitWith {};

					_sector setVariable [ARWA_KEY_static_defense, _new_static_defense];

					_reinforce = false;
				};

				_timer = time + ARWA_static_defense_reinforcement_interval;
				_reinforce = true;
			};
		};

		sleep 10;
		_current_owner = _sector getVariable ARWA_KEY_owned_by;
	};

	[_static_defense] spawn ARWA_remove_static;

	format["Stopped reinforcing static at sector %1 for %2", _sector getVariable ARWA_KEY_target_name, _initial_owner] spawn ARWA_debugger;
};

ARWA_static_fully_alive = {
	params ["_static"];

	private _group = _static select 2;
	private _veh = _static select 0;

	(({alive _x} count units _group) > 0 && (damage _veh < 1));
};

