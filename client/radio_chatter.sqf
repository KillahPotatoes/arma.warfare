
report_casualities = {
	params ["_group", "_deaths", "_distance", "_direction", "_location"];
	sleep random 5;

	if(!isNull _group) then {
		if(_deaths == 1) exitWith {
			(leader _group) sideChat format[localize selectRandom oneCasualty, _distance, _direction, _location];
		};

		if(_deaths > 3) exitWith {
			(leader _group) sideChat format[localize selectRandom heavyCasualties, _deaths, _distance, _direction, _location];
		};

		if(_deaths > 1) exitWith {
			(leader _group) sideChat format[localize selectRandom multipleCasualties, _deaths, _distance, _direction, _location];
		};	
	};
	
};

group_report_client = {
	params ["_group", "_values"];
	sleep random 3;

	private _msg = [_values] call localize_and_format;
	(leader _group) sideChat _msg;
};

HQ_report_client = {
	params ["_side", "_values"];
	sleep random 3;

	private _msg = [_values] call localize_and_format;
	[_side, "HQ"] sideChat _msg;
};

HQ_report_client_all = {
	params ["_side", "_values"];
	sleep random 3;

	private _msg = [_values] call localize_and_format;
	[playerSide, "HQ"] sideChat _msg;
};

localize_and_format = {
	params ["_values"];

	private _localized_str = localize (_values select 0);
	_values set [0,_localized_str];

	format _values;
};

oneCasualty = [
	"ONE_CASUALITY_VAR1", 
	"ONE_CASUALITY_VAR2", 
	"ONE_CASUALITY_VAR3", 
	"ONE_CASUALITY_VAR4"
];

multipleCasualties = [
	"MULTIPLE_CASUALITIES_VAR1", 
	"MULTIPLE_CASUALITIES_VAR2",  
	"MULTIPLE_CASUALITIES_VAR3"
];

heavyCasualties = [
	"HEAVY_CASUALITIES_VAR1",
	"HEAVY_CASUALITIES_VAR2",
	"HEAVY_CASUALITIES_VAR3"
];

report_casualities_in_sector = {
	params ["_group", "_deaths", "_location"];
	sleep random 10;

	if(!isNull _group) then {	
		if(_deaths == 1) exitWith {
			(leader _group) sideChat format[localize selectRandom oneCasualtyInSector, _location];
		};

		if(_deaths > 3) exitWith {
			(leader _group) sideChat format[localize selectRandom heavyCasualtiesInSector, _deaths, _location];
		};

		if(_deaths > 1) exitWith {
			(leader _group) sideChat format[localize selectRandom multipleCasualtiesInSector, _deaths, _location];
		};	
	};
	
};

oneCasualtyInSector = [
	"ONE_CASUALITY_IN_SECTOR_VAR1",
	"ONE_CASUALITY_IN_SECTOR_VAR2",
	"ONE_CASUALITY_IN_SECTOR_VAR3",
	"ONE_CASUALITY_IN_SECTOR_VAR4"
];

multipleCasualtiesInSector = [
	"MULTIPLE_CASUALITIES_IN_SECTOR_VAR1", 
	"MULTIPLE_CASUALITIES_IN_SECTOR_VAR2", 
	"MULTIPLE_CASUALITIES_IN_SECTOR_VAR3"
];

heavyCasualtiesInSector = [
	"HEAVY_CASUALITIES_IN_SECTOR_VAR1",
	"HEAVY_CASUALITIES_IN_SECTOR_VAR2",
	"HEAVY_CASUALITIES_IN_SECTOR_VAR3"
];