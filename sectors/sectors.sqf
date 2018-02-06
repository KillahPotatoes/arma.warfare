sectors = [];

{
	_subName = [_x, 7] spawn SplitString;
	if ( toString _tempmarker == "sector_" ) then {
		sectors pushback _x;
	};
} foreach allMapMarkers;
