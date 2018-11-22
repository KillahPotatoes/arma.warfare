spawn_random_infantry_group = {
	params ["_side", "_can_spawn"];	
		
	private _pos = getMarkerPos ([_side, respawn_ground] call get_prefixed_name);	
	private _rnd = random 100;

	if (_rnd > 80) exitWith {
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

	private _preferred_targets = [_target_sectors, _pos] call find_potential_target_sectors;
	private _preferred_target = selectRandom _preferred_targets;

	_safe_pos = _safe_pos apply { [_x distance (_preferred_target getVariable pos), _x] };
	_safe_pos sort true;

	private _best_pos = (_safe_pos select 0) select 1;

	[_best_pos, 10, 50, 5, 0, 0, 0] call BIS_fnc_findSafePos;	
};

find_potential_target_sectors = {
	params ["_sectors", "_pos"];

	private _sorted_sectors = _sectors apply { [_pos distance (_sectors getVariable pos), _x] };
	_sorted_sectors sort true;

	private _closest_sector = _sorted_sectors select 0;
	private _shortest_distance = _closest_sector select 0;

	_sorted_sectors select { (_x select 0) < (_shortest_distance + 1000) };
};

spawn_squad = {
	params ["_pos", "_side", "_can_spawn"];
	
	_pos = [_pos, _side] call get_infantry_spawn_position;
	_soldier_count = (squad_cap call calc_number_of_soldiers) min _can_spawn;
    [_pos, _side, _soldier_count, false] call spawn_infantry;	
};
