spawn_random_group = {
	params ["_side", "_can_spawn"];	
		
	private _pos = getMarkerPos ([_side, respawn_ground] call get_prefixed_name);
	private _tier = [_side] call get_tier;
	private _rnd = random 100;

	if (_tier >= 2 && {_rnd < (vehicle_chance / 3)}) exitWith {
		private _group = [_pos, _side, 2, _can_spawn] call spawn_vehicle_group;
		[_group] call add_battle_group;		
	}; 

	if (_tier >= 1 && {_rnd < (vehicle_chance / 1.5)}) exitWith {
		private _group = [_pos, _side, 1, _can_spawn] call spawn_vehicle_group;
		[_group] call add_battle_group;
	};

	if (_tier >= 0 && {_rnd < vehicle_chance}) exitWith {
		private _group = [_pos, _side, 0, _can_spawn] call spawn_vehicle_group;
		[_group] call add_battle_group;
	};

	if (_rnd > 80 && (([] call seconds_since_start) > 300)) exitWith {
		[_side, _can_spawn] call helicopter_insertion;
	};

	private _group = [_pos, _side, _can_spawn] call spawn_squad;
	[_group] call add_battle_group;

};

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
			_is_safe = [_road_pos] call check_if_any_units_to_close;
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
	private _vehicle_type = selectRandom (missionNamespace getVariable format["%1_vehicle_tier_%2", _side, _tier]) select 0;

	_pos = [_pos] call try_find_unoccupied_nearby_road;

	private _dir = [_pos] call find_direction_towards_closest_sector;
	private _veh_array = [_pos, _dir, _vehicle_type, _side] call BIS_fnc_spawnVehicle;
	private _group = _veh_array select 2;

	_can_spawn = _can_spawn - (count units _group); 

	if(_can_spawn > 0) then {
    	[_veh_array, _can_spawn] call add_soldiers_to_cargo;		
	};
	
	_group;
};

get_infantry_spawn_position = {
	params ["_pos", "_side"];

	private _safe_sectors = [_side, (sector_size * 2)] call get_safe_sectors;

	private _safe_pos = [_pos];

	{
		_safe_pos = _safe_pos + [_x getVariable pos]
	} forEach _safe_sectors;
	
	private _target_sectors = [_side] call get_other_sectors;	
	_target_sectors = _target_sectors + ([_side] call get_unsafe_sectors);
	
	if(_target_sectors isEqualTo []) exitWith {};

	private _preferred_target = [_target_sectors, _pos] call find_closest_sector;

	_safe_pos = _safe_pos apply { [_x distance (_preferred_target getVariable pos), _x] };
	_safe_pos sort true;

	private _best_pos = (_safe_pos select 0) select 1;

	[_best_pos, 10, 50, 5, 0, 0, 0] call BIS_fnc_findSafePos;	
};

spawn_squad = {
	params ["_pos", "_side", "_can_spawn"];
	
	_pos = [_pos, _side] call get_infantry_spawn_position;
	_soldier_count = (squad_cap call calc_number_of_soldiers) min _can_spawn;
    [_pos, _side, _soldier_count, false] call spawn_infantry;	
};

spawn_battle_group = {
	params ["_side"];
	//_t2 = diag_tickTime;
	private _unit_count = _side call count_battlegroup_units;	
	private _strength = _side call get_strength;
	private _can_spawn = (unit_cap - _unit_count) min (_side call get_unused_strength); 

	if (_can_spawn > (squad_cap / 2) || (_strength == _can_spawn)) then {
		private _group = [_side, _can_spawn] call spawn_random_group;		
	};	
	//[_t2, "spawn_battle_groups"] spawn report_time;	
};

spawn_battle_groups = {
	params ["_side"];

	sleep 30;		

	while {true} do {
		[_side] spawn spawn_battle_group;
		sleep 120;
	};
};

initialize_spawn_battle_groups = {	
	[West] spawn spawn_battle_groups;
	[East] spawn spawn_battle_groups;
	[Independent] spawn spawn_battle_groups;
};




