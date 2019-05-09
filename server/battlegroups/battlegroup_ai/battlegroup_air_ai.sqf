air_create_waypoint = {
	params ["_target", "_group"];
	private _pos = _target getVariable pos;

	_group call delete_all_waypoints; 
	_w = _group addWaypoint [_pos, 5];
	_w setWaypointStatements ["true","[group this] call delete_all_waypoints"];
	
	_w setWaypointType "SAD";
	_group setBehaviour "AWARE";
		
	_group setCombatMode "YELLOW";
	_group setVariable ["target", _target];	
};

air_move_to_sector = {
	params ["_new_target", "_group"];

	if ([_group, _new_target] call should_change_target) then {
		[_new_target, _group] call air_create_waypoint;	
	};

	if ([_group] call needs_new_waypoint) then {
		private _target = _group getVariable "target";
		[_target, _group] call vehicle_create_waypoint;	
	};

	if ([_group] call approaching_target) then {		
		_group setCombatMode "RED";
	};		
};

initialize_air_group_ai = {
	params ["_group", "_veh"];

	private _side = side _group; 

	while{[_group] call group_is_alive} do {

		if(!(someAmmo _veh)) exitWith {
			[_group, _veh] spawn ARWA_take_off_and_despawn;
		};

		if([_group] call group_should_be_commanded) then {
			private _target = [_group, _side] call find_air_target;
			[_target, _group] spawn air_move_to_sector;
		};

		sleep 10;
	};
};

find_air_target = {
	params ["_group", "_side"];

	private _pos = getPosWorld (leader _group);
	
	private _unsafe_sectors = [_side] call get_unsafe_sectors;

	if ((count _unsafe_sectors) > 0) exitWith {
		[_unsafe_sectors, _pos] call find_closest_sector;
	}; 

	private _enemy_sectors = [_side] call find_enemy_sectors;

	if((count _enemy_sectors) > 0) exitWith { 
		[_enemy_sectors, _pos] call find_closest_sector;
	}; 

	[sectors, _pos] call find_closest_sector;
};