[] call compileFinal preprocessFileLineNumbers "shared\common\string.sqf";

ARWA_any_units_too_close = {
	params ["_pos"];

	count (nearestObjects[_pos, ["Tank", "Car", "Air", "Man"], 10]) > 0;
};

ARWA_anything_too_close = {
	params ["_pos"];

	count (nearestObjects[_pos, ["Tank", "Car", "Air", "Man", "static", "StaticWeapon"], 10]) > 0;
};

ARWA_not_in_vehicle = {
	params ["_unit"];
	_unit isEqualTo (vehicle _unit);
};

ARWA_percent_chance = {
	params ["_chance"];

	[true, false] selectRandomWeighted [_chance, 100 - _chance];
};

ARWA_add_action_text = {
  params ["_text", "_level"];

  private _indentation = "";

  for "_x" from 1 to _level step 1 do {
		_indentation = format["%1%2",_indentation, " "];
	};

  format["<t color='#00FF00'>%1%2</t>", _indentation, _text];
};

ARWA_closest_hq = {
	params ["_sides", "_pos"];

	private _closest_hq = _sides select 0;
	private _shortest_distance = 99999;

	{
		private _side = _x;
		private _hq_pos = [_side] call ARWA_get_hq_pos;
		private _distance = _pos distance2D _hq_pos;

		if (_shortest_distance > _distance) then {
			_shortest_distance = _distance;
			_closest_hq = _side;
		};

	} forEach _sides;

	_closest_hq;
};

ARWA_closest_hq_distance = {
	params ["_sides", "_pos"];

	private _closest_hq = _sides select 0;
	private _shortest_distance = 99999;

	{
		private _side = _x;
		private _hq_pos = [_side] call ARWA_get_hq_pos;
		private _distance = _pos distance2D _hq_pos;

		if (_shortest_distance > _distance) then {
			_shortest_distance = _distance;
		};

	} forEach _sides;

	_shortest_distance;
};

ARWA_spawn_vehicle = {
  params ["_pos", "_dir", "_class_name", "_side", ["_kill_bonus", 0]];
   private _veh_arr = [_pos, _dir, _class_name, _side] call BIS_fnc_spawnVehicle;
   private _veh = _veh_arr select 0;
   _veh setVariable [ARWA_KEY_owned_by, _side, true];
   _veh setVariable [ARWA_kill_bonus, _kill_bonus, true];

   _veh_arr;
};

ARWA_delete_vehicle = {
	params ["_veh", "_side"];

	[_veh] call ARWA_throw_out_players;

	private _manpower = (_veh call ARWA_get_manpower) + (_veh call ARWA_remove_soldiers);
	_veh setVariable [ARWA_KEY_manpower, 0];

	private _owner = _veh getVariable ARWA_KEY_owned_by;

	private _kill_bonus = if(!isNil "_owner" && {!(_owner isEqualTo _side)}) then { _veh getVariable [ARWA_kill_bonus, 0]; } else { 0; };
	private _adjusted_salvage_bonus = if(ARWA_vehicleKillBonus == 1) then { _kill_bonus; } else { _kill_bonus * 2; };
	private _total_manpower_points = _adjusted_salvage_bonus + _manpower;

	if(_total_manpower_points > 0 ) then {
		[_side, _total_manpower_points] remoteExec ["ARWA_increase_manpower_server", 2];
		
		if(_manpower > 0) then {
			systemChat format[localize "ARWA_STR_YOU_ADDED_MANPOWER", _manpower];
		};

		if(_adjusted_salvage_bonus > 0) then {
			systemChat format[localize "ARWA_STR_YOU_ADDED_SALVAGE_MANPOWER", _adjusted_salvage_bonus];
		};
	};


	deleteVehicle _veh;
};

ARWA_throw_out_players = {
	params ["_veh"];
	{
		if(isPlayer _x) then {
			moveOut _x;
		};
	} forEach crew _veh;
};

ARWA_get_owned_sectors = {
	params ["_side"];
	ARWA_sectors select { (_x getVariable ARWA_KEY_owned_by) isEqualTo _side; };
};

