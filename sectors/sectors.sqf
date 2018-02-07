F_getUnitsCount = compileFinal preprocessFileLineNumbers "sectors\findUnitsNearby.sqf";
[] call compileFinal preprocessFileLineNumbers "sectors\drawSector.sqf";

sectors = [];
west_sectors = [];
ind_sectors = [];
east_sectors = [];

[] call AddAllSectorsToGlobalArray;
[] call CheckIfSectorsAreCaptures;

AddAllSectorsToGlobalArray = {
	{
		_subName = [_x, 7] call S_SplitString;
		if ( _subName == "sector_" ) then {
			[_x, warfare_color_inactive] call drawSector;
			sectors pushback _x;
		};
	} foreach allMapMarkers;
}

RemoveSectorFromArray = {
	_sector = _this select 0;
	_array = _this select 1;

	_ownedByInd = ind_sectors find (_x); 
	if(_ownedByInd > -1) then {
		ind_sectors deleteAt (_ownedByInd);						
	};
}

CheckIfSectorCaptured = {
	_sector = _this select 0;
	_friendly_sectors = _this select 1;
	_friendly_unit_count = _this select 2;
	_enemy_unit_count = _this select 3;
	_color = _this select 4;

	if (!(_sector in _friendly_sectors) && _friendly_unit_count > 0 && _enemy_unit_count == 0) then {
		
		[_sector, ind_sectors] call RemoveSectorFromArray;
		[_sector, east_sectors] call RemoveSectorFromArray;
		[_sector, west_sectors] call RemoveSectorFromArray;

		_friendly_sectors pushBack _sector;
		[_sector, _color] call drawSector;
		hint "East captured a sector";
	};
}

CheckIfSectorsAreCaptures = {
	while {true} do {	
		{
			_numberEast = [getmarkerpos _x , 200 , EAST] call F_getUnitsCount;
			_numberWest = [getmarkerpos _x , 200 , WEST] call F_getUnitsCount;
			_numberInd = [getmarkerpos _x , 200 , RESISTANCE] call F_getUnitsCount;

			[_x, east_sectors, _numberEast, _numberWest + _numberInd, warfare_color_east] call CheckIfSectorCaptured;
			[_x, west_sectors, _numberWest, _numberEast + _numberInd, warfare_color_west] call CheckIfSectorCaptured;
			[_x, ind_sectors, _numberInd, _numberWest + _numberEast, warfare_color_ind] call CheckIfSectorCaptured;
		} foreach sectors;
	};
}
