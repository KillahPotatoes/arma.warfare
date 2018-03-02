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
	params ["_side", "_unused_strength"];	
		
	private _pos = getMarkerPos ([_side, respawn_ground] call get_prefixed_name);
	private _tier = [_side] call get_tier;
	private _rnd = random 100;

	if (_tier > 2 && {_rnd < (vehicle_chance / 3)}) exitWith {
		([_pos, _side, "heavy", _unused_strength] call spawn_vehicle_group);
	}; 

	if (_tier > 1 && {_rnd < (vehicle_chance / 1.5)}) exitWith {
		([_pos, _side, "medium", _unused_strength] call spawn_vehicle_group);
	};

	if (_tier > 0 && {_rnd < vehicle_chance}) exitWith {
		([_pos, _side, "light", _unused_strength] call spawn_vehicle_group);
	};

	[_pos, _side, _unused_strength] call spawn_squad;	
};

add_soldiers_to_cargo = {
	params ["_veh_array", "_unused_strength"];

	_vehicle = _veh_array select 0;
	_group = _veh_array select 2;

	_cargoCapacity = _vehicle emptyPositions "cargo";
	_cargo = _cargoCapacity min _unused_strength;

	_soldiers = [_pos, _side, _cargo, false] call spawn_infantry;	

	{
		_x moveInCargo _vehicle;
        [_x] joinSilent _group;
		
	} forEach units _soldiers;
};

spawn_vehicle_group = {
	params ["_pos", "_side", "_type", "_unused_strength"];
	private _vehicle_type = selectRandom (missionNamespace getVariable format["%1_%2_vehicles", _side, _type]);

	_pos = [_pos, 10, 50, 15, 0, 0, 0] call BIS_fnc_findSafePos;	
	_veh_array = [_pos, 180, _vehicle_type, _side] call BIS_fnc_spawnVehicle;
    [_veh_array, _unused_strength] call add_soldiers_to_cargo;
	_veh_array select 2;
};

spawn_gunship_group = {
	params ["_pos", "_side"];
	
	_gunship = selectRandom (_side call get_gunship_types); 
	
	_pos = [_pos select 0, _pos select 1, (_pos select 2) + 100];
    _veh = [_pos, 180, _gunship, _side] call BIS_fnc_spawnVehicle;

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
	params ["_pos", "_side", "_unused_strength"];
	
	_pos = [_pos, _side] call get_infantry_spawn_position;
	_soldier_count = (squad_cap call calc_number_of_soldiers) min _unused_strength;
    [_pos, _side, _soldier_count, false] call spawn_infantry;	
};

get_unused_strength = {
	params ["_side"];

	(_side call get_strength) - (_side call count_battlegroup_units);
};

spawn_battle_group = {
	params ["_side"];
	
	private _unit_count = [_side] call count_battlegroup_units;	
	private _unused_strength = [_side] call get_unused_strength;

	if(_unused_strength > (squad_cap / 6)) then {
		private _group = [_side, _unused_strength] call spawn_random_group;	
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
			if ([_side] call get_unused_strength > 0) then {
				private _gunship = _side call get_gunship;

				if (!isNil format["%1_gunship", _side]) then {	
					(_gunship select 0) setDamage 1;					
				}; 

				private _pos = getMarkerPos ([_side, respawn_air] call get_prefixed_name);
				_gunship = [_pos, _side] call spawn_gunship_group;
				[_gunship select 2] call add_battle_group;

				waitUntil {!canMove (_gunship select 0)};
				_tier = [_side] call get_tier;
				sleep random (missionNamespace getVariable format["tier_%1_gunship_respawn_time", _tier]);
			};				
		};
		sleep 10;		
	};
};


