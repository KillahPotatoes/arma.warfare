ARWA_delete_all_waypoints = {
	params ["_group"];

	while {(count (waypoints _group)) > 0} do
	{
		deleteWaypoint [_group, 0];
	};
};

ARWA_group_is_alive = {
	params ["_group"];

	{alive _x} count units _group > 0;
};

ARWA_group_should_be_commanded = {
	params ["_group"];

	!(isPlayer leader _group) && ((side _group) in ARWA_all_sides) && (_group getVariable ["active", true]);
};

ARWA_should_change_target = {
	params ["_group", "_new_target"];

	private _curr_target = _group getVariable "target";

	isNil "_curr_target" || {!(_new_target isEqualTo _curr_target)};
};

ARWA_needs_new_waypoint = {
	params ["_group"];

	private _target = _group getVariable "target";

	if(isNil "_target") exitWith { false; };

	(_target getVariable pos) distance2D (getPosWorld leader _group) > 20 && {count (waypoints _group) == 0};
};

ARWA_approaching_target = {
	params["_group"];

	private _target = _group getVariable "target";

	if(isNil "_target") exitWith { false; };
	(_target getVariable pos) distance2D (getPosWorld leader _group) < ARWA_sector_size;
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

	private _priority_target = _group getVariable priority_target;

	if(isNil "_priority_target") exitWith { false; };

	private _is_safe = [_side, _priority_target, ARWA_sector_size] call ARWA_is_sector_safe;
	private _is_captured = (_priority_target getVariable owned_by) isEqualTo _side;

	_is_safe && _is_captured;
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
