SpawnRandomBattleGroupType = {
	_faction = _this select 0;
	_left_over_strength = _this select 1;
	
	_diceRoll = random 100;

	_respawn_point_ground = format["respawn_ground_%1", _faction];

	_tier =  missionNamespace getVariable (format ["%1_tier", _faction]);
	_base_chance = 20;
    
	if (_tier > 1 && _diceRoll < (_base_chance * 1)) exitWith {
		([_respawn_point_ground, _faction, "_heavy_vehicles"] call SpawnVehicle) select 2;
	}; 

	if (_tier > 0 && _diceRoll < (_base_chance * 2)) exitWith {
		([_respawn_point_ground, _faction,  "_light_vehicles"] call SpawnVehicle) select 2;
	};

	[_respawn_point_ground, _faction, _left_over_strength] call SpawnInfantry;	
};

SpawnVehicle = {
	_marker = _this select 0;
	_faction = _this select 1;
	_vehicle_type = _this select 2;

	_vehicles = missionNamespace getVariable format["%1%2", _faction, _vehicle_type]; 
	_pos = [getMarkerPos _marker, 10, 50, 15, 0, 0, 0] call BIS_fnc_findSafePos;	

	_vehicleType = selectRandom _vehicles;
    [_pos, 180, _vehicleType, _faction] call BIS_fnc_spawnVehicle;
};

SpawnHelicopter = {
	_marker = _this select 0;
	_faction = _this select 1;

	_helicopters = missionNamespace getVariable format["%1_gunships", _faction]; 	

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
	_left_over_strength = _this select 2;

	_pos = [getMarkerPos _marker, 10, 50, 5, 0, 0, 0] call BIS_fnc_findSafePos;	
	
	_numberOfSoldiers = if(_left_over_strength > 10) then { floor random [3,5,10]; } else {	_left_over_strength; };
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
			_battle_group =	[_faction, _left_over_strength] call SpawnRandomBattleGroupType;

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

WaitUntilHelicopterIsDestroyed = {
	_side = _this select 0;
	_veh = _this select 1;

	waitUntil {!alive _veh || !canMove _veh};

	_tier =  ["%1_tier", _side] call Get;
	
	if(_tier == 0) then {
		sleep random[600, 900, 1200];
	};

	if(_tier == 1) then {
		sleep random[540, 840, 1140];
	};

	if(_tier == 2) then {
		sleep random[480, 780, 1080];
	};

	if(_tier == 3) then {
		sleep random[420, 720, 1020];
	};
};

SpawnBattleHelicopter = {
	_side = _this select 0;

	sleep random[600, 900, 1200];
	while {true} do {

		_unit_count = [_side] call CountBattlegroupUnits;
		_strength = [_side] call GetFactionStrength;
		_left_over_strength = _strength - _unit_count;

		if (_left_over_strength > 0) then {
		
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
			
			_battle_helicopter =  ["%1_battle_heli", _side] call Get;
			[_side, _battle_helicopter select 0] call WaitUntilHelicopterIsDestroyed;		
		};
		sleep 30;
	};
};

[] spawn SpawnBattleGroups;

[West] spawn SpawnBattleHelicopter;
[East] spawn SpawnBattleHelicopter;
[independent] spawn SpawnBattleHelicopter;
