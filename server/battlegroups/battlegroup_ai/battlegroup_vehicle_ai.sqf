
create_waypoint = {
	params ["_target", "_group"];
	private _pos = [(_target getVariable pos), 0, 25, 5, 0, 0, 0] call BIS_fnc_findSafePos;

	_group call delete_all_waypoints; 
	_w = _group addWaypoint [_pos, 5];
	//_w setWaypointStatements ["true","[group this] call delete_all_waypoints"];

	_w setWaypointType "MOVE";
	_group setBehaviour "SAFE";
		
	_group setSpeedMode "NORMAL";
	_group setCombatMode "YELLOW";
	_group setVariable ["target", _target];	
};

move_to_sector = {
	params ["_target", "_group"];

	private _curr_target = _group getVariable "target";

	if (isNil "_curr_target" || {!(_target isEqualTo _curr_target)} || {count (waypoints _group) == 0}) then {
		[_target, _group] call create_waypoint;	
	};

	if ((_target getVariable pos) distance2D (getPosWorld leader _group) < 200) then {
		_group setSpeedMode "LIMITED";
		_group setBehaviour "AWARE";
		_group setCombatMode "RED";
	};		
};

ground_group_ai = {
	params ["_group", "_side"];
	private _pos = getPosWorld (leader _group);

	private _sectors = [_side] call get_other_sectors; // gets list of uncapturedSectors
	private _unsafe_sectors = [_side] call get_unsafe_sectors;

	private _sectors = _sectors + _unsafe_sectors;

	private _target = if((count _sectors) > 0) then { 
			[_sectors, _pos] call find_closest_sector;
		} else {
			[sectors, _pos] call find_closest_sector;		
		};
	
	[_target, _group] spawn move_to_sector;
	[_group] spawn report_casualities_over_radio;
};
