add_soldiers_to_cargo = {
	params ["_veh_array", "_can_spawn"];

	_vehicle = _veh_array select 0;
	_crew_count = count (_veh_array select 1);
	_group = _veh_array select 2;
	_side = side _group;

	_cargoCapacity = (_vehicle emptyPositions "cargo") - _crew_count;
	_cargo = _cargoCapacity min _can_spawn;

	if(_cargo > 0) then {

		_soldiers = [[0,0,0], _side, _cargo, false] call spawn_infantry;	

		{
			_x moveInCargo _vehicle;
			[_x] joinSilent _group;
			
		} forEach units _soldiers;

		deleteGroup _soldiers;
	};
};

try_find_unoccupied_nearby_road = {
	params ["_pos"];

	private _road = _pos nearRoads 25;
	_pos = [_pos, 10, 50, 15, 0, 0, 0] call BIS_fnc_findSafePos;

	if (!(_road isEqualTo [])) then {

		private _is_safe = false;
		private _attempt_counter = 0;
		while {!_is_safe && _attempt_counter < 10} do {
			_attempt_counter = _attempt_counter + 1;
			
			_road_pos = getPos (selectRandom _road);
			_is_safe = !([_road_pos] call any_units_too_close);
			if (_is_safe) then {
				_pos = _road_pos;
			};
		};
	};

	_pos;
};

find_direction_towards_closest_sector = {
	params ["_pos"];
	
	private _sector = [sectors, _pos] call find_closest_sector;
	private _sector_pos = _sector getVariable pos;
	_pos getDir _sector_pos;
};

spawn_vehicle_group = {
	params ["_pos", "_side", "_tier", "_can_spawn"];
	private _vehicle_type_arr = selectRandom (missionNamespace getVariable format["%1_vehicle_tier_%2", _side, _tier]);
	private _vehicle_type = _vehicle_type_arr select 0;
	private _kill_bonus = _vehicle_type_arr select 1;

	_pos = [_pos] call try_find_unoccupied_nearby_road;

	private _dir = [_pos] call find_direction_towards_closest_sector;
	private _veh_array = [_pos, _dir, _vehicle_type, _side] call BIS_fnc_spawnVehicle;
	private _group = _veh_array select 2;
	private _veh =  _veh_array select 0;

	_veh setVariable [arwa_kill_bonus, _kill_bonus, true];	

	_group deleteGroupWhenEmpty true;

	_can_spawn = _can_spawn - (count units _group); 

	private _veh_name = _vehicle_type call get_vehicle_display_name;

	diag_log format ["%1: Spawn vehicle: %2", _side, _veh_name];
	diag_log format["%1 manpower: %2", _side, [_side] call get_strength];

	if(_can_spawn > 0) then {
    	[_veh_array, _can_spawn] call add_soldiers_to_cargo;		
	};
	
	_group;
};

spawn_random_vehicle_group = {
	params ["_side", "_can_spawn"];	
		
	private _pos = getMarkerPos ([_side, respawn_ground] call get_prefixed_name);
	private _tier =  floor(random (([_side] call get_tier) + 1));
	private _vehicle_max_count = floor(random 2) + 1;
	private _groups = [];

	while{(count _groups) <= _vehicle_max_count && _can_spawn > (arwa_squad_cap / 2)} do {		
		private _group = [_pos, _side, _tier, _can_spawn] call spawn_vehicle_group;
		
		_groups append [_group];		
		[_group] call add_battle_group;			

		private _unit_count = _side call count_battlegroup_units;	
		private _can_spawn = arwa_unit_cap - _unit_count; 
	};

	diag_log format["%1: Spawned %2 tier %3 vehicles", _side, count _groups, _tier];

	_groups;
};

spawn_reinforcement_vehicle_group = {
	params ["_side", "_can_spawn", "_sector"];	

	private _groups = [_side, _can_spawn] call spawn_random_vehicle_group;
	{ _x setVariable [priority_target, _sector]; } count _groups;
};
