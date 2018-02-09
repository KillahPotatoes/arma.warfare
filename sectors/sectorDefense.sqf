SpawnSquad = {
	_location = _this select 0;
	_faction = _location getVariable "faction";

	_positionForSoldiers = (getPos _location) getPos [_radius * sqrt random 1, random 360];
    _numberOfSoldiers = floor random [3,5,10];
    _group = [_positionForSoldiers, _faction, _numberOfSoldiers] call BIS_fnc_spawnGroup;
    _group setBehaviour "AWARE";
    _group enableDynamicSimulation true;     
};

SpawnMortarPositions = {
	_location = _this select 0;
	_faction = _location getVariable "faction";

	_orientationOfMortar = random 360;
	_numberOfMortars = (floor random 2) + 1;
	_mortarType = selectRandom(([_faction] call GetPreset) getVariable "mortars");

	for "_i" from 1 to _numberOfMortars do {
		_positionForMortar = (getPos _location) getPos [_radius * sqrt random 1, random 360];
		_pos = [_positionForMortar, 0, 50, 5, 0, 0, 0] call BIS_fnc_findSafePos;	
		_group = [_pos, _orientationOfMortar, _mortarType, _faction] call BIS_fnc_spawnVehicle;
		_group enableDynamicSimulation true;    
	};
};

SpawnDefensiveVehicle = {
	_location = _this select 0;
	_faction = _location getVariable "faction";

	_vehicles = ([_faction] call GetPreset) getVariable "light_vehicles"; 
	_pos = [getPos _location, 0, 50, 15, 0, 0, 0] call BIS_fnc_findSafePos;	

	_vehicleType = selectRandom _vehicles;
    _group = [_pos, random 360, _vehicleType, _faction] call BIS_fnc_spawnVehicle;
	_group enableDynamicSimulation true; 
};

SpawnSectorDefense = {
	_location = _this select 0;	
	_chanceOfGuarded = random 100;
	_radius = 25;

    if(_chanceOfGuarded < 70) then {
		[_location] call SpawnSquad;		
    };

	if(_chanceOfGuarded < 30) then {
		[_location] call SpawnMortarPositions;		
    };

	if(_chanceOfGuarded < 10) then {
		[_location] call SpawnDefensiveVehicle;
	};
};