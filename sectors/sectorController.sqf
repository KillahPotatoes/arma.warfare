F_getUnitsCount = compileFinal preprocessFileLineNumbers "sectors\findUnitsNearby.sqf";
[] call compileFinal preprocessFileLineNumbers "sectors\sectors.sqf";
[] call compileFinal preprocessFileLineNumbers "sectors\sectorIncome.sqf";
[] call compileFinal preprocessFileLineNumbers "sectors\drawSector.sqf";
[] call compileFinal preprocessFileLineNumbers "sectors\sectorRespawn.sqf";
[] call compileFinal preprocessFileLineNumbers "sectors\sectorDefense.sqf";

AddAmmoBox = {
	_sector = _this select 0;

	 _pos = _sector getVariable "pos";	 
	_ammo_box = "B_CargoNet_01_ammo_F";
	 _safe_pos = [_pos, 0, 25, 5, 0, 0, 0] call BIS_fnc_findSafePos;	
	 _ammo_box createVehicle (_pos);
};

AddAllSectorsToGlobalArray = {
	{
		_split_string = [_x, 7] call S_SplitString;
		_first_string = _split_string select 0;
		_second_string = _split_string select 1;
				
		if ( _first_string == "sector_" ) then {
			_location = createGroup sideLogic;
			_location setVariable ["pos", getMarkerPos _x];
			_location setVariable ["marker", _x];
			_location setVariable ["faction", civilian];
			_location setVariable ["name", _second_string];

			[_location] call drawSector;
			sectors pushback _location;	
			
			[_location] call AddAmmoBox;		
		};
	} foreach allMapMarkers;
};

RemoveSectorFromArray = {
	_sector = _this select 0;
	_sector_array = _this select 1;

	_index = _sector_array find (_x); 
	if(_index > -1) then {
		_sector_array deleteAt (_index);						
	};
};

CheckIfSectorCaptured = {
	_sector = _this select 0;
	_friendly_sectors = _this select 1;
	_friendly_unit_count = _this select 2;
	_enemy_unit_count = _this select 3;	
	_side = _this select 4;	

	if (!(_sector in _friendly_sectors) && _friendly_unit_count > 0 && _enemy_unit_count == 0) then {
		
		[_sector, ind_sectors] call RemoveSectorFromArray;
		[_sector, east_sectors] call RemoveSectorFromArray;
		[_sector, west_sectors] call RemoveSectorFromArray;

		_sector setVariable ["faction", _side];

		[_sector] call AddRespawnPosition;
		[_sector] call SpawnSectorDefense;

		_friendly_sectors pushBack _sector;		
		[_sector] call drawSector;

		_msg = format["%1 has captured %2", _side, _sector getVariable "name"];
		_msg remoteExec ["hint"]; 
	};
};

CheckIfSectorLost = {
	_sector = _this select 0;
	_friendly_sectors = _this select 1;
	_enemy_unit_count = _this select 2;	
	_side = _this select 3;	

	if (_sector in _friendly_sectors && _enemy_unit_count > 0) then {
		
		[_sector, ind_sectors] call RemoveSectorFromArray;
		[_sector, east_sectors] call RemoveSectorFromArray;
		[_sector, west_sectors] call RemoveSectorFromArray;

		_sector setVariable ["faction", civilian];
		
		[_sector] call drawSector;
		[_sector] call RemoveRespawnPosition;
		_msg = format["%1 has lost %2", _side, _sector getVariable "name"];
		_msg remoteExec ["hint"]; 
	};
};

CheckIfSectorsAreCaptures = {
	while {true} do {	
		{
			_e_numberEast = [_x getVariable "pos", sector_size, EAST] call F_getUnitsCount;
			_e_numberWest = [_x getVariable "pos", sector_size, WEST] call F_getUnitsCount;
			_e_numberInd = [_x getVariable "pos", sector_size, RESISTANCE] call F_getUnitsCount;

			_numberEast = [_x getVariable "pos", sector_size / 4 , EAST] call F_getUnitsCount;
			_numberWest = [_x getVariable "pos", sector_size / 4, WEST] call F_getUnitsCount;
			_numberInd = [_x getVariable "pos", sector_size / 4, RESISTANCE] call F_getUnitsCount;

			[_x, east_sectors, _numberEast, _e_numberWest + _e_numberInd, east] call CheckIfSectorCaptured;
			[_x, west_sectors, _numberWest, _e_numberEast + _e_numberInd, west] call CheckIfSectorCaptured;
			[_x, ind_sectors, _numberInd, _e_numberWest + _e_numberEast, resistance] call CheckIfSectorCaptured;

			[_x, east_sectors, _numberWest + _numberInd, east] call CheckIfSectorLost;
			[_x, west_sectors, _numberEast + _numberInd, west] call CheckIfSectorLost;
			[_x, ind_sectors, _numberWest + _numberEast, resistance] call CheckIfSectorLost;
		} foreach sectors;
	};
};

[] call AddAllSectorsToGlobalArray;
[] spawn CheckIfSectorsAreCaptures;