ARWA_get_manpower = {
    params ["_obj"];

    floor(_obj getVariable [ARWA_KEY_manpower, 0]);
};

ARWA_debugger = {
	params ["_msg", ["_override", false]];
	diag_log _msg;
	if(ARWA_enable_debugger || _override) then {
		systemChat _msg;
	};
};

ARWA_is_type_of = {
	params ["_class_name","_type"];

	private _class_names = [_type] call ARWA_get_all_units;
	_class_name in _class_names;
};

ARWA_get_all_units = {
	params ["_type"];

	private _options = [];
	{
		private _side = _x;
		_options append ([_side, _type] call ARWA_get_all_units_side);
	} forEach ARWA_all_sides;

	_options;
};

ARWA_get_all_units_side = {
	params ["_side", "_type"];

	private _options = [];

	for "_x" from 0 to ARWA_max_tier step 1 do {
		_options append (missionNamespace getVariable [format["ARWA_%1_%2_tier_%3", _side, _type, _x], []]);
	};

	private _class_names = [];

	{
		_class_names append [_x select 0];
	} forEach _options;

	_class_names;
};

ARWA_get_units_based_on_tier = {
	params ["_side", "_type"];

	private _options = [];
	private _tier = (_side call ARWA_get_tier);

	for "_x" from 0 to _tier step 1 do {
		_options append (missionNamespace getVariable [format["ARWA_%1_%2_tier_%3", _side, _type, _x], []]);
	};

	_options;
};

ARWA_delete_all_waypoints = {
	params ["_group"];

	while {(count (waypoints _group)) > 0} do
	{
		deleteWaypoint [_group, 0];
	};
};

ARWA_remove_nvg_and_add_flash_light = {
	params ["_group"];

	{
		[_x] call ARWA_remove_nvg_and_add_flash_light_unit;
	} forEach units _group;
};


ARWA_remove_nvg_and_add_flash_light_unit = {
    params ["_unit"];

    private _side = side _unit;

    private _nvgoogles = missionNamespace getVariable format["ARWA_nvgoogles_%1", _side];

    if(isNil "_nvgoogles") exitWith {};

  	_unit unassignItem _nvgoogles;
		_unit removeItem _nvgoogles;
		_unit addPrimaryWeaponItem "acc_flashlight";
		//_unit enableGunLights "forceon";
};

ARWA_get_direction = {
  params ["_pos1", "_pos2"];

  private _dir = _pos1 getDir _pos2;

  switch true do {
    case ([_dir, 0, 10] call ARWA_is_between): { "north"; };
    case ([_dir, 11, 80] call ARWA_is_between): { "north east"; };
    case ([_dir, 81, 100] call ARWA_is_between): { "east"; };
    case ([_dir, 101, 170] call ARWA_is_between): { "south east"; };
    case ([_dir, 171, 190] call ARWA_is_between): { "south"; };
    case ([_dir, 191, 260] call ARWA_is_between): { "south west"; };
    case ([_dir, 261, 280] call ARWA_is_between): { "west"; };
    case ([_dir, 281, 350] call ARWA_is_between): { "north west"; };
    case ([_dir, 351, 360] call ARWA_is_between): { "north"; };
  };
};

ARWA_is_between = {
  params ["_val", "_start", "_end"];

  _val >= _start && _val <= _end;
};

ARWA_report_time = {
    params ["_time", "_message"];
    format["Time: %1: %2", diag_tickTime - _time, _message] spawn ARWA_debugger;
};

ARWA_get_vehicle_display_name = {
    params ["_class_name"];

    private _cfg  = (configFile >>  "CfgVehicles" >>  _class_name);

    private _name = if (isText(_cfg >> "displayName")) exitWith {
        getText(_cfg >> "displayName")
    };

	_class_name;
};

ARWA_adjust_skill = {
	params ["_skill", "_squad"];

	{
		_x setSkill _skill;
	} forEach (units _squad);
};
