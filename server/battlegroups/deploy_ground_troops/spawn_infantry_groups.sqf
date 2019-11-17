ARWA_spawn_random_infantry_group = {
	params ["_side", "_can_spawn"];

	private _available_helis = !((_side call ARWA_get_transport_heli_type) isEqualTo []);
	private _most_valuable_sector = [_side] call ARWA_pick_most_valued_player_owned_sector;
	private _attack_most_valuable_sector = !(isNil "_most_valuable_sector") && {(random 100) < ([_most_valuable_sector] call ARWA_get_sector_manpower)};

	if(selectRandom[false, _attack_most_valuable_sector && _available_helis]) exitWith {
		[_side, _can_spawn, _most_valuable_sector] call ARWA_special_forces_insertion;
	};

	if ([_available_helis, false] selectRandomWeighted [0.2, 0.8]) exitWith {
		[_side, _can_spawn] call ARWA_helicopter_insertion;
	};

	private _group = [_side, _can_spawn] call ARWA_spawn_squad;

	if(isNil "_group") exitWith {};
	[_group] call ARWA_add_battle_group;
};

ARWA_get_closest_infantry_spawn_pos = {
	params ["_side", "_pos"];

	private _hq_pos = getMarkerPos ([_side, ARWA_KEY_respawn_ground] call ARWA_get_prefixed_name);
	private _safe_sectors = [_side, (ARWA_sector_size * 2)] call ARWA_get_safe_sectors;
	private _safe_pos = [_hq_pos];

	{
		_safe_pos append [_x getVariable ARWA_KEY_pos]
	} forEach _safe_sectors;

	_safe_pos = _safe_pos apply { [_x distance _pos, _x] };
	_safe_pos sort true;

	private _best_pos = (_safe_pos select 0) select 1;

	[_best_pos, 10, 50, 5, 0, 0, 0] call BIS_fnc_findSafePos;
};

ARWA_find_preferred_targets = {
	params["_side"];
	private _hq_pos = getMarkerPos ([_side, ARWA_KEY_respawn_ground] call ARWA_get_prefixed_name);
	private _target_sectors = [_side] call ARWA_get_other_sectors;

	_target_sectors append ([_side] call ARWA_get_unsafe_sectors);

	if(_target_sectors isEqualTo []) exitWith {};

	[_target_sectors, _hq_pos] call ARWA_find_potential_target_sectors;
};

ARWA_get_infantry_spawn_position = {
	params ["_side"];

	private _preferred_targets = [_side] call ARWA_find_preferred_targets;

	if(isNil "_preferred_targets") exitWith {};

	private _preferred_target = (selectRandom _preferred_targets) select 1;
	private _pos = _preferred_target getVariable ARWA_KEY_pos;

	[_side, _pos] call ARWA_get_closest_infantry_spawn_pos;
};

ARWA_find_potential_target_sectors = {
	params ["_sectors", "_pos"];

	private _sorted_sectors = _sectors apply { [_pos distance (_x getVariable ARWA_KEY_pos), _x] };
	_sorted_sectors sort true;

	private _closest_sector = _sorted_sectors select 0;
	private _shortest_distance = _closest_sector select 0;

	_sorted_sectors select { (_x select 0) < (_shortest_distance + 1000) };
};

ARWA_spawn_squad = {
	params ["_side", "_can_spawn"];

	private _pos = [_side] call ARWA_get_infantry_spawn_position;

	if(isNil "_pos") exitWith {};

	private _soldier_count = ARWA_squad_cap min _can_spawn;
    [_pos, _side, _soldier_count, false] call ARWA_spawn_infantry;
};

ARWA_spawn_reinforcement_squad = {
	params ["_side", "_can_spawn", "_target"];

	private _target_pos = _target getVariable ARWA_KEY_pos;
	private _pos = [_side, _target_pos] call ARWA_get_closest_infantry_spawn_pos;

	if(isNil "_pos") exitWith {};

	private _soldier_count = (ARWA_squad_cap call ARWA_calc_number_of_soldiers) min _can_spawn;
	format["%1: Spawn infantry squad (%2)", _side, _soldier_count] spawn ARWA_debugger;
	format["%1 manpower: %2", _side, [_side] call ARWA_get_strength] spawn ARWA_debugger;

    private _group = [_pos, _side, _soldier_count, false] call ARWA_spawn_infantry;

	_group setVariable [ARWA_KEY_priority_target, _target];
	[_group] call ARWA_add_battle_group;
};
