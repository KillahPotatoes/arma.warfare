


SpawnInfantry = {
  	_marker = _this select 0;
	_faction = _this select 1;

	_pos = [getMarkerPos _marker, 10, 50, 5, 0, 0, 0] call BIS_fnc_findSafePos;	
	
    _numberOfSoldiers = floor random [3,5,10];
    _soldierGroup = [_pos, _faction, _numberOfSoldiers] call BIS_fnc_spawnGroup;
    _soldierGroup setBehaviour "AWARE";
    _soldierGroup enableDynamicSimulation true;

	_soldierGroup;
};

FindClosestOtherSector = {
	_side = _this select 0;
	_pos = _this select 1;
	_enemySectors = [_side] call GetOtherSectors;	

	_current_target_sector = _enemySectors select 0;
	_current_shortest_distance = 99999;

	{
		_sector_pos = getPos _x;
		_distance = _leader_pos distance _sector_pos;

		if (_current_shortest_distance > _distance) then {
			_current_shortest_distance = _distance;
			_current_target_sector = _x;
		};

	} forEach _enemySectors;

	_current_target_sector;
};

AttackEnemySector = {
	_battle_group = _this select 0;
	_side = side _battle_group;
	_other_sector_count = [_side] call OtherSectorCount;

	if (_other_sector_count > 0) then {
		_leader_pos = getPos (leader _battle_group);

		_target_sector = [_side, _leader_pos] call FindClosestOtherSector;
		
		_wp1 = _battle_group addWaypoint [getPos _target_sector, 0];
		_wp1 setWaypointType "SAD";
		_battle_group setBehaviour "AWARE";
		_battle_group enableDynamicSimulation false;

		_battle_group setVariable ["target", _target_sector];
	} else {
		// defend?
	};
};

SpawnBattleGroup = {
	_faction = _this select 0;
	
	_unit_count = {alive _x && side _x == _faction} count allUnits;
		
	systemChat format["%1 has %2 units", _faction, _unit_count];

	if (_unit_count < 30) then {
		_respawn_point = format["respawn_%1", _faction];
		_battle_group =	[_respawn_point, _faction] call SpawnInfantry;

		sleep 5;

		[_battle_group] call AttackEnemySector;			
	};
};

SpawnBattleGroups = {

	sleep 10;
	systemChat "Started spawing battlegroups";
	
	while {true} do {
		[West] spawn SpawnBattleGroup;
		[East] spawn SpawnBattleGroup;
		[Independent] spawn SpawnBattleGroup;

		sleep 30;
	};
};

[] call SpawnBattleGroups;
