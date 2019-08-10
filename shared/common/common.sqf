[] call compileFinal preprocessFileLineNumbers "shared\common\string.sqf";

ARWA_any_units_too_close = {
	params ["_pos"];

	count (nearestObjects[_pos, ["Tank", "Car", "Air", "Man"], 10]) > 0;
};

ARWA_not_in_vehicle = {
	params ["_unit"];
	_unit isEqualTo (vehicle _unit);
};

ARWA_add_action_text = {
  params ["_text", "_level"];

  private _indentation = "";

  for "_x" from 1 to _level step 1 do {
		_indentation = format["%1%2",_indentation, " "];
	};

  format["<t color='#00FF00'>%1%2</t>", _indentation, _text];
};

ARWA_is_in_controlled_area = {
    params ["_pos"];

		private _owned_sectors = [] call ARWA_get_all_owned_sectors;

    if(_owned_sectors isEqualTo []) exitWith { systemChat "No owned sectors, so no controlled area"; };
    private _closest_sector = [ARWA_sectors, _pos] call ARWA_find_closest_sector;

    private _closest_owned_sector = [_owned_sectors, _pos] call ARWA_find_closest_sector;
    private _owner = _closest_owned_sector getVariable ARWA_KEY_owned_by;

    if(_closest_sector isEqualTo _closest_owned_sector) exitWith { systemChat format["Closest sector is owned so area is controlled by %1", owner]; _owner; };

    private _other_sectors = _owner call ARWA_get_other_sectors;

    if(_other_sectors isEqualTo []) exitWith { systemChat format["Whole map is controlled by %1", owner]; _owner; };

    private _respawn_marker = [_owner, ARWA_KEY_respawn_ground] call ARWA_get_prefixed_name;
	  private _pos_hq = getMarkerPos _respawn_marker;

    private _closest_other_sector = [_other_sectors, _pos_hq] call ARWA_find_closest_sector;

    private _pos_other_sector = _closest_other_sector getVariable ARWA_KEY_pos;
    private _pos_owned_sector = _closest_owned_sector getVariable ARWA_KEY_pos;

    private _distance_to_hq = _pos distance2D _pos_hq;
    private _distance_to_hq_from_owned_sector = _pos_owned_sector distance2D _pos_hq;
    private _distance_to_hq_from_other_sector = _pos_other_sector distance2D _pos_hq;

    private _behind_enemy_lines = _distance_to_hq <= _distance_to_hq_from_owned_sector && _distance_to_hq_from_owned_sector <= _distance_to_hq_from_other_sector;
    systemChat format["Distance to %1 HQ: %2", owner, _distance_to_hq];
    systemChat format["Distance to HQ from owned sector: %1", _distance_to_hq_from_owned_sector];
    systemChat format["Distance to HQ from other sector: %1", _distance_to_hq_from_other_sector];

    if(_behind_enemy_lines) exitWith { systemChat format["Area controlled by: %1", _owner]; _owner; };

    systemChat "Area controlled by no one";
};

ARWA_spawn_vehicle = {
  params ["_pos", "_dir", "_class_name", "_side", ["_kill_bonus", 0]]; // TODO add key
   private _veh_arr = [_pos, _dir, _class_name, _side] call BIS_fnc_spawnVehicle;
   private _veh = _veh_arr select 0;
   _veh setVariable [ARWA_KEY_owned_by, _side, true];
   _veh setVariable [ARWA_kill_bonus, _kill_bonus, true];

   _veh_arr;
};

ARWA_get_manpower = {
    params ["_obj"];

    floor(_obj getVariable [ARWA_KEY_manpower, 0]);
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

ARWA_calc_number_of_soldiers = {
	params ["_soldier_cap"];
	floor random [_soldier_cap / 2, _soldier_cap / 1.5, _soldier_cap];
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
    diag_log format["Time: %1: %2", diag_tickTime - _time, _message];
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
