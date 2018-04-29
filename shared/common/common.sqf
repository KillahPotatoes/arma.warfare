[] call compileFinal preprocessFileLineNumbers "shared\common\string.sqf";

check_if_any_units_to_close = {
	params ["_pos"];

	count (nearestObjects[_pos, ["Tank", "Car", "Air", "Man"], 10]) == 0;
};

check_if_player_already_in_hq = {
  params ["_player"];

  private _pos = getMarkerPos ([side _player, respawn_ground] call get_prefixed_name);
  (getPos _player) distance _pos > 25; 
};

calc_number_of_soldiers = {
	params ["_soldier_cap"];
	floor random [_soldier_cap / 2, _soldier_cap / 1.5, _soldier_cap];
};

get_direction = {
  params ["_pos1", "_pos2"];

  private _dir = _pos1 getDir _pos2;

  switch true do {
    case ([_dir, 0, 10] call is_between): { "north"; };
    case ([_dir, 11, 80] call is_between): { "north east"; };
    case ([_dir, 81, 100] call is_between): { "east"; };
    case ([_dir, 101, 170] call is_between): { "south east"; };
    case ([_dir, 171, 190] call is_between): { "south"; };
    case ([_dir, 191, 260] call is_between): { "south west"; };
    case ([_dir, 261, 280] call is_between): { "west"; };
    case ([_dir, 281, 350] call is_between): { "north west"; };
    case ([_dir, 351, 360] call is_between): { "north"; };       
  };
};

is_between = {
  params ["_val", "_start", "_end"];

  _val >= _start && _val <= _end;
};

report_time = {
    params ["_time", "_message"];
    diag_log format["Time: %1: %2", diag_tickTime - _time, _message];
};



get_vehicle_display_name = {
    params ["_class_name"];

    private _cfg  = (configFile >>  "CfgVehicles" >>  _class_name);
	
    private _name = if (isText(_cfg >> "displayName")) exitWith {
        getText(_cfg >> "displayName")
    };
    
	_class_name;
};


