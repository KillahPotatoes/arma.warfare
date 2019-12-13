ARWA_add_soldiers_to_cargo = {
	params ["_veh_array", "_can_spawn"];

	_vehicle = _veh_array select 0;
	_crew_count = count (_veh_array select 1);
	_group = _veh_array select 2;
	_side = side _group;

	_cargoCapacity = (_vehicle emptyPositions "cargo") - _crew_count;
	_cargo = _cargoCapacity min _can_spawn;

	if(_cargo > 0) then {

		_soldiers = [[0,0,0], _side, _cargo, false] call ARWA_spawn_infantry;

		{
			_x moveInCargo _vehicle;
			[_x] joinSilent _group;

		} forEach units _soldiers;

		deleteGroup _soldiers;
	};
};

ARWA_try_find_unoccupied_nearby_road = {
	params ["_pos"];

	private _roads = _pos nearRoads 50;

	if (_roads isEqualTo []) exitWith {};

	private _road = nil;

	private _attempt_counter = 0;
	while {_attempt_counter < 10} do {
		_attempt_counter = _attempt_counter + 1;

		private _temp_road = selectRandom _roads;
		private _road_pos = getPos _temp_road;
		private _is_safe = !([_road_pos] call ARWA_any_units_too_close) && count (_road_pos nearObjects 10) == 0;

		if (_is_safe) exitWith {
			_road = _temp_road;
		};
	};

	if (isNil "_road") exitWith {};
	_road;
};

ARWA_find_right_road_dir = {
	params ["_road", "_dir"];

	private _roadConnectedTo = roadsConnectedTo _road;

	if(_roadConnectedTo isEqualTo []) exitWith {
		_dir;
	};

	private _roadConnectedTo_dir = _roadConnectedTo apply { [_road, _x] call BIS_fnc_DirTo; };
	[_dir, _roadConnectedTo_dir] call ARWA_find_right_dir;
};

ARWA_find_right_dir = {
	params ["_dir", "_dir_array"];
	private _normalized_dir =  if(_dir > 180) then { _dir - 360; } else { _dir; };
	private _current_dir = _dir_array select 0;

	{
		private _temp_dir = if(_x > 180) then { _x - 360; } else { _x; };
		private _new_dir_diff = abs (_normalized_dir - _temp_dir);
		private _current_dir_diff = abs (_normalized_dir - _current_dir);

		if (_current_dir_diff > _new_dir_diff) then {
			_current_dir = _temp_dir;
		};

	} forEach _dir_array;

	_current_dir;
};

ARWA_find_direction_towards_closest_sector = {
	params ["_pos"];

	private _sector = [ARWA_sectors, _pos] call ARWA_find_closest_sector;
	private _sector_pos = getPos _sector;
	_pos getDir _sector_pos;
};

ARWA_spawn_vehicle_group = {
	params ["_pos", "_side", "_tier", "_can_spawn"];
	private _vehicle_type_arr = selectRandom (missionNamespace getVariable format["ARWA_%1_vehicle_tier_%2", _side, _tier]);
	private _vehicle_type = _vehicle_type_arr select 0;
	private _kill_bonus = _vehicle_type_arr select 1;

	private _road = [_pos] call ARWA_try_find_unoccupied_nearby_road;

	private _dir = [_pos] call ARWA_find_direction_towards_closest_sector;
	if(isNil "_road") then {
		_pos = [_pos, 10, 50, 15, 0, 0, 0] call BIS_fnc_findSafePos;
	} else {
		_dir = [_road, _dir] call ARWA_find_right_road_dir;
		_pos = getPos _road;
	};

	private _veh_array = [_pos, _dir, _vehicle_type, _side, _kill_bonus] call ARWA_spawn_vehicle;
	private _group = _veh_array select 2;
	private _veh =  _veh_array select 0;

	_group deleteGroupWhenEmpty true;

	_can_spawn = _can_spawn - (count units _group);

	private _veh_name = _vehicle_type call ARWA_get_vehicle_display_name;

	format ["%1: Spawn vehicle: %2", _side, _veh_name] spawn ARWA_debugger;
	format["%1 manpower: %2", _side, [_side] call ARWA_get_strength] spawn ARWA_debugger;

	if(_can_spawn > 0) then {
    	[_veh_array, _can_spawn] call ARWA_add_soldiers_to_cargo;
	};

	_group;
};

ARWA_spawn_random_vehicle_group = {
	params ["_side", "_can_spawn"];

	private _pos = getMarkerPos ([_side, ARWA_KEY_respawn_ground] call ARWA_get_prefixed_name);
	private _tier =  floor(random (([_side] call ARWA_get_tier) + 1));
	private _vehicle_max_count = floor(random 2) + 1;
	private _groups = [];

	while{(count _groups) <= _vehicle_max_count && _can_spawn > (ARWA_squad_cap / 2)} do {
		private _group = [_pos, _side, _tier, _can_spawn] call ARWA_spawn_vehicle_group;

		_groups append [_group];
		[_group] call ARWA_add_battle_group;

		private _unit_count = _side call ARWA_count_battlegroup_units;
		private _can_spawn = floor (([] call ARWA_get_unit_cap) * (2/3)) - _unit_count;
	};

	format["%1: Spawned %2 tier %3 vehicles", _side, count _groups, _tier] spawn ARWA_debugger;

	_groups;
};

ARWA_spawn_reinforcement_vehicle_group = {
	params ["_side", "_can_spawn", "_target"];

	private _groups = [_side, _can_spawn] call ARWA_spawn_random_vehicle_group;
	{ _x setVariable [ARWA_KEY_priority_target, _target]; } count _groups;
};
