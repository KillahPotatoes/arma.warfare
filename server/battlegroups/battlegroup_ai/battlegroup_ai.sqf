ARWA_group_is_alive = {
	params ["_group"];

	{alive _x} count units _group > 0;
};

ARWA_group_should_be_commanded = {
	params ["_group"];

	!(isPlayer leader _group) && ((side _group) in ARWA_all_sides) && (_group getVariable [ARWA_KEY_active, true]);


};

ARWA_should_change_target = {
	params ["_group", "_new_target"];

	private _curr_target = _group getVariable ARWA_KEY_target;
	private _result = isNil "_curr_target" || {isNull _curr_target} || {!(_new_target isEqualTo _curr_target)};

	format["Should change target: %1, current_target: %2, new_target: %3", _result, _curr_target, _new_target] spawn ARWA_debugger;

	_result;
};

ARWA_needs_new_waypoint = {
	params ["_group"];

	private _target = _group getVariable ARWA_KEY_target;

	if(isNil "_target" || {isNull _target}) exitWith { true; };

	private _distance =  (getPos _target) distance2D (getPos leader _group);
	private _waypoint_count = count (waypoints _group);

	private _result = _distance > 20 && _waypoint_count == 0};

	format["Needs new waypoint: %1, target: %2, _distance: %3, _waypoint_count: %4", _result, _target, _distance, _waypoint_count] spawn ARWA_debugger;

};

ARWA_approaching_target = {
	params["_group"];

	private _target = _group getVariable ARWA_KEY_target;

	if(isNil "_target" || {isNull _target}) exitWith { false; };
	(getPos _target) distance2D (getPos leader _group) < ARWA_sector_size;
};

ARWA_check_if_has_priority_target = {
	params ["_group", "_side"];

	private _priority_target = _group getVariable ARWA_KEY_priority_target;

	if(isNil "_priority_target" || {isNull _priority_target}) exitWith { false; }; // Ammobox is deleted after a while so this should be sufficient

	private _owner = _priority_target getVariable ARWA_KEY_owned_by;

	if(!isNil "_owner") exitWith { // target is sector
		private _is_safe = [_side, _priority_target, ARWA_sector_size] call ARWA_is_sector_safe;
		private _is_captured = (_priority_target getVariable ARWA_KEY_owned_by) isEqualTo _side;

		!(_is_safe && _is_captured);
	};

	true; // Because only manpowerboxes has no owner
};

ARWA_initialize_battlegroup_ai = {
	params ["_group"];

	private _veh = vehicle (leader _group);

	if(_veh isKindOf "Air") exitWith {
		[_group, _veh] spawn ARWA_initialize_air_group_ai;
	};

	if(_veh isKindOf "Car" || _veh isKindOf "Tank") exitWith {
		[_group] spawn ARWA_initialize_vehicle_group_ai;
	};

	[_group] spawn ARWA_initialize_infantry_group_ai;
};
