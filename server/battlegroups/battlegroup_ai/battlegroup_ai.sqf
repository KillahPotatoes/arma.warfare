delete_all_waypoints = {
	params ["_group"];

	while {(count (waypoints _group)) > 0} do
	{
		deleteWaypoint [_group, 0];
	};
};

group_is_alive = {
	params ["_group"];

	{alive _x} count units _group > 0;
};

group_should_be_commanded = {
	params ["_group"];

	!(isPlayer leader _group) && (side _group) in factions && _group getVariable "active";
};

should_change_target = {
	params ["_group", "_new_target"];

	private _curr_target = _group getVariable "target";

	isNil "_curr_target" || {!(_new_target isEqualTo _curr_target)};
};

needs_new_waypoint = {
	params ["_group"];

	private _target = _group getVariable "target";

	if(isNil "_target") exitWith { false; };

	(_target getVariable pos) distance2D (getPosWorld leader _group) > 20 && {count (waypoints _group) == 0};
};

approaching_target = {
	params["_group"];

	private _target = _group getVariable "target";

	if(isNil "_target") exitWith { false; };
	(_target getVariable pos) distance2D (getPosWorld leader _group) < 200;
};

get_ground_target = {
	params ["_side", "_pos"];

	private _sectors = [_side] call get_other_sectors;
	private _unsafe_sectors = [_side] call get_unsafe_sectors;
	private _targets = _sectors + _unsafe_sectors;

	if((count _targets) > 0) exitWith { 
		[_targets, _pos] call find_closest_sector;
	};

	[sectors, _pos] call find_closest_sector;		
};

initialize_battlegroup_ai = {
	params ["_group"];

	private _veh = vehicle leader _group;
	
	if(_veh isKindOf "Air") exitWith {
		[_group] spawn initialize_air_group_ai;
	};
	
	if(_veh isKindOf "Car" || _veh isKindOf "Tank") exitWith {
		[_group] spawn initialize_vehicle_group_ai;
	};

	[_group] spawn initialize_infantry_group_ai;
};

