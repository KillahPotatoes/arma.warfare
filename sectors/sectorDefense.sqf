SpawnSquad = {
	_sector = _this select 0;
	_side = _sector getVariable "faction";

	_positionForSoldiers = [_sector getVariable "pos", 0, 25, 5, 0, 0, 0] call BIS_fnc_findSafePos;	
    _numberOfSoldiers = 5;
    _group = [_positionForSoldiers, _side, _numberOfSoldiers] call BIS_fnc_spawnGroup;
    _group setBehaviour "AWARE";
    _group enableDynamicSimulation true;
	_group deleteGroupWhenEmpty true;
	_defenders allowFleeing 0;
	_group;
};

SpawnMortar = {
	_sector = _this select 0;
	_side = _sector getVariable "faction";

	_orientationOfMortar = random 360;
	
	_mortarType = selectRandom(([_side] call GetPreset) getVariable "mortars");
	_pos = [_sector getVariable "pos", 0, 25, 5, 0, 0, 0] call BIS_fnc_findSafePos;
				
	_static_mortar = [_pos, _orientationOfMortar, _mortarType, _side] call BIS_fnc_spawnVehicle;
	_group = _static_mortar select 2;
	_group deleteGroupWhenEmpty true;
	_group enableDynamicSimulation false; 

	_name = _static_mortar select 0;
	_name addeventhandler ["fired", {(_this select 0) setvehicleammo 1}];

	_static_mortar;
};

SpawnMortarPositions = {
	_sector = _this select 0;
	_side = _sector getVariable "faction";

	_mortar = _sector getVariable ["mortar", nil];

	if(isNil "_mortar") then {
		_mortar_squad = [_sector] call SpawnMortar;	
		_sector setVariable ["mortar", _mortar_squad];	

	} else {		
		_vehicle = _mortar select 0;
		_mortar_group = _mortar select 2;

		if (side _mortar_group isEqualTo _side) then {					
			_mortar_dead = ({alive _x} count units _mortar_group) == 0;
			if (_mortar_dead) then {
				deleteVehicle _vehicle;
				_mortar_squad = [_sector] call SpawnMortar;	
				_sector setVariable ["mortar", _mortar_squad];
			};
		};

	    if(!(side _mortar_group isEqualTo _side)) then {
			deleteVehicle _vehicle;
			_mortar_squad = [_sector] call SpawnMortar;	
			_sector setVariable ["mortar", _mortar_squad];	
		};	
	};
};

SpawnReinforcements = {
	_sector = _this select 0;
	_defenders = _this select 1;
	_side = _this select 2;

    _group_count = {alive _x} count units _defenders;

    _numberOfSoldiers = 5 - _group_count;



    _pos = [_sector getVariable "pos", 0, 25, 5, 0, 0, 0] call BIS_fnc_findSafePos;	
    _soldierGroup = [_pos, _side, _numberOfSoldiers] call BIS_fnc_spawnGroup;
    	
    {[_x] joinSilent _defenders} forEach units _soldierGroup;

	_defenders allowFleeing 0;
    _soldierGroup deleteGroupWhenEmpty true;
};

SpawnSectorDefense = {
	_sector = _this select 0;
	
	_side = _sector getVariable "faction";
	_defenders = _sector getVariable ["defenders", nil];

	if(isNil "_defenders") then {
		_defensive_squad = [_sector] call SpawnSquad;	
		_sector setVariable ["defenders", _defensive_squad];
			
	} else {		
		if (side _defenders isEqualTo _side) then {
			_number_of_defenders = count units _defenders;
			[_sector, _defenders, _side] call SpawnReinforcements;
		};

	    if(!(side _defenders isEqualTo _side)) then {
			if({alive _x} count units _defenders > 0) then {
				[_defenders] call AddBattleGroups;
			};

			_defensive_squad = [_sector] call SpawnSquad;	
			_sector setVariable ["defenders", _defensive_squad];
		};	
	};
    [_sector] call SpawnMortarPositions;		
    
};