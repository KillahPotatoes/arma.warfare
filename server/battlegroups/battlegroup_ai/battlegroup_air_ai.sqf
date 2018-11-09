create_waypoint = {
	params ["_target", "_group"];
	private _pos = [(_target getVariable pos), 0, 25, 5, 0, 0, 0] call BIS_fnc_findSafePos;

	_group call delete_all_waypoints; 
	_w = _group addWaypoint [_pos, 5];
	//_w setWaypointStatements ["true","[group this] call delete_all_waypoints"];
	
	_w setWaypointType "SAD";
	_group setBehaviour "AWARE";
		
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
		
		_group setBehaviour "AWARE";
		_group setCombatMode "RED";
	};		
};

air_group_ai = {
	params ["_group", "_side"];
	
	private _target = [_group, _side] call find_air_target;

	[_target, _group] spawn move_to_sector;
};

find_air_target = {
	params ["_group", "_side"];

	private _pos = getPosWorld (leader _group);

	private _enemy_sectors = [_side] call find_enemy_sectors;
	private _unsafe_sectors = [_side] call get_unsafe_sectors;

	if ((count _unsafe_sectors) > 0) exitWith {
		[_unsafe_sectors, _pos] call find_closest_sector;
	}; 

	if((count _enemy_sectors) > 0) exitWith { 
		[_enemy_sectors, _pos] call find_closest_sector;
	}; 

	[sectors, _pos] call find_closest_sector;
};