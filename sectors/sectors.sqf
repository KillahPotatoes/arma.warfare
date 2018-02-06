F_getUnitsCount = compileFinal preprocessFileLineNumbers "sectors\findUnitsNearby.sqf";
[] call compileFinal preprocessFileLineNumbers "sectors\drawSector.sqf";

sectors = [];
west_sectors = [];
ind_sectors = [];
east_sectors = [];

{
	_subName = [_x, 7] call S_SplitString;
	if ( _subName == "sector_" ) then {
		[_x, warfare_color_inactive] call drawSector;
		sectors pushback _x;
	};
} foreach allMapMarkers;

while {true} do {	
	{
		_numberEast = [getmarkerpos _x , 200 , EAST] call F_getUnitsCount;
		_numberWest = [getmarkerpos _x , 200 , WEST] call F_getUnitsCount;
		_numberInd = [getmarkerpos _x , 200 , RESISTANCE] call F_getUnitsCount;

		if (!(_x in east_sectors)) then {
			if (_numberEast > 0) then {
				if (_numberWest == 0 && _numberInd == 0) then {
					east_sectors pushBack _x;
					[_x, warfare_color_east] call drawSector;
					hint "East captured a sector";

					_ownedByInd = ind_sectors find (_x); 
					if(_ownedByInd > -1) then {
						ind_sectors deleteAt (_ownedByInd);						
					};

					_ownedByWest = west_sectors find (_x); 
					if(_ownedByWest > -1) then {
						west_sectors deleteAt (_ownedByWest);						
					};
				};
			};
		};
		
		if (!(_x in west_sectors)) then {
			if (_numberWest > 0) then {
				if (_numberEast == 0 && _numberInd == 0) then {
					west_sectors pushBack _x;
					[_x, warfare_color_west] call drawSector;
					hint "West captured a sector";

					_ownedByInd = ind_sectors find (_x); 
					if(_ownedByInd > -1) then {
						ind_sectors deleteAt (_ownedByInd);						
					};

					_ownedByEast = east_sectors find (_x); 
					if(_ownedByEast > -1) then {
						east_sectors deleteAt (_ownedByEast);						
					};
				};
			};
		};

		if (!(_x in ind_sectors)) then {		
			if (_numberInd > 0) then {
				if (_numberEast == 0 && _numberWest == 0) then {
					ind_sectors pushBack _x;
					[_x, warfare_color_ind] call drawSector;
					hint "Indepedent captured a sector";

					_ownedByWest = west_sectors find (_x); 
					if(_ownedByWest > -1) then {
						west_sectors deleteAt (_ownedByWest);						
					};

					_ownedByEast = east_sectors find (_x); 
					if(_ownedByEast > -1) then {
						east_sectors deleteAt (_ownedByEast);						
					};
				};
			};
		};

	} foreach sectors;
};
