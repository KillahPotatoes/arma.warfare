SpawnSquad = {
	_location = _this select 0;
	_faction = _location getVariable "faction";

	_positionForSoldiers = (getPos _location) getPos [_radius * sqrt random 1, random 360];
    _numberOfSoldiers = floor random [3,5,10];
    _soldierGroup = [_positionForSoldiers, _faction, _numberOfSoldiers] call BIS_fnc_spawnGroup;
    _soldierGroup setBehaviour "AWARE";
    _soldierGroup enableDynamicSimulation true;     
};

SpawnMortarPositions = {
	_location = _this select 0;
	_faction = _location getVariable "faction";

	_orientationOfMortar = random 360;
	_numberOfMortars = (floor random 2) + 1;
	_mortarType = selectRandom(([_faction] call GetPreset) getVariable "mortars");

	for "_i" from 1 to _numberOfMortars do {
		_positionForMortar = (getPos _location) getPos [_radius * sqrt random 1, random 360];
		[_positionForMortar, _orientationOfMortar, _mortarType, _faction] call BIS_fnc_spawnVehicle;
	};
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
};