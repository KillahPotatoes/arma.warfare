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

	private _veh = vehicle leader _group;
	private _is_veh = _veh isKindOf "Car" || _veh isKindOf "Tank";

	if (_is_veh) then {
		_w setWaypointType "MOVE";
		_group setBehaviour "SAFE";
	} else {
		_w setWaypointType "SAD";
		_group setBehaviour "AWARE";
	};
		
	_group setSpeedMode "NORMAL";
	_group setCombatMode "YELLOW";
	_group setVariable ["target", _target];	
};

join_nearby_group = {
	params ["_group"];

	private _joined_other_group = false;

	if ((({ alive _x } count units _group) < 3) && {!([_group] call check_if_in_vehicle)}) then {
		private _groups = [side _group] call get_battlegroups;
		private _pos = getPos leader _group;
		private _nearby_groups = _groups select { [_x, _pos, 100] call check_if_group_nearby && !([_x] call check_if_in_vehicle) };

		if(!(_nearby_groups isEqualTo [])) then {
			private _smallest_group = [_nearby_groups] call get_smallest_group;
		
			{		
				[_x] joinSilent _smallest_group;		
			} forEach units _group;

			deleteGroup _group;
			systemChat format["Group %1 of %2 joined nearby group %3 of %4", groupId _group, count units _group, groupId _smallest_group, count units _smallest_group];
			_joined_other_group = true;
		};		
	};

	_joined_other_group;
};

move_to_sector = {
	params ["_target", "_group"];

	private _curr_target = _group getVariable "target";

	if (isNil "_curr_target" || {!(_target isEqualTo _curr_target)} || {count (waypoints _group) == 0}) then {
		if (!([_group] call join_nearby_group)) then {
			[_target, _group] call create_waypoint;		
			[_group, _target] call report_next_waypoint;
		};
	};

	if ((_target getVariable pos) distance2D (getPosWorld leader _group) < 200) then {
		private _veh = vehicle leader _group;	
		private _is_veh = _veh isKindOf "Car" || _veh isKindOf "Tank";

		if (_is_veh) then {
			_group setSpeedMode "LIMITED";
		};
		_group setBehaviour "AWARE";
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
				[_group] call report_casualities_over_radio;
			};
			sleep random 5;
		} forEach ([] call get_all_battle_groups);
		
	};
};

