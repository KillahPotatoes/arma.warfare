SpawnSquad = {
	_location = _this select 0;
	_faction = _location getVariable "faction";

	_positionForSoldiers = (_location getVariable "pos") getPos [_radius * sqrt random 1, random 360];
    _numberOfSoldiers = floor random [3,5,10];
    _group = [_positionForSoldiers, _faction, _numberOfSoldiers] call BIS_fnc_spawnGroup;
    _group setBehaviour "AWARE";
    _group enableDynamicSimulation true;
	_group deleteGroupWhenEmpty true;
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

SpawnSectorDefense = {
	_location = _this select 0;	
	_chanceOfGuarded = random 100;
	_radius = 25;

    if(_chanceOfGuarded < 80) then {
		[_location] call SpawnSquad;		
    };

	if(_chanceOfGuarded < 50) then {
		[_location] call SpawnMortarPositions;		
    };
};