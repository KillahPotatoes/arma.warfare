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

SpawnBattleGroup = {
	_faction = _this select 0;
	
	_unit_count = [_faction] call CountBattlegroupUnits;
		
	systemChat format["%1 has %2 battlegroup units", _faction, _unit_count];

	if (_unit_count < 30) then {
		_respawn_point = format["respawn_%1", _faction];
		_battle_group =	[_respawn_point, _faction] call SpawnInfantry;

		[_battle_group] call AddBattleGroups;

		sleep 5;
	};
};

SpawnBattleGroups = {
	sleep 10;
	
	while {true} do {
		[West] spawn SpawnBattleGroup;
		[East] spawn SpawnBattleGroup;
		[Independent] spawn SpawnBattleGroup;

		sleep 30;
	};
};

[] call SpawnBattleGroups;
