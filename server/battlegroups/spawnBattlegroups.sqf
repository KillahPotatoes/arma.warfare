set_gunship = {
	params ["_side", "_gunship"];
	missionNamespace setVariable [format["%1_gunship", _side], _gunship];
};

get_gunship = {
	params ["_side"];
	missionNamespace getVariable format["%1_gunship", _side];
};

get_gunship_types = {
	params ["_side"];
	missionNamespace getVariable format["%1_gunships", _side]; 
};

spawn_random_group = {
	params ["_side", "_can_spawn"];	
		
	private _pos = getMarkerPos ([_side, respawn_ground] call get_prefixed_name);
	private _tier = [_side] call get_tier;
	private _rnd = random 100;

	if (_tier >= 2 && {_rnd < (vehicle_chance / 3)}) exitWith {
		([_pos, _side, "heavy", _can_spawn] call spawn_vehicle_group);
	}; 

	if (_tier >= 1 && {_rnd < (vehicle_chance / 1.5)}) exitWith {
		([_pos, _side, "medium", _can_spawn] call spawn_vehicle_group);
	};

	if (_tier >= 0 && {_rnd < vehicle_chance}) exitWith {
		([_pos, _side, "light", _can_spawn] call spawn_vehicle_group);
	};

	[_pos, _side, _can_spawn] call spawn_squad;	
};

add_soldiers_to_cargo = {
	params ["_veh_array", "_can_spawn"];

	_vehicle = _veh_array select 0;
	_crew_count = count (_veh_array select 1);
	_group = _veh_array select 2;

	_cargoCapacity = (_vehicle emptyPositions "cargo") - _crew_count;
	_cargo = _cargoCapacity min _can_spawn;

	_soldiers = [_pos, _side, _cargo, false] call spawn_infantry;	

	{
		_x moveInCargo _vehicle;
        [_x] joinSilent _group;
		
	} forEach units _soldiers;
};

spawn_vehicle_group = {
	params ["_pos", "_side", "_type", "_can_spawn"];
	private _vehicle_type = selectRandom (missionNamespace getVariable format["%1_%2_vehicles", _side, _type]);

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

	private _sector = [sectors, _pos] call find_closest_sector;
	private _sector_pos = _sector getVariable pos;
	private _dir = _pos getDir _sector_pos;

	_veh_array = [_pos, _dir, _vehicle_type, _side] call BIS_fnc_spawnVehicle;
	_group = _veh_array select 2;

	_can_spawn = _can_spawn - (count units _group); 

	if(_can_spawn > 0) then {
    	[_veh_array, _can_spawn] call add_soldiers_to_cargo;		
	};
	
	[_side, format["%1 is deployed in base and ready to head out", _vehicle_type call get_vehicle_display_name]] call report_incoming_support;

	_group;
};

spawn_gunship_group = {
	params ["_pos", "_side"];
	
	private _gunship = selectRandom (_side call get_gunship_types); 
	private _gunship_name = _gunship call get_vehicle_display_name;

	[_side, format["Sending a %1 your way. ETA 2 minutes!", _gunship_name]] call report_incoming_support;
	sleep 120;

	private _respawn_marker = [_side, respawn_ground] call get_prefixed_name;
	private _base_pos = getMarkerPos _respawn_marker;

	private _dir = _pos getDir _base_pos;

	private _pos = [_pos select 0, _pos select 1, (_pos select 2) + 100];
    private _veh = [_pos, _dir, _gunship, _side] call BIS_fnc_spawnVehicle;

	[_side, format["%1 has arrived. See you soon!", _gunship_name]] call report_incoming_support;

	[_side, _veh] call set_gunship;
	_veh;
};

get_infantry_spawn_position = {
	params ["_pos", "_side"];

	private _safe_sectors = _side call get_safe_sectors;

	if((count _safe_sectors) > 0) exitWith {
		private _sector = selectRandom _safe_sectors;
		private _sector_pos = _sector getVariable pos;
		[_sector_pos, 0, 25, 5, 0, 0, 0] call BIS_fnc_findSafePos;
	};

	[_pos, 10, 50, 5, 0, 0, 0] call BIS_fnc_findSafePos;	
};

spawn_squad = {
	params ["_pos", "_side", "_can_spawn"];
	
	_pos = [_pos, _side] call get_infantry_spawn_position;
	_soldier_count = (squad_cap call calc_number_of_soldiers) min _can_spawn;
    [_pos, _side, _soldier_count, false] call spawn_infantry;	
};

get_unused_strength = {
	params ["_side"];

	(_side call get_strength) - (_side call count_battlegroup_units);
};

spawn_battle_group = {
	params ["_side"];
	
	private _unit_count = [_side] call count_battlegroup_units;	
	private _can_spawn = (unit_cap - _unit_count) min ([_side] call get_unused_strength); 

	if (_can_spawn > (squad_cap / 2)) then {
		private _group = [_side, _can_spawn] call spawn_random_group;		;
		[_group] call add_battle_group;
	};	
};

spawn_battle_groups = {
	[West] spawn spawn_gunships;
	[East] spawn spawn_gunships;
	[independent] spawn spawn_gunships;

	while {true} do {
		sleep 30;
		[West] call spawn_battle_group;
		[East] call spawn_battle_group;
		[Independent] call spawn_battle_group;
	};
};

spawn_gunships = {
	params ["_side"];
	
	while {true} do {
		private _tier = [_side] call get_tier;	

		if(_tier > 0) then {
			sleep random (missionNamespace getVariable format["tier_%1_gunship_respawn_time", _tier]);
			if ([_side] call get_unused_strength > 0) then {

				private _gunship = _side call get_gunship;

				if (!isNil format["%1_gunship", _side]) then {	
					(_gunship select 0) setDamage 1;					
				}; 

				private _pos = getMarkerPos ([_side, respawn_air] call get_prefixed_name);
				_gunship = [_pos, _side] call spawn_gunship_group;
				[_gunship select 2] call add_battle_group;

				waitUntil {!canMove (_gunship select 0)};
			};				
		};
		sleep 10;		
	};
};


