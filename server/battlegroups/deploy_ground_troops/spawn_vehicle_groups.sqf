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

	private _road = _pos nearRoads 50;
	_pos = [_pos, 10, 50, 15, 0, 0, 0] call BIS_fnc_findSafePos;

	if (!(_road isEqualTo [])) then {

		private _is_safe = false;
		private _attempt_counter = 0;
		while {!_is_safe && _attempt_counter < 10} do {
			_attempt_counter = _attempt_counter + 1;

			_road_pos = getPos (selectRandom _road);
			_is_safe = !([_road_pos] call ARWA_any_units_too_close) && count (_road_pos nearObjects 10) == 0;
			if (_is_safe) then {
				_pos = _road_pos;
			};
		};
	};

	_pos;
};

ARWA_find_direction_towards_closest_sector = {
	params ["_pos"];

	private _sector = [ARWA_sectors, _pos] call ARWA_find_closest_sector;
	private _sector_pos = _sector getVariable ARWA_KEY_pos;
	_pos getDir _sector_pos;
};

ARWA_spawn_vehicle_group = {
	params ["_pos", "_side", "_tier", "_can_spawn"];
	private _vehicle_type_arr = selectRandom (missionNamespace getVariable format["%1_vehicle_tier_%2", _side, _tier]);
	private _vehicle_type = _vehicle_type_arr select 0;
	private _kill_bonus = _vehicle_type_arr select 1;

	_pos = [_pos] call ARWA_try_find_unoccupied_nearby_road;

	private _dir = [_pos] call ARWA_find_direction_towards_closest_sector;
	private _veh_array = [_pos, _dir, _vehicle_type, _side, _kill_bonus] call ARWA_spawn_vehicle;
	private _group = _veh_array select 2;
	private _veh =  _veh_array select 0;

	_group deleteGroupWhenEmpty true;

	_can_spawn = _can_spawn - (count units _group);

	private _veh_name = _vehicle_type call ARWA_get_vehicle_display_name;

	diag_log format ["%1: Spawn vehicle: %2", _side, _veh_name];
	diag_log format["%1 manpower: %2", _side, [_side] call ARWA_get_strength];

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
		private _can_spawn = ARWA_unit_cap - _unit_count;
	};

	diag_log format["%1: Spawned %2 tier %3 vehicles", _side, count _groups, _tier];

	_groups;
};

ARWA_spawn_reinforcement_vehicle_group = {
	params ["_side", "_can_spawn", "_sector"];

	private _groups = [_side, _can_spawn] call ARWA_spawn_random_vehicle_group;
	{ _x setVariable [ARWA_KEY_priority_target, _sector]; } count _groups;
};
