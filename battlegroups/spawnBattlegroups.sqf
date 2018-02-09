SpawnRandomBattleGroupType = {
	_faction = _this select 0;
	_diceRoll = random 100;

	_respawn_point_ground = format["respawn_ground_%1", _faction];
	_respawn_point_air = format["respawn_air_%1", _faction];

	if (_diceRoll < chanceOfHelicopter) exitWith {
		([_respawn_point_air, _faction] call SpawnHelicopter) select 2;
	}; 
	
	_chanceOfHeavyVehicle = chanceOfHeavyVehicle + chanceOfHelicopter;
	if (_diceRoll < _chanceOfHeavyVehicle) exitWith {
		([_respawn_point_ground, _faction, "heavy_vehicles"] call SpawnVehicle) select 2;
	}; 
	
	_chanceOfLightVehicle = chanceOfLightVehicle + _chanceOfHeavyVehicle;
	if (_diceRoll < _chanceOfLightVehicle) exitWith {
		([_respawn_point_ground, _faction,  "light_vehicles"] call SpawnVehicle) select 2;
	};

	[_respawn_point_ground, _faction] call SpawnInfantry;	
};

SpawnVehicle = {
	_marker = _this select 0;
	_faction = _this select 1;
	_vehicle_type = _this select 2;

	_vehicles = ([_faction] call GetPreset) getVariable _vehicle_type; 
	_pos = [getMarkerPos _marker, 10, 50, 15, 0, 0, 0] call BIS_fnc_findSafePos;	

	_vehicleType = selectRandom _vehicles;
    [_pos, 180, _vehicleType, _faction] call BIS_fnc_spawnVehicle;
};

SpawnHelicopter = {
	_marker = _this select 0;
	_faction = _this select 1;

	 _helicopters = ([_faction] call GetPreset) getVariable "helicopters"; 

	_heliType = selectRandom _helicopters;
    [getMarkerPos _marker, 180, _heliType, _faction] call BIS_fnc_spawnVehicle;
};

SpawnInfantry = {
  	_marker = _this select 0;
	_faction = _this select 1;

	_pos = [getMarkerPos _marker, 10, 50, 5, 0, 0, 0] call BIS_fnc_findSafePos;	
	
    _numberOfSoldiers = floor random [3,5,10];
    _soldierGroup = [_pos, _faction, _numberOfSoldiers] call BIS_fnc_spawnGroup;
    _soldierGroup setBehaviour "AWARE";
	_soldierGroup;
};

SpawnBattleGroup = {
	_faction = _this select 0;
	
	_unit_count = [_faction] call CountBattlegroupUnits;
	_strength = [_faction] call GetFactionStrength;
	_left_over_strength = _strength - _unit_count;

	systemChat format["%1 has %2 battlegroup units", _faction, _unit_count];

	if (_left_over_strength > 0) then {
		if (_unit_count < 30) then {
			_respawn_point = format["respawn_%1", _faction];
			_battle_group =	[_faction] call SpawnRandomBattleGroupType;

			[_battle_group] call AddBattleGroups;
		};
	};	
};

SpawnBattleGroups = {
	sleep 30;
	
	while {true} do {
		[West] call SpawnBattleGroup;
		[East] call SpawnBattleGroup;
		[Independent] call SpawnBattleGroup;

		sleep 30;
	};
};

[] call SpawnBattleGroups;
