SpawnSquad = {
	_location = _this select 0;
	_faction = _location getVariable "faction";

	_positionForSoldiers = [_location getVariable "pos", 0, 25, 5, 0, 0, 0] call BIS_fnc_findSafePos;	
    _numberOfSoldiers = 5;
    _group = [_positionForSoldiers, _faction, _numberOfSoldiers] call BIS_fnc_spawnGroup;
    _group setBehaviour "AWARE";
    _group enableDynamicSimulation true;
	_group deleteGroupWhenEmpty true;
	_group;
};

SpawnMortarPositions = {
	_location = _this select 0;
	_faction = _location getVariable "faction";

	_orientationOfMortar = random 360;
	_numberOfMortars = (floor random 2) + 1;
	_mortarType = selectRandom(([_faction] call GetPreset) getVariable "mortars");

	for "_i" from 1 to _numberOfMortars do {
		_positionForMortar = (_location getVariable "pos") getPos [_radius * sqrt random 1, random 360];
		_pos = [_positionForMortar, 0, 50, 5, 0, 0, 0] call BIS_fnc_findSafePos;	
		_group = [_pos, _orientationOfMortar, _mortarType, _faction] call BIS_fnc_spawnVehicle;
		(_group select 2) deleteGroupWhenEmpty true;
		(_group select 2) enableDynamicSimulation true; 

        _name = _group select 0;
      	_name addeventhandler ["fired", {(_this select 0) setvehicleammo 1}];
	};
};

SpawnDefensiveVehicle = {
	_location = _this select 0;
	_faction = _location getVariable "faction";

	_vehicles = ([_faction] call GetPreset) getVariable "light_vehicles"; 
	_pos = [_location getVariable "pos", 0, 50, 15, 0, 0, 0] call BIS_fnc_findSafePos;	

	_vehicleType = selectRandom _vehicles;
    _group = [_pos, random 360, _vehicleType, _faction] call BIS_fnc_spawnVehicle;
	(_group select 2) enableDynamicSimulation true; 
	(_group select 2) deleteGroupWhenEmpty true;
};

SpawnReinforcements = {
	_sector = _this select 0;
	_defenders = _this select 1;
	_side = _this select 2;

    _group_count = {alive _x} count units _group;

    _numberOfSoldiers = 5 - _group_count;

    _pos = [_sector getVariable "pos", 0, 25, 5, 0, 0, 0] call BIS_fnc_findSafePos;	
    _soldierGroup = [_pos, _side, _numberOfSoldiers] call BIS_fnc_spawnGroup;
    
    {[_x] joinSilent _group} forEach units _soldierGroup;
    _soldierGroup deleteGroupWhenEmpty true;
};

SpawnSectorDefense = {
	_sector = _this select 0;
	
	_side = _sector getVariable "faction";
	_defenders = _sector getVariable ["defenders", nil];

	if(isNil "_defenders") then {
		_defensive_squad = [_sector] call SpawnSquad;	
		_sector setVariable ["defenders", _defensive_squad];
			
	} else if (side _defenders isEqualTo _side) then {
		_number_of_defenders = count units _defenders;
		[_sector, _defenders, _side] call SpawnReinforcements;

	} else if(!(side _defenders isEqualTo _side)) then {
		if({alive _x} count units _group > 0) then {
			[_defenders] call AddBattleGroups;
		};

		_defensive_squad = [_sector] call SpawnSquad;	
		_sector setVariable ["defenders", _defensive_squad];	
	}
    
	if(random 100 < 50) then {
		[_sector] call SpawnMortarPositions;		
    };
};