SpawnRandomBattleGroupType = {
	_faction = _this select 0;
	
	_diceRoll = random 100;

	_respawn_point_ground = format["respawn_ground_%1", _faction];

	_tier =  missionNamespace getVariable (format ["%1_tier", _faction]);
	_base_chance = 20;
    
	if (_tier > 1 && _diceRoll < (_base_chance * 1)) exitWith {
		([_respawn_point_ground, _faction, "heavy_vehicles"] call SpawnVehicle) select 2;
	}; 

	if (_tier > 0 && _diceRoll < (_base_chance * 2)) exitWith {
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
	_pos = getMarkerPos _marker;
	_flying_pos = [_pos select 0, _pos select 1, (_pos select 2) + 100];
    _veh = [_flying_pos, 180, _heliType, _faction] call BIS_fnc_spawnVehicle;
	 missionNamespace setVariable [format["%1_battle_heli", _side], _veh];

	 _veh select 2;
};

SpawnInfantry = {
  	_marker = _this select 0;
	_faction = _this select 1;

	_pos = [getMarkerPos _marker, 10, 50, 5, 0, 0, 0] call BIS_fnc_findSafePos;	
	
    _numberOfSoldiers = floor random [3,5,10]; // TODO make it an even number but so it fills up til 30 overall
    _soldierGroup = [_pos, _faction, _numberOfSoldiers] call BIS_fnc_spawnGroup;
    _soldierGroup setBehaviour "AWARE";
	_soldierGroup;
};

SpawnBattleGroup = {
	_faction = _this select 0;
	
	_unit_count = [_faction] call CountBattlegroupUnits;
	_strength = [_faction] call GetFactionStrength;
	_left_over_strength = _strength - _unit_count;

	if (_left_over_strength > 0) then {
		if (_unit_count < 30) then {
			_respawn_point = format["respawn_%1", _faction];
			_battle_group =	[_faction] call SpawnRandomBattleGroupType;

			_battle_group deleteGroupWhenEmpty true;
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

SpawnBattleHelicopter = {
	_side = _this select 0;

	sleep random[300, 600, 900];
	while {true} do {
		_tier =  ["%1_tier", _side] call Get;
		
		_battle_helicopter =  ["%1_battle_heli", _side] call Get;
		_respawn_point_air = format["respawn_air_%1", _side];

		if (isNil "_battle_helicopter") then {			
			_group = ([_respawn_point_air, _side] call SpawnHelicopter);
			_group deleteGroupWhenEmpty true;
			[_group] call AddBattleGroups;
		} else {
			_veh = _battle_helicopter select 0;

			if(!alive _veh || !canMove _veh) then {
				_veh setDamage 1;
				
				_group = ([_respawn_point_air, _side] call SpawnHelicopter);
				_group deleteGroupWhenEmpty true;
				[_group] call AddBattleGroups;
			};
		};		
		
		waitUntil
		if(_tier == 0) then {
			sleep random[300, 600, 900];
		};

		if(_tier == 1) then {
			sleep random[240, 540, 840];
		};

		if(_tier == 2) then {
			sleep random[180, 480, 780];
		};

		if(_tier == 3) then {
			sleep random[120, 420, 720];
		};
	};
};

[] spawn SpawnBattleGroups;

[West] spawn SpawnBattleHelicopter;
[East] spawn SpawnBattleHelicopter;
[independent] spawn SpawnBattleHelicopter;
