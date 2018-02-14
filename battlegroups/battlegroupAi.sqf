DeleteAllWaypoints = {
	_group = _this select 0;

	while {(count (waypoints _group)) > 0} do
	{
		deleteWaypoint ((waypoints _group) select 0);
	};
};

MoveToSector = {
	_new_target = _this select 0;
	_battle_group = _this select 1;

	_pos = _new_target getVariable "pos";
	_safe_pos = [_pos, 0, 25, 5, 0, 0, 0] call BIS_fnc_findSafePos;

	[_battle_group] call DeleteAllWaypoints;
	_wp1 = _battle_group addWaypoint [_safe_pos, 0];
	_wp1 setWaypointType "SAD";
	_battle_group setBehaviour "AWARE";
	_battle_group enableDynamicSimulation false;

	_battle_group setVariable ["target", _new_target];	
};

FindTargetSector = {
	_battle_group = _this select 0;
	_new_target = _this select 1;

	_current_target = _battle_group getVariable ["target", "undefined"];

	if (_current_target isEqualTo "undefined") exitWith {
		[_new_target, _battle_group] call MoveToSector;
	};

	if (!(_new_target isEqualTo _current_target)) exitWith {
		[_new_target, _battle_group] call MoveToSector;
	};
};

while {true} do {
	{		
		if (!(player isEqualTo leader _x)) then {
			_side = side _x; 
			_leader_pos = getPos (leader _x);
			_other_sector_count = [_side] call OtherSectorCount;

			if (_other_sector_count > 0) then {			
				_new_target = [_side, _leader_pos] call FindClosestOtherSector;				
				[_x, _new_target] call FindTargetSector;
			} else {
				_new_target = [_side, _leader_pos] call FindClosestOwnedSector;				
				[_x, _new_target] call FindTargetSector;
			};
		
		}; 
		
	} forEach ([] call GetAllBattleGroups);
	sleep 10;
};
