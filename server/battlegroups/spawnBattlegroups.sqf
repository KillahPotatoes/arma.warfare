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

	if (_tier > 1 && {_rnd < (tier_2_vehicle_chance)}) exitWith {
		([_pos, _side, "heavy"] call spawn_vehicle_group);
	}; 

	if (_tier > 0 && {_rnd < (tier_1_vehicle_chance)}) exitWith {
		([_pos, _side, "light"] call spawn_vehicle_group);
	};

	[_pos, _side, _unused_strength] call spawn_infantry;	
};

spawn_vehicle_group = {
	params ["_pos", "_side", "_type"];
	private _vehicle_type = selectRandom (missionNamespace getVariable format["%1_%2_vehicles", _side, _type]);

	_pos = [_pos, 10, 50, 15, 0, 0, 0] call BIS_fnc_findSafePos;	
    [_pos, 180, _vehicle_type, _side] call BIS_fnc_spawnVehicle select 2;
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
		[_sector_pos, 10, 50, 5, 0, 0, 0] call BIS_fnc_findSafePos;
	};

	[_pos, 10, 50, 5, 0, 0, 0] call BIS_fnc_findSafePos;	
};

spawn_infantry = {
	params ["_pos", "_side", "_unused_strength"];
	
	_pos = [_pos, _side] call get_infantry_spawn_position;
	_soldier_count = if(_unused_strength > 10) then { floor random [3,5,10]; } else { _unused_strength; };
    _group = [_pos, _side, _soldier_count] call BIS_fnc_spawnGroup;
    _group setBehaviour "AWARE";
	_group;
};

get_unused_strength = {
	params ["_side"];

	(_side call get_strength) - (_side call count_battlegroup_units);
};

spawn_battle_group = {
	params ["_side"];
	
	private _unit_count = [_side] call count_battlegroup_units;	
	private _unused_strength = [_side] call get_unused_strength;

	if (_unit_count < unit_cap && {_unused_strength > 0}) then {
		private _group = [_side, _unused_strength] call spawn_random_group;
		_group deleteGroupWhenEmpty true;
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
		sleep random (missionNamespace getVariable format["tier_%1_gunship_respawn_time", _tier]);

		if ([_side] call get_unused_strength > 0) then {
			private _gunship = _side call get_gunship;

			if (!isNil format["%1_gunship", _side]) then {	
				(_gunship select 0) setDamage 1;					
			}; 

			private _pos = getMarkerPos [_side, respawn_air] call get_prefixed_name;
			_gunship = [_pos, _side] call spawn_gunship_group;
			[_gunship select 2] call add_battle_group;

			waitUntil {!canMove (_gunship select 0)};					
		};		
	};
};


