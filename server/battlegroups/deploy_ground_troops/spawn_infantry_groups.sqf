spawn_random_infantry_group = {
	params ["_side", "_can_spawn"];	
		
	
	private _rnd = random 100;

	if (_rnd > 80) exitWith {
		[_side, _can_spawn] call helicopter_insertion;
	};

	private _group = [_side, _can_spawn] call spawn_squad;

	if(isNil "_group") exitWith {};

	[_group] call add_battle_group;
};

get_closest_infantry_spawn_pos = {
	params ["_side", "_target"];

	private _hq_pos = getMarkerPos ([_side, respawn_ground] call get_prefixed_name);
	private _safe_sectors = [_side, (arwa_sector_size * 2)] call get_safe_sectors;
	private _safe_pos = [_hq_pos];

	{
		_safe_pos append [_x getVariable pos]
	} forEach _safe_sectors;

	_safe_pos = _safe_pos apply { [_x distance (_target getVariable pos), _x] };
	_safe_pos sort true;

	private _best_pos = (_safe_pos select 0) select 1;

	[_best_pos, 10, 50, 5, 0, 0, 0] call BIS_fnc_findSafePos;
};

find_preferred_targets = {
	params["_side"];
	private _hq_pos = getMarkerPos ([_side, respawn_ground] call get_prefixed_name);		
	private _target_sectors = [_side] call get_other_sectors;	
	
	_target_sectors append ([_side] call get_unsafe_sectors);
	
	if(_target_sectors isEqualTo []) exitWith {};

	[_target_sectors, _hq_pos] call find_potential_target_sectors;
};

get_infantry_spawn_position = {
	params ["_side"];

	private _preferred_targets = [_side] call find_preferred_targets;

	if(isNil "_preferred_targets") exitWith {};

	private _preferred_target = (selectRandom _preferred_targets) select 1;

	[_side, _preferred_target] call get_closest_infantry_spawn_pos;
};

find_potential_target_sectors = {
	params ["_sectors", "_pos"];

	private _sorted_sectors = _sectors apply { [_pos distance (_x getVariable pos), _x] };
	_sorted_sectors sort true;

	private _closest_sector = _sorted_sectors select 0;
	private _shortest_distance = _closest_sector select 0;

	_sorted_sectors select { (_x select 0) < (_shortest_distance + 1000) };
};

spawn_squad = {
	params ["_side", "_can_spawn"];
	
	private _pos = [_side] call get_infantry_spawn_position;	

	if(isNil "_pos") exitWith {};

	_soldier_count = (arwa_squad_cap call calc_number_of_soldiers) min _can_spawn;
    [_pos, _side, _soldier_count, false] call spawn_infantry;	
};

spawn_reinforcement_squad = {
	params ["_side", "_can_spawn", "_sector"];
	
	private _pos = [_side, _sector] call get_closest_infantry_spawn_pos;	

	if(isNil "_pos") exitWith {};

	_soldier_count = (arwa_squad_cap call calc_number_of_soldiers) min _can_spawn;
    private _group = [_pos, _side, _soldier_count, false] call spawn_infantry;	

	_group setVariable [priority_target, _sector];
	[_group] call add_battle_group;
};
