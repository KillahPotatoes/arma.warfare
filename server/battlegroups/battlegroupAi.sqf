delete_all_waypoints = {
	params ["_group"];

	while {(count (waypoints _group)) > 0} do
	{
		deleteWaypoint [_group, 0];
	};
};

create_waypoint = {
	params ["_target", "_group"];
	private _pos = [(_target getVariable pos), 0, 25, 5, 0, 0, 0] call BIS_fnc_findSafePos;

	_group call delete_all_waypoints; 
	_w = _group addWaypoint [_pos, 5];
	_w setWaypointType "SAD";
	
	_group setBehaviour "AWARE";
	_group setSpeedMode "NORMAL";
	_group setCombatMode "YELLOW";
	_group setVariable ["target", _target];	
};

move_to_sector = {
	params ["_target", "_group"];

	private _curr_target = _group getVariable "target";

	if (isNil "_curr_target" || {!(_target isEqualTo _curr_target)}) then {
		[_target, _group] call create_waypoint;
	};

	if ((_target getVariable pos) distance2D (getPosWorld leader _group) < 200) then {	
		_group setSpeedMode "LIMITED";		
		_group setCombatMode "RED";
	};		
};

group_ai = {
	while {true} do {
		{		
			private _group = _x;
			private _side = side _group; 

			if (!(player isEqualTo leader _group) && _side in factions) then { // TODO check if in group && (leader or injured) to avoid getting new checkpoints while waiting for revive
				private _pos = getPosWorld (leader _group);

				private _sector_c = [_side] call count_other_sectors; // gets list of uncapturedSectors

				private _target = if(_sector_c > 0) then { 
						[_side, _pos] call find_closest_target_sector;
					} else {
						[_side, _pos] call find_closest_friendly_sector;	
					};
				
				[_target, _group] call move_to_sector;
				[_group] remoteExec ["report_casualities"];
			};
		} forEach ([] call get_all_battle_groups);
		sleep 10;
	};
};

