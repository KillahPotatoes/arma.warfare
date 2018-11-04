spawn_random_infantry_group = {
	params ["_side", "_can_spawn"];	
		
	private _pos = getMarkerPos ([_side, respawn_ground] call get_prefixed_name);	
	private _rnd = random 100;

	if (_rnd > 80 && (([] call seconds_since_start) > 300)) exitWith {
		[_side, _can_spawn] call helicopter_insertion;
	};

	private _group = [_pos, _side, _can_spawn] call spawn_squad;
	[_group] call add_battle_group;
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

spawn_infantry_groups = {
	params ["_side"];
	private _unit_count = _side call count_battlegroup_units;	
	private _strength = _side call get_strength;
	private _can_spawn = (unit_cap - _unit_count) min (_side call get_unused_strength); 

	if (_can_spawn > (squad_cap / 2) || (_strength == _can_spawn)) exitWith {
		[_side, _can_spawn] call spawn_random_infantry_group;		
	};	
};