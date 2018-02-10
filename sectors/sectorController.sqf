F_getUnitsCount = compileFinal preprocessFileLineNumbers "sectors\findUnitsNearby.sqf";
[] call compileFinal preprocessFileLineNumbers "sectors\sectors.sqf";
[] call compileFinal preprocessFileLineNumbers "sectors\sectorIncome.sqf";
[] call compileFinal preprocessFileLineNumbers "sectors\drawSector.sqf";
[] call compileFinal preprocessFileLineNumbers "sectors\sectorRespawn.sqf";
[] call compileFinal preprocessFileLineNumbers "sectors\sectorDefense.sqf";

AddAmmoBox = {
	_sector = _this select 0;

	 _pos = getPos _sector;	 
	_ammo_box = "B_CargoNet_01_ammo_F";
	 _safe_pos = [_pos, 0, 25, 5, 0, 0, 0] call BIS_fnc_findSafePos;	
	 _ammo_box createVehicle (_pos);
};

AddAllSectorsToGlobalArray = {
	{
		_subName = [_x, 7] call S_SplitString;
		if ( _subName == "sector_" ) then {
			_location = createLocation ["Strategic", getMarkerPos _x, sector_size, sector_size];
			_location setVariable ["marker", _x];
			_location setVariable ["faction", civilian];

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

		SystemChat format["%1 has captured %2", _side, _sector];
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
		SystemChat format["%1 has lost %2", _side, _sector];
	};
};

CheckIfSectorsAreCaptures = {
	while {true} do {	
		{
			_e_numberEast = [getPos _x , sector_size, EAST] call F_getUnitsCount;
			_e_numberWest = [getPos _x , sector_size, WEST] call F_getUnitsCount;
			_e_numberInd = [getPos _x , sector_size, RESISTANCE] call F_getUnitsCount;


			_numberEast = [getPos _x , sector_size / 2 , EAST] call F_getUnitsCount;
			_numberWest = [getPos _x , sector_size / 2 , WEST] call F_getUnitsCount;
			_numberInd = [getPos _x , sector_size / 2, RESISTANCE] call F_getUnitsCount;

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
[] call CheckIfSectorsAreCaptures;