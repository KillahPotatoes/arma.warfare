
infantry_create_waypoint = {
	params ["_target", "_group"];
	private _pos = [(_target getVariable pos), 0, 25, 5, 0, 0, 0] call BIS_fnc_findSafePos;

	_group call delete_all_waypoints; 
	_w = _group addWaypoint [_pos, 5];
	_w setWaypointStatements ["true","[group this] call delete_all_waypoints"];
	
	_w setWaypointType "SAD";
	_group setBehaviour "AWARE";
		
	_group setSpeedMode "NORMAL";
	_group setCombatMode "YELLOW";
	_group setVariable ["target", _target];	
};

join_nearby_group = {
	params ["_group"];

	private _joined_other_group = false;
	private _group_count = { alive _x } count units _group;

	if (!(isPlayer leader _group) && {_group_count < 3} && {_group_count > 0} && {!([_group] call in_vehicle)}) then {
		private _groups = ([side _group] call get_battlegroups) - [_group];
		private _pos = getPos leader _group;
		private _nearby_groups = _groups select { [_x, _pos, 100] call group_nearby && !([_x] call in_vehicle) && !(isPlayer leader _x)};

		if(!(_nearby_groups isEqualTo [])) then {
			private _smallest_group = [_nearby_groups] call get_smallest_group;

			{		
				[_x] joinSilent _smallest_group;		
			} forEach units _group;

			deleteGroup _group;
			
			private _new_count = { alive _x } count units _smallest_group;
			_smallest_group setVariable [soldier_count, _new_count];			
			_joined_other_group = true;
		};		
	};

	_joined_other_group;
};

infantry_move_to_sector = {
	params ["_new_target", "_group"];

	if ([_group, _new_target] call should_change_target && !([_group] call join_nearby_group)) then {
		[_new_target, _group] call infantry_create_waypoint;			
	};

	if ([_group] call needs_new_waypoint) then {
		private _target = _group getVariable "target";
		[_target, _group] call vehicle_create_waypoint;	
	};

	if ([_group] call approaching_target) then {
		_group setBehaviour "AWARE";
		_group setCombatMode "RED";
	};		
};

initialize_infantry_group_ai = {
	params ["_group"];

	private _side = side _group; 

	while{[_group] call group_is_alive} do {

		if([_group] call group_should_be_commanded) then {
			[_group, _side] spawn infantry_group_ai;
		};

		sleep 10;
	};
};

infantry_group_ai = {
	params ["_group", "_side"];

	private _pos = getPosWorld (leader _group);
	private _target = [_side, _pos] call get_ground_target;
	
	[_target, _group] spawn infantry_move_to_sector;
	[_group] spawn report_casualities_over_radio;
};