ARWA_group_is_alive = {
	params ["_group"];

	{alive _x} count units _group > 0;
};

ARWA_group_should_be_commanded = {
	params ["_group"];

	!(isPlayer leader _group) && ((side _group) in ARWA_all_sides) && (_group getVariable [ARWA_KEY_active, true]);
};

ARWA_should_change_target = {
	params ["_group", "_new_target_pos"];

	private _curr_target_pos = _group getVariable ARWA_KEY_target;

	isNil "_curr_target_pos" || {!(_new_target_pos isEqualTo _curr_target_pos)};
};

ARWA_needs_new_waypoint = {
	params ["_group"];

	private _target_pos = _group getVariable ARWA_KEY_target;

	if(isNil "_target_pos") exitWith { true; };

	(_target_pos) distance2D (getPosWorld leader _group) > 20 && {count (waypoints _group) == 0};
};

ARWA_approaching_target = {
	params["_group"];

	private _target_pos = _group getVariable ARWA_KEY_target;

	if(isNil "_target_pos") exitWith { false; };
	(_target_pos) distance2D (getPosWorld leader _group) < ARWA_sector_size;
};

ARWA_get_ground_target = {
	params ["_side", "_pos"];

	private _sectors = [_side] call ARWA_get_other_sectors;
	private _unsafe_sectors = [_side] call ARWA_get_unsafe_sectors;
	private _targets = _sectors + _unsafe_sectors;

	if((count _targets) > 0) exitWith {
		[_targets, _pos] call ARWA_find_closest_sector;
	};

	[ARWA_sectors, _pos] call ARWA_find_closest_sector;
};

ARWA_check_if_has_priority_target = {
	params ["_group", "_side"];

	private _priority_target = _group getVariable [ARWA_KEY_MISSION_priority, false];

	if(!_priority_target) exitWith { false; };

	private _mission_type = _group getVariable ARWA_KEY_MISSION_type;

	if(_mission_type isEqualTo ARWA_KEY_MISSION_sector) exitWith {
		private _sector = _group setVariable ARWA_KEY_MISSION_data;

		private _is_safe = [_side, _sector, ARWA_sector_size] call ARWA_is_sector_safe;
		private _is_captured = (_sector getVariable ARWA_KEY_owned_by) isEqualTo _side;

		!(_is_safe && _is_captured);
	};

	if(_mission_type isEqualTo ARWA_KEY_MISSION_player) exitWith {

	};

	if(_mission_type isEqualTo ARWA_KEY_MISSION_manpower_box) exitWith {

	};
};

ARWA_initialize_battlegroup_ai = {
	params ["_group"];

	private _veh = vehicle leader _group;

	if(_veh isKindOf "Air") exitWith {
		[_group, _veh] spawn ARWA_initialize_air_group_ai;
	};

	if(_veh isKindOf "Car" || _veh isKindOf "Tank") exitWith {
		[_group] spawn ARWA_initialize_vehicle_group_ai;
	};

	[_group] spawn ARWA_initialize_infantry_group_ai;
};
