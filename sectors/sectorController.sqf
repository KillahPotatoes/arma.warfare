F_getUnitsCount = compileFinal preprocessFileLineNumbers "sectors\findUnitsNearby.sqf";
[] call compileFinal preprocessFileLineNumbers "sectors\sectors.sqf";
[] call compileFinal preprocessFileLineNumbers "sectors\drawSector.sqf";
[] call compileFinal preprocessFileLineNumbers "sectors\sectorRespawn.sqf";
[] call compileFinal preprocessFileLineNumbers "sectors\sectorDefense.sqf";

AddAllSectorsToGlobalArray = {
	{
		_subName = [_x, 7] call S_SplitString;
		if ( _subName == "sector_" ) then {

			_sector_size = getMarkerSize _x;
			_location = createLocation ["Strategic", getMarkerPos _x, _sector_size select 0, _sector_size select 1];
			_location setVariable ["marker", _x];
			_location setVariable ["faction", civilian];

			[_location] call drawSector;
			sectors pushback _location;			
		};
	} foreach allMapMarkers;
};

RemoveSectorFromArray = {
	_sector = _this select 0;
	_array = _this select 1;

	_ownedByInd = ind_sectors find (_x); 
	if(_ownedByInd > -1) then {
		ind_sectors deleteAt (_ownedByInd);						
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

CheckIfSectorsAreCaptures = {
	while {true} do {	
		{
			_numberEast = [getPos _x , 200 , EAST] call F_getUnitsCount;
			_numberWest = [getPos _x , 200 , WEST] call F_getUnitsCount;
			_numberInd = [getPos _x , 200 , RESISTANCE] call F_getUnitsCount;

			[_x, east_sectors, _numberEast, _numberWest + _numberInd, east] call CheckIfSectorCaptured;
			[_x, west_sectors, _numberWest, _numberEast + _numberInd, west] call CheckIfSectorCaptured;
			[_x, ind_sectors, _numberInd, _numberWest + _numberEast, resistance] call CheckIfSectorCaptured;
		} foreach sectors;
	};
};

[] call AddAllSectorsToGlobalArray;
[] call CheckIfSectorsAreCaptures;